module test_bench;
    logic clock;
    logic reset;

    // Instantiate the processor
    pipeline uut(
        .clk(clock),
        .reset(reset)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10ns clock period
    end

    // Test sequence
    initial begin
        reset = 1; // Assert reset
        #20;       // Hold reset for 20ns
        reset = 0; // Deassert reset
        // Add more test cases here
    end
    
endmodule
