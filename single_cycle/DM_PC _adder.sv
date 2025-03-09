module dm_pc_mux (
    input logic [31:0]pc_next,
    output logic [31:0] jump_dm_input

);
always_comb begin
    jump_dm_input=pc_next+4;
end
    
endmodule