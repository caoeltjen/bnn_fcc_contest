`timescale 1ns/1ps

module tb_layer_bank #(
    parameter int PW = 16,
    parameter int PN = 4,
    parameter int ADDR_W = 11,
    parameter int INPUTS_PER_NEURON = 256,
    parameter NUM_TESTS = 1000,
    parameter int MIN_BEATS = 1,
    parameter int MAX_BEATS = 5,
    parameter int MIN_CYCLES_BETWEEN_TESTS = 1,
    parameter int MAX_CYCLES_BETWEEN_TESTS = 5
);

    localparam int NUM_BEATS_PER_NEURON = (INPUTS_PER_NEURON + PW - 1) / PW;
    localparam int BEAT_CNT_W = (NUM_BEATS_PER_NEURON <= 1) ? 1 : $clog2(NUM_BEATS_PER_NEURON);

    localparam int DEPTH = 512;

    logic                   rst;
    logic                   ram_finished = 1'b0;
    logic                   clk = 1'b0;

    logic [PW-1:0]          x;
    logic                   valid_in;

    logic                         cfg_w_we;
    logic [$clog2(PN)-1:0]        cfg_w_np_sel;
    logic [8:0]                   cfg_w_addr;
    logic [63:0]                  cfg_w_data;

    logic [PN-1:0]                cfg_t_we_np;
    logic [PN-1:0][ADDR_W-1:0]    cfg_t_addr_np;
    logic [PN-1:0][PW-1:0]        cfg_t_data_np;

    logic [PN-1:0]          np_active = '1;
    logic [PN-1:0]          y;
    logic [PN-1:0][PW-1:0]  popcount;
    logic [PN-1:0]          valid_out;

    int passed, failed;

    logic [63:0] w_bram_data [0:PN-1][0:DEPTH-1];
    logic [PW-1:0] t_bram_data [0:PN-1][0:DEPTH-1];

    mailbox scoreboard_input_mailbox = new;
    mailbox scoreboard_output_mailbox = new;
    mailbox driver_mailbox = new;

    layer_bank #(
        .PW(PW),
        .PN(PN),
        .ADDR_W(ADDR_W),
        .INPUTS_PER_NEURON(INPUTS_PER_NEURON)
    ) dut (
        .rst(rst),
        .clk(clk),
        .x(x),
        .valid_in(valid_in),
        .np_active(np_active),

        .cfg_w_we(cfg_w_we),
        .cfg_w_np_sel(cfg_w_np_sel),
        .cfg_w_addr(cfg_w_addr),
        .cfg_w_data(cfg_w_data),

        .cfg_t_we_np(cfg_t_we_np),
        .cfg_t_addr_np(cfg_t_addr_np),
        .cfg_t_data_np(cfg_t_data_np),

        .y(y),
        .popcount(popcount),
        .valid_out(valid_out)
    );

    class neuron_item;
        rand bit [PW-1:0] x_beats[NUM_BEATS_PER_NEURON];
    endclass

    typedef struct packed {
        logic [PW-1:0] popcount;
        logic          y;
    } model_out_t;

    typedef struct {
        bit [PW-1:0] x_beats[];
        bit [PW-1:0] w_beats[0:PN-1][];  // per neuron
        bit [PW-1:0] threshold[0:PN-1];  // per neuron
    } scoreboard_input_t;

    typedef struct {
        logic [PW-1:0] popcount[0:PN-1];
        logic          y[0:PN-1];
    } scoreboard_output_t;

    function automatic model_out_t model(
        input bit [PW-1:0] x_beats[],
        input bit [PW-1:0] w_beats[],
        input logic [PW-1:0] threshold
    );
        model_out_t result;
        int i, j;
        begin
            result.popcount = '0;
            result.y        = 1'b0;

            for (i = 0; i < NUM_BEATS_PER_NEURON; i++) begin
                for (j = 0; j < PW; j++) begin
                    if (!(x_beats[i][j] ^ w_beats[i][j]))
                        result.popcount = result.popcount + 1;
                end
            end

            result.y = (result.popcount >= threshold);
            return result;
        end
    endfunction

    initial begin : generate_clock
        forever #5 clk <= ~clk;
    end

    initial begin : initialization
        $timeformat(-9, 0, " ns");

        rst <= 1'b1;
        x <= '0;
        valid_in <= 1'b0;

        cfg_w_we <= 1'b0;
        cfg_w_np_sel <= '0;
        cfg_w_addr <= '0;
        cfg_w_data <= '0;

        cfg_t_we_np <= '0;
        cfg_t_addr_np <= '{default:'0};
        cfg_t_data_np <= '{default:'0};

        repeat (5) @(posedge clk);
        @(negedge clk);
        rst <= 1'b0;
    end

    // initial begin : load_bram_data
    //     int unsigned depth = (1 << ADDR_W);

    //     @(posedge clk iff !rst);

    //     for(int unsigned neuron = 0; neuron < PN; neuron++) begin

    //         //Weight Loading
    //         for(int unsigned addr = 0; addr < depth; addr++) begin
    //             logic [PW-1:0] w_data;
    //             w_data = $urandom;
    //             cfg_we <= 1'b1;
    //             cfg_is_weight <= 1'b1;
    //             cfg_np_sel <= neuron;
    //             cfg_addr <= addr;
    //             cfg_data <= w_data;
    //             w_bram_data[neuron][addr] = w_data;
    //             @(posedge clk);
    //         end

    //         //Threshold Loading
    //         for(int unsigned addr = 0; addr < depth; addr++) begin
    //             logic [PW-1:0] t_data;
    //             t_data = $urandom_range(0, 16'h00AA);;
    //             cfg_we <= 1'b1;
    //             cfg_is_weight <= 1'b0;
    //             cfg_np_sel <= neuron;
    //             cfg_addr <= addr;
    //             cfg_data <= t_data;
    //             t_bram_data[neuron][addr] = t_data;
    //             @(posedge clk);
    //         end
    //     end

    //     cfg_we <= 1'b0;
    //     ram_finished <= 1'b1;
    //     @(posedge clk);
    // end

    initial begin : load_bram_data
        int unsigned depth = (1 << ADDR_W);

        @(posedge clk iff !rst);

        // ----------------------------
        // WEIGHTS (64-bit)
        // ----------------------------
        for (int unsigned neuron = 0; neuron < PN; neuron++) begin
            for (int unsigned addr = 0; addr < depth; addr++) begin
                logic [63:0] w_data;
                w_data = {$urandom, $urandom}; // full 64-bit

                cfg_w_we       <= 1'b1;
                cfg_w_np_sel   <= neuron;
                cfg_w_addr     <= addr;
                cfg_w_data     <= w_data;

                w_bram_data[neuron][addr] = w_data;

                cfg_t_we_np <= '0;

                @(posedge clk);
            end
        end

        cfg_w_we <= 1'b0;

        // ----------------------------
        // THRESHOLDS (PARALLEL WRITE)
        // ----------------------------
        for (int unsigned addr = 0; addr < depth; addr++) begin
            cfg_t_we_np <= '1;

            for (int unsigned neuron = 0; neuron < PN; neuron++) begin
                logic [PW-1:0] t_data;
                t_data = $urandom_range(0, 16'h00AA);

                cfg_t_addr_np[neuron] <= addr;
                cfg_t_data_np[neuron] <= t_data;

                t_bram_data[neuron][addr] = t_data;
            end

            @(posedge clk);
        end

        cfg_t_we_np <= '0;

        ram_finished <= 1'b1;
        @(posedge clk);
    end

    initial begin : generator
        neuron_item test;

        for (int i = 0; i < NUM_TESTS; i++) begin
            test = new();
            assert(test.randomize())
            else $fatal(1, "Failed to randomize neuron_item");

            driver_mailbox.put(test);
        end
    end

    initial begin : driver
        neuron_item item;
        int gap;

        @(posedge clk iff !rst);

        @(posedge ram_finished);  // Wait until BRAM loading is done

        forever begin
            driver_mailbox.get(item);

            for (int i = 0; i < NUM_BEATS_PER_NEURON; i++) begin
                x <= item.x_beats[i];
                valid_in <= 1'b1;
                @(posedge clk);
            end

            gap = $urandom_range(MIN_CYCLES_BETWEEN_TESTS-1, MAX_CYCLES_BETWEEN_TESTS);

            if (gap > 0) begin
                x <= '0;
                valid_in <= 1'b0;
                repeat (gap) @(posedge clk);
            end
        end
    end

    initial begin : start_monitor
        scoreboard_input_t txn;
        bit [PW-1:0] x_q[$];
        bit [PW-1:0] w_q[0:PN-1][$];  // per neuron

        int unsigned w_ptr = 0;
        int unsigned t_ptr = 0;

        int unsigned beat_count = 0;

        forever begin
            @(posedge clk iff (!rst && valid_in));

            x_q.push_back(x);
            for (int n = 0; n < PN; n++) begin
                if (np_active[n]) begin
                    logic [63:0] w_word;
                    logic [PW-1:0] w_slice;

                    w_word = w_bram_data[n][(w_ptr >> 2) % DEPTH];

                    case (w_ptr[1:0])
                        2'd0: w_slice = w_word[15:0];
                        2'd1: w_slice = w_word[31:16];
                        2'd2: w_slice = w_word[47:32];
                        2'd3: w_slice = w_word[63:48];
                    endcase

                    w_q[n].push_back(w_slice);
                end
            end
            w_ptr++;

            beat_count++;

            if (beat_count == NUM_BEATS_PER_NEURON) begin
                for (int n = 0; n < PN; n++) begin
                    if (np_active[n]) begin
                        txn.w_beats[n] = w_q[n];
                        txn.threshold[n] = t_bram_data[n][t_ptr % DEPTH];
                    end
                end
                txn.x_beats = x_q;
                scoreboard_input_mailbox.put(txn);
                t_ptr++;
                x_q = {};
                for (int n = 0; n < PN; n++) w_q[n] = {};
                beat_count = 0;
                w_ptr = 0;
            end
        end
    end

    initial begin : done_monitor
        scoreboard_output_t out;

        forever begin
            @(posedge clk iff valid_out != 0);  // wait for any valid_out
            for (int n = 0; n < PN; n++) begin
                if (valid_out[n]) begin
                    out.popcount[n] = popcount[n];
                    out.y[n] = y[n];
                end
            end
            scoreboard_output_mailbox.put(out);
        end
    end

    initial begin : scoreboard
        scoreboard_input_t in_txn;
        scoreboard_output_t actual;
        model_out_t expected[0:PN-1];

        passed = 0;
        failed = 0;

        for (int i = 0; i < NUM_TESTS; i++) begin
            scoreboard_input_mailbox.get(in_txn);
            scoreboard_output_mailbox.get(actual);

            for (int n = 0; n < PN; n++) begin
                if (np_active[n]) begin
                    expected[n] = model(in_txn.x_beats, in_txn.w_beats[n], in_txn.threshold[n]);

                    if ((actual.popcount[n] === expected[n].popcount) &&
                        (actual.y[n] === expected[n].y)) begin
                        $display("PASS neuron=%0d time=%0t threshold=%0d popcount=%0d y=%0b",
                                 n, $time, in_txn.threshold[n], actual.popcount[n], actual.y[n]);
                        passed++;
                    end else begin
                        $display("FAIL neuron=%0d time=%0t threshold=%0d actual(popcount=%0d y=%0b) expected(popcount=%0d y=%0b) num_beats=%0d",
                                 n, $time, in_txn.threshold[n],
                                 actual.popcount[n], actual.y[n],
                                 expected[n].popcount, expected[n].y, in_txn.x_beats.size());
                        failed++;
                    end
                end
            end
        end

        $display("Tests completed: %0d passed, %0d failed", passed, failed);
        disable generate_clock;
    end
    
endmodule