module processor(
        input clk,
        input reset,
        input write,
        input start,
        input [7:0] write_pmem_address,
        input [15:0] program_in
    );

    wire [15:0] bus;
    wire [15:0] code;
    wire [15:0] ir_code;
    wire [7:0] PC_address;

    wire inc_PC, jump_en, read_bus_en, brsh;
    wire [15:0] r_en_OH, tri_controller_OH;
    wire A_en, G_en, G_out, status_reg_en, status_reg_out;
    wire [2:0] ALU_mux;
    wire dmem_out, dmem_in;
    wire [7:0] dmem_addr;
    wire [7:0] extern_data;
    wire extern_en;

    program_ram PMEM(
        .clk(clk),
        .reset(reset),
        .write_enable(write),
        .write_address(write_pmem_address),
        .read_address(PC_address),
        .data_in(program_in),
        .data_out(code)
    );

    program_counter inst_PC(
        .clk(clk),
        .reset(reset),
        .start(start),
        .inc_PC(inc_PC),
        .jump_en(jump_en),
        .read_bus_en(read_bus_en),
        .brsh(brsh),
        .bus(bus),
        .address(PC_address)
    );

    instruction_reg my_inst_reg(
        .clk(clk),
        .reset(reset),
        .d_in(code),
        .q_out(ir_code)
    );

    CU control(
        .clk(clk),
        .reset(reset),
        .instruction(ir_code),
        .r_en_OH(r_en_OH),
        .tri_controller_OH(tri_controller_OH),
        .A_en(A_en),
        .G_en(G_en),
        .G_out(G_out),
        .status_reg_en(status_reg_en),
        .status_reg_out(status_reg_out),
        .ALU_mux(ALU_mux),
        .inc_PC(inc_PC),
        .PC_jump_en(jump_en),
        .PC_read_bus_en(read_bus_en),
        .brsh(brsh),
        .DMEM_out(dmem_out),
        .DMEM_in(dmem_in),
        .DMEM_addr(dmem_addr),
        .extern_en(extern_en),
        .extern_data(extern_data)
    );

    datapath my_datapath(
        .clk(clk),
        .reset(reset),
        .r_en_OH(r_en_OH),
        .tri_controller_OH(tri_controller_OH),
        .A_en(A_en),
        .G_en(G_en),
        .G_out(G_out),
        .status_reg_en(status_reg_en),
        .status_reg_out(status_reg_out),
        .ALU_mux(ALU_mux),
        .DMEM_out(dmem_out),
        .DMEM_in(dmem_in),
        .DMEM_addr(dmem_addr),
        .extern_en(extern_en),
        .extern_data(extern_data),
        .bus(bus)
    );

endmodule