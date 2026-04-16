module bnn_fcc_large #(
    parameter int INPUT_DATA_WIDTH  = 8,
    parameter int INPUT_BUS_WIDTH   = 64,
    parameter int CONFIG_BUS_WIDTH  = 64,
    parameter int OUTPUT_DATA_WIDTH = 4,
    parameter int OUTPUT_BUS_WIDTH  = 8,

    parameter int TOTAL_LAYERS = 4,  // Includes input, hidden, and output
    parameter int TOPOLOGY[TOTAL_LAYERS] = '{0: 784, 1: 256, 2: 256, 3: 10, default: 0},  // 0: input, TOTAL_LAYERS-1: output

    parameter int PARALLEL_INPUTS = 16,
    parameter int PARALLEL_NEURONS[TOTAL_LAYERS-1] = '{16, 16, 10},

    parameter int ADDR_W = 11
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

    // stuff for the config manager if it output 16 bits. I didnt wanna touch it
    // localparam int CFG_PAYLOAD_LANES = CONFIG_BUS_WIDTH / 16;
    // localparam int CFG_PAYLOAD_BYTES = CONFIG_BUS_WIDTH / 8;

    // logic [15:0] cfg_payload_words [CFG_PAYLOAD_LANES-1:0];
    // logic [CFG_PAYLOAD_BYTES-1:0] cfg_payload_valid;
    // logic [CFG_PAYLOAD_LANES-1:0] cfg_payload_word_valid;
    // logic cfg_payload_ready;
    // logic cfg_error;

    localparam int CFG_PAYLOAD_BYTES = CONFIG_BUS_WIDTH / 8;

    logic [7:0] cfg_payload_bytes [0:CFG_PAYLOAD_BYTES-1]; // this is a bit gross but it lets us keep the payload as 16 bits without changing the config manager
    logic [CFG_PAYLOAD_BYTES-1:0] cfg_payload_valid;
    logic cfg_error;

    localparam int IMG_CHUNKS = INPUT_BUS_WIDTH / 16;
    localparam int BIN_PIXELS_PER_CHUNK = 2;
    localparam int BIN_PIXELS_PER_BEAT = INPUT_BUS_WIDTH / 8;

    logic [BIN_PIXELS_PER_CHUNK-1:0] img_data_out[IMG_CHUNKS];
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
    localparam int PW = PARALLEL_INPUTS;

    logic l0_cfg_w_we; //write enable for layer 0 brams
    logic [$clog2(PN0)-1:0] l0_cfg_w_np_sel; // select signal to choose which neuron processor to write to (if we have multiple)
    logic [8:0] l0_cfg_w_addr; // address for the bram we are writing to
    logic [63:0] l0_cfg_w_data; // weights/thresholds being written to bram

    logic [PN0-1:0] l0_cfg_t_we_np; // write enable for layer 0 threshold brams, one per neuron processor
    logic [PN0-1:0][ADDR_W-1:0] l0_cfg_t_addr_np; // address for layer 0 threshold brams, one per neuron processor
    logic [PN0-1:0][PW-1:0] l0_cfg_t_data_np; // threshold data for layer 0, one per neuron processor

    logic [PN0-1:0] l0_y; // output of layer 0 neuron processors for each processor
    logic [PN0-1:0][PARALLEL_INPUTS-1:0] l0_popcount; // packed signal of popcount results for each neuron processor. 
    logic [PN0-1:0] l0_valid_out; // valid

    logic [PN0-1:0] l0_last_img_out;

    logic [PARALLEL_INPUTS-1:0] layer0_x; // image data
    logic layer0_valid_in; // valid

    logic img_last_out;

    // questions:
        // how many neurons are being instantiated?
        // how is data being streamed to all the neurons?
        // is this pipelined or sequential for solving the popcount of all pixels in img for all the neurons instantiated?
        // how are the weights and thresholds being stored/streamed to the neurons? 
        // if there's waveform examples of how layer bank works, please show so i can visualize better
    layer_bank #(
        .PW(PARALLEL_INPUTS),
        .PN(PN0),
        .ADDR_W(ADDR_W),
        .INPUTS_PER_NEURON(TOPOLOGY[0])
    ) layer0_bank_inst (
        .rst(rst),
        .clk(clk),
        .x(layer0_x),
        .valid_in(layer0_valid_in),
        .np_active('1),

        .cfg_w_we(l0_cfg_w_we),
        .cfg_w_np_sel(l0_cfg_w_np_sel),
        .cfg_w_addr(l0_cfg_w_addr),
        .cfg_w_data(l0_cfg_w_data),

        .cfg_t_we_np(l0_cfg_t_we_np),
        .cfg_t_addr_np(l0_cfg_t_addr_np),
        .cfg_t_data_np(l0_cfg_t_data_np),

        .image_last(img_last_out),

        .y(l0_y),
        .popcount(l0_popcount),
        .valid_out(l0_valid_out),

        .last_img_out(l0_last_img_out)
    );

//------------------------------------------------------------------------------
// Layer 1
//------------------------------------------------------------------------------

    localparam int PN1 = PARALLEL_NEURONS[1];

    logic l1_cfg_w_we; //write enable for layer 1 brams
    logic [$clog2(PN1)-1:0] l1_cfg_w_np_sel; // select signal to choose which neuron processor to write to (if we have multiple)
    logic [8:0] l1_cfg_w_addr; // address for the bram we are writing to
    logic [63:0] l1_cfg_w_data; // weights/thresholds being written to bram

    logic [PN1-1:0] l1_cfg_t_we_np; // write enable for layer 1 threshold brams, one per neuron processor
    logic [PN1-1:0][ADDR_W-1:0] l1_cfg_t_addr_np; // address for layer 1 threshold brams, one per neuron processor
    logic [PN1-1:0][PW-1:0] l1_cfg_t_data_np; // threshold data for layer 1, one per neuron processor

    logic [PN1-1:0] l1_y; // output of layer 1 neuron processors for each processor
    logic [PN1-1:0][PARALLEL_INPUTS-1:0] l1_popcount; // packed signal of popcount results for each neuron processor. 
    logic [PN1-1:0] l1_valid_out; // valid

    logic [PN1-1:0] l1_last_img_out;

    logic [PARALLEL_INPUTS-1:0] layer1_x; // image data
    logic layer1_valid_in; // valid

    logic l01_last_img_out;

    // questions:
        // how many neurons are being instantiated?
        // how is data being streamed to all the neurons?
        // is this pipelined or sequential for solving the popcount of all pixels in img for all the neurons instantiated?
        // how are the weights and thresholds being stored/streamed to the neurons? 
        // if there's waveform examples of how layer bank works, please show so i can visualize better
    layer_bank #(
        .PW(PARALLEL_INPUTS),
        .PN(PN1),
        .ADDR_W(ADDR_W),
        .INPUTS_PER_NEURON(TOPOLOGY[1])
    ) layer1_bank_inst (
        .rst(rst),
        .clk(clk),
        .x(layer1_x),
        .valid_in(layer1_valid_in),
        .np_active('1),

        .cfg_w_we(l1_cfg_w_we),
        .cfg_w_np_sel(l1_cfg_w_np_sel),
        .cfg_w_addr(l1_cfg_w_addr),
        .cfg_w_data(l1_cfg_w_data),

        .cfg_t_we_np(l1_cfg_t_we_np),
        .cfg_t_addr_np(l1_cfg_t_addr_np),
        .cfg_t_data_np(l1_cfg_t_data_np),

        .image_last(l01_last_img_out),

        .y(l1_y),
        .popcount(l1_popcount),
        .valid_out(l1_valid_out),

        .last_img_out(l1_last_img_out)
    );

//------------------------------------------------------------------------------
// Layer 2
//------------------------------------------------------------------------------

    localparam int PN2 = PARALLEL_NEURONS[2];

    logic l2_cfg_w_we; //write enable for layer 2 brams
    logic [$clog2(PN2)-1:0] l2_cfg_w_np_sel; // select signal to choose which neuron processor to write to (if we have multiple)
    logic [8:0] l2_cfg_w_addr; // address for the bram we are writing to
    logic [63:0] l2_cfg_w_data; // weights/thresholds being written to bram

    logic [PN2-1:0] l2_cfg_t_we_np; // write enable for layer 2 threshold brams, one per neuron processor
    logic [PN2-1:0][ADDR_W-1:0] l2_cfg_t_addr_np; // address for layer 2 threshold brams, one per neuron processor
    logic [PN2-1:0][PW-1:0] l2_cfg_t_data_np; // threshold data for layer 2, one per neuron processor

    logic [PN2-1:0] l2_y; // output of layer 2 neuron processors for each processor
    logic [PN2-1:0][PARALLEL_INPUTS-1:0] l2_popcount; // packed signal of popcount results for each neuron processor. 
    logic [PN2-1:0] l2_valid_out; // valid

    logic [PN2-1:0] l2_last_img_out;

    logic [PARALLEL_INPUTS-1:0] layer2_x; // image data
    logic layer2_valid_in; // valid

    // questions:
        // how many neurons are being instantiated?
        // how is data being streamed to all the neurons?
        // is this pipelined or sequential for solving the popcount of all pixels in img for all the neurons instantiated?
        // how are the weights and thresholds being stored/streamed to the neurons? 
        // if there's waveform examples of how layer bank works, please show so i can visualize better
    layer_bank #(
        .PW(PARALLEL_INPUTS),
        .PN(PN2),
        .ADDR_W(ADDR_W),
        .INPUTS_PER_NEURON(TOPOLOGY[2])
    ) layer2_bank_inst (
        .rst(rst),
        .clk(clk),
        .x(layer2_x),
        .valid_in(layer2_valid_in),
        .np_active('1),

        .cfg_w_we(l2_cfg_w_we),
        .cfg_w_np_sel(l2_cfg_w_np_sel),
        .cfg_w_addr(l2_cfg_w_addr),
        .cfg_w_data(l2_cfg_w_data),

        .cfg_t_we_np(l2_cfg_t_we_np),
        .cfg_t_addr_np(l2_cfg_t_addr_np),
        .cfg_t_data_np(l2_cfg_t_data_np),

        .image_last(l1_last_img_out[0]),

        .y(l2_y),
        .popcount(l2_popcount),
        .valid_out(l2_valid_out),

        .last_img_out(l2_last_img_out)
    );

//------------------------------------------------------------------------------
// Seralize Image Data, Feed into FIFO, FIFO feeds Layer 0
//------------------------------------------------------------------------------

    localparam int IMG_BEAT_W = IMG_CHUNKS * 2; // 8 bits

    logic [IMG_BEAT_W-1:0] img_l0_buf;
    logic                  img_l0_buf_valid;
    logic [PARALLEL_INPUTS-1:0] img_to_fifo; // image data
    logic img_to_fifo_valid; // valid

    logic [IMG_BEAT_W-1:0] packed_img_beat;

    logic img_to_fifo_last;

    // NOTE: we are ignoring img_data_out_last because of the assumption that the input image size is going to be 784 bits
    // we could change that to handle different sizes but that would also require changing 
    // the logic inside the neuron processor for last assertion.

    always_comb begin
        packed_img_beat = '0;
        for (int i = 0; i < IMG_CHUNKS; i++) begin // loop through image data output
            packed_img_beat[i*2 +: 2] = img_data_out[i]; // pack all 8 bits into one 8 bit vector
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            img_l0_buf        <= '0;
            img_l0_buf_valid  <= 1'b0;
            img_to_fifo       <= '0;
            img_to_fifo_valid <= 1'b0;
            img_to_fifo_last <= 1'b0;
        end
        else begin
            img_to_fifo_valid <= 1'b0;
            img_to_fifo_last <= img_data_out_last;

            if (&img_data_out_valid) begin // if the data is valid (all of it)
                if (!img_l0_buf_valid) begin // if buffer isnt in use
                    // first packed 8-bit beat
                    img_l0_buf       <= packed_img_beat; // send the packed bit
                    img_l0_buf_valid <= 1'b1; // set buffer to valid
                end
                else begin
                    // second packed 8-bit beat -> emit full 16-bit input
                    img_to_fifo <= {packed_img_beat, img_l0_buf}; // if it is valid pack the current and previous beats
                    img_to_fifo_valid <= 1'b1; // set valid in for layer 0
                    img_l0_buf_valid <= 1'b0; // reset buffer
                end
            end
        end
    end

    img_data_fifo #(
        .WIDTH(PARALLEL_INPUTS),
        .INPUTS(TOPOLOGY[0]),
        .NUM_REPLAYS(TOPOLOGY[1] / PN0),
        .DEPTH(50)
    ) img_data_fifo_inst0 (
        .clk(clk),
        .rst(rst),

        .data_in(img_to_fifo),
        .valid_in(img_to_fifo_valid),
        .img_data_last(img_to_fifo_last),
        //doesnt need a connection rn but could be useful
        .ready_in(), // this is a signal so we can monitor if the fifo is full from the outside

        .data_out(layer0_x),
        .valid_out(layer0_valid_in),
        .img_last_out(img_last_out),
        .ready_out(1'b1)
    );

//------------------------------------------------------------------------------
// Seralize Layer 0 Output and Feed into Layer 1
//------------------------------------------------------------------------------

    logic [PN0-1:0] l01_buf [PARALLEL_INPUTS / PN0 - 1:0]; // buffer for layer 0 outputs
    logic l01_buf_full; // flag to see when buffer is full
    logic [$clog2(PARALLEL_INPUTS / PN0)-1:0] l01_buf_idx; // index to keep track of where we are writing in the buffer

    logic [PARALLEL_INPUTS-1:0] l01_data; // image data
    logic l01_valid_in; // valid

    logic l01_last_image_r1, l01_last_image_r2;

    // this is fire
    // might neeed to make proper handshakes here but that's my only thing

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            l01_buf <= '{default: '0}; // reset everything
            l01_data <= '0;
            l01_valid_in <= 1'b0;
            l01_buf_full <= 1'b0;
            l01_buf_idx <= '0;

            l01_last_image_r1 <= 1'b0;
            l01_last_image_r2 <= 1'b0;
        end
        else begin
            l01_valid_in <= 1'b0;

            l01_last_image_r1 <= l0_last_img_out[0];
            l01_last_image_r2 <= l01_last_image_r1;

            if(l01_buf_full) begin // if the buffer is full
                // hardcoded version
                // layer1_x <= {l01_buf[1], l01_buf[0]}; // send the packed 16 bit data to the next layer

                // Generic version -- Assumes Parallel Inputs is divisible by your layer size (PN)
                for (int i = 0; i < PARALLEL_INPUTS / PN0; i++) begin
                    l01_data[i*PN0 +: PN0] <= l01_buf[i];
                end

                l01_valid_in <= 1'b1; // set valid signal
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

    img_data_fifo #(
        .WIDTH(PARALLEL_INPUTS),
        .INPUTS(TOPOLOGY[1]),
        .NUM_REPLAYS(TOPOLOGY[2] / PN1),
        .DEPTH(50)
    ) img_data_fifo_inst1 (
        .clk(clk),
        .rst(rst),

        .data_in(l01_data),
        .valid_in(l01_valid_in),
        .img_data_last(l01_last_image_r2),
        //doesnt need a connection rn but could be useful
        .ready_in(), // this is a signal so we can monitor if the fifo is full from the outside

        .data_out(layer1_x),
        .valid_out(layer1_valid_in),
        .img_last_out(l01_last_img_out),
        .ready_out(1'b1)
    );

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
// Capture Layer 2 Outputs
//------------------------------------------------------------------------------

    logic [PARALLEL_INPUTS-1:0] final_scores [TOPOLOGY[3]-1:0]; // buffer for layer 2 outputs
    logic [$clog2(TOPOLOGY[3]+1)-1:0] final_scores_idx; // index to keep track of where we are writing in the buffer
    logic final_scores_full; // flag to see when buffer is full

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            final_scores_full <= 1'b0;
            final_scores_idx <= '0;
            final_scores <= '{default: '0};
        end
        else begin
            int next_count;
            next_count = final_scores_idx;

            if(data_out_valid && data_out_ready) begin
                final_scores_full <= 1'b0; // reset full flag to start filling buffer again
                final_scores_idx <= '0; // reset index
                final_scores <= '{default: '0}; // clear buffer
            end

            if(!final_scores_full) begin // if the final scores list is not full
                for(int i = 0; i < PN2; i++) begin // increment through all the neuron processors
                    if(l2_valid_out[i] && next_count < TOPOLOGY[3]) begin // if the output is valid and we have room in the buffer
                        final_scores[next_count] <= l2_popcount[i]; // write outputs to the buffer
                        next_count = next_count + 1; // increment count
                    end
                end

                final_scores_idx <= next_count;

                if(next_count >= TOPOLOGY[3]) begin // if we get to past the size of the buffer
                    final_scores_full <= 1'b1; // set full to 1
                end
            end
        end
    end

