module uart_tx_datapath(
    input logic clk, reset,
    input logic load, tx_sr_en, parity_sel, tx_sel,
    input logic [7:0] data_in,
    output logic tx_out
);

    // Internal signals
    logic parity_bit;
    logic [11:0] shift_register;

    // Parity generation logic (even or odd parity based on parity_sel) --> XOR of data bits
    always_comb begin
        if (parity_sel)
            parity_bit = ~(^data_in); // Odd parity
        else
            parity_bit = (^data_in);  // Even parity
    end

    // Shift register logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_register <= 12'b0;
        end else if (load) begin
            // Load start bit, data, parity, and stop bits into the shift register
            shift_register <= {1'b1, 1'b1, parity_bit, data_in[7:0], 1'b0}; // Stop bits, parity, data, start bit
        end else if (tx_sr_en) begin
            // Shift the register to the right
            shift_register <= {1'b0, shift_register[11:1]};
        end
    end

    // Output the least significant bit of the shift register
    always_comb begin
        if (tx_sel)
            tx_out = shift_register[0]; // Serialized data
        else
            tx_out = 1'b1; // Idle state
    end

endmodule