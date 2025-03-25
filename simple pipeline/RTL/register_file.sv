module register_file(
    input logic clk,reset,reg_wr,
    input logic [4:0] raddr1,raddr2,waddr, 
    input logic [31:0] wdata,
    
    output logic [31:0] rdata1,rdata2 
);
logic [31:0] Memory[31:0];

always @* begin 
    rdata1 = Memory[raddr1];
    rdata2 = Memory[raddr2];
end
always_ff @ (posedge clk or posedge reset) begin
    if (reset) begin
        for (int i =0; i<32 ; i++)begin
            Memory[i] <= 32'h00000000;
        end
    end
    else if (reg_wr && (waddr != 5'b00000)) begin
        Memory[waddr] <= wdata ;
    end
end

endmodule