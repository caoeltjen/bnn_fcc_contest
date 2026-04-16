module img_data_fifo #(
    parameter int WIDTH = 16,
    parameter int INPUTS = 784,
    parameter int NUM_REPLAYS = 32,
    parameter int DEPTH = 16
) (
    input logic clk,
    input logic rst,

    input logic [WIDTH-1:0] data_in,
    input logic             valid_in,
    input logic             img_data_last,
    output logic            ready_in,

    output logic [WIDTH-1:0] data_out,
    output logic             valid_out,
    output logic             img_last_out,
    input  logic             ready_out
);

    localparam int BEATS_PER_IMAGE = (INPUTS + WIDTH - 1) / WIDTH;

    logic [WIDTH-1:0] fifo [0:DEPTH-1][0:BEATS_PER_IMAGE-1];
    logic [$clog2(DEPTH)-1:0] wr_img_ptr, rd_img_ptr;
    logic [$clog2(BEATS_PER_IMAGE)-1:0] wr_beat_idx, rd_beat_idx;
    logic [$clog2(NUM_REPLAYS)-1:0] replay_idx;
    logic [$clog2(DEPTH+1)-1:0] img_count, img_count_next;

    logic fifo_full, fifo_empty;
    logic write_done, read_done;

    assign fifo_full = (img_count == DEPTH);
    assign fifo_empty = (img_count == 0);

    assign ready_in = !fifo_full;

    always_comb begin
        write_done    = valid_in && ready_in && img_data_last;
        read_done     = (!fifo_empty && ready_out && (rd_beat_idx == BEATS_PER_IMAGE-1) && (replay_idx  == NUM_REPLAYS-1));

        img_count_next = img_count;
        case ({write_done, read_done})
            2'b10: img_count_next = img_count + 1'b1;
            2'b01: img_count_next = img_count - 1'b1;
            default: img_count_next = img_count;
        endcase
    end

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            wr_img_ptr <= '0;
            rd_img_ptr <= '0;
            wr_beat_idx <= '0;
            rd_beat_idx  <= '0;
            replay_idx   <= '0;
            img_count    <= '0;

            data_out     <= '0;
            valid_out    <= 1'b0;
            img_last_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0;
            img_last_out <= 1'b0;
            img_count <= img_count_next;

            if(valid_in && ready_in) begin
                fifo[wr_img_ptr][wr_beat_idx] <= data_in;

                wr_beat_idx <= wr_beat_idx + 1'b1;
                if(img_data_last) begin
                    wr_beat_idx <= '0;
                    wr_img_ptr <= wr_img_ptr + 1'b1;
                end
            end

            if(!fifo_empty && ready_out) begin
                img_last_out <= 1'b0;
                data_out <= fifo[rd_img_ptr][rd_beat_idx];
                valid_out <= 1'b1;
                rd_beat_idx <= rd_beat_idx + 1'b1;

                if(rd_beat_idx == BEATS_PER_IMAGE-1 && replay_idx == NUM_REPLAYS-1) begin
                    img_last_out <= 1'b1;
                    rd_beat_idx <= '0;
                    rd_img_ptr <= rd_img_ptr + 1'b1;
                    replay_idx <= '0;
                end
                else if (rd_beat_idx == BEATS_PER_IMAGE-1) begin
                    rd_beat_idx <= '0;
                    replay_idx <= replay_idx + 1'b1;
                end
            end
        end
    end

endmodule