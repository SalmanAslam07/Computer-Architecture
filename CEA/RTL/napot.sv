module napot (
    input logic [31:0] addr,addr_n,
    input logic [2:0]size,
    output logic napot_out
);
logic [4:0]position;
logic [31:0]noes,base,offset;

assign ones=~(32'b1 << positon+1);
assign base=(addr_n & (ones));
assign offset=(32'h8<<position);
assign napot_out=(((base) + offset-1) >= (addr+size-1)) && (addr >= (base));



always_comb begin :priority circuit
    casez (addr_n)  // casez allows ? for don't-care bits
        32'b???????????????????????????????1: position = 5'd0;
        32'b??????????????????????????????10: position = 5'd1;
        32'b?????????????????????????????100: position = 5'd2;
        32'b????????????????????????????1000: position = 5'd3;
        32'b???????????????????????????10000: position = 5'd4;
        32'b??????????????????????????100000: position = 5'd5;
        32'b?????????????????????????1000000: position = 5'd6;
        32'b????????????????????????10000000: position = 5'd7;
        32'b???????????????????????100000000: position = 5'd8;
        32'b??????????????????????1000000000: position = 5'd9;
        32'b?????????????????????10000000000: position = 5'd10;
        32'b????????????????????100000000000: position = 5'd11;
        32'b???????????????????1000000000000: position = 5'd12;
        32'b??????????????????10000000000000: position = 5'd13;
        32'b?????????????????100000000000000: position = 5'd14;
        32'b????????????????1000000000000000: position = 5'd15;
        32'b???????????????10000000000000000: position = 5'd16;
        32'b??????????????100000000000000000: position = 5'd17;
        32'b?????????????1000000000000000000: position = 5'd18;
        32'b????????????10000000000000000000: position = 5'd19;
        32'b???????????100000000000000000000: position = 5'd20;
        32'b??????????1000000000000000000000: position = 5'd21;
        32'b?????????10000000000000000000000: position = 5'd22;
        32'b????????100000000000000000000000: position = 5'd23;
        32'b???????1000000000000000000000000: position = 5'd24;
        32'b??????10000000000000000000000000: position = 5'd25;
        32'b?????100000000000000000000000000: position = 5'd26;
        32'b????1000000000000000000000000000: position = 5'd27;
        32'b???10000000000000000000000000000: position = 5'd28;
        32'b??100000000000000000000000000000: position = 5'd29;
        32'b?1000000000000000000000000000000: position = 5'd30;
        32'b10000000000000000000000000000000: position = 5'd31;
        default: position = 5'd0;  // When no bits are set
    endcase
end
    
endmodule