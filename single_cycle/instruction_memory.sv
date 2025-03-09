module instruction_memory (
    input logic [31:0] write_address_G,
    output logic [31:0] machine_code
);
logic [31:0]instruction_memory_reg  [31:0];
always_comb begin
    machine_code=instruction_memory_reg[write_address_G>>2];
end
initial begin
     
       
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            instruction_memory_reg[i] = 32'h00000000;
        end
instruction_memory_reg[1]=32'h123450b7;// LUI x1, 0x12345       U-type
instruction_memory_reg[2]=32'h12345117; // AUIPC x2, 0x12345
instruction_memory_reg[3]=32'h00a00113;// ADDI x2, x0, 10      I-type
instruction_memory_reg[4]=32'h01400093;// ADDI x1, x0, 20
//instruction_memory_reg[5]=32'h0080006f;// JAL x1, 8
//instruction_memory_reg[6]=32'h01e00113;// ADDI x2, x0, 30
//instruction_memory_reg[7]=32'h001101b3;// ADD x3, x2, x1
//instruction_memory_reg[8]=32'h003022a3;// SW x3, 3(x0)
//instruction_memory_reg[9]=32'h00502303;// LW x6, 5(x0)
//instruction_memory_reg[10]=32'h00008067;// JALR x0, x1, 0
//instruction_memory_reg[11]=32'h00000013;// NOP
//instruction_memory_reg[12]=32'h0;
//instruction_memory_reg[13]=32'h0;
//instruction_memory_reg[14]=32'h0;
//instruction_memory_reg[15]=32'h0;
 
end
endmodule

