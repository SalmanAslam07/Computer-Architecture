module ALU(
    input logic [31:0] A, B ,
    input logic [3:0] alu_op,
    output logic [31:0] alu_out
);
always_comb begin
    case (alu_op)
    4'b0000 : alu_out = A+B;                                    // ADD-addition
    4'b0001 : alu_out = A-B;                                    // SUB-subtraction
    4'b0010 : alu_out = A << B;                        // SLL-Shift Left Logic
    4'b0100 : alu_out = ($signed(A) < $signed(B)) ? 1 : 0;  // SLT-Set Less Than (signed)
    4'b0110 : alu_out = (A < B) ? 1 : 0;                    // SLTU
    4'b1000 : alu_out = A ^ B;                              // XOR
    4'b1010 : alu_out = A >> B;                        // SRL-Shift Right Logical
    4'b1011 : alu_out = $signed(A) >>> B;              // SRA-Shift Right Arithmetic
    4'b1100 : alu_out = A | B;                              // OR
    4'b1110 : alu_out = A & B;                              // AND
    default: alu_out = 32'b0;
            
    endcase
end
endmodule
