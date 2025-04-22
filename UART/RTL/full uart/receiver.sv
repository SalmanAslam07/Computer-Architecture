module uart_top_rx(
    input logic clk, reset,
    input logic rx, parity_sel, stop_sel, rx_en,
    input logic [11:0] baud_divisor,
    output logic [7:0] data_out,
    output logic valid_out, parity_ok
);

    // Baud Counter Logic
    logic [11:0] bc_in, bc_out;
    logic baud_comp;
    always_ff @(posedge clk or posedge reset) begin
        if (reset || baud_comp)
            bc_out <= 12'b0;
        else
            bc_out <= bc_in;
    end
    always_comb begin
        bc_in = bc_out + 1;
        baud_comp = (bc_out == (baud_divisor - 1));
    end

    // Stop Bit Counter Logic
    logic [3:0] cc_in, cc_out;
    logic cnt_en_i, shift_done;
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            cc_out <= 4'b0;
        else if (cnt_en_i)
            cc_out <= cc_in;
    end
    always_comb begin
        cc_in = cc_out + 1;
        shift_done = (cc_out == (stop_sel ? 4'd12 : 4'd11)); // 1 or 2 stop bits
    end

    // UART RX Controller Logic
    typedef enum {IDLE, READY, SHIFT, OUT} state_t;
    state_t state, next_state;
    logic rx_sel, rx_shift_en, cnt_en, valid_in;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
    case (state)
        IDLE: begin
            cnt_en = 1'b0;
            rx_shift_en = 1'b0;
            rx_sel = 1'b0;
            valid_out = 1'b0; // Ensure valid_out is deasserted
            parity_ok = 1'b0; // Reset parity_ok
            data_out = 8'b0;  // Reset data_out
            next_state = rx_en ? READY : IDLE;
        end
        READY: begin
            cnt_en = 1'b0;
            rx_shift_en = 1'b0;
            rx_sel = 1'b1;
            valid_out = 1'b0; // Ensure valid_out is deasserted
            parity_ok = 1'b0; // Reset parity_ok
            data_out = 8'b0;  // Reset data_out
            next_state = valid_in ? SHIFT : READY;
        end
        SHIFT: begin
            if (shift_done)
                next_state = OUT;
            else
                next_state = SHIFT;
            rx_sel = 1'b1;
            rx_shift_en = baud_comp;
            cnt_en = baud_comp;
            valid_out = 1'b0; // Ensure valid_out is deasserted
            parity_ok = 1'b0; // Reset parity_ok
            data_out = 8'b0;  // Reset data_out
        end
        OUT: begin
            cnt_en = 1'b0;
            rx_shift_en = 1'b0;
            rx_sel = 1'b1;
            valid_out = 1'b1; // Assert valid_out in the OUT state
            parity_ok = parity_cal; // Update parity_ok based on parity calculation
            data_out = sr_val[7:0]; // Update data_out with the received data
            next_state = READY; // Transition back to READY
        end
    endcase
end

    // UART RX Datapath Logic
    logic [11:0] sr_val;
    logic parity_cal, stop_ok;

    // Metastability protection for RX input
    logic line1, line2;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            line1 <= 1'b1;
            line2 <= 1'b1;
        end else begin
            line1 <= rx;
            line2 <= line1;
        end
    end
    assign valid_in = (line2 & ~line1); // Falling edge detection

    // Shift Register (LSB-first)
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            sr_val <= 12'b0;
        else if (rx_shift_en)
            sr_val <= {sr_val[10:0], rx}; // Shift left
    end

    // Parity Calculation
    always_comb begin
        parity_cal = parity_sel ? ^sr_val[8:1] : ~^sr_val[8:1];
        data_out = sr_val[7:0]; // Correct data bits
        parity_ok = (parity_cal == sr_val[8]);
    end

    // Stop Bit Validation
    assign stop_ok = stop_sel ? (sr_val[9] & sr_val[10]) : sr_val[9];

    // Final Output Validation
    assign valid_out = (state == OUT) && parity_ok && stop_ok;
    assign cnt_en_i = cnt_en;
    always_comb begin
        if (valid_out) begin
            data_out = sr_val[7:0];
            valid_out = 1'b1;
            parity_ok = parity_cal;
        end else begin
            data_out = 8'b0;
            valid_out = 1'b0;
            parity_ok = 1'b0;
        end
    end

endmodule