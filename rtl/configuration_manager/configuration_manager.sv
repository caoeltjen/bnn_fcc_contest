module config_manager #(
    parameter int BUS_WIDTH       = 64,
    parameter int LAYERS           = 3,
    parameter int PARALLEL_INPUTS  = 8,
    parameter int PARALLEL_NEURONS [LAYERS] = '{default: 8}
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
)

endmodule