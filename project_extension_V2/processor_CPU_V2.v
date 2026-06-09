module processor_CPU_V2(
        input clk,
        input reset,
        input write,
        input read,
        input start,
        input start_PC,
        input [7:0] write_pmem_address,
        input [15:0] program_in
    );

    wire [15:0] bus;
    wire [15:0] code;
    wire [15:0] ir_code;
    wire [7:0] PC_address;

    wire inc_PC, jump_en, read_bus_en, brsh_en, brlo_en;
    wire [15:0] r_en_OH, tri_controller_OH;
    wire A_en, G_en, G_out, status_reg_en, status_reg_out;
    wire [2:0] ALU_mux;
    wire dmem_out, dmem_in;
    wire [7:0] dmem_addr;
    wire [7:0] extern_data;
    wire extern_en;

    PC_processor PC_processor(
        .clk(clk),
        .reset(reset),
        .write(write),
        .start(start),
        .read(read),
        .start_PC(start_PC),
        .write_pmem_address(write_pmem_address),
        .program_in(program_in),
        .inc_PC(inc_PC),
        .jump_en(jump_en),
        .read_bus_en(read_bus_en),
        .brsh_en(brsh_en),
        .brlo_en(brlo_en),
        .bus(bus),
        .ir_code(ir_code) // send IR code to Control Unit (CU).
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
        .inc_PC(inc_PC), // GOES to PC_Processor
        .PC_jump_en(jump_en), // GOES to PC_Processor
        .PC_read_bus_en(read_bus_en), // GOES to PC_Processor
        .brsh_en(brsh_en), // GOES to PC_Processor
        .brlo_en(brlo_en), // GOES to PC_Processor
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
        .bus(bus) // GOES to PC_Processor
    );

endmodule