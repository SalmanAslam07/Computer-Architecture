module immediate (
    input  logic [31:0] instructions,
    output logic [31:0] immediate_out
);
    logic [6:0] opcode;
    logic signed [31:0] immediate;

    always_comb begin
        opcode = instructions[6:0];
        immediate = 32'b0; // Initialize the immediate to zero
        
        case (opcode)
            7'b0000011, // I-type (load)
            7'b0010011, // I-type (ALU immediate)
            7'b1100111: // I-type (JALR)
                immediate = {{20{instructions[31]}}, instructions[31:20]}; // Sign-extend 12-bit immediate

            7'b0100011: // S-type (store)
                immediate = {{20{instructions[31]}}, instructions[31:25], instructions[11:7]}; // Sign-extend 12-bit immediate

            7'b1100011: // B-type (branch)
                immediate = {{19{instructions[31]}}, instructions[31], instructions[7], instructions[30:25], instructions[11:8], 1'b0}; // Sign-extend 13-bit immediate

            7'b0110111, // U-type (LUI)
            7'b0010111: // U-type (AUIPC)
                immediate = {instructions[31:12], 12'b0}; // Upper immediate

            7'b1101111: // J-type (JAL)
                immediate = {{11{instructions[31]}}, instructions[31], instructions[19:12], instructions[20], instructions[30:21], 1'b0}; // Sign-extend 21-bit immediate

            default: // Default case for unknown opcodes
                immediate = 32'b0;
        endcase
        
        immediate_out = immediate; // Assign the calculated immediate to the output
    end
endmodule
