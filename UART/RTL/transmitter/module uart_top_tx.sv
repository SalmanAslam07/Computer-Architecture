module uart_top_tx(
    input logic clk, reset,
    input logic valid_in, parity_sel, stop_sel,
    input logic [7:0] data_in,
    input logic [14:0] baud_divisor,
    output logic tx_out
);

    // Internal signals
    logic baud_en; 
    logic [11:0] baud_counter;
    logic stop_bit, tx_shift_en, tx_sel, load; 
    logic [3:0] stop_bit_counter, stop_bit_value;
    logic transmit_done; 

    // Baud counter logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            baud_counter <= 12'b0;
            baud_en <= 1'b0; 
        end else begin
            if (baud_counter == (baud_divisor - 1)) begin
                baud_counter <= 12'b0;
                baud_en <= 1'b1; 
            end else begin
                baud_counter <= baud_counter + 1;
                baud_en <= 1'b0; 
            end
        end
    end

    // Stop bit counter logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            stop_bit_counter <= 4'b0;
        else if (stop_bit) 
            stop_bit_counter <= stop_bit_counter + 1;
        else if (transmit_done) 
            stop_bit_counter <= 4'b0; // Reset counter after transmission
    end

    // Stop bit selection logic
    always_comb begin
        if (stop_sel)
            stop_bit_value = 4'd12; // Two stop bits
        else
            stop_bit_value = 4'd11; // One stop bit
        transmit_done = (stop_bit_counter == stop_bit_value); 
    end

    // Controller
    uart_tx_controller CONTROLLER(
        .clk(clk),
        .reset(reset),
        .baud_en(baud_en), 
        .transmit_done(transmit_done), 
        .valid_in(valid_in),
        .stop_bit(stop_bit), 
        .tx_shift_en(tx_shift_en),
        .tx_sel(tx_sel),
        .load(load)
    );

    // Datapath
    uart_tx_datapath DATAPATH(
        .clk(clk),
        .reset(reset),
        .load(load),
        .tx_sr_en(tx_shift_en),
        .parity_sel(parity_sel),
        .tx_sel(tx_sel),
        .data_in(data_in),
        .tx_out(tx_out)
    );

endmodule