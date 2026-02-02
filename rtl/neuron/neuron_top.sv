module neuron_top #(
    parameter int PW = 16,
    parameter int THRESH_W = 16,

) (
    input logic               clk,
    input logic               rst,

    // Inputs for threshold and weight ram writing
    input logic               cfg_w_en,
    input logic [PW-1:0]      cfg_w_data,


    // Outputs of neuron processor
    output logic             valid_out,
    output logic             y,
    output logic [THRESH_W-1:0] popcount_out

);

    logic [PW-1:0]         x;
    logic [PW-1:0]         w;
    logic [THRESH_W-1:0]   threshold;
    logic                  clk;
    logic                  rst;
    logic                  valid_in;
    logic                  last;

    neuron #(
        .PW(PW),
        .THRESH_W(THRESH_W)
    ) neuron_inst (
        .x(x),
        .w(w),
        .threshold(threshold),
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .last(last),
        .valid_out(valid_out),
        .y(y),
        .popcount_out(popcount_out)
    );

    // Instantiate weight and threshold brams here

endmodule