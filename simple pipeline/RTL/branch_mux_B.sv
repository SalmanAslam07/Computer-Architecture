module branch_mux_B(
    input logic [31:0] rdata2,
    input logic [31:0] write_back_data,
    input logic f_sel_B,
    output logic [31:0] data2
);

always_comb begin
    if (f_sel_B) begin
         data2 = rdata2;
    end
    else begin data2 = write_back_data;
    end
end

endmodule