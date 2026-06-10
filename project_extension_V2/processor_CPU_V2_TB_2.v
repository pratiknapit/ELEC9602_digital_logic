`timescale 1ns / 1ps

module processor_CPU_V2_TB;

    reg clk, reset, write, read;
    reg start, start_PC;
    reg [7:0] write_pmem_address;
    reg [15:0] instruction;

    // Instantiate your processor
    processor_CPU_V2 my_processor_CPU_V2(
        .clk(clk),
        .reset(reset),
        .write(write),
        .read(read),
        .start(start),
        .start_PC(start_PC),
        .write_pmem_address(write_pmem_address),
        .program_in(instruction)
    );

    // Clock generation (10ns period)
    initial clk = 0;
    initial instruction = 16'h0000;
    initial reset = 0;
    initial start = 0;
    initial read = 0;
    initial start_PC = 0;
    initial write = 0;
    initial write_pmem_address = 8'h00;
    always #5 clk = ~clk;

    integer i;
    reg [15:0] test_prog [0:30];

    initial begin

        // --- TEST 1: BASICS & ARITHMETIC INSTRUCTIONS ---
        @(posedge clk)
        test_prog[0] = 16'h011F; // LOAD R1, 0x1F  (R1 = 1F)
        test_prog[1] = 16'h0241; // LOAD R2, 0x41  (R2 = 41)
        test_prog[2] = 16'h0304; // LOAD R3, 0x04  (R3 = 4)
        test_prog[3] = 16'h0478; // LOAD R4, 0x78  (R4 = 78)
        test_prog[4] = 16'h0521; // LOAD R5, 0x21  (R5 = 21)

        test_prog[5] = 16'h2350; // ADD R5, R3 (R5 = 1D)
        test_prog[6] = 16'h3420; // SUB R4, R2 (R4 = 37)

        test_prog[7] = 16'h8450; // CP R4, R5 => SREG = 37 - 1D (brsh enabled)
        test_prog[8] = 16'hA004; // BRSH 4
        test_prog[9] = 16'h0103; // LOAD R1, 0x03 (Should be skipped by BRSH)
        test_prog[10] = 16'h0122; // LOAD R1, 0x22 (Should be skipped by BRSH)
        test_prog[11] = 16'h0135; // LOAD R1, 0x35 (Should be skipped by BRSH)
        test_prog[12] = 16'h0102; // LOAD R1, 0x02

        test_prog[13] = 16'h9003; // RJMP 3
        test_prog[14] = 16'h0103; // LOAD R1, 0x03 (Should be skipped by BRSH)
        test_prog[15] = 16'h0122; // LOAD R1, 0x22 (Should be skipped by BRSH)
        test_prog[16] = 16'h0135; // LOAD R1, 0x35

        test_prog[17] = 16'h8540; // CP R5, R4 => SREG = 1D - 37 (brsh not enabled)
        test_prog[18] = 16'hA002; // BRSH 2
        test_prog[19] = 16'h0103; // LOAD R1, 0x03 (Should NOT be skipped by BRSH)
        test_prog[20] = 16'h0122; // LOAD R1, 0x22 (Should NOT be skipped by BRSH)

        // --- END ---
        
        // -----------------------------------------------------
        // 2. Initialize System
        // -----------------------------------------------------
        reset = 1;
        
        @(posedge clk)
        reset = 0;
        write = 1;


        // -----------------------------------------------------
        // 3. Load program into PMEM
        // -----------------------------------------------------
        for (i = 0; i < 21; i = i + 1) begin
            @(posedge clk);
            write_pmem_address = i[7:0];
            instruction = test_prog[i];
        end

        // -----------------------------------------------------
        // 4. Start execution
        // -----------------------------------------------------
        @(posedge clk);
        write = 0;
        start_PC = 1;
        
        @(posedge clk);
        start_PC = 0;
        read = 1;
        start = 1;

        // Let the CPU run long enough to reach the end
        #900;

        $finish;
    end

    // Standard VCD dumping
    initial begin
        $dumpfile("processor_CPU_V2_TB.vcd");
        $dumpvars(0, processor_CPU_V2_TB);
    end

endmodule