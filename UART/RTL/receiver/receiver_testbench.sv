`timescale 1ns/1ns

module uart_top_rx_tb;

    // Testbench Signals
    logic clk, reset;
    logic rx, parity_sel, stop_sel, rx_en;
    logic [11:0] baud_divisor;
    logic [7:0] data_out;
    logic valid_out, parity_ok;

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns clock period

    // DUT Instantiation
    uart_top_rx DUT (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .parity_sel(parity_sel),
        .stop_sel(stop_sel),
        .rx_en(rx_en),
        .baud_divisor(baud_divisor),
        .data_out(data_out),
        .valid_out(valid_out),
        .parity_ok(parity_ok)
    );

    // Task to send a UART frame
    task send_uart_frame(
        input [7:0] data,
        input parity_sel,
        input stop_sel
    );
        integer i;
        logic parity_bit;

        // Calculate parity bit
        parity_bit = (parity_sel) ? ^data : ~(^data);

        // Send start bit (low)
        rx = 0;
        #(baud_divisor * 10);

        // Send data bits (LSB first)
        for (i = 0; i < 8; i = i + 1) begin
            rx = data[i];
            #(baud_divisor * 10);
        end

        // Send parity bit
        rx = parity_bit;
        #(baud_divisor * 10);

        // Send stop bit(s)
        rx = 1;
        #(baud_divisor * 10 * (stop_sel ? 2 : 1));
    endtask

    // Testbench Logic
    initial begin
        // Initialize signals
        reset = 1;
        rx = 1; // Idle state
        parity_sel = 0; // Even parity
        stop_sel = 0; // 1 stop bit
        rx_en = 0;
        baud_divisor = 12'd10; // Simulated baud rate divisor

        // Apply reset
        #20;
        reset = 0;

        // Enable receiver
        rx_en = 1;

        // Test Case 1: Send a valid frame with even parity
        #20;
        send_uart_frame(8'hA5, 0, 0); // Data: 0xA5, Even parity, 1 stop bit
        #200;

        // Test Case 2: Send a valid frame with odd parity
        send_uart_frame(8'h3C, 1, 0); // Data: 0x3C, Odd parity, 1 stop bit
        #200;

        // Test Case 3: Send a valid frame with 2 stop bits
        stop_sel = 1; // 2 stop bits
        send_uart_frame(8'hFF, 0, 1); // Data: 0xFF, Even parity, 2 stop bits
        #200;

        // Test Case 4: Send a frame with incorrect parity
        parity_sel = 1; // Odd parity
        send_uart_frame(8'h55, 0, 0); // Data: 0x55, Even parity, 1 stop bit
        #200;

        // End simulation
        $stop;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time: %0t | Data Out: %h | Valid Out: %b | Parity OK: %b", 
                 $time, data_out, valid_out, parity_ok);
    end

endmodule