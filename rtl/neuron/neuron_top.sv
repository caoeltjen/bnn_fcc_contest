// Top-level neuron wrapper: comments added for clarity

module neuron_top #(
    parameter int PW = 16,            // PW: width of input vector and weight elements
    parameter int THRESH_W = 16      // THRESH_W: width of threshold / popcount output
) (
    input logic                 clk, // system clock
    input logic                 rst, // synchronous reset (active high)

    // Inputs for threshold and weight ram writing
    input logic                 cfg_w_enw,      // write enable for weight BRAM (port A)
    input logic [PW-1:0]        cfg_w_dataw,    // data to write into weight BRAM
    input logic [PW-1:0]        cfg_w_addrw,    // write address for weight BRAM

    input logic                 cfg_w_ent,      // write enable for threshold BRAM (port A)
    input logic [THRESH_W-1:0]  cfg_w_datat,    // data to write into threshold BRAM
    input logic [THRESH_W-1:0]  cfg_w_addrt,    // write address for threshold BRAM

    // Outputs of neuron processor
    output logic                valid_out,      // asserted when neuron output is valid
    output logic                y,              // neuron binary output (activation)
    output logic [THRESH_W-1:0] popcount_out    // population count result / internal sum
);

    // Internal registers hold the current input vector, weight vector, and threshold
    logic [PW-1:0]         x;          // input activation vector presented to neuron
    logic [PW-1:0]         w;          // weight vector read from BRAM (port B)
    logic [THRESH_W-1:0]   threshold;  // threshold value read from BRAM (port B)
    logic                  valid_in_r; // registered valid indicating input data is ready
    logic                  last_r;     // registered 'last' flag marking end of a read burst

    // Next-state signals for sequential update
    logic                  next_valid_in;
    logic                  next_last;

    // Counters tracking how many words were written into BRAMs (used to know read length)
    logic [5:0] write_count_w_r;
    logic [5:0] write_count_t_r;
    logic [5:0] next_write_count_w;
    logic [5:0] next_write_count_t;

    // Read addresses for BRAM port B (used during reading phase)
    logic [5:0] addr_weight_read_r;     // current read address for weights
    logic [5:0] addr_threshold_read_r;  // current read address for thresholds
    logic [5:0] next_addr_weight_read;
    logic [5:0] next_addr_threshold_read;

    // Flags to enable reading from BRAM (controls BRAM port B enb signals)
    logic reading_weights_r;      // high while reading weight BRAM
    logic reading_thresholds_r;   // high while reading threshold BRAM
    logic next_reading_weights;
    logic next_reading_thresholds;

    // Small state machine to coordinate write and read phases
    typedef enum logic [1:0] {
        IDLE,
        WRITING,
        READING
    } state_t;

    state_t state_r, next_state;

    // Instantiate the neuron processing block. It consumes x, w, threshold and
    // produces valid_out, y and popcount_out. Comments clarify interface mapping.
    neuron #(
        .PW(PW),
        .THRESH_W(THRESH_W)
    ) neuron_inst (
        .x(x),                 // input activations (from BRAM read path)
        .w(w),                 // weights (from BRAM read path)
        .threshold(threshold), // threshold for activation decision
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in_r), // indicates x/w/threshold are valid this cycle
        .last(last_r),         // indicates last element in a sequence
        .valid_out(valid_out),
        .y(y),
        .popcount_out(popcount_out)
    );

    // BRAM Instantiations:
    // - Port A (clka) used for writes via cfg_w_enw/cfg_w_dataw/cfg_w_addrw
    // - Port B (clkb) used for reads while reading_*_r is asserted; doutb drives w/16-bit data
    weight_bram weight_bram_inst (
        .clka(clk),
        .ena(cfg_w_enw),                  // enable for write port A
        .wea(cfg_w_enw),                  // write enable tied to ena
        .addra(cfg_w_addrw[5:0]),         // write address (lower bits used)
        .dina(cfg_w_dataw[15:0]),         // data in for write port
        .clkb(clk),
        .enb(reading_weights_r),          // enable for read port B while in READING
        .web(1'b0),                       // read-only on port B
        .addrb(addr_weight_read_r),       // read address for weights
        .doutb(w)                         // read data -> w
    );

    // Threshold BRAM: similar usage as weight BRAM
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


    // Sequential register updates: on reset clear counters/flags and start in WRITING
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            write_count_w_r       <= '0;      // clear number of written weight words
            write_count_t_r       <= '0;      // clear number of written threshold words
            addr_weight_read_r    <= '0;      // reset read addresses
            addr_threshold_read_r <= '0;
            reading_weights_r     <= 1'b0;    // not reading after reset
            reading_thresholds_r  <= 1'b0;
            valid_in_r            <= 1'b0;    // no valid data yet
            last_r                <= 1'b0;    // not last element
            state_r               <= WRITING; // enter WRITING so configuration writes possible
        end
        else begin
            // update registers from combinational next-state values
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

    // Combinational next-state logic: implements a simple three-state controller
    always_comb begin
        // defaults
        next_state = state_r;
        next_write_count_w = write_count_w_r;
        next_write_count_t = write_count_t_r;
        next_addr_weight_read = addr_weight_read_r;
        next_addr_threshold_read = addr_threshold_read_r;
        next_reading_weights = reading_weights_r;
        next_reading_thresholds = reading_thresholds_r;
        next_valid_in = 1'b0; // default: no new valid input
        next_last = 1'b0;     // default: not last

        case(state_r)
            IDLE: begin
                // If any config write enable asserted, go to WRITING state
                if(cfg_w_enw || cfg_w_ent) next_state = WRITING;
            end
            WRITING: begin
                // while cfg write enables asserted, increment respective write counters
                if(cfg_w_enw) next_write_count_w = write_count_w_r + 1;
                if(cfg_w_ent) next_write_count_t = write_count_t_r + 1;
                // when writes stop but we have written data, move to READING to load BRAM into neuron
                if (!cfg_w_enw && !cfg_w_ent && (next_write_count_w != 0 || next_write_count_t != 0))
                    next_state = READING;
            end
            READING: begin
                // start reading sequence: enable BRAM read ports and set addresses to zero
                if (!reading_weights_r && !reading_thresholds_r) begin
                    next_reading_weights     = 1'b1;
                    next_reading_thresholds  = 1'b1;
                    next_addr_weight_read    = 6'd0;
                    next_addr_threshold_read = 6'd0;
                    next_valid_in = 1'b0; // data will be valid next cycle after BRAM outputs stabilize
                    next_last = 1'b0;
                end
                else begin
                    // while reading, assert valid_in when weights are being read (drives neuron valid_in)
                    next_valid_in = reading_weights_r;

                    // detect when we've reached the last element based on the write_count_w_r
                    if(write_count_w_r != 0 && addr_weight_read_r == (write_count_w_r - 1)) begin
                        next_last = 1'b1; // mark last element of the burst
                    end 
                    else begin
                        next_last = 1'b0;
                    end

                    if(next_last) begin
                        // finished reading: deassert reading flags and return to IDLE
                        next_reading_weights = 1'b0;
                        next_reading_thresholds = 1'b0;
                        next_state = IDLE;
                    end
                    else begin
                        // continue reading: increment read addresses for next beat
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