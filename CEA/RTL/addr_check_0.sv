module addr_check_0 (
    input logic [31:0]addr,addr_n_1,adrr_n
    input logic [4:0]size,
    input logic [1:0]a_n,
    output logic out;
);
logic na4_out,napot_out,tor0_out;
tor0 TOR0(.*);
nap NA4(.*);
napot NAPOT(.*);
always_comb begin
    case (a_n)
       1'h0:out =1'b0;
       1'h1:out =tor0_out;
       1'h2:out =na4_out;
       1'h3:out =napot_out;
        default: 1'b0;
    endcase
end

endmodule