`timescale 1ns/1ps

module uart_full_tb;

    // Testbench Signals
    logic clk, reset;
    logic tx_valid_in, rx_en, parity_sel, stop_sel;
    logic [7:0] data_in, rx_data_out;
    logic [11:0] baud_divisor;
    logic tx_out, rx_valid_out, rx_parity_ok;

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns clock period

    // DUT Instantiation
    uart_full DUT (
        .clk(clk),
        .reset(reset),
        .tx_valid_in(tx_valid_in),
        .rx_en(rx_en),
        .parity_sel(parity_sel),
        .stop_sel(stop_sel),
        .data_in(data_in),
        .baud_divisor(baud_divisor),
        .rx_data_out(rx_data_out),
        .tx_out(tx_out),
        .rx_valid_out(rx_valid_out),
        .rx_parity_ok(rx_parity_ok)
    );

    // Testbench Logic
    initial begin
        // Initialize signals
        reset = 1;
        tx_valid_in = 0;
        rx_en = 0;
        parity_sel = 0; // Even parity
        stop_sel = 0;   // 1 stop bit
        data_in = 8'b0;
        baud_divisor = 12'd10; // Simulated baud rate divisor

        // Apply reset
        #20;
        reset = 0;

        // Enable receiver
        rx_en = 1;

        // Test Case 1: Transmit and receive data with even parity and 1 stop bit
        #20;
        data_in = 8'hA5; // Data: 0xA5
        tx_valid_in = 1;
        #10;
        tx_valid_in = 0;
        #200;

        // Test Case 2: Transmit and receive data with odd parity and 1 stop bit
        parity_sel = 1; // Odd parity
        data_in = 8'h3C; // Data: 0x3C
        tx_valid_in = 1;
        #10;
        tx_valid_in = 0;
        #200;

        // Test Case 3: Transmit and receive data with even parity and 2 stop bits
        parity_sel = 0; // Even parity
        stop_sel = 1;   // 2 stop bits
        data_in = 8'hFF; // Data: 0xFF
        tx_valid_in = 1;
        #10;
        tx_valid_in = 0;
        #300;

        // End simulation
        $stop;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time: %0t | TX Data: %h | RX Data: %h | RX Valid: %b | RX Parity OK: %b",
                 $time, data_in, rx_data_out, rx_valid_out, rx_parity_ok);
    end

endmodule