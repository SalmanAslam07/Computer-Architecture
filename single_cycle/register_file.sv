module register_file (
    input logic clock,
    input logic reset,
    input logic [4:0] read_address_1,
    input logic [4:0] read_address_2,
    input logic [4:0]write_address,
    input logic[31:0] write_back_data=32'd0,
    input logic write_register_enable,
    output logic [31:0] read_data_1,
    output logic [31:0]read_data_2
);
    
logic [31:0] instruction_memory_reg [31:0];

always_comb
begin
    read_data_1 = instruction_memory_reg[read_address_1];
    read_data_2 = instruction_memory_reg[read_address_2];
end

integer i;
always_ff @( posedge clock ) begin 
    if (reset) begin
        for ( i=0 ;i<32 ;i++ ) begin
            instruction_memory_reg[i]<=32'h00000000;
        end
        //instruction_memory_reg[0] <=3'd4;
        //instruction_memory_reg[1]<=3'd6;
        end
    else if (write_register_enable && write_address!=5'b0) begin
        instruction_memory_reg[write_address]=write_back_data; 
    end
    end    
endmodule