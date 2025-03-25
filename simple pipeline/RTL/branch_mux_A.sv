module branch_mux_A(
    input logic [31:0] write_back_data,
    input logic [31:0] rdata1,
    input logic f_sel_A,
    output logic [31:0] data1
);
always_comb begin
    case (f_sel_A)
        1'b1: data1 = rdata1;
        1'b0: data1 = write_back_data;
    endcase
    
end

endmodule