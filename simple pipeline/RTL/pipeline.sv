module pipeline(
    input logic clk, reset
);
logic [31:0] pc, pc_out, inst, rdata1, rdata2, A, B, alu_out, data_memory_output,
            write_back_data, immediate_out,
            forw_reg_1_pc,forw_reg_1_inst,
            forw_reg_2_pc,forw_reg_2_inst,forw_reg_2_alu_out,forw_reg_2_rdata2, data2;
            
logic reg_wr, rd_en, wr_en, sel_A, sel_B, stall, f_sel_A, f_sel_B, forw_reg_2_rd_en,forw_reg_2_wr_en,forw_reg_2_reg_wr;
logic [1:0] sel_dm, preg_2_sel_dm;
logic [2:0] br_type;
logic [3:0] alu_op;
logic br_taken;

// pc
pc p_pc(
    .clk(clk),
    .reset(reset),
    .pc_out(pc_out),
    .pc(pc)
);

// pc_mux
pc_mux p_pc_mux(
    .pc(pc),
    .alu_out(alu_out),
    .pc_out(pc_out),
    .br_taken(br_taken)
);

// Instruction memory
instruction_memory p_instruction_memory(
    .addr(pc),
    .inst(inst)
);

// output declaration of module preg_1


forw_reg_1 p_forw_reg_1(
    .clk         	(clk          ),
    .reset       	(reset        ),
    .stall       	(stall        ),
    .br_taken    	(br_taken     ),
    .pc          	(pc           ),
    .inst        	(inst         ),
    .forw_reg_1_pc   	(forw_reg_1_pc    ),
    .forw_reg_1_inst 	(forw_reg_1_inst  )
);


// Register file
register_file p_register_file(
    .clk(clk),
    .reset(reset),
    .reg_wr(reg_wr),
    .raddr1(forw_reg_1_inst[19:15]),
    .raddr2(forw_reg_1_inst[24:20]),
    .waddr(forw_reg_2_inst[11:7]),
    .wdata(write_back_data), // Ensure wdata is connected to write_back_data
    .rdata1(rdata1),
    .rdata2(rdata2)
);

// output declaration of module bmux_A
wire [31:0] data1;

branch_mux_A p_branch_mux_A(
    .write_back_data 	(write_back_data  ),
    .rdata1          	(rdata1           ),
    .f_sel_A         	(f_sel_A          ),
    .data1           	(data1            )
);

// mux_A
mux_A p_mux_A(
    .pc(forw_reg_1_pc),
    .data1(data1),
    .sel_A(sel_A),
    .A(A)
);

// output declaration of module bmux_B


branch_mux_B p_branch_mux_B(
    .rdata2          	(rdata2           ),
    .write_back_data 	(write_back_data  ),
    .f_sel_B         	(f_sel_B          ),
    .data2           	(data2            )
);

// mux_B
mux_B p_mux_B(
    .immediate_out(immediate_out),
    .rdata2(data2),
    .sel_B(sel_B),
    .B(B)
);

// ALU
ALU p_ALU(
    .A(A),
    .B(B),
    .alu_op(alu_op),
    .alu_out(alu_out)
);

// Controller
controller controller(
    .inst(forw_reg_1_inst),
    .reg_wr(reg_wr),
    .sel_B(sel_B),
    .alu_op(alu_op),
    .br_type(br_type),
    .rd_en(rd_en),
    .wr_en(wr_en),
    .sel_dm(sel_dm),
    .sel_A(sel_A),
    .stall(stall),
    .f_sel_A(f_sel_A),
    .f_sel_B(f_sel_B),
    .reg_2_inst(forw_reg_2_inst)
);

// Branch condition
branch_condition p_branch_condition(
    .rdata1(data1),
    .rdata2(data2),
    .br_type(br_type),
    .br_taken(br_taken)
);

// Immediate generator
immediate_generator p_immediate_generator(
    .inst(forw_reg_1_inst),
    .immediate_out(immediate_out)
);

// output declaration of module preg_2


forw_reg_2 p_forw_reg_2(
    .clk            	(clk             ),
    .reset          	(reset           ),
    .stall          	(stall           ),
    .rd_en          	(rd_en           ),
    .wr_en          	(wr_en           ),
    .reg_wr         	(reg_wr          ),
    .sel_dm         	(sel_dm          ),
    .alu_out        	(alu_out         ),
    .rdata2         	(rdata2          ),
    .forw_reg_1_pc      	(forw_reg_1_pc       ),
    .forw_reg_1_inst    	(forw_reg_1_inst     ),
    .forw_reg_2_rd_en   	(forw_reg_2_rd_en    ),
    .forw_reg_2_wr_en   	(forw_reg_2_wr_en    ),
    .forw_reg_2_reg_wr  	(forw_reg_2_reg_wr   ),
    .forw_reg_2_sel_dm  	(forw_reg_2_sel_dm   ),
    .forw_reg_2_alu_out 	(forw_reg_2_alu_out  ),
    .forw_reg_2_rdata2  	(forw_reg_2_rdata2   ),
    .forw_reg_2_pc      	(forw_reg_2_pc       ),
    .forw_reg_2_inst    	(forw_reg_2_inst     )
);

// Data memory mux
data_mem_mux p_data_mem_mux(
    .data_memory_output(data_memory_output),
    .sel_dm(forw_reg_2_sel_dm),
    .alu_out(forw_reg_2_alu_out),
    .pc(forw_reg_2_pc),
    .write_back_data(write_back_data)
);

// Data memory
data_memory p_data_memory(
    .data_memory_input(forw_reg_2_alu_out),
    .write_data(forw_reg_2_rdata2),
    .clk(clk),
    .reset(reset),
    .wr_en(forw_reg_2_wr_en),
    .rd_en(forw_reg_2_rd_en),
    .data_memory_output(data_memory_output)
);

endmodule