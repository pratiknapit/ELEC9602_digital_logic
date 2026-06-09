module PC_processor(
        input clk,
        input reset,
        input write,
        input read,
        input start,
        input start_PC,
        input [7:0] write_pmem_address,
        input [15:0] program_in,
        input inc_PC,
        input jump_en,
        input read_bus_en,
        input brsh_en, brlo_en,
        input [15:0] bus,
        output [15:0] ir_code
    );

    wire [15:0] code;
    wire [7:0] PC_address;

    assign ir_code = code;

    program_ram PMEM(
        .clk(clk),
        .reset(reset),
        .write_enable(write),
        .read_enable(read),
        .write_address(write_pmem_address),
        .read_address(PC_address),
        .data_in(program_in),
        .data_out(code)
    );

    program_counter inst_PC(
        .clk(clk),
        .reset(reset),
        .start_PC(start_PC),
        .inc_PC(inc_PC),
        .jump_en(jump_en),
        .read_bus_en(read_bus_en),
        .brsh_en(brsh_en),
        .brlo_en(brlo_en),
        .bus(bus),
        .address(PC_address)
    );

    // instruction_reg my_inst_reg(
    //     .clk(clk),
    //     .reset(reset),
    //     .start(start),
    //     .d_in(code),
    //     .q_out(ir_code)
    // );

endmodule