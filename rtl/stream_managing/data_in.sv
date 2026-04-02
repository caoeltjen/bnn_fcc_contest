module data_in #(
    parameter int INPUT_BUS_WIDTH = 64
)(
    input logic clk,
    input logic rst,
    input  logic                         data_in_valid,
    output logic                         data_in_ready,
    input  logic [  INPUT_BUS_WIDTH-1:0] data_in_data,
    input  logic [INPUT_BUS_WIDTH/8-1:0] data_in_keep,
    input  logic                         data_in_last,

    // input the config header
    input  logic [31:0] reserved,
    input logic [31:0] total_bytes,
    input logic [15:0] bytes_per_neuron,
    input logic [15:0] num_neurons,
    input logic [15:0] layer_inputs,
    input logic [7:0]  layer_id,
    input logic [7:0]  msg_type,

    // output the data
    output logic [(INPUT_BUS_WIDTH/8)-1:0] img_data_out[INPUT_BUS_WIDTH/8]
);

    
    // states to track status of data_in stream receiver
    typedef enum {
        IDLE,
        RECEIVING
    } state_t;
    state_t curr_state, next_state;

    // struct to store image data as its being received
    typedef struct packed {
        logic [INPUT_BUS_WIDTH-1:0] data;
        logic [(INPUT_BUS_WIDTH/8)-1:0] keep;
    } data_in_t;

    typedef struct packed {
        logic [(INPUT_BUS_WIDTH/8)-1:0] data; 
    } img_data_t;
    // size is runtime dependent, so we need to find a compile time constant.
    // we know that the config gives us a size, but that is going to be massive for big trees
    // we can define a streaming setup where we pipeline the data to the neurons as we're receiving it,
    // as this will save storage and allow us to have a compile time constant size
    // here, we're going to define  
    data_in_t img_data;
    img_data_t img_data_out_arr[(INPUT_BUS_WIDTH/8)]; 



    always_ff @(posedge clk) begin : state_mover
        if (rst) begin
            curr_state <= IDLE;
        end else begin
            curr_state <= next_state;
        end
    end


    always_comb begin : reading_data
        case (curr_state)
            IDLE: begin
                data_in_ready = 1'b1;
                if (data_in_valid) begin
                    next_state = RECEIVING;
                end else begin 
                    next_state = IDLE;
                end
            end

            RECEIVING: begin
                data_in_ready = '0;
                if (data_in_valid && data_in_last) begin
                    next_state = IDLE;
                    img_data = '{data_in_data, data_in_keep};
                    img_data_out_arr[0] = (img_data.keep[0]) ? img_data.data[7:0] : '0;
                    img_data_out_arr[1] = (img_data.keep[1]) ? img_data.data[15:8] : '0;
                    img_data_out_arr[2] = (img_data.keep[2]) ? img_data.data[23:16] : '0;
                    img_data_out_arr[3] = (img_data.keep[3]) ? img_data.data[31:24] : '0;
                    img_data_out_arr[4] = (img_data.keep[4]) ? img_data.data[39:32] : '0;
                    img_data_out_arr[5] = (img_data.keep[5]) ? img_data.data[47:40] : '0;
                    img_data_out_arr[6] = (img_data.keep[6]) ? img_data.data[55:48] : '0;
                    img_data_out_arr[7] = (img_data.keep[7]) ? img_data.data[63:56] : '0;
                end else if (data_in_valid && !data_in_last) begin
                    next_state = RECEIVING;
                    img_data = '{data_in_data, data_in_keep};
                    img_data_out_arr[0] = (img_data.keep[0]) ? img_data.data[7:0] : '0;
                    img_data_out_arr[1] = (img_data.keep[1]) ? img_data.data[15:8] : '0;
                    img_data_out_arr[2] = (img_data.keep[2]) ? img_data.data[23:16] : '0;
                    img_data_out_arr[3] = (img_data.keep[3]) ? img_data.data[31:24] : '0;
                    img_data_out_arr[4] = (img_data.keep[4]) ? img_data.data[39:32] : '0;
                    img_data_out_arr[5] = (img_data.keep[5]) ? img_data.data[47:40] : '0;
                    img_data_out_arr[6] = (img_data.keep[6]) ? img_data.data[55:48] : '0;
                    img_data_out_arr[7] = (img_data.keep[7]) ? img_data.data[63:56] : '0;
                end else begin
                    next_state = RECEIVING;
                    img_data = '0;
                    img_data_out_arr = '{default: '0}; 
                end
                // defined in all instances
                img_data_out = img_data_out_arr;
            end
        endcase
    end


    always_comb begin : processing_data
        
    end

endmodule