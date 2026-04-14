module config_desc_fifo #(
    parameter int FIFO_DEPTH = 8
) (
    input logic clk,
    input logic rst,

    input logic [7:0] layer_id_in,
    input logic is_weight_in,
    input logic [31:0] total_words_in,
    input logic push,

    output logic [7:0] layer_id_out,
    output logic is_weight_out,
    output logic [31:0] total_words_out,
    output logic valid_out,
    input logic ready_in
);

    localparam int PTR_W = $clog2(FIFO_DEPTH);
    localparam int COUNT_W = $clog2(FIFO_DEPTH + 1);

    typedef struct packed {
        logic [7:0] layer_id;
        logic is_weight;
        logic [31:0] total_words;
    } cfg_desc_t;

    cfg_desc_t fifo_mem [0:FIFO_DEPTH-1];

    logic [PTR_W-1:0] wr_ptr, rd_ptr;
    logic [COUNT_W-1:0] fifo_count;

    logic pop, full, empty;

    assign empty = (fifo_count == 0);
    assign full = (fifo_count == FIFO_DEPTH);

    assign valid_out = !empty;
    assign layer_id_out = fifo_mem[rd_ptr].layer_id;
    assign is_weight_out = fifo_mem[rd_ptr].is_weight;
    assign total_words_out = fifo_mem[rd_ptr].total_words;

    assign pop = valid_out && ready_in;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
            fifo_count <= '0;
            fifo_mem <= '{default: '0};
        end
        else begin
            logic [PTR_W-1:0] wr_ptr_next;
            logic [PTR_W-1:0] rd_ptr_next;
            logic [COUNT_W-1:0] count_next;

            wr_ptr_next = wr_ptr;
            rd_ptr_next = rd_ptr;
            count_next = fifo_count;

            if (pop) begin
                rd_ptr_next = rd_ptr_next + 1'b1;
                count_next = count_next - 1'b1;
            end

            if (push && !full) begin
                fifo_mem[wr_ptr_next].layer_id <= layer_id_in;
                fifo_mem[wr_ptr_next].is_weight <= is_weight_in;
                fifo_mem[wr_ptr_next].total_words <= total_words_in;
                wr_ptr_next = wr_ptr_next + 1'b1;
                count_next = count_next + 1'b1;
            end

            wr_ptr <= wr_ptr_next;
            rd_ptr <= rd_ptr_next;
            fifo_count <= count_next;
        end
    end

endmodule