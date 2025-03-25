module data_memory (
    input logic [31:0] data_memory_input,
    input logic [31:0] write_data, 
    input logic clk,
    input logic reset,
    input logic wr_en,
    input logic rd_en,
    output logic [31:0] data_memory_output
);
integer i;
logic [31:0] data_memory_reg [31:0];

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < 32; i++) begin
            data_memory_reg[i] <= 32'h00000000;
        end
    end
    else if (wr_en && data_memory_input != 32'h0) begin
        data_memory_reg[data_memory_input] <= write_data; 
    end
end   

always_comb begin
    if (rd_en) begin
        data_memory_output = data_memory_reg[data_memory_input];
    end
    else begin
        data_memory_output = 32'h00000000;
    end
end
    
endmodule