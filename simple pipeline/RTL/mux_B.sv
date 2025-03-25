module mux_B(
    input logic [31:0] immediate_out,
    input logic [31:0]rdata2,
    input logic sel_B,
    output logic[31:0] B
);
always_comb begin
    if (sel_B) begin
        B=immediate_out;
    end
    else begin
        B=rdata2;
    end   
end   
endmodule
