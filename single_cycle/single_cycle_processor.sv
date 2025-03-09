module single_cycle_processor (
    input logic clock,
    input logic reset
);
    // Internal signals
    logic [31:0]  pc_next, read_data_1, read_data_2, machine_code,write_back_data, alu_out, immediate_output, mux_output,data_memory_output,bc_pc_out,a, pc_with_four_out,jump_dm_input;
    logic [3:0]   alu_op;
    logic [2:0]   branch_type;
    logic [1:0]   sel_dm;
    logic write_register_enable, sel_B, read_enable, write_enable,branch_taken,sel_a;

    
    pc program_counter (
        .clock(clock),
        .reset(reset),
        .pc(bc_pc_out),
        .pc_next(pc_next)
    );

    
    instruction_memory instr_mem (
        .write_address_G(pc_next), 
        .machine_code(machine_code)
    );

    
    register_file reg_file (
        .clock(clock),
        .reset(reset),
        .read_address_1(machine_code[19:15]),
        .read_address_2(machine_code[24:20]),
        .write_address(machine_code[11:7]),
        .write_back_data(write_back_data),
        .write_register_enable(write_register_enable),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    
        // Correct module name and port connection
    immediate imm_gen (
        .instructions(machine_code),
        .immediate_out(immediate_output)  // Port name matches the module's output
    );

    
    two_cross_one mux (
        .mux_input(immediate_output),
        .read_data_2(read_data_2),
        .selB(sel_B),
        .mux_output(mux_output)
    );

  
    controller ctrl (
        .instructions(machine_code),
        .write_register_enable(write_register_enable),
        .sel_B(sel_B),
        .alu_op(alu_op),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .sel_dm(sel_dm),
        .sel_a(sel_a),
        .branch_type(branch_type)
        
    );

 
    alu arithmetic_logic_unit (
        .a(a),
        .b(mux_output),
        .alu_op(alu_op),
        .alu_out(alu_out)
    );

    data_memory data_mem (
        .data_memory_input(alu_out), // Address to access
        .write_data(read_data_2), // Data to be written
        .clock(clock),
        .reset(reset),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .data_memory_output(data_memory_output) // Data to be read
    );

    data_memory_mux dm_mux(
        .data_memory_output(data_memory_output),
        .sel_dm(sel_dm),
        .alu_out(alu_out),
        .jump_dm_input(jump_dm_input),
        .write_back_data(write_back_data)
    );
     
    branch_condition bc(
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .branch_type(branch_type),
        .branch_taken(branch_taken)
    );

    bc_pc_mux bc_pc_mux(
        .pc_with_four_out(pc_with_four_out),
        .alu_out(alu_out),
        .bc_pc_out(bc_pc_out),
        .branch_taken(branch_taken)
    );

    rs1_pc_mux rs1_pc_mux(
        .pc_next(pc_next),
        .read_data_1(read_data_1),
        .sel_a(sel_a),
        .a(a)
    );

    pc_with_four four(
        .pc_next(pc_next),
        .pc_with_four_out(pc_with_four_out)
    );

    dm_pc_mux dm_pc_mux(
        .pc_next(pc_next),
        .jump_dm_input(jump_dm_input)

    );
endmodule
