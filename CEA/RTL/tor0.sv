module tor0 (
    input logic [31:0] addr,addr_n_1,adrr_n
    input logic [2:0]size,
    output logic tor0_out
    );
    assign tor0_out=(addr>=addr_n_1) && ((addr+size-1)< (addr_n));
endmodule