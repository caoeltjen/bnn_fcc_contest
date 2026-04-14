module binarize_input #(
    parameter int INPUT_DATA_WIDTH = 8
) (
    input logic [INPUT_DATA_WIDTH-1:0] data_in,
    output logic                       data_out
);

    always_comb begin
        // Binarization: if input >= 128, output 1; else output 0
        if (data_in >= 128) begin
            data_out = 1'b1;
        end else begin
            data_out = 1'b0;
        end
    end

endmodule