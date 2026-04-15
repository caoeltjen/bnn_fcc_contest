module shift_reg #(
    parameter int WIDTH = 64,
    parameter int DEPTH = 3,
    parameter bit ALIGN_TO_BYTES_PER_NEURON = 1'b0
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  shift_in_valid,
    input  logic [(WIDTH/8)-1:0]  shift_in_keep,
    input  logic [WIDTH-1:0]      shift_in_data,
    input  logic                  shift_in_last,
    input  logic [7:0]            msg_type,
    input  logic                  msg_type_valid,
    input  logic [15:0]           bytes_per_neuron,
    input  logic                  bytes_per_neuron_valid,
    output logic                  shift_in_ready,
    output logic                  shift_out_valid,
    output logic [WIDTH-1:0]      shift_out_data,
    output logic [(WIDTH/8-1):0]  shift_out_keep,
    output logic                  shift_out_last,
    input  logic                  shift_out_ready
);
    localparam int BYTE_LANES = WIDTH / 8;

    generate
        // reformatted everything so it's dependent on if the config_manager
        // or the data_in_manager is instantiating the shift_register
        // if it's not the config_manager, then we don't have to align the data
        // and won't have to account for the bytes_per_neuron config input, so we can just use a normal fifo
        if (!ALIGN_TO_BYTES_PER_NEURON) begin : GEN_BEAT_FIFO
            localparam int COUNT_W = $clog2(DEPTH+1);
            // normal fifo stuff
            logic [WIDTH-1:0] fifo[DEPTH-1:0];
            logic [BYTE_LANES-1:0] fifo_keep[DEPTH-1:0];
            logic fifo_last[DEPTH-1:0];
            logic [COUNT_W-1:0] count;
            logic [WIDTH-1:0] masked_in_data;
            logic unused_cfg_inputs;
            logic push;
            logic pop;

            // handle masking of bytes that aren't valid
            always_comb begin
                masked_in_data = '0;
                for (int i = 0; i < BYTE_LANES; i++) begin
                    if (shift_in_keep[i]) begin
                        masked_in_data[i*8 +: 8] = shift_in_data[i*8 +: 8];
                    end else begin
                        masked_in_data[i*8 +: 8] = '0;
                    end
                end
            end

            // basically so there's no warnings on the verilator
            assign unused_cfg_inputs = msg_type_valid ^ (^msg_type) ^ bytes_per_neuron_valid ^ (^bytes_per_neuron);

            // status registers and control signals
            assign shift_in_ready  = (count < COUNT_W'(DEPTH));
            assign shift_out_valid = (count > 0);
            assign push = shift_in_valid && shift_in_ready;
            assign pop  = shift_out_valid && shift_out_ready;

            always_comb begin
                shift_out_data = '0;
                shift_out_keep = '0;
                shift_out_last = 1'b0;
                if (count > 0) begin
                    shift_out_data = fifo[count-1];
                    shift_out_keep = fifo_keep[count-1];
                    shift_out_last = fifo_last[count-1];
                end
            end

            always_ff @(posedge clk or posedge rst) begin
                if (rst) begin
                    count <= '0;
                    for (int i = 0; i < DEPTH; i++) begin
                        fifo[i] <= '0;
                        fifo_keep[i] <= '0;
                        fifo_last[i] <= 1'b0;
                    end
                end else begin
                    if (push) begin
                        for (int i = DEPTH-1; i > 0; i--) begin
                            fifo[i] <= fifo[i-1];
                            fifo_keep[i] <= fifo_keep[i-1];
                            fifo_last[i] <= fifo_last[i-1];
                        end
                        fifo[0] <= masked_in_data;
                        fifo_keep[0] <= shift_in_keep;
                        fifo_last[0] <= shift_in_last;
                    end

                    case ({push, pop})
                        2'b10: count <= count + 1'b1;
                        2'b01: count <= count - 1'b1;
                        default: count <= count;
                    endcase
                end
            end
        end else begin : GEN_BYTE_ALIGN
            // This mode is used by config_manager, where payload consumption needs
            // to follow the configuration header rather than simply draining one
            // full bus beat per cycle.
            //
            localparam int COUNT_W = $clog2(DEPTH+1);
            
            // normal fifo stuff
            logic [WIDTH-1:0] fifo[DEPTH-1:0];
            logic [BYTE_LANES-1:0] fifo_keep[DEPTH-1:0];
            logic fifo_last[DEPTH-1:0];
            logic [COUNT_W-1:0] count;
            logic [WIDTH-1:0] masked_in_data;
            logic push;
            logic pop;

            // handle masking of bytes that aren't valid
            always_comb begin
                masked_in_data = '0;
                for (int i = 0; i < BYTE_LANES; i++) begin
                    if (shift_in_keep[i]) begin
                        masked_in_data[i*8 +: 8] = shift_in_data[i*8 +: 8];
                    end else begin
                        masked_in_data[i*8 +: 8] = '0;
                    end
                end
            end

            // things to do
                // track how many bytes received
                // find which byte in the beat the neuron boundary is
                // zero pad the rest of the data and keep the beat on the top of the fifo until we push it out
                // merge the leftover data from the previous beat with the new beat to form the next output beat
                // hold the offset so that we know how to align the next incoming beat and when to assert shift_out_last
                // example:
                    // bytes_per_neuron = 12
                    // cycle 0: receive beat with 8 bytes, increment running total by 8, prepare it to be pushed out
                    // cycle 1: push out previous beat, receive new beat with 8 bytes, increment running total by 8 (now 16)
                    //          measure the difference between the running total and the bytes_per_neuron to find the offset,
                    //          which will be 4. subtract 4 by 1 to get the index of the last byte that belonds to the current beat,
                    //          which will be the fourth byte at index 3. now, store the last 4 bytes (index 4 to 7) of the previous beat to 
                    //          a register so that they can be merged with the first 4 bytes of the new beat to form the next output beat.
                    //          take the running total and subtract it by the bytes_per_neuron (16-12) to find how many bytes belong to the next beat, which will be 4.
                    //          finally, for the bytes that belong to the current beat and neuron, zero them out in the fifo and set the keep signals accordingly. 
                    // cycle 2: push out the beat that was just formed and receive a new beat with 8 bytes. increment the running total by 8 (now 12)  
                    //          and merge the previous 4 stored bytes with the first 4 btyes of the new beat to form the next output beat. 
                // i want to expand on this to check for the case where shifted in data isn't valid, so we can ignore
                // the invalid bytes and push more of the "leftover" data from the previous beat if there's space. 
                // example
                    // bytes_per_neuron = 12
                    // cycle 0: receive beat with 8 bytes, increment running total by 8, prepare it to be pushed out
                    // cycle 1: push out previous beat, receive new beat with 8 bytes, increment running total by 8 (now 16)
                    //          measure the difference between the running total and the bytes_per_neuron to find the offset,
                    //          which will be 4. subtract 4 by 1 to get the index of the last byte that belonds to the current beat,
                    //          which will be the fourth byte at index 3. now, store the last 4 bytes (index 4 to 7) of the previous beat to 
                    //          a register so that they can be merged with the first 4 bytes of the new beat to form the next output beat.
                    //          take the running total and subtract it by the bytes_per_neuron (16-12) to find how many bytes belong to the next beat, which will be 4.
                    //          finally, for the bytes that belong to the current beat and neuron, zero them out in the fifo and set the keep signals accordingly. 
                    // cycle 2: push out the beat that was just formed and receive a new beat with 8 bytes. This new beat, only 4 bytes are valid,  
                    //          so we increment the running total only by 4, and merge the new 4 valid bytes to the old 4 stored bytes to form the next output beat.  
            

            // tracking how many bytes received
            logic [15:0] bytes_received;
            always_comb begin
                bytes_received = '0;
                for (int i = 0; i < BYTE_LANES; i++) begin
                    if (shift_in_valid && shift_in_keep[i]) begin
                        bytes_received += 1;
                    end
                end
                // reset it if it's too big 
                if (bytes_received > bytes_per_neuron) begin
                    bytes_received -= bytes_per_neuron;
                end
            end
            
            // status registers and control signals
            assign shift_in_ready  = (count < COUNT_W'(DEPTH));
            assign shift_out_valid = (count > 0);
            assign push = shift_in_valid && shift_in_ready;
            assign pop  = shift_out_valid && shift_out_ready;

            always_comb begin
                shift_out_data = '0;
                shift_out_keep = '0;
                shift_out_last = 1'b0;
                if (count > 0) begin
                    shift_out_data = fifo[count-1];
                    shift_out_keep = fifo_keep[count-1];
                    shift_out_last = fifo_last[count-1];
                end
            end

            always_ff @(posedge clk or posedge rst) begin
                if (rst) begin
                    count <= '0;
                    for (int i = 0; i < DEPTH; i++) begin
                        fifo[i] <= '0;
                        fifo_keep[i] <= '0;
                        fifo_last[i] <= 1'b0;
                    end
                end else begin
                    if (push) begin
                        for (int i = DEPTH-1; i > 0; i--) begin
                            fifo[i] <= fifo[i-1];
                            fifo_keep[i] <= fifo_keep[i-1];
                            fifo_last[i] <= fifo_last[i-1];
                        end
                        fifo[0] <= masked_in_data;
                        fifo_keep[0] <= shift_in_keep;
                        fifo_last[0] <= shift_in_last;
                    end

                    case ({push, pop})
                        2'b10: count <= count + 1'b1;
                        2'b01: count <= count - 1'b1;
                        default: count <= count;
                    endcase
                end
            end
        end
    endgenerate

endmodule
