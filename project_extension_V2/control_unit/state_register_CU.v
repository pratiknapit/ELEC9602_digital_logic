module state_register_CU(clk, reset, D, Q); // D flip flop positive edge registers.
    input clk, reset;
    input[7:0] D;
    output reg[7:0] Q;

    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1)
            Q <= 8'h00;
        else
            Q <= D; 
    end
endmodule