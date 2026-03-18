module config_manager #(
    parameter int BUS_WIDTH       = 64, // bus stores 8 bytes
    parameter int LAYERS           = 3, // 3 layers in the bnn
    parameter int PARALLEL_INPUTS  = 8, // Pw and Pi
    parameter int PARALLEL_NEURONS [LAYERS] = '{default: 8} // packs array with default value 8
) (
    input logic                          clk,
    input logic                          rst,
    input logic [31:0]                   config_data_in,
    input logic                          config_valid,
    input logic [(32/8)-1:0]             config_keep,
    input logic                          config_last,
    output logic                         config_ready,
    output logic [BUS_WIDTH-1:0]         weight_wr_data,
    output logic [LAYERS-1:0]            weight_wr_en,
    output logic [BUS_WIDTH-1:0]         threshold_wr_data,
    output logic [LAYERS-1:0]            threshold_wr_en
);
    

    /*
    Config manager follows a network-style communcation protocol. 
    Config header = 128 bits
        [7:0] = msg_type; 0=Weights, 1=Thresholds
        [15:8] = layer_id; index of current layer (1,2,3,..)
        [31:16] = layer_inputs; # of inputs fanned into layer (ignore when pushing threshholds)
        [47:32] = num_neurons; # of neurons in layer_id
        [63:48] = bytes_per_neuron; # of bytes in payload per neuron
        [95:64] = total_bytes; total # of bytes for the message
        [127:96] = reserved, ignore last 4 bytes for now

    */

    // Store the config header at first few addresses in RAM component
    // We'll create a ram component that can be addressed with axi for pipelined read/write potentially
    // Create a basic ram component to just read the inputs and store, tryd
    
    
    // dependent on the amount of layers and neuron processors, 
    ram#(
        .DATA_WIDTH(ram_pkg::DATA_WIDTH),
        .ADDR_WIDTH(ram_pkg::ADDR_WIDTH)
    ) thresh_ram (
        .clk(clk),
        .rst(rst),
        .wr_en(threshold_wr_en[i]),
        .rd_en(1),
        .addr(address),
        .wr_data(threshold_wr_data[i]),
        .rd_data(threshold_rd_data[i])
    );

endmodule
