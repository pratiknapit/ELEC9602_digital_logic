`timescale 1ns / 1ps

module datapath_TB;

    reg clk, reset;
    reg[15:0] r_en_OH, tri_controller_OH;
    reg A_en, G_en, G_out, status_reg_en, status_reg_out;
    reg[2:0] ALU_mux;
    reg DMEM_out, DMEM_in;
    reg[7:0] DMEM_addr;
    reg extern_en;
    reg[7:0] extern_data;
    wire[15:0] bus;

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
        .DMEM_out(DMEM_out),
        .DMEM_in(DMEM_in),
        .DMEM_addr(DMEM_addr),
        .extern_en(extern_en),
        .extern_data(extern_data),
        .bus(bus)
    );


    // Clock generation (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        @(posedge clk)
        reset = 1;
        r_en_OH = 16'b0000000000000000;
        tri_controller_OH = 16'b0000000000000000;
        A_en = 0;
        G_en = 0;
        G_out = 0;
        status_reg_en = 0;
        status_reg_out = 0;
        ALU_mux = 3'b000;
        DMEM_out = 0;
        DMEM_in = 0;
        DMEM_addr = 8'h00;
        extern_en = 0;
        extern_data = 8'h00;


        @(posedge clk)
        reset = 0;
        // instruction = 16'h0305; // LDI R3, 5
        @(posedge clk)
        r_en_OH = 16'b0000000000001000;
        extern_data = 5;
        extern_en = 1;
        // inc_PC = 1;
        #10
        r_en_OH = 16'b0000000000000000;
        extern_data = 0;
        extern_en = 0;

        #20
        // instruction = 16'h1430; // MOV R4, R3
        r_en_OH = 16'b0000000000010000;
        tri_controller_OH = 16'b0000000000001000;
        #10
        r_en_OH = 16'b0000000000000000;
        tri_controller_OH = 16'b0000000000000000;

        #20
        // instruction = 16'h2430; // ADD R4, R3 => R4 = 10
        tri_controller_OH = 16'b0000000000010000;  // Put R4 into A reg
        A_en = 1;
        #10
        tri_controller_OH = 16'b0000000000001000; // Put R3 onto bus
        ALU_mux = 3'b000; // ALU = A + Bus
        G_en = 1; // G accepts result from ALU
        A_en = 0;
        #10
        G_en = 0;
        tri_controller_OH = 16'b0000000000000000;
        G_out = 1; // G onto bus
        r_en_OH = 16'b0000000000010000; // R4 accepts from bus
        // inc_PC = 1;

        
        #40;
        // instruction = 16'h3A8C; // Given the code 3 => SUB INSTRUCTION (State 6) => (State 8)


        #100;

        $finish;
    end

        // Standard VCD dumping
    initial begin
        $dumpfile("datapath_TB.vcd");
        $dumpvars(0, datapath_TB);
    end


endmodule