module bnn_fcc #(
    parameter int INPUT_DATA_WIDTH  = 8,
    parameter int INPUT_BUS_WIDTH   = 64,
    parameter int CONFIG_BUS_WIDTH  = 64,
    parameter int OUTPUT_DATA_WIDTH = 4,
    parameter int OUTPUT_BUS_WIDTH  = 8,

    parameter int TOTAL_LAYERS = 4,  // Includes input, hidden, and output
    parameter int TOPOLOGY[TOTAL_LAYERS] = '{0: 784, 1: 256, 2: 256, 3: 10, default: 0},  // 0: input, TOTAL_LAYERS-1: output

    parameter int PARALLEL_INPUTS = 16,
    parameter int PARALLEL_NEURONS[TOTAL_LAYERS-1] = '{default: 8},

    parameter int ADDR_W = 10
) (
    input logic clk,
    input logic rst,

    // AXI streaming configuration interface (consumer)
    input  logic                          config_valid,
    output logic                          config_ready,
    input  logic [  CONFIG_BUS_WIDTH-1:0] config_data,
    input  logic [(CONFIG_BUS_WIDTH/8)-1:0] config_keep,
    input  logic                          config_last,

    // AXI streaming image input interface (consumer)
    input  logic                         data_in_valid,
    output logic                         data_in_ready,
    input  logic [  INPUT_BUS_WIDTH-1:0] data_in_data,
    input  logic [INPUT_BUS_WIDTH/8-1:0] data_in_keep,
    input  logic                         data_in_last,

    // AXI streaming classification output interface (producer)
    output logic                          data_out_valid,
    input  logic                          data_out_ready,
    output logic [  OUTPUT_BUS_WIDTH-1:0] data_out_data,
    output logic [OUTPUT_BUS_WIDTH/8-1:0] data_out_keep, // a single bit
    output logic                          data_out_last
);

//------------------------------------------------------------------------------
// Structures
//------------------------------------------------------------------------------

    // current header being read in
    typedef struct packed {
        logic [7:0]               msg_type;
        logic [7:0]               layer_id;
        logic [15:0]              layer_inputs;
        logic [15:0]              num_neurons;
        logic [15:0]              bytes_per_neuron;
        logic [31:0]              total_bytes;
        logic [31:0]              reserved;
    } header_t;
    header_t cfg_header_out;
    logic cfg_header_out_valid;

//------------------------------------------------------------------------------
// Config Manager and Data In Manager
//------------------------------------------------------------------------------

    logic [7:0] cfg_payload_bytes [7:0];
    logic [7:0] cfg_payload_valid;
    logic cfg_error;

    logic [(INPUT_DATA_WIDTH*2)-1:0] img_data_out[INPUT_BUS_WIDTH/16];
    logic [INPUT_BUS_WIDTH/16-1:0] img_data_out_valid;
    logic img_data_out_last;
    logic img_data_out_error;

    logic [INPUT_BUS_WIDTH-1:0] cfg_data_out; // UNUSED

    config_manager #(
        .BUS_WIDTH(CONFIG_BUS_WIDTH)
    ) config_manager_inst (
        .clk(clk),
        .rst(rst),
        .config_valid(config_valid),
        .config_ready(config_ready),
        .config_data_in(config_data),
        .config_keep(config_keep),
        .config_last(config_last),

        .msg_type(cfg_header_out.msg_type),
        .layer_id(cfg_header_out.layer_id),
        .layer_inputs(cfg_header_out.layer_inputs),
        .num_neurons(cfg_header_out.num_neurons),
        .bytes_per_neuron(cfg_header_out.bytes_per_neuron),
        .total_bytes(cfg_header_out.total_bytes),
        .reserved(cfg_header_out.reserved),
        .header_valid(cfg_header_out_valid),
        
        .data_out(cfg_payload_bytes),
        .data_out_valid(cfg_payload_valid),
        .error(cfg_error)
    );

    data_in_manager #(
        .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
        .INPUT_BUS_WIDTH(INPUT_BUS_WIDTH)
    ) data_manager_inst (
        .clk(clk),
        .rst(rst),
        
        .data_in_valid(data_in_valid),
        .data_in_ready(data_in_ready),
        .data_in_data(data_in_data),
        .data_in_keep(data_in_keep),
        .data_in_last(data_in_last),

        .img_data_out(img_data_out),
        .img_data_out_valid(img_data_out_valid),
        .img_data_out_last(img_data_out_last),
        .img_data_out_error(img_data_out_error)
    );

