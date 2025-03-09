module rs1_pc_mux (
    input logic [31:0]pc_next,
    input logic [31:0]read_data_1,
    input logic       sel_a,
    output logic [31:0]     a
);
always_comb begin
    if (sel_a) begin
        a=read_data_1;
    end
    else begin
        a=pc_next;
    end
end
    
endmodule