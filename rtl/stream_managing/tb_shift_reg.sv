`timescale 1ns/1ps

module tb_shift_reg #(
    parameter int NUM_RANDOM_TESTS = 100,
    parameter int MIN_RANDOM_BEATS = 1,
    parameter int MAX_RANDOM_BEATS = 6
);
    localparam int WIDTH = 64;
    localparam int BYTE_LANES = WIDTH / 8;
    localparam int DEPTH = 4;

    typedef bit [WIDTH-1:0] bus_word_t;
    typedef bit [BYTE_LANES-1:0] keep_t;

    typedef struct packed {
        bus_word_t data;
        keep_t keep;
        logic last;
    } beat_t;

    logic clk = 1'b0;
    logic rst;

    logic plain_shift_in_valid;
    logic [BYTE_LANES-1:0] plain_shift_in_keep;
    logic [WIDTH-1:0] plain_shift_in_data;
    logic plain_shift_in_last;
    logic plain_shift_in_ready;
    logic plain_shift_out_valid;
    logic [WIDTH-1:0] plain_shift_out_data;
    logic [BYTE_LANES-1:0] plain_shift_out_keep;
    logic plain_shift_out_last;
    logic plain_shift_out_ready;

    logic aligned_shift_in_valid;
    logic [BYTE_LANES-1:0] aligned_shift_in_keep;
    logic [WIDTH-1:0] aligned_shift_in_data;
    logic aligned_shift_in_last;
    logic [7:0] aligned_msg_type;
    logic aligned_msg_type_valid;
    logic [15:0] aligned_bytes_per_neuron;
    logic aligned_bytes_per_neuron_valid;
    logic aligned_shift_in_ready;
    logic aligned_shift_out_valid;
    logic [WIDTH-1:0] aligned_shift_out_data;
    logic [BYTE_LANES-1:0] aligned_shift_out_keep;
    logic aligned_shift_out_last;
    logic aligned_shift_out_ready;

    int unsigned passed;
    int unsigned failed;

    shift_reg #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ALIGN_TO_BYTES_PER_NEURON(1'b0)
    ) dut_plain (
        .clk(clk),
        .rst(rst),
        .shift_in_valid(plain_shift_in_valid),
        .shift_in_keep(plain_shift_in_keep),
        .shift_in_data(plain_shift_in_data),
        .shift_in_last(plain_shift_in_last),
        .msg_type('0),
        .msg_type_valid(1'b0),
        .bytes_per_neuron('0),
        .bytes_per_neuron_valid(1'b0),
        .shift_in_ready(plain_shift_in_ready),
        .shift_out_valid(plain_shift_out_valid),
        .shift_out_data(plain_shift_out_data),
        .shift_out_keep(plain_shift_out_keep),
        .shift_out_last(plain_shift_out_last),
        .shift_out_ready(plain_shift_out_ready)
    );

    shift_reg #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ALIGN_TO_BYTES_PER_NEURON(1'b1)
    ) dut_aligned (
        .clk(clk),
        .rst(rst),
        .shift_in_valid(aligned_shift_in_valid),
        .shift_in_keep(aligned_shift_in_keep),
        .shift_in_data(aligned_shift_in_data),
        .shift_in_last(aligned_shift_in_last),
        .msg_type(aligned_msg_type),
        .msg_type_valid(aligned_msg_type_valid),
        .bytes_per_neuron(aligned_bytes_per_neuron),
        .bytes_per_neuron_valid(aligned_bytes_per_neuron_valid),
        .shift_in_ready(aligned_shift_in_ready),
        .shift_out_valid(aligned_shift_out_valid),
        .shift_out_data(aligned_shift_out_data),
        .shift_out_keep(aligned_shift_out_keep),
        .shift_out_last(aligned_shift_out_last),
        .shift_out_ready(aligned_shift_out_ready)
    );

    initial begin : generate_clock
        forever #5 clk = ~clk;
    end

    function automatic bus_word_t pack_low_lanes(
        input int unsigned start_byte,
        input int unsigned count,
        input bit [7:0] base
    );
        bus_word_t word;

        word = '0;
        for (int i = 0; i < count; i++) begin
            word[i*8 +: 8] = 8'(int'(base) + start_byte + i);
        end
        return word;
    endfunction

    function automatic bus_word_t pack_by_keep(
        input keep_t keep,
        input int unsigned start_byte,
        input bit [7:0] base
    );
        bus_word_t word;
        int unsigned next_byte;

        word = '0;
        next_byte = start_byte;
        for (int lane = 0; lane < BYTE_LANES; lane++) begin
            if (keep[lane]) begin
                word[lane*8 +: 8] = 8'(int'(base) + next_byte);
                next_byte++;
            end
        end
        return word;
    endfunction

    task automatic drive_plain_idle();
        begin
            plain_shift_in_valid <= 1'b0;
            plain_shift_in_keep <= '0;
            plain_shift_in_data <= '0;
            plain_shift_in_last <= 1'b0;
        end
    endtask

    task automatic drive_aligned_idle();
        begin
            aligned_shift_in_valid <= 1'b0;
            aligned_shift_in_keep <= '0;
            aligned_shift_in_data <= '0;
            aligned_shift_in_last <= 1'b0;
            aligned_msg_type <= '0;
            aligned_msg_type_valid <= 1'b0;
            aligned_bytes_per_neuron <= '0;
            aligned_bytes_per_neuron_valid <= 1'b0;
        end
    endtask

    task automatic reset_duts();
        begin
            @(negedge clk);
            drive_plain_idle();
            drive_aligned_idle();
            rst <= 1'b1;
            repeat (2) @(posedge clk);
            @(negedge clk);
            rst <= 1'b0;
        end
    endtask

    task automatic check_plain_beat(
        input int test_id,
        input int beat_id,
        input beat_t expected,
        inout bit test_failed
    );
        if (plain_shift_out_keep !== expected.keep) begin
            $display("FAIL time=%0t test=%0d beat=%0d keep mismatch exp=%b act=%b",
                     $time, test_id, beat_id, expected.keep, plain_shift_out_keep);
            test_failed = 1'b1;
        end

        if (plain_shift_out_data !== expected.data) begin
            $display("FAIL time=%0t test=%0d beat=%0d data mismatch exp=%h act=%h",
                     $time, test_id, beat_id, expected.data, plain_shift_out_data);
            test_failed = 1'b1;
        end

        if (plain_shift_out_last !== expected.last) begin
            $display("FAIL time=%0t test=%0d beat=%0d last mismatch exp=%0b act=%0b",
                     $time, test_id, beat_id, expected.last, plain_shift_out_last);
            test_failed = 1'b1;
        end
    endtask

    task automatic check_aligned_beat(
        input int test_id,
        input int beat_id,
        input beat_t expected,
        inout bit test_failed
    );
        if (aligned_shift_out_keep !== expected.keep) begin
            $display("FAIL time=%0t test=%0d beat=%0d keep mismatch exp=%b act=%b",
                     $time, test_id, beat_id, expected.keep, aligned_shift_out_keep);
            test_failed = 1'b1;
        end

        if (aligned_shift_out_data !== expected.data) begin
            $display("FAIL time=%0t test=%0d beat=%0d data mismatch exp=%h act=%h",
                     $time, test_id, beat_id, expected.data, aligned_shift_out_data);
            test_failed = 1'b1;
        end

        if (aligned_shift_out_last !== expected.last) begin
            $display("FAIL time=%0t test=%0d beat=%0d last mismatch exp=%0b act=%0b",
                     $time, test_id, beat_id, expected.last, aligned_shift_out_last);
            test_failed = 1'b1;
        end
    endtask

    task automatic make_random_plain_stream(output beat_t beats[]);
        int unsigned num_beats;
        int unsigned valid_bytes;

        num_beats = $urandom_range(MIN_RANDOM_BEATS, MAX_RANDOM_BEATS);
        beats = new[num_beats];

        foreach (beats[i]) begin
            beats[i].data = bus_word_t'($urandom);
            beats[i].data[63:32] = $urandom;
            beats[i].last = (i == num_beats - 1);
            if (beats[i].last) begin
                valid_bytes = $urandom_range(1, BYTE_LANES);
                beats[i].keep = keep_t'((1 << valid_bytes) - 1);
            end else begin
                beats[i].keep = '1;
            end
        end
    endtask

    task automatic run_plain_stream(
        input int test_id,
        input beat_t expected[]
    );
        bit test_failed;
        int unsigned observed;
        int unsigned drain_cycles;

        test_failed = 1'b0;
        observed = 0;
        drain_cycles = 0;

        reset_duts();

        for (int beat = 0; beat < expected.size(); beat++) begin
            @(negedge clk);
            plain_shift_in_valid <= 1'b1;
            plain_shift_in_data <= expected[beat].data;
            plain_shift_in_keep <= expected[beat].keep;
            plain_shift_in_last <= expected[beat].last;

            @(posedge clk);
            if (plain_shift_out_valid) begin
                check_plain_beat(test_id, observed, expected[observed], test_failed);
                observed++;
            end
        end

        @(negedge clk);
        drive_plain_idle();

        while ((observed < expected.size()) && (drain_cycles < (expected.size() + 8))) begin
            @(posedge clk);
            if (plain_shift_out_valid) begin
                check_plain_beat(test_id, observed, expected[observed], test_failed);
                observed++;
            end
            drain_cycles++;
        end

        if (observed != expected.size()) begin
            $display("FAIL time=%0t test=%0d observed %0d plain beats expected %0d",
                     $time, test_id, observed, expected.size());
            test_failed = 1'b1;
        end

        if (test_failed) begin
            failed++;
            $display("FAIL time=%0t test=%0d plain stream", $time, test_id);
        end else begin
            passed++;
            $display("PASS time=%0t test=%0d plain stream", $time, test_id);
        end
    endtask

    task automatic make_random_aligned_stream(
        output beat_t input_beats[],
        output beat_t expected_beats[],
        output logic [7:0] msg_type,
        output logic [15:0] bytes_per_neuron_cfg
    );
        bit [7:0] payload_bytes[];
        keep_t payload_keeps[];
        int unsigned payload_size;
        int unsigned payload_idx;
        int unsigned valid_bytes;
        int unsigned num_neurons;
        int unsigned bytes_left_in_neuron;
        int unsigned expected_idx;
        int unsigned beat_bytes;
        int unsigned num_beats;

        msg_type = 8'($urandom_range(0, 1));
        if (msg_type == 8'd0) begin
            bytes_per_neuron_cfg = 16'($urandom_range(1, BYTE_LANES + 4));
            num_neurons = $urandom_range(1, 4);
            payload_size = num_neurons * bytes_per_neuron_cfg;
        end else begin
            bytes_per_neuron_cfg = 16'd4;
            payload_size = $urandom_range(1, MAX_RANDOM_BEATS) * 4;
        end

        payload_bytes = new[payload_size];
        foreach (payload_bytes[i]) begin
            payload_bytes[i] = 8'($urandom);
        end

        payload_idx = 0;
        num_beats = 0;
        while (payload_idx < payload_size) begin
            num_beats++;
            payload_idx += $urandom_range(1, (payload_size - payload_idx < BYTE_LANES) ? (payload_size - payload_idx) : BYTE_LANES);
        end

        payload_keeps = new[num_beats];
        payload_idx = 0;
        foreach (payload_keeps[beat]) begin
            payload_keeps[beat] = '0;
            valid_bytes = $urandom_range(1, (payload_size - payload_idx < BYTE_LANES) ? (payload_size - payload_idx) : BYTE_LANES);
            for (int select = 0; select < valid_bytes; ) begin
                int lane;
                lane = $urandom_range(0, BYTE_LANES - 1);
                if (!payload_keeps[beat][lane]) begin
                    payload_keeps[beat][lane] = 1'b1;
                    select++;
                end
            end
            payload_idx += valid_bytes;
        end

        input_beats = new[payload_keeps.size()];
        payload_idx = 0;
        foreach (input_beats[beat]) begin
            input_beats[beat].data = '0;
            input_beats[beat].keep = payload_keeps[beat];
            input_beats[beat].last = (beat == input_beats.size() - 1);
            for (int lane = 0; lane < BYTE_LANES; lane++) begin
                if (payload_keeps[beat][lane]) begin
                    input_beats[beat].data[lane*8 +: 8] = payload_bytes[payload_idx];
                    payload_idx++;
                end
            end
        end

        if (msg_type == 8'd0) begin
            expected_beats = new[0];
            payload_idx = 0;
            bytes_left_in_neuron = int'(bytes_per_neuron_cfg);
            expected_idx = 0;
            while (payload_idx < payload_size) begin
                expected_beats = new[expected_idx + 1](expected_beats);
                expected_beats[expected_idx].data = '0;
                expected_beats[expected_idx].keep = '0;
                beat_bytes = bytes_left_in_neuron;
                if (beat_bytes > BYTE_LANES) begin
                    beat_bytes = BYTE_LANES;
                end
                if (beat_bytes > (payload_size - payload_idx)) begin
                    beat_bytes = payload_size - payload_idx;
                end
                for (int lane = 0; lane < beat_bytes; lane++) begin
                    expected_beats[expected_idx].data[lane*8 +: 8] = payload_bytes[payload_idx + lane];
                    expected_beats[expected_idx].keep[lane] = 1'b1;
                end
                payload_idx += beat_bytes;
                expected_beats[expected_idx].last = (payload_idx == payload_size);
                if (beat_bytes == bytes_left_in_neuron) begin
                    bytes_left_in_neuron = int'(bytes_per_neuron_cfg);
                end else begin
                    bytes_left_in_neuron -= beat_bytes;
                end
                expected_idx++;
            end
        end else begin
            expected_beats = new[input_beats.size()];
            foreach (input_beats[beat]) begin
                expected_beats[beat] = input_beats[beat];
            end
        end
    endtask

    task automatic run_aligned_stream(
        input int test_id,
        input beat_t input_beats[],
        input beat_t expected[] ,
        input logic [7:0] msg_type,
        input logic [15:0] bytes_per_neuron_cfg
    );
        bit test_failed;
        int unsigned observed;
        int unsigned drain_cycles;

        test_failed = 1'b0;
        observed = 0;
        drain_cycles = 0;

        reset_duts();

        for (int beat = 0; beat < input_beats.size(); beat++) begin
            @(negedge clk);
            aligned_shift_in_valid <= 1'b1;
            aligned_shift_in_data <= input_beats[beat].data;
            aligned_shift_in_keep <= input_beats[beat].keep;
            aligned_shift_in_last <= input_beats[beat].last;
            aligned_msg_type <= msg_type;
            aligned_msg_type_valid <= (beat == 0);
            aligned_bytes_per_neuron <= bytes_per_neuron_cfg;
            aligned_bytes_per_neuron_valid <= (beat == 0) && (msg_type == 8'd0);

            @(posedge clk);
            if (aligned_shift_out_valid) begin
                check_aligned_beat(test_id, observed, expected[observed], test_failed);
                observed++;
            end
        end

        @(negedge clk);
        drive_aligned_idle();

        while ((observed < expected.size()) && (drain_cycles < (expected.size() + input_beats.size() + 8))) begin
            @(posedge clk);
            if (aligned_shift_out_valid) begin
                check_aligned_beat(test_id, observed, expected[observed], test_failed);
                observed++;
            end
            drain_cycles++;
        end

        if (observed != expected.size()) begin
            $display("FAIL time=%0t test=%0d observed %0d aligned beats expected %0d",
                     $time, test_id, observed, expected.size());
            test_failed = 1'b1;
        end

        if (test_failed) begin
            failed++;
            $display("FAIL time=%0t test=%0d aligned stream", $time, test_id);
        end else begin
            passed++;
            $display("PASS time=%0t test=%0d aligned stream", $time, test_id);
        end
    endtask

    task automatic run_random_tests(input int unsigned num_tests);
        beat_t plain_beats[];
        beat_t aligned_input[];
        beat_t aligned_expected[];
        logic [7:0] msg_type;
        logic [15:0] bytes_per_neuron_cfg;

        for (int test_idx = 0; test_idx < num_tests; test_idx++) begin
            make_random_plain_stream(plain_beats);
            run_plain_stream(100 + (2 * test_idx), plain_beats);

            make_random_aligned_stream(aligned_input, aligned_expected, msg_type, bytes_per_neuron_cfg);
            run_aligned_stream(101 + (2 * test_idx), aligned_input, aligned_expected, msg_type, bytes_per_neuron_cfg);
        end
    endtask

    task automatic run_plain_case();
        beat_t expected[];
        expected = new[2];

        expected[0] = '{
            data: 64'h8877665544332211,
            keep: 8'hFF,
            last: 1'b0
        };
        expected[1] = '{
            data: 64'h0000D4C3B2A100EF,
            keep: 8'h3F,
            last: 1'b1
        };
        run_plain_stream(0, expected);
    endtask

    task automatic run_aligned_weight_case();
        beat_t input_beats[];
        beat_t expected[];
        logic [7:0] msg_type;
        logic [15:0] bytes_per_neuron_cfg;

        expected = new[4];
        input_beats = new[3];
        msg_type = 8'd0;
        bytes_per_neuron_cfg = 16'd12;

        expected[0] = '{data: pack_low_lanes(0, 8, 8'h00), keep: 8'hFF, last: 1'b0};
        expected[1] = '{data: pack_low_lanes(8, 4, 8'h00), keep: 8'h0F, last: 1'b0};
        expected[2] = '{data: pack_low_lanes(12, 8, 8'h00), keep: 8'hFF, last: 1'b0};
        expected[3] = '{data: pack_low_lanes(20, 4, 8'h00), keep: 8'h0F, last: 1'b1};

        input_beats[0] = '{data: pack_low_lanes(0, 8, 8'h00), keep: 8'hFF, last: 1'b0};
        input_beats[1] = '{data: pack_low_lanes(8, 8, 8'h00), keep: 8'hFF, last: 1'b0};
        input_beats[2] = '{data: pack_low_lanes(16, 8, 8'h00), keep: 8'hFF, last: 1'b1};

        run_aligned_stream(1, input_beats, expected, msg_type, bytes_per_neuron_cfg);
    endtask

    task automatic run_aligned_passthrough_case();
        beat_t input_beats[];
        beat_t expected[];
        keep_t input_keep[];
        logic [7:0] msg_type;
        logic [15:0] bytes_per_neuron_cfg;

        expected = new[2];
        input_beats = new[2];
        input_keep = new[2];
        msg_type = 8'd1;
        bytes_per_neuron_cfg = 16'd4;

        input_keep[0] = 8'hF0;
        input_keep[1] = 8'h0F;
        expected[0] = '{data: pack_by_keep(input_keep[0], 0, 8'h40), keep: input_keep[0], last: 1'b0};
        expected[1] = '{data: pack_by_keep(input_keep[1], 4, 8'h40), keep: input_keep[1], last: 1'b1};

        input_beats[0] = expected[0];
        input_beats[1] = expected[1];

        run_aligned_stream(2, input_beats, expected, msg_type, bytes_per_neuron_cfg);
    endtask

    initial begin : test_runner
        rst <= 1'b1;
        plain_shift_out_ready <= 1'b1;
        aligned_shift_out_ready <= 1'b1;
        drive_plain_idle();
        drive_aligned_idle();
        passed = 0;
        failed = 0;

        repeat (3) @(posedge clk);
        rst <= 1'b0;

        run_plain_case();
        run_aligned_weight_case();
        run_aligned_passthrough_case();
        run_random_tests(NUM_RANDOM_TESTS);

        $display("Tests completed at time=%0t: %0d passed, %0d failed", $time, passed, failed);
        $finish;
    end

endmodule