//------------------------------------------------------------------------------
// Layer 0
//------------------------------------------------------------------------------

    localparam int PN0 = PARALLEL_NEURONS[0];

    logic l0_cfg_we;
    logic l0_cfg_is_weight;
    logic [$clog2(PN0)-1:0] l0_cfg_np_sel;
    logic [ADDR_W-1:0] l0_cfg_addr;
    logic [PARALLEL_INPUTS-1:0] l0_cfg_data;

    logic [PN0-1:0] l0_y;
    logic [PN0-1:0][PARALLEL_INPUTS-1:0] l0_popcount;
    logic [PN0-1:0] l0_valid_out;

    logic [PARALLEL_INPUTS-1:0] layer0_x;
    logic layer0_valid_in;

    layer_bank #(
        .PW(PARALLEL_INPUTS),
        .PN(PN0),
        .ADDR_W(ADDR_W),
        .INPUTS_PER_NEURON(784)
    ) layer0_bank_inst (
        .rst(rst),
        .clk(clk),

        .x(layer0_x),
        .valid_in(layer0_valid_in),
        .np_active('1), // have them all active for now. we can change this when we get into real design stuff
        .cfg_we(l0_cfg_we),
        .cfg_is_weight(l0_cfg_is_weight),
        .cfg_np_sel(l0_cfg_np_sel),
        .cfg_addr(l0_cfg_addr),
        .cfg_data(l0_cfg_data),

        .y(l0_y),
        .popcount(l0_popcount),
        .valid_out(l0_valid_out)
    );

//------------------------------------------------------------------------------
// Layer 1
//------------------------------------------------------------------------------

    localparam int PN1 = PARALLEL_NEURONS[1];

    logic l1_cfg_we;
    logic l1_cfg_is_weight;
    logic [$clog2(PN1)-1:0] l1_cfg_np_sel;
    logic [ADDR_W-1:0] l1_cfg_addr;
    logic [PARALLEL_INPUTS-1:0] l1_cfg_data;

    logic [PN1-1:0] l1_y;
    logic [PN1-1:0][PARALLEL_INPUTS-1:0] l1_popcount;
    logic [PN1-1:0] l1_valid_out;

    logic [PARALLEL_INPUTS-1:0] layer1_x;
    logic layer1_valid_in;

    layer_bank #(
        .PW(PARALLEL_INPUTS),
        .PN(PN1),
        .ADDR_W(ADDR_W),
        .INPUTS_PER_NEURON(256)
    ) layer1_bank_inst (
        .rst(rst),
        .clk(clk),

        .x(layer1_x),
        .valid_in(layer1_valid_in),
        .np_active('1), // have them all active for now. we can change this when we get into real design stuff
        .cfg_we(l1_cfg_we),
        .cfg_is_weight(l1_cfg_is_weight),
        .cfg_np_sel(l1_cfg_np_sel),
        .cfg_addr(l1_cfg_addr),
        .cfg_data(l1_cfg_data),

        .y(l1_y),
        .popcount(l1_popcount),
        .valid_out(l1_valid_out)
    );

//------------------------------------------------------------------------------
// Layer 2
//------------------------------------------------------------------------------

    localparam int PN2 = PARALLEL_NEURONS[2];

    logic l2_cfg_we;
    logic l2_cfg_is_weight;
    logic [$clog2(PN2)-1:0] l2_cfg_np_sel;
    logic [ADDR_W-1:0] l2_cfg_addr;
    logic [PARALLEL_INPUTS-1:0] l2_cfg_data;

    logic [PN2-1:0] l2_y;
    logic [PN2-1:0][PARALLEL_INPUTS-1:0] l2_popcount;
    logic [PN2-1:0] l2_valid_out;

    logic [PARALLEL_INPUTS-1:0] layer2_x;
    logic layer2_valid_in;

    layer_bank #(
        .PW(PARALLEL_INPUTS),
        .PN(PN2),
        .ADDR_W(ADDR_W),
        .INPUTS_PER_NEURON(256)
    ) layer2_bank_inst (
        .rst(rst),
        .clk(clk),

        .x(layer2_x),
        .valid_in(layer2_valid_in),
        .np_active('1), // have them all active for now. we can change this when we get into real design stuff
        .cfg_we(l2_cfg_we),
        .cfg_is_weight(l2_cfg_is_weight),
        .cfg_np_sel(l2_cfg_np_sel),
        .cfg_addr(l2_cfg_addr),
        .cfg_data(l2_cfg_data),

        .y(l2_y),
        .popcount(l2_popcount),
        .valid_out(l2_valid_out)
    );

//------------------------------------------------------------------------------
// Seralize Image Data and Feed into Layer 0
//------------------------------------------------------------------------------

    localparam int IMG_CHUNKS = INPUT_BUS_WIDTH / 16;

    logic [PARALLEL_INPUTS-1:0] img_buffer [IMG_CHUNKS];
    logic [IMG_CHUNKS-1:0]      img_buf_valid;
    logic                       img_buf_busy;
    logic [$clog2(IMG_CHUNKS)-1:0] img_idx;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            img_buf_valid <= '0;
            img_buf_busy <= 1'b0;
            img_idx <= '0;
            img_buffer <= '{default: '0};

            layer0_x <= '0;
            layer0_valid_in <= 1'b0;
        end
        else begin
            layer0_valid_in <= 1'b0;
            if(!img_buf_busy && (|img_data_out_valid)) begin
                for(int i = 0; i < IMG_CHUNKS; i++) begin
                    img_buffer[i] <= img_data_out[i];
                    img_buf_valid[i] <= img_data_out_valid[i];
                end
                img_buf_busy <= 1'b1;
                img_idx <= '0;
            end
            else if(img_buf_busy) begin
                layer0_x <= img_buffer[img_idx];
                layer0_valid_in <= img_buf_valid[img_idx];
                img_idx <= img_idx + 1;
                if(img_idx == IMG_CHUNKS - 1) begin
                    img_buf_busy <= 1'b0;
                end
            end
        end
    end

