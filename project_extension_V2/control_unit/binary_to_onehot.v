module binary_to_onehot(
    input [3:0] fourbit,
    input en, // Explicit enable added
    output reg [15:0] onehot
);

    always @(*) begin
        if (en == 1'b0) begin
            onehot = 16'b0000_0000_0000_0000; // Output nothing if disabled
        end else begin
            case (fourbit)
                4'b0000 : onehot = 16'b0000_0000_0000_0001;
                4'b0001 : onehot = 16'b0000_0000_0000_0010;
                4'b0010 : onehot = 16'b0000_0000_0000_0100;
                4'b0011 : onehot = 16'b0000_0000_0000_1000;
                4'b0100 : onehot = 16'b0000_0000_0001_0000;
                4'b0101 : onehot = 16'b0000_0000_0010_0000;
                4'b0110 : onehot = 16'b0000_0000_0100_0000;
                4'b0111 : onehot = 16'b0000_0000_1000_0000;
                4'b1000 : onehot = 16'b0000_0001_0000_0000;
                4'b1001 : onehot = 16'b0000_0010_0000_0000;
                4'b1010 : onehot = 16'b0000_0100_0000_0000;
                4'b1011 : onehot = 16'b0000_1000_0000_0000;
                4'b1100 : onehot = 16'b0001_0000_0000_0000;
                4'b1101 : onehot = 16'b0010_0000_0000_0000;
                4'b1110 : onehot = 16'b0100_0000_0000_0000;
                4'b1111 : onehot = 16'b1000_0000_0000_0000;
                default : onehot = 16'b0000_0000_0000_0000;
            endcase 
        end
    end

endmodule