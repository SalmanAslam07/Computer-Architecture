module instruction_memory(
    input logic [31:0] addr,
    output logic [31:0] inst 
);
logic [31:0] Memory [31:0] = '{default:0}; // mem. of 32 reg with 32 bit each

always_comb begin
    inst = Memory[addr >> 2];
end

initial begin
    for (int i = 0; i < 32; i = i + 1) begin
        Memory[i] = 32'h00000000;
    end

    Memory[0] = 32'h00500093; // addi x1, x0, 5 - Completes in Cycle 3
    Memory[1] = 32'h00A08113; // addi x2, x1, 10 - Completes in Cycle 4
    Memory[2] = 32'h002081B3; // add x3, x1, x2 - Completes in Cycle 5
    Memory[3] = 32'h00208263; // beq x1, x2, label - Completes in Cycle 5 (branch decision made)
    Memory[4] = 32'h01400213; // addi x4, x0, 20 - Completes in Cycle 7
    Memory[5] = 32'h01E00293; // addi x5, x0, 30 - Completes in Cycle 8
end

endmodule
