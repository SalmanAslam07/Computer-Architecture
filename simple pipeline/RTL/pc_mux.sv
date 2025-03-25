module pc_mux(
    input logic [31:0] pc,
    input logic [31:0] alu_out,
    output logic [31:0] pc_out,
    input logic br_taken
);

always_comb begin
    if (br_taken) begin
        pc_out=alu_out;
    end
    else begin
        pc_out=pc+4;
    end
end
    
endmodule
