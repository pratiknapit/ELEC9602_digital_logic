`timescale 1ns / 1ps

module control_unit_TB;

    reg clk, reset;
    reg [15:0] instruction;

    CU control_unit(
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        // .r_en_OH(r_en_OH),
        // .tri_controller_OH(tri_controller_OH),
        // .A_en(A_en),
        // .G_en(G_en),
        // .G_out(G_out),
        // .status_reg_en(status_reg_en),
        // .status_reg_out(status_reg_out),
        // .ALU_mux(ALU_mux),
        .inc_PC(inc_PC)
        // .PC_jump_en(PC_jump_en),
        // .PC_read_bus_en(PC_read_bus_en),
        // .brsh(brsh),
        // .DMEM_out(DMEM_out),
        // .DMEM_in(DMEM_in),
        // .DMEM_addr(DMEM_addr),
        // .extern_data(extern_data),
        // .extern_en(extern_en)
    );

    wire inc_PC;

    // Clock generation (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        @(posedge clk)
        reset = 1;

        @(posedge clk)
        reset = 0;
        instruction = 16'h0305; // Given the code 0 => LOAD INSTRUCTION (State 1) => (State 0)

        #20
        instruction = 16'h1405; // Given the code 1 => MOVE INSTRUCTION (State 2)

        #20
        instruction = 16'h26E5; // Given the code 2 => ADD INSTRUCTION (State 3) => (State 5)
        #40;
        instruction = 16'h3A8C; // Given the code 3 => SUB INSTRUCTION (State 6) => (State 8)


        #100;

        $finish;
    end

        // Standard VCD dumping
    initial begin
        $dumpfile("control_unit_TB.vcd");
        $dumpvars(0, control_unit_TB);
    end


endmodule