module uart_full(
    input logic clk, reset,
    input logic tx_valid_in, rx_en, parity_sel, stop_sel,
    input logic [7:0] tx_data_in,
    input logic [11:0] baud_divisor,
    output logic [7:0] rx_data_out,
    output logic tx, rx_valid_out, rx_parity_ok
);

    // Internal signals
    logic tx_out; // Transmitter output connected to receiver input
    logic rx_in;  // Receiver input connected to transmitter output

    // UART Transmitter
    uart_top_tx UART_TX (
        .clk(clk),
        .reset(reset),
        .valid_in(tx_valid_in),
        .parity_sel(parity_sel),
        .stop_sel(stop_sel),
        .data(tx_data_in),
        .baud_divisor(baud_divisor),
        .tx(tx_out)
    );

    // UART Receiver
    uart_top_rx UART_RX (
        .clk(clk),
        .reset(reset),
        .rx(tx_out), // Connect transmitter output to receiver input
        .parity_sel(parity_sel),
        .stop_sel(stop_sel),
        .rx_en(rx_en),
        .baud_divisor(baud_divisor),
        .data_out(rx_data_out),
        .valid_out(rx_valid_out),
        .parity_ok(rx_parity_ok)
    );

    // Assign transmitter output to receiver input
    assign rx_in = tx_out;

endmodule