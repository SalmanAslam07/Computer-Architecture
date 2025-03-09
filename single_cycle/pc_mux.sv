module bc_pc_mux (
    input logic[31:0]   pc_with_four_out,
    input logic [31:0]  alu_out,
    output logic [31:0] bc_pc_out,
    input logic         branch_taken
);
always_comb begin
    if (branch_taken) begin
        bc_pc_out=alu_out;
    end
    else begin
        bc_pc_out=pc_with_four_out;
    end
end
    
endmodule