`timescale 1ns/1ps

module tb_config_manager #(
    parameter int BUS_WIDTH = 64,
    parameter int NUM_TESTS = 10,
    parameter int MIN_PAYLOAD_BYTES = 1,
    parameter int MAX_PAYLOAD_BYTES = 48
);

    localparam int BYTE_LANES = BUS_WIDTH / 8;

    typedef bit [BUS_WIDTH-1:0] bus_word_t;
    typedef bit [BYTE_LANES-1:0] keep_t;

    typedef struct packed {
        logic [7:0]  msg_type;
        logic [7:0]  layer_id;
        logic [15:0] layer_inputs;
        logic [15:0] num_neurons;
        logic [15:0] bytes_per_neuron;
        logic [31:0] total_bytes;
        logic [31:0] reserved;
    } header_t;

    logic                     clk = 1'b0;
    logic                     rst;
    logic [BUS_WIDTH-1:0]     config_data_in;
    logic                     config_valid;
    logic [BYTE_LANES-1:0]    config_keep;
    logic                     config_last;
    logic                     config_ready;

    logic [7:0]               msg_type;
    logic [7:0]               layer_id;
    logic [15:0]              layer_inputs;
    logic [15:0]              num_neurons;
    logic [15:0]              bytes_per_neuron;
    logic [31:0]              total_bytes;
    logic [31:0]              reserved;
    logic                     header_valid;
    logic [7:0]               data_out[0:7];
    logic [7:0]               data_out_valid;
    logic                     error;

    int current_test_id;
    int unsigned passed;
    int unsigned failed;

    config_manager #(
        .BUS_WIDTH(BUS_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .config_data_in(config_data_in),
        .config_valid(config_valid),
        .config_keep(config_keep),
        .config_last(config_last),
        .config_ready(config_ready),
        .msg_type(msg_type),
        .layer_id(layer_id),
        .layer_inputs(layer_inputs),
        .num_neurons(num_neurons),
        .bytes_per_neuron(bytes_per_neuron),
        .total_bytes(total_bytes),
        .reserved(reserved),
        .header_valid(header_valid),
        .data_out(data_out),
        .data_out_valid(data_out_valid),
        .error(error)
    );

    initial begin : generate_clock
        forever #5 clk = ~clk;
    end

    task automatic drive_idle();
        begin
            config_valid <= 1'b0;
            config_data_in <= '0;
            config_keep <= '0;
            config_last <= 1'b0;
        end
    endtask

    task automatic build_stream(
        input header_t header,
        input bit [7:0] payload_bytes[],
        output bus_word_t beats[],
        output keep_t keeps[]
    );
        bus_word_t beat_q[$];
        keep_t keep_q[$];
        bus_word_t current_word;
        keep_t current_keep;
        int payload_idx;
        int valid_bytes_in_beat;
        int remaining_bytes;
        int selected_lanes;
        int lane;

        // The 16-byte header is always sent as two fully valid beats.
        current_word = '0;
        current_keep = '1;
        current_word[7:0] = header.msg_type;
        current_word[15:8] = header.layer_id;
        current_word[31:16] = header.layer_inputs;
        current_word[47:32] = header.num_neurons;
        current_word[63:48] = header.bytes_per_neuron;
        beat_q.push_back(current_word);
        keep_q.push_back(current_keep);

        current_word = '0;
        current_keep = '1;
        current_word[31:0] = header.total_bytes;
        current_word[63:32] = header.reserved;
        beat_q.push_back(current_word);
        keep_q.push_back(current_keep);

        // Payload beats may include holes in TKEEP. The shift register should
        // compact valid bytes only for weight payloads; other msg_types should
        // preserve this beat formatting.
        payload_idx = 0;
        while (payload_idx < payload_bytes.size()) begin
            current_word = '0;
            current_keep = '0;
            remaining_bytes = payload_bytes.size() - payload_idx;
            valid_bytes_in_beat = $urandom_range(1, (remaining_bytes < BYTE_LANES) ? remaining_bytes : BYTE_LANES);

            selected_lanes = 0;
            while (selected_lanes < valid_bytes_in_beat) begin
                lane = $urandom_range(0, BYTE_LANES - 1);
                if (!current_keep[lane]) begin
                    current_keep[lane] = 1'b1;
                    selected_lanes++;
                end
            end

            for (int i = 0; i < BYTE_LANES; i++) begin
                if (current_keep[i]) begin
                    current_word[i*8 +: 8] = payload_bytes[payload_idx];
                    payload_idx++;
                end
            end

            beat_q.push_back(current_word);
            keep_q.push_back(current_keep);
        end

        beats = new[beat_q.size()];
        keeps = new[keep_q.size()];
        foreach (beat_q[i]) begin
            beats[i] = beat_q[i];
            keeps[i] = keep_q[i];
        end
    endtask

    task automatic build_stream_with_payload_keeps(
        input header_t header,
        input bit [7:0] payload_bytes[],
        input keep_t payload_keeps[],
        output bus_word_t beats[],
        output keep_t keeps[]
    );
        bus_word_t beat_q[$];
        keep_t keep_q[$];
        bus_word_t current_word;
        keep_t current_keep;
        int payload_idx;
        int beat_bytes;

        current_word = '0;
        current_word[7:0] = header.msg_type;
        current_word[15:8] = header.layer_id;
        current_word[31:16] = header.layer_inputs;
        current_word[47:32] = header.num_neurons;
        current_word[63:48] = header.bytes_per_neuron;
        beat_q.push_back(current_word);
        keep_q.push_back('1);

        current_word = '0;
        current_word[31:0] = header.total_bytes;
        current_word[63:32] = header.reserved;
        beat_q.push_back(current_word);
        keep_q.push_back('1);

        payload_idx = 0;
        foreach (payload_keeps[beat]) begin
            current_word = '0;
            for (int lane = 0; lane < BYTE_LANES; lane++) begin
                if (payload_keeps[beat][lane]) begin
                    if (payload_idx >= payload_bytes.size()) begin
                        $fatal(1, "Directed payload keep pattern over-consumed payload bytes");
                    end
                    current_word[lane*8 +: 8] = payload_bytes[payload_idx];
                    payload_idx++;
                end
            end
            beat_q.push_back(current_word);
            keep_q.push_back(payload_keeps[beat]);
        end

        // The directed keep pattern only needs to describe the interesting
        // leading beats. If payload bytes remain, append additional beats so the
        // message still carries the full payload declared in the header.
        while (payload_idx < payload_bytes.size()) begin
            current_word = '0;
            current_keep = '0;
            beat_bytes = payload_bytes.size() - payload_idx;
            if (beat_bytes > BYTE_LANES) begin
                beat_bytes = BYTE_LANES;
            end

            for (int lane = 0; lane < beat_bytes; lane++) begin
                current_word[lane*8 +: 8] = payload_bytes[payload_idx + lane];
                current_keep[lane] = 1'b1;
            end

            beat_q.push_back(current_word);
            keep_q.push_back(current_keep);
            payload_idx += beat_bytes;
        end

        beats = new[beat_q.size()];
        keeps = new[keep_q.size()];
        foreach (beat_q[i]) begin
            beats[i] = beat_q[i];
            keeps[i] = keep_q[i];
        end
    endtask

    task automatic build_expected_output_beats(
        input header_t header,
        input bit [7:0] payload_bytes[],
        input bus_word_t input_beats[],
        input keep_t input_keeps[],
        output bus_word_t expected_beats[],
        output keep_t expected_keeps[]
    );
        bus_word_t expected_beat_q[$];
        keep_t expected_keep_q[$];
        bus_word_t current_word;
        keep_t current_keep;
        int payload_idx;
        int bytes_left_in_neuron;
        int beat_bytes;

        if (header.msg_type == 8'd0) begin
            payload_idx = 0;
            bytes_left_in_neuron = int'(header.bytes_per_neuron);

            while (payload_idx < payload_bytes.size()) begin
                current_word = '0;
                current_keep = '0;
                beat_bytes = bytes_left_in_neuron;

                if (beat_bytes > BYTE_LANES) begin
                    beat_bytes = BYTE_LANES;
                end
                if (beat_bytes > (payload_bytes.size() - payload_idx)) begin
                    beat_bytes = payload_bytes.size() - payload_idx;
                end

                for (int lane = 0; lane < beat_bytes; lane++) begin
                    current_word[lane*8 +: 8] = payload_bytes[payload_idx + lane];
                    current_keep[lane] = 1'b1;
                end

                expected_beat_q.push_back(current_word);
                expected_keep_q.push_back(current_keep);
                payload_idx += beat_bytes;

                if (beat_bytes == bytes_left_in_neuron) begin
                    if (payload_idx < payload_bytes.size()) begin
                        bytes_left_in_neuron = int'(header.bytes_per_neuron);
                    end else begin
                        bytes_left_in_neuron = 0;
                    end
                end else begin
                    bytes_left_in_neuron -= beat_bytes;
                end
            end
        end else begin
            for (int beat = 2; beat < input_beats.size(); beat++) begin
                expected_beat_q.push_back(input_beats[beat]);
                expected_keep_q.push_back(input_keeps[beat]);
            end
        end

        expected_beats = new[expected_beat_q.size()];
        expected_keeps = new[expected_keep_q.size()];
        foreach (expected_beat_q[i]) begin
            expected_beats[i] = expected_beat_q[i];
            expected_keeps[i] = expected_keep_q[i];
        end
    endtask

    task automatic make_random_item(
        output header_t header,
        output bit [7:0] payload[]
    );
        int unsigned payload_size;
        int unsigned max_num_neurons;
        int unsigned num_neurons_tmp;
        int unsigned bytes_per_neuron_tmp;
        int unsigned layer_inputs_tmp;
        int unsigned threshold_beats;

        header = '0;
        header.msg_type = 8'($urandom_range(0, 1));
        header.layer_id = 8'($urandom_range(0, 2));
        header.reserved = 32'd0;

        if (header.msg_type == 8'd0) begin
            payload_size = 0;
            while ((payload_size < MIN_PAYLOAD_BYTES) || (payload_size > MAX_PAYLOAD_BYTES)) begin
                layer_inputs_tmp = $urandom_range(1, 8 * MAX_PAYLOAD_BYTES);
                bytes_per_neuron_tmp = (layer_inputs_tmp + 7) / 8;
                max_num_neurons = MAX_PAYLOAD_BYTES / bytes_per_neuron_tmp;
                if (max_num_neurons == 0) begin
                    max_num_neurons = 1;
                end
                num_neurons_tmp = $urandom_range(1, max_num_neurons);
                payload_size = num_neurons_tmp * bytes_per_neuron_tmp;
                header.layer_inputs = 16'(layer_inputs_tmp);
                header.num_neurons = 16'(num_neurons_tmp);
                header.bytes_per_neuron = 16'(bytes_per_neuron_tmp);
            end
        end else begin
            payload_size = 0;
            threshold_beats = 0;
            while ((payload_size < MIN_PAYLOAD_BYTES) || (payload_size > MAX_PAYLOAD_BYTES)) begin
                threshold_beats = $urandom_range(1, MAX_PAYLOAD_BYTES / 8);
                payload_size = threshold_beats * 8;
            end
            header.layer_inputs = 16'($urandom_range(1, 1024));
            header.bytes_per_neuron = 16'd4;
            header.num_neurons = 16'((payload_size / 4));
        end

        header.total_bytes = 32'(payload_size);
        payload = new[payload_size];
        foreach (payload[i]) begin
            payload[i] = 8'($urandom);
        end
    endtask

    task automatic check_outputs(
        input header_t expected_header,
        input bus_word_t expected_beats[],
        input keep_t expected_keeps[],
        input int test_id,
        inout int unsigned expected_beat_idx,
        inout bit header_checked,
        inout bit test_failed
    );
        if (!header_checked && header_valid) begin
            if ((msg_type !== expected_header.msg_type) ||
                (layer_id !== expected_header.layer_id) ||
                (layer_inputs !== expected_header.layer_inputs) ||
                (num_neurons !== expected_header.num_neurons) ||
                (bytes_per_neuron !== expected_header.bytes_per_neuron) ||
                (total_bytes !== expected_header.total_bytes) ||
                (reserved !== expected_header.reserved)) begin
                $display("FAIL time=%0t test=%0d header mismatch", $time, test_id);
                $display("  exp msg_type=%0h layer_id=%0h layer_inputs=%0h num_neurons=%0h bytes_per_neuron=%0h total_bytes=%0h reserved=%0h",
                         expected_header.msg_type, expected_header.layer_id, expected_header.layer_inputs,
                         expected_header.num_neurons, expected_header.bytes_per_neuron, expected_header.total_bytes,
                         expected_header.reserved);
                test_failed = 1'b1;
            end
            header_checked = 1'b1;
        end

        if (data_out_valid != '0) begin
            if (expected_beat_idx >= expected_beats.size()) begin
                $display("FAIL time=%0t test=%0d unexpected payload beat observed keep=%b data=%h",
                         $time, test_id, data_out_valid, {
                             data_out[7], data_out[6], data_out[5], data_out[4],
                             data_out[3], data_out[2], data_out[1], data_out[0]
                         });
                test_failed = 1'b1;
                return;
            end

            for (int lane = 0; lane < BYTE_LANES; lane++) begin
                bit expected_valid;
                bit [7:0] expected_byte;

                expected_valid = expected_keeps[expected_beat_idx][lane];
                expected_byte = expected_beats[expected_beat_idx][lane*8 +: 8];

                if (data_out_valid[lane] !== expected_valid) begin
                    $display("FAIL time=%0t test=%0d beat=%0d lane=%0d valid mismatch exp=%0b act=%0b",
                             $time, test_id, expected_beat_idx, lane, expected_valid, data_out_valid[lane]);
                    test_failed = 1'b1;
                end

                if (data_out[lane] !== expected_byte) begin
                    $display("FAIL time=%0t test=%0d beat=%0d lane=%0d data mismatch exp=0x%0h act=0x%0h",
                             $time, test_id, expected_beat_idx, lane, expected_byte, data_out[lane]);
                    test_failed = 1'b1;
                end
            end

            expected_beat_idx++;
        end
    endtask

    task automatic run_case(
        input int test_id,
        input header_t expected_header,
        input bit [7:0] expected_payload[],
        input keep_t payload_keeps[]
    );
        int gap_cycles[];

        gap_cycles = new[0];
        run_case_with_gaps(test_id, expected_header, expected_payload, payload_keeps, gap_cycles);
    endtask

    task automatic run_case_with_gaps(
        input int test_id,
        input header_t expected_header,
        input bit [7:0] expected_payload[],
        input keep_t payload_keeps[],
        input int gap_cycles[]
    );
        bus_word_t beats[];
        keep_t keeps[];
        bus_word_t expected_output_beats[];
        keep_t expected_output_keeps[];
        int unsigned expected_beat_idx;
        int unsigned drain_cycles;
        bus_word_t held_data;
        keep_t held_keep;
        logic held_last;
        int gap_count;
        bit header_checked;
        bit test_failed;

        current_test_id = test_id;
        if (payload_keeps.size() == 0) begin
            build_stream(expected_header, expected_payload, beats, keeps);
        end else begin
            build_stream_with_payload_keeps(expected_header, expected_payload, payload_keeps, beats, keeps);
        end
        build_expected_output_beats(expected_header, expected_payload, beats, keeps,
                                    expected_output_beats, expected_output_keeps);

        expected_beat_idx = 0;
        drain_cycles = 0;
        header_checked = 1'b0;
        test_failed = 1'b0;
        held_data = '0;
        held_keep = '0;
        held_last = 1'b0;

        for (int beat = 0; beat < beats.size(); beat++) begin
            gap_count = (beat < gap_cycles.size()) ? gap_cycles[beat] : 0;

            repeat (gap_count) begin
                @(negedge clk);
                config_valid <= 1'b0;
                config_data_in <= held_data;
                config_keep <= held_keep;
                config_last <= held_last;

                @(posedge clk);
                check_outputs(expected_header, expected_output_beats, expected_output_keeps,
                              test_id, expected_beat_idx,
                              header_checked, test_failed);
            end

            @(negedge clk);
            config_valid <= 1'b1;
            config_data_in <= beats[beat];
            config_keep <= keeps[beat];
            config_last <= (beat == beats.size() - 1);

            while (!config_ready) begin
                @(posedge clk);
                check_outputs(expected_header, expected_output_beats, expected_output_keeps,
                              test_id, expected_beat_idx,
                              header_checked, test_failed);
            end

            @(posedge clk iff config_ready);
            check_outputs(expected_header, expected_output_beats, expected_output_keeps,
                          test_id, expected_beat_idx,
                          header_checked, test_failed);

            held_data = beats[beat];
            held_keep = keeps[beat];
            held_last = (beat == beats.size() - 1);
        end

        @(negedge clk);
        drive_idle();

        while ((expected_beat_idx != expected_output_beats.size()) &&
               (drain_cycles < (expected_output_beats.size() + int'(expected_header.num_neurons) + 8))) begin
            @(posedge clk);
            check_outputs(expected_header, expected_output_beats, expected_output_keeps,
                          test_id, expected_beat_idx,
                          header_checked, test_failed);
            drain_cycles++;
        end

        if (!header_checked) begin
            $display("FAIL time=%0t test=%0d header was never observed", $time, test_id);
            test_failed = 1'b1;
        end

        if (expected_beat_idx != expected_output_beats.size()) begin
            $display("FAIL time=%0t test=%0d payload beat count mismatch: expected %0d observed %0d",
                     $time, test_id, expected_output_beats.size(), expected_beat_idx);
            test_failed = 1'b1;
        end

        if (error) begin
            $display("FAIL time=%0t test=%0d unexpected error asserted", $time, test_id);
            test_failed = 1'b1;
        end

        if (test_failed) begin
            failed++;
            $display("FAIL time=%0t test=%0d complete", $time, test_id);
        end else begin
            passed++;
            $display("PASS time=%0t test=%0d payload_bytes=%0d", $time, test_id, expected_payload.size());
        end
    endtask

    task automatic run_directed_tests();
        header_t directed_header;
        bit [7:0] directed_payload[];
        keep_t directed_keeps[];
        int gap_cycles[];

        directed_header = '0;
        directed_header.msg_type = 8'd0;
        directed_header.layer_id = 8'd0;
        directed_header.layer_inputs = 16'd96;
        directed_header.num_neurons = 16'd2;
        directed_header.bytes_per_neuron = 16'd12;
        directed_header.total_bytes = 32'd24;
        directed_header.reserved = 32'd0;
        directed_payload = new[24];
        foreach (directed_payload[i]) begin
            directed_payload[i] = 8'(i);
        end
        directed_keeps = new[3];
        directed_keeps[0] = 8'hFF;
        directed_keeps[1] = 8'hFF;
        directed_keeps[2] = 8'h0F;
        run_case(1000, directed_header, directed_payload, directed_keeps);

        directed_header = '0;
        directed_header.msg_type = 8'd0;
        directed_header.layer_id = 8'd1;
        directed_header.layer_inputs = 16'd96;
        directed_header.num_neurons = 16'd2;
        directed_header.bytes_per_neuron = 16'd12;
        directed_header.total_bytes = 32'd24;
        directed_header.reserved = 32'd0;
        directed_payload = new[24];
        foreach (directed_payload[i]) begin
            directed_payload[i] = 8'h80 ^ 8'(i);
        end
        directed_keeps = new[5];
        directed_keeps[0] = 8'hFF;
        directed_keeps[1] = 8'hF0;
        directed_keeps[2] = 8'h0F;
        directed_keeps[3] = 8'h3F;
        directed_keeps[4] = 8'h03;
        run_case(1001, directed_header, directed_payload, directed_keeps);

        directed_header = '0;
        directed_header.msg_type = 8'd1;
        directed_header.layer_id = 8'd2;
        directed_header.layer_inputs = 16'd256;
        directed_header.num_neurons = 16'd4;
        directed_header.bytes_per_neuron = 16'd4;
        directed_header.total_bytes = 32'd16;
        directed_header.reserved = 32'd0;
        directed_payload = new[16];
        foreach (directed_payload[i]) begin
            directed_payload[i] = 8'h40 ^ 8'(i);
        end
        directed_keeps = new[2];
        directed_keeps[0] = 8'hF0;
        directed_keeps[1] = 8'h0F;
        run_case(1002, directed_header, directed_payload, directed_keeps);

        directed_header = '0;
        directed_header.msg_type = 8'd0;
        directed_header.layer_id = 8'd3;
        directed_header.layer_inputs = 16'd96;
        directed_header.num_neurons = 16'd2;
        directed_header.bytes_per_neuron = 16'd12;
        directed_header.total_bytes = 32'd24;
        directed_header.reserved = 32'h55AA1234;
        directed_payload = new[24];
        foreach (directed_payload[i]) begin
            directed_payload[i] = 8'hA0 + 8'(i);
        end
        directed_keeps = new[3];
        directed_keeps[0] = 8'hFF;
        directed_keeps[1] = 8'hF0;
        directed_keeps[2] = 8'hFF;
        gap_cycles = new[5];
        gap_cycles[0] = 0;
        gap_cycles[1] = 2;
        gap_cycles[2] = 3;
        gap_cycles[3] = 1;
        gap_cycles[4] = 2;
        run_case_with_gaps(1003, directed_header, directed_payload, directed_keeps, gap_cycles);

        directed_header = '0;
        directed_header.msg_type = 8'd1;
        directed_header.layer_id = 8'd4;
        directed_header.layer_inputs = 16'd128;
        directed_header.num_neurons = 16'd4;
        directed_header.bytes_per_neuron = 16'd4;
        directed_header.total_bytes = 32'd16;
        directed_header.reserved = 32'hAA5500FF;
        directed_payload = new[16];
        foreach (directed_payload[i]) begin
            directed_payload[i] = 8'h30 + 8'(i);
        end
        directed_keeps = new[3];
        directed_keeps[0] = 8'h33;
        directed_keeps[1] = 8'hF0;
        directed_keeps[2] = 8'h0F;
        gap_cycles = new[5];
        gap_cycles[0] = 0;
        gap_cycles[1] = 1;
        gap_cycles[2] = 2;
        gap_cycles[3] = 2;
        gap_cycles[4] = 1;
        run_case_with_gaps(1004, directed_header, directed_payload, directed_keeps, gap_cycles);
    endtask

    task automatic run_test(input int test_id);
        header_t expected_header;
        bit [7:0] expected_payload[];
        keep_t payload_keeps[];

        make_random_item(expected_header, expected_payload);
        payload_keeps = new[0];
        run_case(test_id, expected_header, expected_payload, payload_keeps);
    endtask

    initial begin : test_runner
        rst <= 1'b1;
        drive_idle();
        current_test_id = -1;
        passed = 0;
        failed = 0;

        repeat (5) @(posedge clk);
        @(negedge clk);
        rst <= 1'b0;

        run_directed_tests();
        for (int test_id = 0; test_id < NUM_TESTS; test_id++) begin
            run_test(test_id);
        end

        current_test_id = -1;
        $display("Tests completed at time=%0t: %0d passed, %0d failed", $time, passed, failed);
        $finish;
    end

endmodule
