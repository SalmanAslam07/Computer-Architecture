module forw_reg_2(
    input logic clk,reset,stall,rd_en,wr_en,reg_wr,
    input logic [1:0] sel_dm,
    input logic [31:0] alu_out,rdata2,forw_reg_1_pc,forw_reg_1_inst,
    output logic forw_reg_2_rd_en,forw_reg_2_wr_en,forw_reg_2_reg_wr,
    output logic [1:0] forw_reg_2_sel_dm,
    output logic [31:0] forw_reg_2_alu_out,forw_reg_2_rdata2,forw_reg_2_pc,forw_reg_2_inst
    
    
);

always_ff @( posedge clk ) begin 
    
    if (reset | stall ) begin
        forw_reg_2_rd_en<=1'b0;
        forw_reg_2_wr_en<=1'b0;
        forw_reg_2_reg_wr<=1'b0;
        forw_reg_2_sel_dm<=2'b00;
        forw_reg_2_alu_out<=32'b0;
        forw_reg_2_rdata2<=32'b0;
        forw_reg_2_pc<=32'b0;
        forw_reg_2_inst<=32'b0;
        
        
    end
    else begin
        forw_reg_2_rd_en<=rd_en;
        forw_reg_2_wr_en<=wr_en;
        forw_reg_2_reg_wr<=reg_wr;
        forw_reg_2_sel_dm<=sel_dm;
        forw_reg_2_alu_out<=alu_out;
        forw_reg_2_rdata2<=rdata2;
        forw_reg_2_pc<=forw_reg_1_pc;
        forw_reg_2_inst<=forw_reg_1_inst;
    end
end
endmodule