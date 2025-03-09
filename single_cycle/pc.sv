module pc (
    input logic clock,reset,
    input logic [31:0] pc,
    output logic [31:0] pc_next
    
);
always_ff @( posedge clock ) begin
    
    if (reset) begin
        pc_next<=32'b0;
        
    end
    else begin
        pc_next<=pc;

    end  
end
endmodule