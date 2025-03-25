module data_mem_mux (
    input logic [31:0] data_memory_output,
    input logic [1:0]sel_dm,
    input logic [31:0] alu_out,
    input logic [31:0] pc,
    output logic [31:0]write_back_data
);
always_comb begin
    case (sel_dm)
        2'b00:write_back_data=alu_out; 
        2'b01:write_back_data=data_memory_output;
        2'b10:write_back_data=pc+4;
        default: write_back_data=alu_out;
    endcase
end

endmodule
    
