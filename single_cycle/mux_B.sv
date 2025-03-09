module two_cross_one (
    input logic [31:0] mux_input,
    input logic [31:0]read_data_2,
    input logic selB,
    output logic[31:0] mux_output
);
always_comb begin
    if (selB) begin
        mux_output=mux_input;
    end
    else begin
        mux_output=read_data_2;
    end   
end   
endmodule