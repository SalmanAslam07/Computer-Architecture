module controller (
    input logic [31:0] instructions,
    output logic write_register_enable,
    output logic sel_B, 
    output logic [3:0] alu_op,
    output logic [2:0] branch_type,
    output logic read_enable,
    output logic write_enable, // Added to handle store operations
    output logic [1:0]sel_dm,        //DM Mux CONTROLLER
    output logic sel_a
    
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    always_comb begin
        opcode = instructions[6:0];
        funct3 = instructions[14:12];
        funct7 = instructions[31:25];
        alu_op = 4'h0;
        write_register_enable = 1'b0;
        sel_B = 1'b0;        //  Initialize to 0 mux 2*1 select pin 
        read_enable = 1'b0;  //  Initialize to 0 to write data in register file
        write_enable = 1'b0; //  Initialize to 0 handle store opreation
        sel_dm=2'b00;         //  Initilaize to 0 only 1 in load type
        sel_a=1'b1;          //  Initilaize to 1 selecting b/w pc_next and alu_out
        branch_type=3'd2;

        case (opcode)
            // r-type instructions
            7'b0110011: begin
                write_register_enable = 1'b1;
                sel_B = 1'b0;
                read_enable = 1'b0;
                write_enable = 1'b0;
                sel_dm=2'b00;
                sel_a=1'b1; 
                branch_type=3'd2;
                case (funct3)
                    3'd0: begin
                        if (funct7 == 7'b0100000)
                            alu_op = 4'h1; 
                        else
                            alu_op = 4'h0; 
                    end
                    3'd1: alu_op = 4'h2;
                    3'd2: alu_op = 4'h3; 
                    3'd3: alu_op = 4'h4; 
                    3'd4: alu_op = 4'h5; 
                    3'd5: begin
                        if (funct7 == 7'b0100000)
                            alu_op = 4'h7; 
                        else
                            alu_op = 4'h6; 
                    end
                    3'd6: alu_op = 4'h8;
                    3'd7: alu_op = 4'h9;
                    default: alu_op = 4'h0; 
                endcase
            end

            // I-type instructions
             7'b0010011: begin
                write_register_enable = 1'b1;
                sel_B = 1'b1;
                read_enable = 1'b0;
                write_enable = 1'b0;
                sel_dm=2'b00;
                sel_a=1'b1;
                branch_type=3'd2;
                case (funct3)
                    3'd0: alu_op = 4'h0;   
                    3'd1: alu_op = 4'h2;   
                    3'd2: alu_op = 4'd10;   
                    3'd3: alu_op = 4'd11;   
                    3'd4: alu_op = 4'h5;   
                    3'd5: if (0100000 ) begin
                        alu_op=4'h7;
                        
                    end 
                    else begin
                        alu_op=4'h6;
                    end  
                    3'd6: alu_op = 4'h8;   
                    3'd7: alu_op = 4'h9;   
                    default: alu_op = 4'h0;
                endcase
            end

            // Load type  instructions:
            7'b0000011: begin
                write_register_enable = 1'b1;
                sel_B = 1'b1;
                read_enable = 1'b1;
                write_enable = 1'b0;
                alu_op = 4'h0; // ADD for address calculation
                sel_dm=2'b01;
                sel_a=1'b1; 
                branch_type=3'd2;

                
            end

            // Store type  instructions
            7'b0100011: begin
                write_register_enable = 1'b0;
                sel_B = 1'b1;
                read_enable = 1'b0;
                write_enable = 1'b1;
                sel_a=1'b1; 
                sel_dm=2'b01;
                branch_type=3'd2;
                alu_op=4'h0;
            end
            // Branch type instructions
            7'b1100011:begin
                write_register_enable = 1'b0;
                sel_B = 1'b1;
                read_enable = 1'b0;
                write_enable = 1'b0;
                sel_dm=2'b01;
                sel_a=1'b0;    
                branch_type=funct3;
                alu_op=4'h0;
            end
            
            // U type instructions (LUI)
            7'b0110111: begin
                write_register_enable=1'b1;
                alu_op=4'd12;
                sel_B=1;
                sel_a=1'b0;
                sel_dm=2'b00;
                read_enable = 1'b0;
                write_enable = 1'b0;
                branch_type=3'd2;
            end 

            // U type instructions (AUI)
            7'b0010111:begin
                write_register_enable=1'b1;
                alu_op=4'd0;
                sel_B=1;
                sel_a=0;
                sel_dm=2'b00;
                read_enable = 1'b0;
                write_enable = 1'b0;
                branch_type=3'd2;
            end 

            // Jump type instructions   (JAL)
            7'b1101111:begin
                sel_a=1'b0;
                sel_B=1'b1;
                branch_type=3'd3;
                read_enable = 1'b0;
                write_enable = 1'b0;
                alu_op=4'd0;
                write_register_enable=1'b1;
                
                sel_dm=2'b10;
                
            end

            // jAL type instruction
            7'b1100111 :begin
                sel_a=1'b1;
                sel_B=1'b1;
                branch_type=3'd3;
                read_enable = 1'b0;
                write_enable = 1'b0;
                alu_op=4'd0;
                write_register_enable=1'b1;               
                sel_dm=2'b10;
                
            end

            default: begin
                write_register_enable = 1'b0;
                sel_B = 1'b0;
                read_enable = 1'b0;
                write_enable = 1'b0;
                sel_a=1'b1;
                sel_dm=2'b00;
                alu_op = 4'h0; // Default to ADD
                branch_type=3'd2;
            end
        endcase
    end

endmodule
