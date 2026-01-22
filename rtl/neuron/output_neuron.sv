module neuron #(
    parameter int INPUT_DATA_WIDTH,
    parameter int WEIGHT_DATA_WIDTH,
    parameter int OUTPUT_DATA_WIDTH
) (
    input logic [INPUT_DATA_WIDTH-1:0]  input_data,
    input logic [WEIGHT_DATA_WIDTH-1:0] weight_data,
    // no threshold value for output neurons
    output logic [OUTPUT_DATA_WIDTH-1:0] output_data
);

endmodule