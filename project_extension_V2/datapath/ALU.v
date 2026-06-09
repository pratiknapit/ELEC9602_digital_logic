module ALU(A, B, ALU_sig, result);
	input [15:0] A;
	input [15:0] B;
    input [2:0] ALU_sig;
    output reg [15:0] result;

    always @(*) begin
        case (ALU_sig)
            3'b000 : begin result <= A + B; end //ADD
            3'b001 : begin result <= A - B; end //SUB
            3'b010 : begin result <= A + 1; end //INC
            3'b011 : begin result <= A - 1; end //DEC
            3'b100 : begin result <= A << 1; end //LSL
            3'b101 : begin result <= A >> 1; end //LSR
        endcase
    end
endmodule