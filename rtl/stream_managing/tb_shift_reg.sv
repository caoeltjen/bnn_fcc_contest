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

    function automatic bus_word_t mask_by_keep(
        input bus_word_t data,
        input keep_t keep
    );
        bus_word_t word;

        word = '0;
        for (int lane = 0; lane < BYTE_LANES; lane++) begin
            if (keep[lane]) begin
                word[lane*8 +: 8] = data[lane*8 +: 8];
            end
        end
        return word;
    endfunction

    function automatic bus_word_t make_header_word0(
        input logic [7:0] msg_type,
        input logic [7:0] layer_id,
        input logic [15:0] layer_inputs,
        input logic [15:0] num_neurons,
        input logic [15:0] bytes_per_neuron_cfg
    );
        bus_word_t word;

        word = '0;
        word[7:0] = msg_type;
        word[15:8] = layer_id;
        word[31:16] = layer_inputs;
        word[47:32] = num_neurons;
        word[63:48] = bytes_per_neuron_cfg;
        return word;
    endfunction

    function automatic bus_word_t make_header_word1(
        input logic [31:0] total_bytes,
        input logic [31:0] reserved
    );
        bus_word_t word;

        word = '0;
        word[31:0] = total_bytes;
        word[63:32] = reserved;
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
        bus_word_t expected_masked_data;

        expected_masked_data = mask_by_keep(expected.data, expected.keep);

        if (plain_shift_out_keep !== expected.keep) begin
            $display("FAIL time=%0t test=%0d beat=%0d keep mismatch exp=%b act=%b",
                     $time, test_id, beat_id, expected.keep, plain_shift_out_keep);
            test_failed = 1'b1;
        end

        if (plain_shift_out_data !== expected_masked_data) begin
            $display("FAIL time=%0t test=%0d beat=%0d data mismatch exp=%h act=%h",
                     $time, test_id, beat_id, expected_masked_data, plain_shift_out_data);
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
        int gap_cycles[];

        gap_cycles = new[0];
        run_plain_stream_with_gaps(test_id, expected, gap_cycles);
    endtask

    task automatic run_plain_stream_with_gaps(
        input int test_id,
        input beat_t expected[],
        input int gap_cycles[]
    );
        bit test_failed;
        int unsigned observed;
        int unsigned drain_cycles;
        beat_t held_beat;
        int gap_count;

        test_failed = 1'b0;
        observed = 0;
        drain_cycles = 0;
        held_beat = '{default: '0};

        reset_duts();

        for (int beat = 0; beat < expected.size(); beat++) begin
            gap_count = (beat < gap_cycles.size()) ? gap_cycles[beat] : 0;

            repeat (gap_count) begin
                @(negedge clk);
                plain_shift_in_valid <= 1'b0;
                plain_shift_in_data <= held_beat.data;
                plain_shift_in_keep <= held_beat.keep;
                plain_shift_in_last <= held_beat.last;

                @(posedge clk);
                if (plain_shift_out_valid) begin
                    check_plain_beat(test_id, observed, expected[observed], test_failed);
                    observed++;
                end
            end

            @(negedge clk);
            plain_shift_in_valid <= 1'b1;
            plain_shift_in_data <= expected[beat].data;
            plain_shift_in_keep <= expected[beat].keep;
            plain_shift_in_last <= expected[beat].last;

            while (!plain_shift_in_ready) begin
                @(posedge clk);
                if (plain_shift_out_valid) begin
                    check_plain_beat(test_id, observed, expected[observed], test_failed);
                    observed++;
                end
            end

            @(posedge clk iff plain_shift_in_ready);
            if (plain_shift_out_valid) begin
                check_plain_beat(test_id, observed, expected[observed], test_failed);
                observed++;
            end

            held_beat = expected[beat];
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
        bit [7:0] available_bytes[$];
        keep_t payload_keeps[];
        int unsigned payload_size;
        int unsigned payload_idx;
        int unsigned valid_bytes;
        int unsigned num_neurons;
        int unsigned bytes_left_in_neuron;
        int unsigned expected_idx;
        int unsigned beat_bytes;
        int unsigned num_beats;
        logic [7:0] layer_id;
        logic [15:0] layer_inputs;
        logic [31:0] reserved;

        msg_type = 8'($urandom_range(0, 1));
        layer_id = 8'($urandom);
        reserved = 32'($urandom);
        if (msg_type == 8'd0) begin
            bytes_per_neuron_cfg = 16'($urandom_range(1, BYTE_LANES + 4));
            num_neurons = $urandom_range(1, 4);
            payload_size = num_neurons * bytes_per_neuron_cfg;
            layer_inputs = 16'(bytes_per_neuron_cfg * 8);
        end else begin
            bytes_per_neuron_cfg = 16'd4;
            payload_size = $urandom_range(1, MAX_RANDOM_BEATS) * 4;
            num_neurons = payload_size / 4;
            layer_inputs = 16'($urandom_range(1, 1024));
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

        input_beats = new[payload_keeps.size() + 2];
        input_beats[0] = '{
            data: make_header_word0(msg_type, layer_id, layer_inputs, 16'(num_neurons), bytes_per_neuron_cfg),
            keep: '1,
            last: 1'b0
        };
        input_beats[1] = '{
            data: make_header_word1(32'(payload_size), reserved),
            keep: '1,
            last: 1'b0
        };
        payload_idx = 0;
        for (int beat = 0; beat < payload_keeps.size(); beat++) begin
            int beat_idx;

            beat_idx = beat + 2;
            input_beats[beat_idx].data = '0;
            input_beats[beat_idx].keep = payload_keeps[beat];
            input_beats[beat_idx].last = (beat == payload_keeps.size() - 1);
            for (int lane = 0; lane < BYTE_LANES; lane++) begin
                if (payload_keeps[beat][lane]) begin
                    input_beats[beat_idx].data[lane*8 +: 8] = payload_bytes[payload_idx];
                    payload_idx++;
                end
            end
        end

        if (msg_type == 8'd0) begin
            expected_beats = new[2];
            expected_beats[0] = input_beats[0];
            expected_beats[1] = input_beats[1];
            bytes_left_in_neuron = int'(bytes_per_neuron_cfg);
            expected_idx = 2;

            for (int beat = 2; beat < input_beats.size(); beat++) begin
                for (int lane = 0; lane < BYTE_LANES; lane++) begin
                    if (input_beats[beat].keep[lane]) begin
                        available_bytes.push_back(input_beats[beat].data[lane*8 +: 8]);
                    end
                end

                expected_beats = new[expected_idx + 1](expected_beats);
                expected_beats[expected_idx].data = '0;
                expected_beats[expected_idx].keep = '0;
                beat_bytes = available_bytes.size();
                if (beat_bytes > BYTE_LANES) begin
                    beat_bytes = BYTE_LANES;
                end
                if (beat_bytes > bytes_left_in_neuron) begin
                    beat_bytes = bytes_left_in_neuron;
                end

                for (int lane = 0; lane < beat_bytes; lane++) begin
                    expected_beats[expected_idx].data[lane*8 +: 8] = available_bytes.pop_front();
                    expected_beats[expected_idx].keep[lane] = 1'b1;
                end
                expected_beats[expected_idx].last = input_beats[beat].last && (available_bytes.size() == 0);
                if (beat_bytes == bytes_left_in_neuron) begin
                    bytes_left_in_neuron = int'(bytes_per_neuron_cfg);
                end else begin
                    bytes_left_in_neuron -= beat_bytes;
                end
                expected_idx++;
            end

            while (available_bytes.size() != 0) begin
                expected_beats = new[expected_idx + 1](expected_beats);
                expected_beats[expected_idx].data = '0;
                expected_beats[expected_idx].keep = '0;
                beat_bytes = available_bytes.size();
                if (beat_bytes > BYTE_LANES) begin
                    beat_bytes = BYTE_LANES;
                end
                if (beat_bytes > bytes_left_in_neuron) begin
                    beat_bytes = bytes_left_in_neuron;
                end

                for (int lane = 0; lane < beat_bytes; lane++) begin
                    expected_beats[expected_idx].data[lane*8 +: 8] = available_bytes.pop_front();
                    expected_beats[expected_idx].keep[lane] = 1'b1;
                end
                expected_beats[expected_idx].last = (available_bytes.size() == 0);
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
        int gap_cycles[];

        gap_cycles = new[0];
        run_aligned_stream_with_gaps(test_id, input_beats, expected, msg_type, bytes_per_neuron_cfg, gap_cycles);
    endtask

    task automatic run_aligned_stream_with_gaps(
        input int test_id,
        input beat_t input_beats[],
        input beat_t expected[] ,
        input logic [7:0] msg_type,
        input logic [15:0] bytes_per_neuron_cfg,
        input int gap_cycles[]
    );
        bit test_failed;
        int unsigned observed;
        int unsigned drain_cycles;
        beat_t held_beat;
        int gap_count;

        test_failed = 1'b0;
        observed = 0;
        drain_cycles = 0;
        held_beat = '{default: '0};

        reset_duts();

        for (int beat = 0; beat < input_beats.size(); beat++) begin
            gap_count = (beat < gap_cycles.size()) ? gap_cycles[beat] : 0;

            repeat (gap_count) begin
                @(negedge clk);
                aligned_shift_in_valid <= 1'b0;
                aligned_shift_in_data <= held_beat.data;
                aligned_shift_in_keep <= held_beat.keep;
                aligned_shift_in_last <= held_beat.last;
                aligned_msg_type <= msg_type;
                aligned_msg_type_valid <= 1'b0;
                aligned_bytes_per_neuron <= bytes_per_neuron_cfg;
                aligned_bytes_per_neuron_valid <= 1'b0;

                @(posedge clk);
                if (aligned_shift_out_valid) begin
                    check_aligned_beat(test_id, observed, expected[observed], test_failed);
                    observed++;
                end
            end

            @(negedge clk);
            aligned_shift_in_valid <= 1'b1;
            aligned_shift_in_data <= input_beats[beat].data;
            aligned_shift_in_keep <= input_beats[beat].keep;
            aligned_shift_in_last <= input_beats[beat].last;
            aligned_msg_type <= msg_type;
            aligned_msg_type_valid <= (beat == 0);
            aligned_bytes_per_neuron <= bytes_per_neuron_cfg;
            aligned_bytes_per_neuron_valid <= (beat == 0) && (msg_type == 8'd0);

            while (!aligned_shift_in_ready) begin
                @(posedge clk);
                if (aligned_shift_out_valid) begin
                    check_aligned_beat(test_id, observed, expected[observed], test_failed);
                    observed++;
                end
            end

            @(posedge clk iff aligned_shift_in_ready);
            if (aligned_shift_out_valid) begin
                check_aligned_beat(test_id, observed, expected[observed], test_failed);
                observed++;
            end

            held_beat = input_beats[beat];
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

    task automatic run_plain_gap_case();
        beat_t expected[];
        int gap_cycles[];

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

        gap_cycles = new[2];
        gap_cycles[0] = 0;
        gap_cycles[1] = 3;
        run_plain_stream_with_gaps(10, expected, gap_cycles);
    endtask

    task automatic run_aligned_weight_case();
        beat_t input_beats[];
        beat_t expected[];
        logic [7:0] msg_type;
        logic [15:0] bytes_per_neuron_cfg;

        expected = new[6];
        input_beats = new[5];
        msg_type = 8'd0;
        bytes_per_neuron_cfg = 16'd12;

        input_beats[0] = '{
            data: make_header_word0(8'd0, 8'd1, 16'd96, 16'd2, 16'd12),
            keep: '1,
            last: 1'b0
        };
        input_beats[1] = '{
            data: make_header_word1(32'd24, 32'h12345678),
            keep: '1,
            last: 1'b0
        };
        input_beats[2] = '{data: pack_low_lanes(0, 8, 8'h00), keep: 8'hFF, last: 1'b0};
        input_beats[3] = '{data: pack_low_lanes(8, 8, 8'h00), keep: 8'hFF, last: 1'b0};
        input_beats[4] = '{data: pack_low_lanes(16, 8, 8'h00), keep: 8'hFF, last: 1'b1};

        expected[0] = input_beats[0];
        expected[1] = input_beats[1];
        expected[2] = '{data: pack_low_lanes(0, 8, 8'h00), keep: 8'hFF, last: 1'b0};
        expected[3] = '{data: pack_low_lanes(8, 4, 8'h00), keep: 8'h0F, last: 1'b0};
        expected[4] = '{data: pack_low_lanes(12, 8, 8'h00), keep: 8'hFF, last: 1'b0};
        expected[5] = '{data: pack_low_lanes(20, 4, 8'h00), keep: 8'h0F, last: 1'b1};

        run_aligned_stream(1, input_beats, expected, msg_type, bytes_per_neuron_cfg);
    endtask

    task automatic run_aligned_passthrough_case();
        beat_t input_beats[];
        beat_t expected[];
        keep_t input_keep[];
        logic [7:0] msg_type;
        logic [15:0] bytes_per_neuron_cfg;

        expected = new[4];
        input_beats = new[4];
        input_keep = new[2];
        msg_type = 8'd1;
        bytes_per_neuron_cfg = 16'd4;

        input_keep[0] = 8'hF0;
        input_keep[1] = 8'h0F;
        input_beats[0] = '{
            data: make_header_word0(8'd1, 8'd2, 16'd256, 16'd4, 16'd4),
            keep: '1,
            last: 1'b0
        };
        input_beats[1] = '{
            data: make_header_word1(32'd16, 32'hCAFE1234),
            keep: '1,
            last: 1'b0
        };
        input_beats[2] = '{data: pack_by_keep(input_keep[0], 0, 8'h40), keep: input_keep[0], last: 1'b0};
        input_beats[3] = '{data: pack_by_keep(input_keep[1], 4, 8'h40), keep: input_keep[1], last: 1'b1};

        expected[0] = input_beats[0];
        expected[1] = input_beats[1];
        expected[2] = input_beats[2];
        expected[3] = input_beats[3];

        run_aligned_stream(2, input_beats, expected, msg_type, bytes_per_neuron_cfg);
    endtask

    task automatic run_aligned_gap_case();
        beat_t input_beats[];
        beat_t expected[];
        int gap_cycles[];
        logic [7:0] msg_type;
        logic [15:0] bytes_per_neuron_cfg;

        expected = new[6];
        input_beats = new[5];
        gap_cycles = new[5];
        msg_type = 8'd0;
        bytes_per_neuron_cfg = 16'd12;

        input_beats[0] = '{
            data: make_header_word0(8'd0, 8'd3, 16'd96, 16'd2, 16'd12),
            keep: '1,
            last: 1'b0
        };
        input_beats[1] = '{
            data: make_header_word1(32'd24, 32'h55AA1234),
            keep: '1,
            last: 1'b0
        };
        input_beats[2] = '{data: pack_by_keep(8'hFF, 0, 8'h20), keep: 8'hFF, last: 1'b0};
        input_beats[3] = '{data: pack_by_keep(8'hF0, 8, 8'h20), keep: 8'hF0, last: 1'b0};
        input_beats[4] = '{data: pack_by_keep(8'hFF, 12, 8'h20), keep: 8'hFF, last: 1'b1};

        expected[0] = input_beats[0];
        expected[1] = input_beats[1];
        expected[2] = '{data: pack_low_lanes(0, 8, 8'h20), keep: 8'hFF, last: 1'b0};
        expected[3] = '{data: pack_low_lanes(8, 4, 8'h20), keep: 8'h0F, last: 1'b0};
        expected[4] = '{data: pack_low_lanes(12, 8, 8'h20), keep: 8'hFF, last: 1'b0};
        expected[5] = '{data: pack_low_lanes(20, 4, 8'h20), keep: 8'h0F, last: 1'b1};

        gap_cycles[0] = 0;
        gap_cycles[1] = 2;
        gap_cycles[2] = 1;
        gap_cycles[3] = 3;
        gap_cycles[4] = 2;
        run_aligned_stream_with_gaps(11, input_beats, expected, msg_type, bytes_per_neuron_cfg, gap_cycles);
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
        run_plain_gap_case();
        run_aligned_weight_case();
        run_aligned_passthrough_case();
        run_aligned_gap_case();
        run_random_tests(NUM_RANDOM_TESTS);

        $display("Tests completed at time=%0t: %0d passed, %0d failed", $time, passed, failed);
        $finish;
    end

endmodule

