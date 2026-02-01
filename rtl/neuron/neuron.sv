module neuron #(
    parameter int PW = 8,
    parameter int THRESH_W = 16,
    parameter int Y_WIDTH = $clog2(PW+1)
) (
    input logic [PW-1:0]  x, // input vector
    input logic [PW-1:0] w, // weight vector
    input logic [THRESH_W-1:0] thresh, // has threshold
    
    // controller signals
    input logic clk,
    input logic rst,
    input logic valid_in,
    input logic last,

    // output signals
    output logic valid_out, // use TBD
    output logic [Y_WIDTH-1:0] y // output vector
    output logic [Y_WIDTH-1:0] popcount_out
);

logic [PW-1:0] xnor_result;
logic [PW-1:0] comb_pc;
logic [Y_WIDTH-1:0] popcount;


assign xnor_result = ~(x ^ w); 
assign comb_pc = $countones(xnor_result); 
assign popcount_out = popcount;

always_ff @(posedge clk or posedge rst) begin : control
    if (rst) begin
        xnor_result <= '0;
        popcount <= '0;
        valid_out <= 0;
        y <= '0;
    end
    else if (valid_in) begin
        popcount <= popcount + comb_pc; 
        valid_out <= 0;
        
        if (last) begin
            y <= (popcount >= thresh) ? '1 : '0;
            valid_out <= 1;
            popcount <= '0;
        end
        else begin
            
        end
    end
end

endmodule