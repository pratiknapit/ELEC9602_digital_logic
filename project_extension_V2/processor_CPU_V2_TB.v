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
        test_prog[0] = 16'h0105; // LOAD R1, 0x05  (R1 = 5)
        test_prog[1] = 16'h020A; // LOAD R2, 0x0A  (R2 = 10)
        test_prog[2] = 16'h0311; // LOAD R3, 0x08  (R3 = 8)
        test_prog[3] = 16'h041E; // LOAD R4, 0x1E  (R4 = 30)
        test_prog[4] = 16'h1530; // MOV R5, R3 (R5 = R3 = 8)
        test_prog[5] = 16'h2540; // ADD R5, R4 (R5 = 38)
        test_prog[6] = 16'h1650; // MOV R6, R5 (R6 = 38)
        test_prog[7] = 16'h3620; // SUB R6, R2 (R6 = 28 = 0x1C)
        test_prog[8] = 16'h4600; // INC R6 (R6 = 29)
        test_prog[9] = 16'h5600; // DEC R6 (R6 = 28)
        test_prog[10] = 16'h6600; // LSL R6 (R6 = 56)
        test_prog[11] = 16'h7600; // LSR R6 (R6 = 28)
        test_prog[12] = 16'h8160; // CP R1, R6 => SREG = 5 - 28 = -23
        
        // --- TEST 2: JUMP INSTRUCTIONS ---
        test_prog[13] = 16'h9003; // RJMP 3; => PC_address = 14
        test_prog[14] = 16'h0603; // LOAD R6, 0x03 (Should be skipped by JMP)
        test_prog[15] = 16'h060A; // LOAD R6, 0x0A (Should be skipped by JMP)
        test_prog[16] = 16'h061F; // LOAD R6, 0x1F (R6 = 31)

        // --- TEST 3: Branch (BRSH) TAKEN ---
        test_prog[17] = 16'h8620; // CP R6, R2 => SREG = 31 - 10 (brsh enabled)
        test_prog[18] = 16'hA003; // BRSH 3
        test_prog[19] = 16'h0603; // LOAD R6, 0x03 (Should be skipped by JMP)
        test_prog[20] = 16'h060A; // LOAD R6, 0x0A (Should be skipped by JMP)
        test_prog[21] = 16'h0628; // LOAD R6, 0x28 (R6 = 40)

        // --- TEST 3: Branch (BRLO) TAKEN ---
        test_prog[22] = 16'h8120; // CP R1, R2 => SREG = 5 - 10 (brlo enabled)
        test_prog[23] = 16'hB003; // BRLO 3
        test_prog[24] = 16'h0603; // LOAD R6, 0x03 (Should be skipped by JMP)
        test_prog[25] = 16'h060A; // LOAD R6, 0x0A (Should be skipped by JMP)
        test_prog[26] = 16'h06B7; // LOAD R6, 0xB7 (R6 = 0xB7)

        

        // --- TEST 4: Load & Store to RAM ---
        test_prog[27] = 16'hC106; // sts R1, 0x06 (store 0x05 to 0x06)
        test_prog[28] = 16'hD606; // lds R6, 0x06 (read 0x05 from 0x06 into R6)

        
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
        for (i = 0; i < 29; i = i + 1) begin
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