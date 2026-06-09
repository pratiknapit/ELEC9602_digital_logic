module instruction_reg(clk, reset, start, d_in, q_out); // D flip flop positive edge registers.
    input clk, reset, start;
    input[15:0] d_in;
    output reg[15:0] q_out;

    always @(posedge clk or posedge reset) begin
        if (reset)
            q_out <= 16'h0000;
        else if (start)
            q_out <= d_in;
    end
endmodule