module config_manager #(
    parameter int BUS_WIDTH       = 64 // bus stores 8 bytes
) (
    // general i/o
    input logic                          clk,
    input logic                          rst,
    input logic [BUS_WIDTH-1:0]          config_data_in,
    input logic                          config_valid,
    input logic [(BUS_WIDTH/8)-1:0]      config_keep,
    input logic                          config_last,
    output logic                         config_ready,

    // outputs of header
    output logic [7:0]                   msg_type,
    output logic [7:0]                   layer_id,
    output logic [15:0]                  layer_inputs,
    output logic [15:0]                  num_neurons,
    output logic [15:0]                  bytes_per_neuron,
    output logic [31:0]                  total_bytes,
    output logic [31:0]                  reserved,

    // outputs of data
    output logic [7:0]                   data_out[0:7], // 8 bytes read per cycle, so max bytes per beat is 8
    output logic [7:0]                   data_out_valid, // valid signal for data_out that says which bytes are real data
    output logic                         error // assert when payload byte count doesn't match total_bytes in header or config_last is not aligned with payload byte count
);

// 128 bit bus MSB-->LSB
    typedef struct packed {
        logic [31:0] reserved;
        logic [31:0] total_bytes;
        logic [15:0] bytes_per_neuron;
        logic [15:0] num_neurons;
        logic [15:0] layer_inputs;
        logic [7:0]  layer_id;
        logic [7:0]  msg_type;
    } config_header_t;
    config_header_t header;

    // registered data for header fields
    logic [7:0] msg_type_r, msg_type_r_next;
    logic [7:0] layer_id_r, layer_id_r_next;
    logic [15:0] layer_inputs_r, layer_inputs_r_next;
    logic [15:0] num_neurons_r, num_neurons_r_next;
    logic [15:0] bytes_per_neuron_r, bytes_per_neuron_r_next;
    logic [31:0] total_bytes_r, total_bytes_r_next;
    logic [31:0] reserved_r, reserved_r_next;
    assign header.msg_type = msg_type_r;
    assign header.layer_id = layer_id_r;
    assign header.layer_inputs = layer_inputs_r;
    assign header.num_neurons = num_neurons_r;
    assign header.bytes_per_neuron = bytes_per_neuron_r;
    assign header.total_bytes = total_bytes_r;
    assign header.reserved = reserved_r;
    // assign them to outputs
    assign msg_type = msg_type_r;
    assign layer_id = layer_id_r;
    assign layer_inputs = layer_inputs_r;
    assign num_neurons = num_neurons_r;
    assign bytes_per_neuron = bytes_per_neuron_r;
    assign total_bytes = total_bytes_r;
    assign reserved = reserved_r;   


    // weight and threshold data structure
    typedef struct packed {
        logic [7:0] weight;
    } data_t;

    // internal signals for shift register
    typedef enum {
        IDLE, // wait for first accepted beat
        HEADER, // consume 16 valid header bytes
        PAYLOAD, // consume total_bytes payload bytes
        DONE // finish when both payload byte count reached and config_last. if disagreed, assert cfg_error
    } state_t;
    state_t curr_state, next_state;
    assign config_ready = (curr_state == IDLE); // ready when not reading anything
    
    logic [31:0] payload_bytes_received; // track number of payload bytes received to compare against total_bytes in header
    logic [15:0] current_neuron_idx;
    logic [15:0] byte_idx_within_neuron;
    logic [15:0] word_addr_within_neuron; // need to define address size here based on storage width and bytes_per_neuron
    logic [7:0] packer_byte_counter; // track byte count for packing data into cfg_cmd_data and cfg_cmd_strb
    data_t packer_data; // temporary storage for packing data into cfg_cmd_data

    assign error = (payload_bytes_received != header.total_bytes && config_last); // when both payload byte count and config_last conflict

    logic shift_in_ready;
    logic shift_out_valid;
    logic [BUS_WIDTH-1:0] shift_out_data;
    logic [(BUS_WIDTH/8)-1:0] shift_out_keep;
    // shift register to read in data for header parsing and weight/threshold storage
    shift_reg #(
        .WIDTH(BUS_WIDTH),
        .DEPTH(3) // just a number for now, can be adjusted later    
    ) header_shift_reg (
        .clk(clk),
        .rst(rst),
        .shift_in_valid(config_valid),
        .shift_in_keep(config_keep),
        .shift_in_data(config_data_in),
        .shift_in_ready(shift_in_ready),
        .shift_out_valid(shift_out_valid),
        .shift_out_data(shift_out_data),
        .shift_out_keep(shift_out_keep),
        .shift_out_ready(1'b1) // always ready to accept header data
    );

    logic [63:0] header_bytes[0:1]; // 2 bytes per header
    logic header_byte_idx, header_byte_idx_next;  // header for weights and header for thresholds. weights=0, thresholds=1;
    
    
    logic [7:0] data_out_next[0:7];
    logic [7:0] data_out_r[0:7];
    logic [7:0] data_out_valid_next;
    logic [7:0] data_out_valid_r;
    assign data_out = data_out_r;
    assign data_out_valid = data_out_valid_r;


    // logic
    always_comb begin
        msg_type_r_next = msg_type_r;
        layer_id_r_next = layer_id_r;
        layer_inputs_r_next = layer_inputs_r;
        num_neurons_r_next = num_neurons_r;
        bytes_per_neuron_r_next = bytes_per_neuron_r;
        total_bytes_r_next = total_bytes_r;
        reserved_r_next = reserved_r;
        next_state = curr_state;
        case (curr_state) 
            IDLE: begin
                if (shift_out_valid) begin
                    // read the first beat of the header, then move to next state where second header byte is defined
                    next_state = HEADER;
                    header_bytes[header_byte_idx] = shift_out_data;
                    header_byte_idx_next = 1'b1; // move to second header byte
                end
                else next_state = IDLE;
            end
            HEADER: begin
                header_bytes[header_byte_idx] = shift_out_data;
                if (header_byte_idx == 1) begin
                    // after reading in second header beat, parse the header and move to payload state
                    // remember, the shift register handles the keep, so we don't need to validate here
                    msg_type_r_next = header_bytes[0][7:0];
                    layer_id_r_next = header_bytes[0][15:8];
                    layer_inputs_r_next = header_bytes[0][31:16];
                    num_neurons_r_next = header_bytes[0][47:32];
                    bytes_per_neuron_r_next = header_bytes[0][63:48];
                    total_bytes_r_next = header_bytes[1][31:0];
                    reserved_r_next = header_bytes[1][63:32];
                    next_state = PAYLOAD;
                    header_byte_idx_next = '0; // reset for threshold header
                end else begin
                    next_state = HEADER;
                    $display("Error: Header should be contained within 2 beats. Current header byte index: %0d", header_byte_idx);
                end
            end
            PAYLOAD: begin
                if (shift_out_valid) begin
                    // 
                    if (payload_bytes_received >= header.total_bytes) begin
                        next_state = DONE;
                    end else begin
                        next_state = PAYLOAD;
                        payload_bytes_received = payload_bytes_received + (shift_out_keep.countones()); // count valid bytes in the beat and accumulate
                        // pack the valid bytes into data_out and data_out_valid
                        for (int i = 0; i < BUS_WIDTH/8; i++) begin
                            if (shift_out_keep[i]) begin
                                data_out_next[i] = shift_out_data[i*8 +: 8];
                                data_out_valid_next[i] = 1'b1;
                            end else begin
                                data_out_next[i] = '0;
                                data_out_valid_next[i] = 1'b0;
                            end
                        end
                    end
                end else begin
                    next_state = PAYLOAD;
                end
            end
            DONE: begin
                $display("Info: Payload processing done. Total bytes received: %0d", payload_bytes_received);
                
            end

        endcase


    end


    // state mover and registered stuff
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // reset header
            header <= '{default:0};
            msg_type_r <= '0;
            layer_id_r <= '0;
            layer_inputs_r <= '0;
            num_neurons_r <= '0;
            bytes_per_neuron_r <= '0;
            total_bytes_r <= '0;
            reserved_r <= '0;
            // reset status tracking signals
            payload_bytes_received <= '0;
            current_neuron_idx <= '0;
            byte_idx_within_neuron <= '0;
            word_addr_within_neuron <= '0;
            packer_byte_counter <= '0;
            header_byte_idx <= '0;
            // reset state
            curr_state <= IDLE;
            // reset data outputs
            data_out_r <= '{default:'0};
            data_out_valid_r <= '0;
        end else begin
            curr_state <= next_state;
            msg_type_r <= msg_type_r_next;
            layer_id_r <= layer_id_r_next;
            layer_inputs_r <= layer_inputs_r_next;
            num_neurons_r <= num_neurons_r_next;
            bytes_per_neuron_r <= bytes_per_neuron_r_next;
            total_bytes_r <= total_bytes_r_next;
            reserved_r <= reserved_r_next;
            header_byte_idx <= header_byte_idx_next;
            data_out_r <= data_out_next;
            data_out_valid_r <= data_out_valid_next;
        end
    end


endmodule


