module sixteenbit_reg_enable(
    input clk, reset, en,
    input [15:0] d_in,
    output reg [15:0] q_out
);
    always @(posedge clk or posedge reset) begin // Fixed: posedge reset
        if (reset == 1'b1) 
            q_out <= 0;
        else begin
            if (en == 1'b1)
                q_out <= d_in;
        end
    end
endmodule