//------------------------------------------------------------------------------
// Argmax
//------------------------------------------------------------------------------

    logic [PARALLEL_INPUTS-1:0] max_val;
    logic [$clog2(TOPOLOGY[3])-1:0] max_idx;

    assign data_out_valid = final_scores_full; // output is valid when we have all the final scores
    assign data_out_data = max_idx; // output the index of the max value as the classification result
    
    // These two im not really sure about @lucas if you wanna look these over thatd be great
    assign data_out_keep = '1;
    assign data_out_last = 1'b1;

    always_comb begin
        max_val = final_scores[0]; // set initial max to the first value
        max_idx = 0; // set initial index to 0

        if(final_scores_full) begin
            for(int i = 1; i < TOPOLOGY[3]; i++) begin // loop through all the final scores
                if(final_scores[i] > max_val) begin // if the current score is greater than the max
                    max_val = final_scores[i]; // update value and index
                    max_idx = i;
                end
            end
        end
    end

//------------------------------------------------------------------------------
// Parse Config Manager and Write to BRAMS
//------------------------------------------------------------------------------

    localparam int LAYER0 = 8'd0;
    localparam int LAYER1 = 8'd1;
    localparam int LAYER2 = 8'd2;

    localparam int L0_WORDS_PER_NEURON = (TOPOLOGY[0] + 63) / 64;
    localparam int L1_WORDS_PER_NEURON = (TOPOLOGY[1] + 63) / 64;
    localparam int L2_WORDS_PER_NEURON = (TOPOLOGY[2] + 63) / 64;

    logic [$clog2(PN0)-1:0] l0_w_np_count;
    logic [$clog2(PN1)-1:0] l1_w_np_count;
    logic [$clog2(PN2)-1:0] l2_w_np_count;

    logic [$clog2(L0_WORDS_PER_NEURON+1)-1:0] l0_weight_counter;
    logic [$clog2(L1_WORDS_PER_NEURON+1)-1:0] l1_weight_counter;
    logic [$clog2(L2_WORDS_PER_NEURON+1)-1:0] l2_weight_counter;

    logic [3:0] active_layer_id;
    logic active_is_weight;

    logic [2:0] t_eights;

    logic [31:0] weight_iter;

    logic [ADDR_W-1:0] cfg_addr_count;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            l0_cfg_w_we <= 1'b0; 
            l0_cfg_w_np_sel <= '0; 
            l0_cfg_w_addr <= '0; 
            l0_cfg_w_data <= '0; 

            l0_cfg_t_we_np <= '0;
            l0_cfg_t_addr_np <= '0;
            l0_cfg_t_data_np <= '0;


            l1_cfg_w_we <= 1'b0; 
            l1_cfg_w_np_sel <= '0; 
            l1_cfg_w_addr <= '0; 
            l1_cfg_w_data <= '0; 

            l1_cfg_t_we_np <= '0;
            l1_cfg_t_addr_np <= '0;
            l1_cfg_t_data_np <= '0;


            l2_cfg_w_we <= 1'b0; 
            l2_cfg_w_np_sel <= '0; 
            l2_cfg_w_addr <= '0; 
            l2_cfg_w_data <= '0; 

            l2_cfg_t_we_np <= '0;
            l2_cfg_t_addr_np <= '0;
            l2_cfg_t_data_np <= '0;


            active_layer_id <= '0;
            active_is_weight <= 1'b0;
            cfg_addr_count <= '0;

            l0_w_np_count <= '0;
            l1_w_np_count <= '0;
            l2_w_np_count <= '0;

            l0_weight_counter <= '0;
            l1_weight_counter <= '0;
            l2_weight_counter <= '0;

            weight_iter <= '0;

            t_eights <= 3'b000;
        end
        else begin
            l0_cfg_w_we <= 1'b0; // set all write enables to 0 by default
            l1_cfg_w_we <= 1'b0;
            l2_cfg_w_we <= 1'b0;

            l0_cfg_t_we_np <= '0;
            l1_cfg_t_we_np <= '0;
            l2_cfg_t_we_np <= '0;

            if(cfg_header_out_valid) begin

                cfg_addr_count <= '0; // reset address count

                l0_w_np_count <= '0; // reset neuron processor counters
                l1_w_np_count <= '0;
                l2_w_np_count <= '0;

                l0_weight_counter <= '0;
                l1_weight_counter <= '0;
                l2_weight_counter <= '0;

                active_layer_id <= cfg_header_out.layer_id; // set active layer based on config header
                active_is_weight <= (cfg_header_out.msg_type == 0);

                weight_iter <= '0; // reset weight iteration counter

                t_eights <= 3'b000; // reset threshold upper half flag
            end

            else if(&cfg_payload_valid) begin // make sure 16 bits ready to write
                if(active_layer_id == LAYER0) begin // check active layer amd assign write enables ready to rumble
                    if(active_is_weight) begin // if we are writing weights
                        l0_cfg_w_np_sel <= l0_w_np_count;
                        l0_cfg_w_addr <= cfg_addr_count;
                        l0_cfg_w_we <= 1'b1;
                        l0_cfg_w_data <= {
                            cfg_payload_bytes[7],
                            cfg_payload_bytes[6],
                            cfg_payload_bytes[5],
                            cfg_payload_bytes[4],
                            cfg_payload_bytes[3],
                            cfg_payload_bytes[2],
                            cfg_payload_bytes[1],
                            cfg_payload_bytes[0]
                        };

                        l0_weight_counter <= l0_weight_counter + 1; // we increment the amount of weights we have written
                        cfg_addr_count <= cfg_addr_count + 1; // we incrmenet the address

                        if(l0_weight_counter == L0_WORDS_PER_NEURON-1) begin // for every neuron worth of weights we write (last bit 16 bits padded with an extra 48)
                            l0_w_np_count <= l0_w_np_count + 1; // we move to the next neuron processor
                            cfg_addr_count <= weight_iter * L0_WORDS_PER_NEURON; // we reset the address to start from 0 on the next neuron processor's bram
                            l0_weight_counter <= '0; // we reset the weight counter as well

                            if(l0_w_np_count == PN0 - 1) begin // if we are on the last neuron processor and writing the last weight
                                l0_w_np_count <= '0; // next cycle put the select back to the first neuron
                                weight_iter <= weight_iter + 1; // we have done a full iteration of writing weights, we increment the iteration counter
                                cfg_addr_count <= (weight_iter + 1'b1) * L0_WORDS_PER_NEURON; // we move the address count to the next set of weights for the next iteration
                            end
                        end
                    end

                    else if(!active_is_weight) begin
                        logic [31:0] t0_32, t1_32;
                        logic [15:0] t0, t1;

                        t0_32 = {cfg_payload_bytes[3], cfg_payload_bytes[2], cfg_payload_bytes[1], cfg_payload_bytes[0]};
                        t1_32 = {cfg_payload_bytes[7], cfg_payload_bytes[6], cfg_payload_bytes[5], cfg_payload_bytes[4]};

                        t0 = t0_32[15:0];
                        t1 = t1_32[15:0];

                        if (t_eights == 3'b000) begin
                            // first 4 thresholds go to neuron processors 0,1,2,3
                            l0_cfg_t_we_np[0]   <= 1'b1;
                            l0_cfg_t_we_np[1]   <= 1'b1;

                            l0_cfg_t_addr_np[0] <= cfg_addr_count;
                            l0_cfg_t_addr_np[1] <= cfg_addr_count;

                            l0_cfg_t_data_np[0] <= t0;
                            l0_cfg_t_data_np[1] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 3'b001) begin
                            l0_cfg_t_we_np[2]   <= 1'b1;
                            l0_cfg_t_we_np[3]   <= 1'b1;

                            l0_cfg_t_addr_np[2] <= cfg_addr_count;
                            l0_cfg_t_addr_np[3] <= cfg_addr_count;

                            l0_cfg_t_data_np[2] <= t0;
                            l0_cfg_t_data_np[3] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 3'b010) begin
                            l0_cfg_t_we_np[4]   <= 1'b1;
                            l0_cfg_t_we_np[5]   <= 1'b1;

                            l0_cfg_t_addr_np[4] <= cfg_addr_count;
                            l0_cfg_t_addr_np[5] <= cfg_addr_count;

                            l0_cfg_t_data_np[4] <= t0;
                            l0_cfg_t_data_np[5] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 3'b011) begin
                            // next 4 thresholds go to neuron processors 4,5,6,7
                            l0_cfg_t_we_np[6]   <= 1'b1;
                            l0_cfg_t_we_np[7]   <= 1'b1;

                            l0_cfg_t_addr_np[6] <= cfg_addr_count;
                            l0_cfg_t_addr_np[7] <= cfg_addr_count;

                            l0_cfg_t_data_np[6] <= t0;
                            l0_cfg_t_data_np[7] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 4'b100) begin
                            l0_cfg_t_we_np[8]   <= 1'b1;
                            l0_cfg_t_we_np[9]   <= 1'b1;

                            l0_cfg_t_addr_np[8] <= cfg_addr_count;
                            l0_cfg_t_addr_np[9] <= cfg_addr_count;

                            l0_cfg_t_data_np[8] <= t0;
                            l0_cfg_t_data_np[9] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 4'b101) begin
                            l0_cfg_t_we_np[10]   <= 1'b1;
                            l0_cfg_t_we_np[11]   <= 1'b1;

                            l0_cfg_t_addr_np[10] <= cfg_addr_count;
                            l0_cfg_t_addr_np[11] <= cfg_addr_count;

                            l0_cfg_t_data_np[10] <= t0;
                            l0_cfg_t_data_np[11] <= t1;
                        end
                        else if (t_eights == 4'b110) begin
                            l0_cfg_t_we_np[12]   <= 1'b1;
                            l0_cfg_t_we_np[13]   <= 1'b1;

                            l0_cfg_t_addr_np[12] <= cfg_addr_count;
                            l0_cfg_t_addr_np[13] <= cfg_addr_count;

                            l0_cfg_t_data_np[12] <= t0;
                            l0_cfg_t_data_np[13] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else begin
                            l0_cfg_t_we_np[14]   <= 1'b1;
                            l0_cfg_t_we_np[15]   <= 1'b1;

                            l0_cfg_t_addr_np[14] <= cfg_addr_count;
                            l0_cfg_t_addr_np[15] <= cfg_addr_count;

                            l0_cfg_t_data_np[14] <= t0;
                            l0_cfg_t_data_np[15] <= t1;

                            t_eights <= 3'b000;
                            cfg_addr_count <= cfg_addr_count + 1;
                        end
                    end
                end

                if(active_layer_id == LAYER1) begin
                    if(active_is_weight) begin // if we are writing weights
                        l1_cfg_w_np_sel <= l1_w_np_count;
                        l1_cfg_w_addr <= cfg_addr_count;
                        l1_cfg_w_we <= 1'b1;
                        l1_cfg_w_data <= {
                            cfg_payload_bytes[7],
                            cfg_payload_bytes[6],
                            cfg_payload_bytes[5],
                            cfg_payload_bytes[4],
                            cfg_payload_bytes[3],
                            cfg_payload_bytes[2],
                            cfg_payload_bytes[1],
                            cfg_payload_bytes[0]
                        };

                        l1_weight_counter <= l1_weight_counter + 1; // we increment the amount of weights we have written
                        cfg_addr_count <= cfg_addr_count + 1; // we incrmenet the address

                        if(l1_weight_counter == L1_WORDS_PER_NEURON-1) begin // for every neuron worth of weights we write (last bit 16 bits padded with an extra 48)
                            l1_w_np_count <= l1_w_np_count + 1; // we move to the next neuron processor
                            cfg_addr_count <= weight_iter * L1_WORDS_PER_NEURON; // we reset the address to start from 0 on the next neuron processor's bram
                            l1_weight_counter <= '0; // we reset the weight counter as well

                            if(l1_w_np_count == PN1 - 1) begin // if we are on the last neuron processor and writing the last weight
                                l1_w_np_count <= '0; // next cycle put the select back to the first neuron
                                weight_iter <= weight_iter + 1; // we have done a full iteration of writing weights, we increment the iteration counter
                                cfg_addr_count <= (weight_iter + 1'b1) * L1_WORDS_PER_NEURON; // we move the address count to the next set of weights for the next iteration
                            end
                        end
                    end

                    else if(!active_is_weight) begin
                        logic [31:0] t0_32, t1_32;
                        logic [15:0] t0, t1;

                        t0_32 = {cfg_payload_bytes[3], cfg_payload_bytes[2], cfg_payload_bytes[1], cfg_payload_bytes[0]};
                        t1_32 = {cfg_payload_bytes[7], cfg_payload_bytes[6], cfg_payload_bytes[5], cfg_payload_bytes[4]};

                        t0 = t0_32[15:0];
                        t1 = t1_32[15:0];

                        if (t_eights == 3'b000) begin
                            // first 4 thresholds go to neuron processors 0,1,2,3
                            l1_cfg_t_we_np[0]   <= 1'b1;
                            l1_cfg_t_we_np[1]   <= 1'b1;

                            l1_cfg_t_addr_np[0] <= cfg_addr_count;
                            l1_cfg_t_addr_np[1] <= cfg_addr_count;

                            l1_cfg_t_data_np[0] <= t0;
                            l1_cfg_t_data_np[1] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 3'b001) begin
                            l1_cfg_t_we_np[2]   <= 1'b1;
                            l1_cfg_t_we_np[3]   <= 1'b1;

                            l1_cfg_t_addr_np[2] <= cfg_addr_count;
                            l1_cfg_t_addr_np[3] <= cfg_addr_count;

                            l1_cfg_t_data_np[2] <= t0;
                            l1_cfg_t_data_np[3] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 3'b010) begin
                            l1_cfg_t_we_np[4]   <= 1'b1;
                            l1_cfg_t_we_np[5]   <= 1'b1;

                            l1_cfg_t_addr_np[4] <= cfg_addr_count;
                            l1_cfg_t_addr_np[5] <= cfg_addr_count;

                            l1_cfg_t_data_np[4] <= t0;
                            l1_cfg_t_data_np[5] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 3'b011) begin
                            // next 4 thresholds go to neuron processors 4,5,6,7
                            l1_cfg_t_we_np[6]   <= 1'b1;
                            l1_cfg_t_we_np[7]   <= 1'b1;

                            l1_cfg_t_addr_np[6] <= cfg_addr_count;
                            l1_cfg_t_addr_np[7] <= cfg_addr_count;

                            l1_cfg_t_data_np[6] <= t0;
                            l1_cfg_t_data_np[7] <= t1;
                            
                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 4'b100) begin
                            l1_cfg_t_we_np[8]   <= 1'b1;
                            l1_cfg_t_we_np[9]   <= 1'b1;

                            l1_cfg_t_addr_np[8] <= cfg_addr_count;
                            l1_cfg_t_addr_np[9] <= cfg_addr_count;

                            l1_cfg_t_data_np[8] <= t0;
                            l1_cfg_t_data_np[9] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 4'b101) begin
                            l1_cfg_t_we_np[10]   <= 1'b1;
                            l0_cfg_t_we_np[11]   <= 1'b1;

                            l1_cfg_t_addr_np[10] <= cfg_addr_count;
                            l1_cfg_t_addr_np[11] <= cfg_addr_count;

                            l1_cfg_t_data_np[10] <= t0;
                            l1_cfg_t_data_np[11] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else if (t_eights == 4'b110) begin
                            l1_cfg_t_we_np[12]   <= 1'b1;
                            l1_cfg_t_we_np[13]   <= 1'b1;

                            l1_cfg_t_addr_np[12] <= cfg_addr_count;
                            l1_cfg_t_addr_np[13] <= cfg_addr_count;

                            l1_cfg_t_data_np[12] <= t0;
                            l1_cfg_t_data_np[13] <= t1;

                            t_eights <= t_eights + 1'b1;
                        end
                        else begin
                            l1_cfg_t_we_np[14]   <= 1'b1;
                            l1_cfg_t_we_np[15]   <= 1'b1;

                            l1_cfg_t_addr_np[14] <= cfg_addr_count;
                            l1_cfg_t_addr_np[15] <= cfg_addr_count;

                            l1_cfg_t_data_np[14] <= t0;
                            l1_cfg_t_data_np[15] <= t1;

                            t_eights <= 3'b000;
                            cfg_addr_count <= cfg_addr_count + 1;
                        end
                    end
                end

                if(active_layer_id == LAYER2) begin
                    if(active_is_weight) begin
                        l2_cfg_w_np_sel <= l2_w_np_count;
                        l2_cfg_w_addr <= cfg_addr_count;
                        l2_cfg_w_we <= 1'b1;
                        l2_cfg_w_data <= {
                            cfg_payload_bytes[7],
                            cfg_payload_bytes[6],
                            cfg_payload_bytes[5],
                            cfg_payload_bytes[4],
                            cfg_payload_bytes[3],
                            cfg_payload_bytes[2],
                            cfg_payload_bytes[1],
                            cfg_payload_bytes[0]
                        };

                        l2_weight_counter <= l2_weight_counter + 1; // we increment the amount of weights we have written
                        cfg_addr_count <= cfg_addr_count + 1; // we incrmenet the address

                        if(l2_weight_counter == L2_WORDS_PER_NEURON-1) begin // for every neuron worth of weights we write (last bit 16 bits padded with an extra 48)
                            l2_w_np_count <= l2_w_np_count + 1; // we move to the next neuron processor
                            cfg_addr_count <= weight_iter * L2_WORDS_PER_NEURON; // we reset the address to start from 0 on the next neuron processor's bram
                            l2_weight_counter <= '0; // we reset the weight counter as well

                            if(l2_w_np_count == PN2 - 1) begin // if we are on the last neuron processor and writing the last weight
                                l2_w_np_count <= '0; // next cycle put the select back to the first neuron
                                weight_iter <= weight_iter + 1; // we have done a full iteration of writing weights, we increment the iteration counter
                                cfg_addr_count <= (weight_iter + 1'b1) * L2_WORDS_PER_NEURON; // we move the address count to the next set of weights for the next iteration
                            end
                        end
                    end
                end
            end
        end
    end


endmodule