`timescale 1ns/1ps

module tb_neuron_top_skip;

    localparam int PW                = 16;
    localparam int ADDR_W            = 11;
    localparam int INPUTS_PER_NEURON = 784;

    localparam int NUM_BEATS         = (INPUTS_PER_NEURON + PW - 1) / PW;   // 49
    localparam int WORDS_PER_NEURON  = (INPUTS_PER_NEURON + 63) / 64;       // 13
    localparam int PAD_READ_BEATS    = WORDS_PER_NEURON*4 - NUM_BEATS;      // 3

    logic                  clk;
    logic                  rst;
    logic [PW-1:0]         x;
    logic                  valid_in;
    logic                  cfg_done;
    logic                  image_last;

    logic                  cfg_w_we;
    logic [8:0]            cfg_w_addr;
    logic [63:0]           cfg_w_data;

    logic                  cfg_t_we;
    logic [ADDR_W-1:0]     cfg_t_addr;
    logic [PW-1:0]         cfg_t_data;

    logic                  y;
    logic [PW-1:0]         popcount;
    logic                  valid_out;
    logic                  last_img_out;

    logic [PW-1:0] img0 [0:NUM_BEATS-1];
    logic [PW-1:0] img1 [0:NUM_BEATS-1];
    logic [PW-1:0] img2 [0:NUM_BEATS-1];

    int out_count;

    neuron_top #(
        .PW(PW),
        .ADDR_W(ADDR_W),
        .INPUTS_PER_NEURON(INPUTS_PER_NEURON)
    ) dut (
        .clk         (clk),
        .rst         (rst),
        .x           (x),
        .valid_in    (valid_in),
        .cfg_done    (cfg_done),
        .image_last  (image_last),

        .cfg_w_we    (cfg_w_we),
        .cfg_w_addr  (cfg_w_addr),
        .cfg_w_data  (cfg_w_data),

        .cfg_t_we    (cfg_t_we),
        .cfg_t_addr  (cfg_t_addr),
        .cfg_t_data  (cfg_t_data),

        .y           (y),
        .popcount    (popcount),
        .valid_out   (valid_out),
        .last_img_out(last_img_out)
    );

    always #5 clk = ~clk;

    // ---------------------------
    // WRITE TASKS
    // ---------------------------
    task automatic write_weight_word(
        input logic [8:0]  addr,
        input logic [63:0] data
    );
    begin
        @(negedge clk);
        cfg_w_we   = 1'b1;
        cfg_w_addr = addr;
        cfg_w_data = data;
        @(negedge clk);
        cfg_w_we   = 1'b0;
        cfg_w_addr = '0;
        cfg_w_data = '0;
    end
    endtask

    task automatic write_threshold(
        input logic [ADDR_W-1:0] addr,
        input logic [PW-1:0]     data
    );
    begin
        @(negedge clk);
        cfg_t_we   = 1'b1;
        cfg_t_addr = addr;
        cfg_t_data = data;
        @(negedge clk);
        cfg_t_we   = 1'b0;
        cfg_t_addr = '0;
        cfg_t_data = '0;
    end
    endtask

    // ---------------------------
    // SEND TRANSACTION
    // ---------------------------
    task automatic send_transaction(
        input logic [PW-1:0] beats [0:NUM_BEATS-1],
        input logic          last_flag
    );
        int i;
    begin
        for (i = 0; i < NUM_BEATS; i++) begin
            @(negedge clk);
            x          = beats[i];
            valid_in   = 1'b1;
            image_last = (i == NUM_BEATS-1) ? last_flag : 1'b0;
        end

        @(negedge clk);
        x          = '0;
        valid_in   = 1'b0;
        image_last = 1'b0;
    end
    endtask

    // ---------------------------
    // MAIN TEST
    // ---------------------------
    initial begin
        int i;

        clk        = 1'b0;
        rst        = 1'b1;
        x          = '0;
        valid_in   = 1'b0;
        cfg_done   = 1'b0;
        image_last = 1'b0;
        cfg_w_we   = 1'b0;
        cfg_w_addr = '0;
        cfg_w_data = '0;
        cfg_t_we   = 1'b0;
        cfg_t_addr = '0;
        cfg_t_data = '0;
        out_count  = 0;

        // deterministic inputs
        for (i = 0; i < NUM_BEATS; i++) begin
            img0[i] = 16'hFFFF;  // full match with weights[0]
            img1[i] = 16'hFFFF;  // mismatch with weights[1]
            img2[i] = 16'b0000_0000_0111_1111;;  // mismatch with weights[0] after reset
        end

        // reset
        repeat (5) @(negedge clk);
        rst = 1'b0;

        // ---------------------------
        // WRITE WEIGHTS
        // ---------------------------

        // neuron 0 (all 1s)
        for (i = 0; i < 12; i++) begin
            write_weight_word(i[8:0], 64'hFFFF_FFFF_FFFF_FFFF);
        end
        write_weight_word(9'd12, 64'h9ABC_5678_1234_FFFF); // padded junk

        // neuron 1 (all 0s)
        for (i = 13; i < 25; i++) begin
            write_weight_word(i[8:0], 64'h0000_0000_0000_0000);
        end
        write_weight_word(9'd25, 64'hDEAD_BEEF_CAFE_0000); // padded junk

        // ---------------------------
        // WRITE THRESHOLDS
        // ---------------------------
        write_threshold(11'd0, 16'd780);
        write_threshold(11'd1, 16'd1);

        // enable controller
        @(negedge clk);
        cfg_done = 1'b1;

        repeat (3) @(negedge clk);

        // ---------------------------
        // TRANSACTIONS
        // ---------------------------

        $display("---- Sending transaction 0 (weights[0], threshold[0]) ----");
        send_transaction(img0, 1'b0);

        $display("---- Sending transaction 1 (weights[1], threshold[1]) ----");
        send_transaction(img1, 1'b1);

        $display("---- Sending transaction 2 (REUSE weights[0], threshold[0]) ----");
        send_transaction(img2, 1'b1);

        // wait for outputs
        repeat (60) @(negedge clk);

        if (out_count != 3) begin
            $display("FAIL: expected 3 outputs, saw %0d", out_count);
            $stop;
        end

        $display("PASS: reset + reuse test completed.");
        $stop;
    end

    // ---------------------------
    // CHECKER
    // ---------------------------
    always @(posedge clk) begin
        if (!rst && valid_out) begin
            out_count <= out_count + 1;

            case (out_count)
                0: begin
                    $display("OUT0 time=%0t popcount=%0d y=%0b last=%0b",
                             $time, popcount, y, last_img_out);

                    if (popcount !== 16'd784 || y !== 1'b1) begin
                        $display("FAIL txn0");
                        $stop;
                    end
                end

                1: begin
                    $display("OUT1 time=%0t popcount=%0d y=%0b last=%0b",
                             $time, popcount, y, last_img_out);

                    if (popcount !== 16'd0 || y !== 1'b0) begin
                        $display("FAIL txn1");
                        $stop;
                    end
                end

                2: begin
                    $display("OUT2 time=%0t popcount=%0d y=%0b last=%0b",
                             $time, popcount, y, last_img_out);

                    if (popcount !== 16'd343 || y !== 1'b0) begin
                        $display("FAIL txn2 (reuse failed)");
                        $stop;
                    end

                    if (last_img_out !== 1'b1) begin
                        $display("FAIL txn2 last_img_out");
                        $stop;
                    end
                end

                default: begin
                    $display("FAIL: extra output");
                    $stop;
                end
            endcase
        end
    end

endmodule