//------------------------------------------------------------------------------
// Seralize Layer 0 Output and Feed into Layer 1
//------------------------------------------------------------------------------

    logic [PN0-1:0] l01_buf [PARALLEL_INPUTS / PN0 - 1:0]; // buffer for layer 0 outputs
    logic l01_buf_full; // flag to see when buffer is full
    logic [$clog2(PARALLEL_INPUTS / PN0)-1:0] l01_buf_idx; // index to keep track of where we are writing in the buffer

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            l01_buf <= '{default: '0}; // reset everything
            layer1_x <= '0;
            layer1_valid_in <= 1'b0;
            l01_buf_full <= 1'b0;
            l01_buf_idx <= '0;
        end
        else begin
            layer1_valid_in <= 1'b0;

            if(l01_buf_full) begin // if the buffer is full
                // hardcoded version
                // layer1_x <= {l01_buf[1], l01_buf[0]}; // send the packed 16 bit data to the next layer

                // Generic version -- Assumes Parallel Inputs is divisible by your layer size (PN)
                for (int i = 0; i < PARALLEL_INPUTS / PN0; i++) begin
                    layer1_x[i*PN0 +: PN0] <= l01_buf[i];
                end

                layer1_valid_in <= 1'b1; // set valid signal
                l01_buf_full <= 1'b0; // set full to 0
            end
            else if(&l0_valid_out) begin // if the buffer isnt full and the outputs on the previous layer are valid
                l01_buf[l01_buf_idx] <= l0_y; // write outputs to the buffer
                l01_buf_idx <= l01_buf_idx + 1; // incremenet index

                if(l01_buf_idx == (PARALLEL_INPUTS / PN0) - 1) begin // if we are at the end of the buffer
                    l01_buf_full <= 1'b1; // set full to 1
                    l01_buf_idx <= '0; // reset index
                end
            end
        end
    end

