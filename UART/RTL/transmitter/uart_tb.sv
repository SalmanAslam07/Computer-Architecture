`timescale 1ns/1ps

module testbench_uart_top_tx;

    // Testbench signals
    logic clk, reset;
    logic valid_in, parity_sel, stop_sel;
    logic [7:0] data_in;
    logic [14:0] baud_divisor;
    logic tx_out;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns clock period

    // DUT instantiation
    uart_top_tx DUT (
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .parity_sel(parity_sel),
        .stop_sel(stop_sel),
        .data_in(data_in),
        .baud_divisor(baud_divisor),
        .tx_out(tx_out)
    );

    // Testbench procedure
    initial begin
        // Initialize inputs
        reset = 1;
        valid_in = 0;
        parity_sel = 0;
        stop_sel = 0;
        data_in = 8'b0;
        baud_divisor = 12'd10; // Example baud divisor

        // Apply reset
        #20 reset = 0;

        // Test case 1: Transmit data with even parity and one stop bit
        parity_sel = 0; // Even parity
        stop_sel = 0;   // One stop bit
        data_in = 8'hA5; // Example data
        valid_in = 1;
        #10 valid_in = 0;

        // Wait for transmission to complete
        #1200;

        // Test case 2: Transmit data with odd parity and two stop bits
        parity_sel = 1; // Odd parity
        stop_sel = 1;   // Two stop bits
        data_in = 8'h3C; // Example data
        valid_in = 1;
        #10 valid_in = 0;

        // Wait for transmission to complete
        #1200;

        // Test case 3: Transmit another data byte
        parity_sel = 0; // Even parity
        stop_sel = 1;   // Two stop bits
        data_in = 8'hFF; // Example data
        valid_in = 1;
        #10 valid_in = 0;

        // Wait for transmission to complete
        #1200;

        // End simulation
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | Reset: %b | Valid: %b | Data: %h | Parity: %b | Stop: %b | TX Out: %b",
                 $time, reset, valid_in, data_in, parity_sel, stop_sel, tx_out);
    end

endmodule