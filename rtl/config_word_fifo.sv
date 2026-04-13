module config_word_fifo #(
    parameter int CONFIG_BUS_WIDTH = 64,
    parameter int FIFO_DEPTH = 32
) (
    input  logic clk,
    input  logic rst,

    input  logic [7:0] data_in [0:CONFIG_BUS_WIDTH/8-1],
    input  logic [CONFIG_BUS_WIDTH/8-1:0] data_valid_in,

    output logic [15:0] data_out,
    output logic        data_out_valid,
    input  logic        data_out_ready
);

    localparam int NUM_BYTES          = CONFIG_BUS_WIDTH / 8;
    localparam int WORDS_PER_BEAT     = NUM_BYTES / 2;
    localparam int FIFO_PTR_W         = $clog2(FIFO_DEPTH);
    localparam int FIFO_COUNT_W       = $clog2(FIFO_DEPTH + 1);
    localparam int PUSH_COUNT_W       = $clog2(WORDS_PER_BEAT + 1);

    // FIFO storage
    logic [15:0] fifo_mem [0:FIFO_DEPTH-1];
    logic [FIFO_PTR_W-1:0] wr_ptr;
    logic [FIFO_PTR_W-1:0] rd_ptr;
    logic [FIFO_COUNT_W-1:0] fifo_count;

    // Packed candidate words from this cycle's input beat
    logic [15:0] pair_words [0:WORDS_PER_BEAT-1];
    logic [WORDS_PER_BEAT-1:0] pair_valid;

    // Next-state helpers
    logic pop_fifo;
    logic [PUSH_COUNT_W-1:0] push_count;

    //--------------------------------------------------------------------------
    // Pack byte pairs into 16-bit candidate words
    //--------------------------------------------------------------------------
    always_comb begin
        for (int i = 0; i < WORDS_PER_BEAT; i++) begin
            pair_words[i] = {data_in[2*i+1], data_in[2*i]};
            pair_valid[i] = data_valid_in[2*i+1] & data_valid_in[2*i];
        end
    end

    //--------------------------------------------------------------------------
    // FIFO output interface
    //--------------------------------------------------------------------------
    assign data_out_valid = (fifo_count != 0);
    assign data_out       = fifo_mem[rd_ptr];
    assign pop_fifo       = data_out_valid & data_out_ready;

    // Count how many complete 16-bit words are available to push this cycle
    always_comb begin
        push_count = '0;
        for (int i = 0; i < WORDS_PER_BEAT; i++) begin
            if (pair_valid[i]) begin
                push_count = push_count + 1'b1;
            end
        end
    end

    //--------------------------------------------------------------------------
    // FIFO sequential logic
    //--------------------------------------------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr     <= '0;
            rd_ptr     <= '0;
            fifo_count <= '0;
            fifo_mem   <= '{default: '0};
        end
        else begin
            logic [FIFO_PTR_W-1:0] wr_ptr_next;
            logic [FIFO_COUNT_W-1:0] fifo_count_next;

            wr_ptr_next    = wr_ptr;
            fifo_count_next = fifo_count;

            // Pop one word if downstream consumed it
            if (pop_fifo) begin
                rd_ptr <= rd_ptr + 1'b1;
                fifo_count_next = fifo_count_next - 1'b1;
            end

            // Push all valid words from this beat
            for (int i = 0; i < WORDS_PER_BEAT; i++) begin
                if (pair_valid[i]) begin
                    if (fifo_count_next < FIFO_DEPTH) begin
                        fifo_mem[wr_ptr_next] <= pair_words[i];
                        wr_ptr_next = wr_ptr_next + 1'b1;
                        fifo_count_next = fifo_count_next + 1'b1;
                    end
                end
            end

            wr_ptr     <= wr_ptr_next;
            fifo_count <= fifo_count_next;
        end
    end

endmodule