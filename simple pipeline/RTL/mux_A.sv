module mux_A(
    input logic [31:0] pc,
    input logic [31:0] data1,
    input logic sel_A,
    output logic [31:0] A
);
always_comb begin
    case (sel_A)
        1'b1: A = data1;
        1'b0: A = pc;
        default: A = 32'h00000000;
    endcase
    
end

endmodule