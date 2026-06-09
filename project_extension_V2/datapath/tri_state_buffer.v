module tri_state_buffer(en, in, out);
    input en;
    input [15:0] in;
    output wire [15:0] out; // Changed to wire for continuous assignment

    // Continuous assignment is safer and prevents zero-extension bugs
    assign out = (en == 1'b1) ? in : 16'hzzzz;
    
endmodule