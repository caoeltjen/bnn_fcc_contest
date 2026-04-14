module neuron_top_cont # (
    parameter int PW = 16,
    parameter int ADDR_W = 11,
    parameter int INPUTS_PER_NEURON = 784
)(
    input logic            clk,
    input logic            rst,

    input logic            cfg_done,

    output logic           thres_read_en,
    output logic [ADDR_W-1:0]     thres_read_addr,

    output logic           w_read_en,
    output logic [ADDR_W-1:0]     w_read_addr,

    output logic            last,
    input logic            valid_in
);

    localparam int NUM_BEATS_PER_NEURON = (INPUTS_PER_NEURON + PW - 1) / PW;
    localparam int BEAT_CNT_W = (NUM_BEATS_PER_NEURON <= 1) ? 1 : $clog2(NUM_BEATS_PER_NEURON);

    localparam int PACK_W = 64;

    localparam int USEFUL_READ_BEATS =
    (INPUTS_PER_NEURON + PW - 1) / PW;

    localparam int WORDS_PER_NEURON_64 =
        (INPUTS_PER_NEURON + PACK_W - 1) / PACK_W;

    localparam int READS_PER_PACKED_WORD =
        PACK_W / PW;

    localparam int STORED_READ_BEATS =
        WORDS_PER_NEURON_64 * READS_PER_PACKED_WORD;

    localparam int PAD_READ_BEATS =
        STORED_READ_BEATS - USEFUL_READ_BEATS;

    logic first_read_happened;
    logic [BEAT_CNT_W-1:0] beat_count;

    assign last = beat_count == NUM_BEATS_PER_NEURON - 1 ? 1 : 0;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            thres_read_en <= 1'b0;
            thres_read_addr <= '0;
            w_read_en <= 1'b0;
            w_read_addr <= '0;
            first_read_happened <= 1'b0;
            beat_count <= '0;
        end
        else begin
            thres_read_en <= 1'b0;
            w_read_en     <= 1'b0;

            if(!first_read_happened && cfg_done) begin
                thres_read_en <= 1'b1;
                w_read_en <= 1'b1;
                first_read_happened <= 1'b1;
                beat_count <= '0;
            end 
            else if(valid_in) begin
                thres_read_en <= 1'b1;
                w_read_en <= 1'b1;
                w_read_addr <= w_read_addr + 1;
                beat_count <= beat_count + 1;
                if(beat_count == USEFUL_READ_BEATS - 1) begin
                    thres_read_addr <= thres_read_addr + 1;
                    beat_count <= '0;
                    w_read_addr <= w_read_addr + 1 + PAD_READ_BEATS;
                end
            end
        end
    end

endmodule