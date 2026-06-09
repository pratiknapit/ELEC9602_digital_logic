`timescale 1ns / 1ps

module processor_TB;

    reg clk, reset, write;
    reg [7:0] address;
    reg [15:0] instruction;
    reg start_PC;

    // Instantiate your processor
    processor my_processor(
        .clk(clk),
        .reset(reset),
        .write(write),
        .start(start_PC),
        .write_pmem_address(address),
        .program_in(instruction)
    );

    // Clock generation (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    integer i;
    reg [15:0] test_prog [0:15];

    initial begin
        // -----------------------------------------------------
        // 1. Define the Control Flow Test Program
        // -----------------------------------------------------
        
        test_prog[0]  = 16'h0105; // 0x00: LOAD R1, 0x05  (R1 = 5)
        test_prog[1]  = 16'h020A; // 0x01: LOAD R2, 0x0A  (R2 = 10)
        
        // --- TEST 1: Branch TAKEN ---
        // test_prog[2]  = 16'h9210; // 0x02: CP R2, R1      (10 - 5 = 5. Positive, so N_flag = 0)
        // test_prog[3]  = 16'hA002; // 0x03: BRSH 0x02      (N_flag is 0, so jump forward 2 spaces to 0x05)
        // test_prog[4]  = 16'h01FF; // 0x04: LOAD R1, 0xFF  (SKIPPED! If R1 becomes FF, branch failed)
        
        // --- TEST 2: Branch NOT TAKEN ---
        // test_prog[5]  = 16'h9120; // 0x05: CP R1, R2      (5 - 10 = -5. Negative, so N_flag = 1)
        // test_prog[6]  = 16'hA002; // 0x06: BRSH 0x02      (N_flag is 1, branch fails. CPU goes to 0x07)
        // test_prog[7]  = 16'h0207; // 0x07: LOAD R2, 0x07  (EXECUTED! R2 becomes 7)
        
        // --- TEST 3: Unconditional JUMP ---
        // test_prog[8]  = 16'h8002; // 0x08: JUMP 0x02      (Jumps forward 2 spaces to 0x0A)
        // test_prog[9]  = 16'h01AA; // 0x09: LOAD R1, 0xAA  (SKIPPED! If R1 becomes AA, jump failed)

        // test_prog[8] = 16'hC206; // sts 
        // test_prog[7] = 16'hB106; // ld

        
        // --- END ---
        // test_prog[12] = 16'h8000; // 0x0A: JUMP 0x00      (Infinite Loop offset by 0. Locks PC at 0x0A)

        // -----------------------------------------------------
        // 2. Initialize System
        // -----------------------------------------------------
        reset = 1;
        write = 0;
        start_PC = 0;
        address = 8'h00;
        instruction = 16'hz;

        #20 reset = 0;

        // -----------------------------------------------------
        // 3. Load program into PMEM
        // -----------------------------------------------------
        write = 1;
        for (i = 0; i < 11; i = i + 1) begin
            @(posedge clk);
            address = i[7:0];
            instruction = test_prog[i];
        end
        
        @(posedge clk);
        write = 0;

        // -----------------------------------------------------
        // 4. Start execution
        // -----------------------------------------------------
        @(posedge clk);
        start_PC = 1;
        
        @(posedge clk);
        start_PC = 0;

        // Let the CPU run long enough to reach the end
        #600;

        $finish;
    end

    // Standard VCD dumping
    initial begin
        $dumpfile("processor_TB.vcd");
        $dumpvars(0, processor_TB);
    end

endmodule