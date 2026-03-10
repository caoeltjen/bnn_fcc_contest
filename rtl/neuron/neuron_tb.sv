module neuron_tb #(
    parameter int PW = 8
);

    logic clk = 1'b0;
    logic rst;
    logic [PW-1:0] x;
    logic [PW-1:0] w;
    logic [PW-1:0] threshold;
    logic valid_in;
    logic last;

    logic y;
    logic [PW-1:0] popcount;
    logic valid_out;

    neuron #(
        .PW(PW)
    ) dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .w(w),
        .threshold(threshold),
        .valid_in(valid_in),
        .last(last),
        .y(y),
        .popcount(popcount),
        .valid_out(valid_out)
    );

    initial begin : generate_clock
        forever #5 clk = ~clk;
    end

    initial begin : drive_inputs
        $timeformat(-9, 0, " ns");

        rst <= 1'b1;
        x <= '0;
        w <= '0;
        threshold <= '0;

        repeat (5) @(posedge clk);
        @(negedge clk);
        rst <= 1'b0;

        
    end


endmodule