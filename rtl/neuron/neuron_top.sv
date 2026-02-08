module neuron_top #(
    parameter int PW = 16,
    parameter int THRESH_W = 16,

) (
    input logic                 clk,
    input logic                 rst,

    // Inputs for threshold and weight ram writing
    input logic                 cfg_w_enw,
    input logic [PW-1:0]        cfg_w_dataw,
    input logic [PW-1:0]        cfg_w_addrw,

    input logic                 cfg_w_ent,
    input logic [THRESH_W-1:0]  cfg_w_datat,
    input logic [THRESH_W-1:0]  cfg_w_addrt,

    // Outputs of neuron processor
    output logic                valid_out,
    output logic                y,
    output logic [THRESH_W-1:0] popcount_out

);

    logic [PW-1:0]         x;
    logic [PW-1:0]         w;
    logic [THRESH_W-1:0]   threshold;
    logic                  valid_in_r;
    logic                  last_r;

    logic                  next_valid_in;
    logic                  next_last;

    logic [5:0] write_count_w_r;
    logic [5:0] write_count_t_r;

    logic [5:0] next_write_count_w;
    logic [5:0] next_write_count_t;

    logic [5:0] addr_weight_read_r;
    logic [5:0] addr_threshold_read_r;

    logic [5:0] next_addr_weight_read;
    logic [5:0] next_addr_threshold_read;

    logic reading_weights_r;
    logic reading_thresholds_r;

    logic next_reading_weights;
    logic next_reading_thresholds;

    typedef enum logic [1:0] {
        IDLE,
        WRITING,
        READING
    } state_t;

    state_t state_r, next_state;

    neuron #(
        .PW(PW),
        .THRESH_W(THRESH_W)
    ) neuron_inst (
        .x(x),
        .w(w),
        .threshold(threshold),
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in_r),
        .last(last_r),
        .valid_out(valid_out),
        .y(y),
        .popcount_out(popcount_out)
    );

    // BRAM Instantiations
    weight_bram weight_bram_inst (
        .clka(clk),
        .ena(cfg_w_enw),
        .wea(cfg_w_enw),
        .addra(cfg_w_addrw[5:0]),
        .dina(cfg_w_dataw[15:0]),
        .clkb(clk),
        .enb(reading_weights_r),
        .web(1'b0),
        .addrb(addr_weight_read_r),
        .doutb(w)
    );

    threshold_bram threshold_bram_inst (
        .clka(clk),
        .ena(cfg_w_ent),
        .wea(cfg_w_ent),
        .addra(cfg_w_addrt[5:0]),
        .dina(cfg_w_datat),
        .clkb(clk),
        .enb(reading_thresholds_r),
        .web(1'b0),
        .addrb(addr_threshold_read_r),
        .doutb(threshold)
    );    


    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            write_count_w_r       <= '0;
            write_count_t_r       <= '0;
            addr_weight_read_r    <= '0;
            addr_threshold_read_r <= '0;
            reading_weights_r     <= 1'b0;
            reading_thresholds_r  <= 1'b0;
            valid_in_r            <= 1'b0;
            last_r                <= 1'b0;
            state_r               <= WRITING;
        end
        else begin
            write_count_w_r       <= next_write_count_w;
            write_count_t_r       <= next_write_count_t;
            addr_weight_read_r    <= next_addr_weight_read;
            addr_threshold_read_r <= next_addr_threshold_read;
            reading_weights_r     <= next_reading_weights;
            reading_thresholds_r  <= next_reading_thresholds;
            valid_in_r            <= next_valid_in;
            last_r                <= next_last;
            state_r               <= next_state;
        end   
    end

    always_comb begin
        //defaults
        next_state = state_r;
        next_write_count_w = write_count_w_r;
        next_write_count_t = write_count_t_r;
        next_addr_weight_read = addr_weight_read_r;
        next_addr_threshold_read = addr_threshold_read_r;
        next_reading_weights = reading_weights_r;
        next_reading_thresholds = reading_thresholds_r;
        next_valid_in = 1'b0;
        next_last = 1'b0;

        case(state_r)
            IDLE: begin
                if(cfg_w_enw || cfg_w_ent) next_state = WRITING;
            end
            WRITING: begin
                if(cfg_w_enw) next_write_count_w = write_count_w_r + 1;
                if(cfg_w_ent) next_write_count_t = write_count_t_r + 1;
                if (!cfg_w_enw && !cfg_w_ent && (next_write_count_w != 0 || next_write_count_t != 0))
                    next_state = READING;
            end
            READING: begin
                // start reading sequence
                if (!reading_weights_r && !reading_thresholds_r) begin
                    next_reading_weights     = 1'b1;
                    next_reading_thresholds  = 1'b1;
                    next_addr_weight_read    = 6'd0;
                    next_addr_threshold_read = 6'd0;
                    next_valid_in = 1'b0; // data will be valid next cycle
                    next_last = 1'b0;
                end
                else begin
                    next_valid_in = reading_weights_r;

                    if(write_count_w_r != 0 && addr_weight_read_r == (write_count_w_r - 1)) begin
                        next_last = 1'b1;
                    end 
                    else begin
                        next_last = 1'b0;
                    end

                    if(next_last) begin
                        next_reading_weights = 1'b0;
                        next_reading_thresholds = 1'b0;
                        next_state = IDLE;
                    end
                    else begin
                        next_reading_weights = 1'b1;
                        next_reading_thresholds = 1'b1;
                        next_addr_weight_read = addr_weight_read_r + 1;
                        next_addr_threshold_read = addr_threshold_read_r + 1;
                    end
                end
            end

        endcase
    end

endmodule