module tor (
    input logic [31:0] addr,addr_n_1,addr_n,
    input logic [2:0]size,
    output logic tor_out
    );
    assign tor_out=(addr>=addr_n_1) && ((addr+size-1)< (addr_n));;
endmodule