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
            localparam int BYTES_W = $clog2(BYTE_LANES+1);
            
            // normal fifo stuff
            logic [WIDTH-1:0] fifo[DEPTH-1:0];
            logic [BYTE_LANES-1:0] fifo_keep[DEPTH-1:0];
            logic fifo_last[DEPTH-1:0];
            logic [COUNT_W-1:0] count;
            logic [WIDTH-1:0] masked_in_data;
            logic push;
            logic pop;
            logic align_mode_r;
            logic [15:0] aligned_bytes_per_neuron_r;
            logic [15:0] bytes_left_in_neuron_r;
            logic aligned_out_valid;
            logic [WIDTH-1:0] aligned_out_data;
            logic [BYTE_LANES-1:0] aligned_out_keep;
            logic aligned_out_last;
            logic [BYTE_LANES-1:0] consume_mask[DEPTH-1:0];
            logic [WIDTH-1:0] remainder_data[DEPTH-1:0];
            logic [BYTE_LANES-1:0] remainder_keep[DEPTH-1:0];
            logic [BYTES_W-1:0] aligned_bytes_emitted;
            logic [15:0] bytes_needed;
            logic [15:0] total_valid_bytes;
            logic message_last_seen;
            logic should_align_next;
            logic [15:0] next_bytes_per_neuron;

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

            always_comb begin
                should_align_next = 1'b0;
                next_bytes_per_neuron = aligned_bytes_per_neuron_r;

                if (msg_type_valid) begin
                    should_align_next = (msg_type == 8'd0) && bytes_per_neuron_valid && (bytes_per_neuron != 16'd0);
                    if (bytes_per_neuron_valid && (bytes_per_neuron != 16'd0)) begin
                        next_bytes_per_neuron = bytes_per_neuron;
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
            

            always_comb begin
                int unsigned out_idx;
                int unsigned rem_idx;
                
                // basically dupes of what the output would be registered here to keep track
                // of the rest of the data as it's being streamed in
                aligned_out_valid = 1'b0;
                aligned_out_data = '0;
                aligned_out_keep = '0;
                aligned_out_last = 1'b0;
                aligned_bytes_emitted = '0;
                bytes_needed = bytes_left_in_neuron_r;
                total_valid_bytes = '0;
                message_last_seen = 1'b0;

                if ((bytes_needed == '0) || (bytes_needed > BYTE_LANES)) begin
                    bytes_needed = BYTE_LANES;
                end
                // initialize masks and remainder registers
                for (int entry = 0; entry < DEPTH; entry++) begin
                    consume_mask[entry] = '0;
                    remainder_data[entry] = '0;
                    remainder_keep[entry] = '0;
                end

                // count how many valid bytes are in the fifo and find the last valid byte so we know when to assert TLAST
                // also generate the aligned output beat by consuming the valid bytes
                out_idx = 0;
                for (int entry = DEPTH-1; entry >= 0; entry--) begin
                    if (entry < count) begin
                        total_valid_bytes += 16'($countones(fifo_keep[entry]));
                        message_last_seen |= fifo_last[entry]; // if fifo_last was ever asserted for any of the valid bytes
                        for (int lane = 0; lane < BYTE_LANES; lane++) begin
                            if (fifo_keep[entry][lane] && (out_idx < bytes_needed)) begin
                                aligned_out_data[out_idx*8 +: 8] = fifo[entry][lane*8 +: 8];
                                aligned_out_keep[out_idx] = 1'b1;
                                consume_mask[entry][lane] = 1'b1;
                                out_idx++;
                            end
                        end
                    end
                end

                aligned_bytes_emitted = BYTES_W'(out_idx);
                aligned_out_valid = (out_idx != 0);
                // TLAST only leaves the module once every valid byte already in
                // the FIFO has been consumed into this aligned output beat.
                aligned_out_last = aligned_out_valid && message_last_seen && (total_valid_bytes == out_idx);
                
                // generate the "remainder" beats that will be merged with the new incoming data
                for (int entry = 0; entry < DEPTH; entry++) begin
                    rem_idx = 0;
                    if (entry < count) begin
                        for (int lane = 0; lane < BYTE_LANES; lane++) begin
                            if (fifo_keep[entry][lane] && !consume_mask[entry][lane]) begin
                                remainder_data[entry][rem_idx*8 +: 8] = fifo[entry][lane*8 +: 8];
                                remainder_keep[entry][rem_idx] = 1'b1;
                                rem_idx++;
                            end
                        end
                    end
                end
            end
            
            // status registers and control signals
            assign shift_in_ready  = (count < COUNT_W'(DEPTH));
            assign push = shift_in_valid && shift_in_ready;
            assign pop  = shift_out_valid && shift_out_ready;
            assign shift_out_valid = align_mode_r ? aligned_out_valid : (count > 0);

            // hold behavior depending on if we're reading weights or thresholds
            always_comb begin
                shift_out_data = '0;
                shift_out_keep = '0;
                shift_out_last = 1'b0;
                if (align_mode_r) begin
                    shift_out_data = aligned_out_data;
                    shift_out_keep = aligned_out_keep;
                    shift_out_last = aligned_out_last;
                end else if (count > 0) begin
                    shift_out_data = fifo[count-1];
                    shift_out_keep = fifo_keep[count-1];
                    shift_out_last = fifo_last[count-1];
                end
            end

            always_ff @(posedge clk or posedge rst) begin
                if (rst) begin
                    count <= '0;
                    align_mode_r <= 1'b0;
                    aligned_bytes_per_neuron_r <= '0;
                    bytes_left_in_neuron_r <= '0;
                    for (int i = 0; i < DEPTH; i++) begin
                        fifo[i] <= '0;
                        fifo_keep[i] <= '0;
                        fifo_last[i] <= 1'b0;
                    end
                end else begin
                    logic [WIDTH-1:0] next_fifo[DEPTH-1:0];
                    logic [BYTE_LANES-1:0] next_fifo_keep[DEPTH-1:0];
                    logic next_fifo_last[DEPTH-1:0];
                    int unsigned next_count;

                    for (int i = 0; i < DEPTH; i++) begin
                        next_fifo[i] = '0;
                        next_fifo_keep[i] = '0;
                        next_fifo_last[i] = 1'b0;
                    end

                    next_count = 0;

                    if (align_mode_r && pop) begin
                        // After an aligned transfer, keep only the bytes that were
                        // not consumed so the next beat can be assembled from them
                        // plus any newly pushed input data.
                        for (int src = 0; src < DEPTH; src++) begin
                            if (src < count) begin
                                if (remainder_keep[src] != '0) begin
                                    next_fifo[next_count] = remainder_data[src];
                                    next_fifo_keep[next_count] = remainder_keep[src];
                                    next_fifo_last[next_count] = fifo_last[src];
                                    next_count++;
                                end
                            end
                        end
                    end else if (pop) begin
                        for (int src = 0; src < DEPTH-1; src++) begin
                            if ((src + 1) < count) begin
                                next_fifo[src] = fifo[src];
                                next_fifo_keep[src] = fifo_keep[src];
                                next_fifo_last[src] = fifo_last[src];
                            end
                        end
                        next_count = count - 1'b1;
                    end else begin
                        for (int src = 0; src < DEPTH; src++) begin
                            if (src < count) begin
                                next_fifo[src] = fifo[src];
                                next_fifo_keep[src] = fifo_keep[src];
                                next_fifo_last[src] = fifo_last[src];
                            end
                        end
                        next_count = count;
                    end

                    if (push) begin
                        for (int i = DEPTH-1; i > 0; i--) begin
                            next_fifo[i] = next_fifo[i-1];
                            next_fifo_keep[i] = next_fifo_keep[i-1];
                            next_fifo_last[i] = next_fifo_last[i-1];
                        end
                        next_fifo[0] = masked_in_data;
                        next_fifo_keep[0] = shift_in_keep;
                        next_fifo_last[0] = shift_in_last;
                        next_count++;
                    end

                    for (int i = 0; i < DEPTH; i++) begin
                        fifo[i] <= next_fifo[i];
                        fifo_keep[i] <= next_fifo_keep[i];
                        fifo_last[i] <= next_fifo_last[i];
                    end
                    count <= COUNT_W'(next_count);

                    if (msg_type_valid) begin
                        // A new header selects whether the following payload uses
                        // neuron-aligned packing or plain beat streaming.
                        align_mode_r <= should_align_next;
                        if (should_align_next) begin
                            aligned_bytes_per_neuron_r <= next_bytes_per_neuron;
                            bytes_left_in_neuron_r <= next_bytes_per_neuron;
                        end else begin
                            aligned_bytes_per_neuron_r <= '0;
                            bytes_left_in_neuron_r <= '0;
                        end
                    end else if (align_mode_r && pop) begin
                        // Reset the byte budget at each neuron boundary; otherwise
                        // carry the remaining bytes into the next aligned beat.
                        if (aligned_out_last) begin
                            align_mode_r <= 1'b0;
                            aligned_bytes_per_neuron_r <= '0;
                            bytes_left_in_neuron_r <= '0;
                        end else if (aligned_bytes_emitted == bytes_left_in_neuron_r) begin
                            bytes_left_in_neuron_r <= aligned_bytes_per_neuron_r;
                        end else begin
                            bytes_left_in_neuron_r <= bytes_left_in_neuron_r - 16'(aligned_bytes_emitted);
                        end
                    end else if (!align_mode_r && pop && shift_out_last) begin
                        aligned_bytes_per_neuron_r <= '0;
                        bytes_left_in_neuron_r <= '0;
                    end
                end
            end
        end
    endgenerate

endmodule
