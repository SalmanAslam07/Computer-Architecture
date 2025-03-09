module pc_with_four(
    input [31:0] pc_next,
    output logic[31:0] pc_with_four_out
);
always_comb begin
    pc_with_four_out=pc_next+32'h4;
end
endmodule