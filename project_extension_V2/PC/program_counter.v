module program_counter(
        input clk, reset, start_PC,
        input inc_PC, jump_en, read_bus_en,
        input brsh_en, brlo_en,
        input [15:0] bus,
        output reg [7:0] address
    );

    reg N_flag;
    wire [15:0] bus_value = bus;
    wire branch_taken = (brsh_en & ~N_flag) | (brlo_en & N_flag);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            address <= 8'hzz;
            N_flag = 0;
        end else if (start_PC) begin
            address <= 8'h00;
        end else begin
            if (read_bus_en)
                N_flag <= bus_value[15];
            else if (jump_en || branch_taken)
                address <= address + bus_value[7:0];
            else if (inc_PC)
                address <= address + 1'b1;
            else
                address <= address;
                N_flag = 0;
        end
    end

endmodule