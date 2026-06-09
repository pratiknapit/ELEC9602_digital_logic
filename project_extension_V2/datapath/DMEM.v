module DMEM(
    input wire clk,
    input wire we, 
    input wire re,                 
    input wire [7:0] address,      
    input wire [15:0] d_in,         
    output wire [15:0] d_out 
);

    reg [15:0] memory [0:255];

    // Synchronous Write
    always @(posedge clk) begin
        if (we)
            memory[address] <= d_in;
    end
    
    // Combinational Read
    assign d_out = (re == 1'b1) ? memory[address] : 16'hzzzz;

endmodule