module forw_reg_1(
    input logic clk,reset,stall,br_taken,
    input logic [31:0] pc,inst,
    output logic [31:0] forw_reg_1_pc,forw_reg_1_inst
    );

always_ff @( posedge clk or posedge reset ) begin 
    if (reset | stall | br_taken ) begin
        forw_reg_1_pc<=32'b0;
        forw_reg_1_inst<=32'h00000000;
    end
    else begin
        forw_reg_1_pc<=pc;
        forw_reg_1_inst<=inst;
    end
end 
    
endmodule