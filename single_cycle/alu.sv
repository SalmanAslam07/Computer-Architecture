module alu (
    input logic [31:0]a,b,
    input logic [3:0]alu_op,
     output logic [31:0] alu_out
);
always_comb begin 
     
    
    case (alu_op)
        4'd0 :alu_out =a+b; //ADD
        4'd1 :alu_out =a-b; //SUB
        4'd2 :alu_out =a<<b;
        4'd3 :alu_out =($signed (a))<($signed(b));
        4'd4 :alu_out = ($unsigned (a))<($unsigned(b));
        4'd5 :alu_out =a^b; 
        4'd6 :alu_out =a>>b[4:0];
        4'd7 :alu_out =a>>>b[4:0];
        4'd8 :alu_out =a|b;   //Bit wise OR
        4'd9:alu_out=a&b;     //Bit wise AND
        4'd10:alu_out= (a < b) ? 1:0 ;
        4'd11:alu_out= ($unsigned(a) < $unsigned(b)) ? 1:0 ;
        4'd12:alu_out=b;
        



        default: alu_out=a+b;
    endcase
    
end
    
endmodule