//------------------------------------------------------------------------------
// Seralize Layer 1 Output and Feed into Layer 2
//------------------------------------------------------------------------------

    logic [PN1-1:0] l12_buf [PARALLEL_INPUTS / PN1 - 1:0]; // buffer for layer 0 outputs
    logic l12_buf_full; // flag to see when buffer is full
    logic [$clog2(PARALLEL_INPUTS / PN1)-1:0] l12_buf_idx; // index to keep track of where we are writing in the buffer

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            l12_buf <= '{default: '0}; // reset everything
            layer2_x <= '0;
            layer2_valid_in <= 1'b0;
            l12_buf_full <= 1'b0;
            l12_buf_idx <= '0;
        end
        else begin
            layer2_valid_in <= 1'b0;

            if(l12_buf_full) begin // if the buffer is full
                // hardcoded version
                // layer2_x <= {l12_buf[1], l12_buf[0]}; // send the packed 16 bit data to the next layer

                // Generic version -- Assumes Parallel Inputs is divisible by your layer size (PN)
                for (int i = 0; i < PARALLEL_INPUTS / PN1; i++) begin
                    layer2_x[i*PN1 +: PN1] <= l12_buf[i];
                end

                layer2_valid_in <= 1'b1; // set valid signal
                l12_buf_full <= 1'b0; // set full to 0
            end
            else if(&l1_valid_out) begin // if the buffer isnt full and the outputs on the previous layer are valid
                l12_buf[l12_buf_idx] <= l1_y; // write outputs to the buffer
                l12_buf_idx <= l12_buf_idx + 1; // incremenet index

                if(l12_buf_idx == (PARALLEL_INPUTS / PN1) - 1) begin // if we are at the end of the buffer
                    l12_buf_full <= 1'b1; // set full to 1
                    l12_buf_idx <= '0; // reset index
                end
            end
        end
    end

