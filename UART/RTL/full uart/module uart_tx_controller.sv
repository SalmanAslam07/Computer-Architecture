module uart_tx_controller(
    input logic clk, reset,
    input logic baud_comp, shift_done, valid_in,
    output logic stop_bit_cnt_en, tx_shift_en, tx_sel, load
);

    // State encoding
    typedef enum logic [1:0] {IDLE, LOAD_DATA, TRANSMIT_DATA} state_t;
    state_t current_state, next_state;

    // State transition logic (sequential)
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic and output logic (combinational)
    always_comb begin
        // Default values for outputs
        stop_bit_cnt_en = 1'b0;
        tx_shift_en = 1'b0;
        tx_sel = 1'b0;
        load = 1'b0;

        case (current_state)
            IDLE: begin
                if (valid_in)
                    next_state = LOAD_DATA;
                else
                    next_state = IDLE;
            end

            LOAD_DATA: begin
                load = 1'b1; // Load data into the shift register
                next_state = TRANSMIT_DATA;
            end

            TRANSMIT_DATA: begin
                tx_sel = 1'b1; // Enable serialized data output
                if (baud_comp) begin
                    tx_shift_en = 1'b1; // Enable shift register on baud completion
                    stop_bit_cnt_en = 1'b1; // Enable stop bit counter
                end
                if (shift_done)
                    next_state = IDLE; // Return to IDLE after transmission
                else
                    next_state = TRANSMIT_DATA;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule