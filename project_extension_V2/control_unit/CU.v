module CU(
        input clk, reset,
        input[15:0] instruction,
        output[15:0] r_en_OH, 
        output[15:0] tri_controller_OH, 
        output A_en, G_en, G_out, status_reg_en, status_reg_out,
        output[2:0] ALU_mux,
        output inc_PC, PC_jump_en, PC_read_bus_en, brsh_en, brlo_en,
        output DMEM_out, DMEM_in,
        output[7:0] DMEM_addr,
        output[7:0] extern_data,
        output extern_en
    );

    wire[7:0] current_state_wire, next_state_wire;
    wire [3:0] r_en, tri_controller;
    
    // Internal signals for register read/write enabling
    wire r_we, r_re;

    ns_CU next_state(.reset(reset), .state(current_state_wire), .inst(instruction), .n_state(next_state_wire));
    state_register_CU st_reg(.clk(clk), .reset(reset), .D(next_state_wire), .Q(current_state_wire));

    out_signal_CU output_signal(
        .state(current_state_wire), 
        .code(instruction), 
        .r_en(r_en), 
        .tri_controller_out(tri_controller),
        .r_we(r_we),  // Hooked up write enable
        .r_re(r_re),  // Hooked up read enable
        .A_en(A_en), 
        .G_en(G_en), 
        .G_out(G_out), 
        .status_reg_en(status_reg_en), 
        .status_reg_out(status_reg_out), 
        .ALU_mux(ALU_mux),
        .inc_PC(inc_PC), 
        .PC_jump_en(PC_jump_en), 
        .PC_read_bus_en(PC_read_bus_en), 
        .brsh_en(brsh_en), 
        .brlo_en(brlo_en), 
        .DMEM_out(DMEM_out), 
        .DMEM_in(DMEM_in),
        .DMEM_addr(DMEM_addr), 
        .extern_data(extern_data), 
        .extern_en(extern_en)
    );

    // Passed Enables to decoders to prevent R0 constant overwrite
    binary_to_onehot decoder_en(.fourbit(r_en), .en(r_we), .onehot(r_en_OH));
    binary_to_onehot decoder_tri(.fourbit(tri_controller), .en(r_re), .onehot(tri_controller_OH));

endmodule