//------------------------------------------------------------------------------
// Parse Config Manager and Write to BRAMS
//------------------------------------------------------------------------------

    localparam int LAYER0 = 8'd1;
    localparam int LAYER1 = 8'd2;
    localparam int LAYER2 = 8'd3;

    logic [7:0] active_layer_id;
    logic       active_is_weight;
    logic [ADDR_W-1:0] cfg_addr_count;
    logic [31:0] weight_iter; // can parameterize this if we want to just didnt feel like doing the math

    logic [$clog2(PN0)-1:0] l0_np_count;
    logic [$clog2(PN1)-1:0] l1_np_count;
    logic [$clog2(PN2)-1:0] l2_np_count;

    logic [$clog2(TOPOLOGY[0] / PARALLEL_INPUTS)-1:0] l0_weight_counter;
    logic [$clog2(TOPOLOGY[1] / PARALLEL_INPUTS)-1:0] l1_weight_counter;
    logic [$clog2(TOPOLOGY[2] / PARALLEL_INPUTS)-1:0] l2_weight_counter;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            l0_cfg_we <= 1'b0;
            l0_cfg_is_weight <= 1'b0;
            l0_cfg_np_sel <= '0;
            l0_cfg_addr <= '0;
            l0_cfg_data <= '0;

            l1_cfg_we <= 1'b0;
            l1_cfg_is_weight <= 1'b0;
            l1_cfg_np_sel <= '0;
            l1_cfg_addr <= '0;
            l1_cfg_data <= '0;

            l2_cfg_we <= 1'b0;
            l2_cfg_is_weight <= 1'b0;
            l2_cfg_np_sel <= '0;
            l2_cfg_addr <= '0;
            l2_cfg_data <= '0;

            active_layer_id <= '0;
            active_is_weight <= 1'b0;
            cfg_addr_count <= '0;

            l0_np_count <= '0;
            l1_np_count <= '0;
            l2_np_count <= '0;

            l0_weight_counter <= '0;
            l1_weight_counter <= '0;
            l2_weight_counter <= '0;

            weight_iter <= '0;
        end
        else begin
            l0_cfg_we <= 1'b0; // set all write enables to 0 by default
            l1_cfg_we <= 1'b0;
            l2_cfg_we <= 1'b0;

            if(cfg_header_out_valid) begin
                active_layer_id <= cfg_header_out.layer_id; // latch active layer
                active_is_weight <= (cfg_header_out.msg_type == 0); // latch whether its weight or threshold
                cfg_addr_count <= '0; // reset address count

                l0_np_count <= '0; // reset neuron processor counters
                l1_np_count <= '0;
                l2_np_count <= '0;

                l0_weight_counter <= '0;
                l1_weight_counter <= '0;
                l2_weight_counter <= '0;

                weight_iter <= '0;
            end

            // TODO: i need to pack these like actually. We need like a small buffer to put together 1,0 3,2 5,4 7,6 yktv
            if(cfg_payload_valid[0] && cfg_payload_valid[1]) begin // make sure 16 bits ready to write
                if(active_layer_id == LAYER0) begin // check active layer amd assign write enables ready to rumble
                    l0_cfg_we <= 1'b1;
                    l0_cfg_is_weight <= active_is_weight;
                    l0_cfg_addr <= cfg_addr_count;
                    l0_cfg_data <= {cfg_payload_bytes[1], cfg_payload_bytes[0]}; // combine
                    l0_cfg_np_sel <= l0_np_count;
                    if(active_is_weight) begin // if we are writing weights
                        l0_weight_counter <= l0_weight_counter + 1; // we increment the amount of weights we have written
                        cfg_addr_count <= cfg_addr_count + 1; // we incrmenet the address

                        if(l0_weight_counter == TOPOLOGY[0] / PARALLEL_INPUTS - 1) begin ///for every neuron worth of weights we write
                            l0_np_count <= l0_np_count + 1; // we move to the next neuron processor
                            cfg_addr_count <= weight_iter * (TOPOLOGY[0] / PARALLEL_INPUTS); // we reset the address to start from 0 on the next neuron processor's bram
                            l0_weight_counter <= '0; // we reset the weight counter as well

                            if(l0_np_count == PN0 - 1) begin // if we are on the last neuron processor and writing the last weight
                                l0_np_count <= '0; // next cycle put the select back to the first neuron
                                weight_iter <= weight_iter + 1; // we have done a full iteration of writing weights, we increment the iteration counter
                                cfg_addr_count <= (weight_iter + 1'b1) * (TOPOLOGY[0] / PARALLEL_INPUTS); // we move the address count to the next set of weights for the next iteration
                            end
                        end
                    end

                    else if(!active_is_weight) begin
                        l0_np_count <= l0_np_count + 1; // increment the select signal

                        if(l0_np_count == PN0 - 1) begin // if the select signal is at the last neuron
                            l0_np_count <= '0; // next cycle put the select back to the first neuron
                            cfg_addr_count <= cfg_addr_count + 1; // increment the address
                        end
                    end
                end

                if(active_layer_id == LAYER1) begin
                    l1_cfg_we <= 1'b1;
                    l1_cfg_is_weight <= active_is_weight;
                    l1_cfg_addr <= cfg_addr_count;
                    l1_cfg_data <= {cfg_payload_bytes[1], cfg_payload_bytes[0]}; // combine
                    l1_cfg_np_sel <= l1_np_count;

                    if(active_is_weight) begin // if we are writing weights
                        l1_weight_counter <= l1_weight_counter + 1; // we increment the amount of weights we have written
                        cfg_addr_count <= cfg_addr_count + 1; // we incrmenet the address

                        if(l1_weight_counter == TOPOLOGY[1] / PARALLEL_INPUTS - 1) begin ///for every neuron worth of weights we write
                            l1_np_count <= l1_np_count + 1; // we move to the next neuron processor
                            cfg_addr_count <= weight_iter * (TOPOLOGY[1] / PARALLEL_INPUTS); // we reset the address to start from 0 on the next neuron processor's bram
                            l1_weight_counter <= '0; // we reset the weight counter as well

                            if(l1_np_count == PN1 - 1) begin // if we are on the last neuron processor and writing the last weight
                                l1_np_count <= '0; // next cycle put the select back to the first neuron
                                weight_iter <= weight_iter + 1; // we have done a full iteration of writing weights, we increment the iteration counter
                                cfg_addr_count <= (weight_iter + 1'b1) * (TOPOLOGY[1] / PARALLEL_INPUTS); // we move the address count to the next set of weights for the next iteration
                            end
                        end
                    end

                    else if(!active_is_weight) begin
                        l1_np_count <= l1_np_count + 1; // increment the select signal

                        if(l1_np_count == PN1 - 1) begin // if the select signal is at the last neuron
                            l1_np_count <= '0; // next cycle put the select back to the first neuron
                            cfg_addr_count <= cfg_addr_count + 1; // increment the address
                        end
                    end
                end

                if(active_layer_id == LAYER2) begin
                    l2_cfg_we <= 1'b1;
                    l2_cfg_is_weight <= active_is_weight;
                    l2_cfg_addr <= cfg_addr_count;
                    l2_cfg_data <= {cfg_payload_bytes[1], cfg_payload_bytes[0]}; // combine
                    l2_cfg_np_sel <= l2_np_count;

                    if(active_is_weight) begin // if we are writing weights
                        l2_weight_counter <= l2_weight_counter + 1; // we increment the amount of weights we have written
                        cfg_addr_count <= cfg_addr_count + 1; // we incrmenet the address

                        if(l2_weight_counter == TOPOLOGY[2] / PARALLEL_INPUTS - 1) begin ///for every neuron worth of weights we write
                            l2_np_count <= l2_np_count + 1; // we move to the next neuron processor
                            cfg_addr_count <= weight_iter * (TOPOLOGY[2] / PARALLEL_INPUTS); // we reset the address to start from 0 on the next neuron processor's bram
                            l2_weight_counter <= '0; // we reset the weight counter as well

                            if(l2_np_count == PN2 - 1) begin // if we are on the last neuron processor and writing the last weight
                                l2_np_count <= '0; // next cycle put the select back to the first neuron
                                weight_iter <= weight_iter + 1; // we have done a full iteration of writing weights, we increment the iteration counter
                                cfg_addr_count <= (weight_iter + 1'b1) * (TOPOLOGY[2] / PARALLEL_INPUTS); // we move the address count to the next set of weights for the next iteration
                            end
                        end
                    end

                    else if(!active_is_weight) begin
                        l2_np_count <= l2_np_count + 1; // increment the select signal

                        if(l2_np_count == PN2 - 1) begin // if the select signal is at the last neuron
                            l2_np_count <= '0; // next cycle put the select back to the first neuron
                            cfg_addr_count <= cfg_addr_count + 1; // increment the address
                        end
                    end
                end
            end
        end
    end


endmodule
