module ns_CU(
    input reset,
    input [7:0] state,
    input [15:0] inst,
    output reg [7:0] n_state
);

    wire [3:0] operation = inst[15:12]; 
    wire [11:0] arguments = inst[11:0];

    wire [11:0] temp = {state, operation};

    always @(*) begin
        n_state = 8'hzz; // default to prevent latches
        if (reset == 1'b1 || inst == 16'h0000) begin
            n_state = 8'h00;
        end
        else begin
            casez(state)
                8'h00 :
                    begin
                        casez(operation)
                            4'h0 : n_state = 8'h01; // load
                            4'h1 : n_state = 8'h02; // move
                            4'h2 : n_state = 8'h03; // add1
                            4'h3 : n_state = 8'h06; // sub1
                            4'h4 : n_state = 8'h09; // inc1
                            4'h5 : n_state = 8'h0C; // dec1
                            4'h6 : n_state = 8'h0F; // lsl1
                            4'h7 : n_state = 8'h12; // lsr1
                            4'h8 : n_state = 8'h15; // cp

                            4'h9 : n_state = 8'h18; // jump
                            4'hA : n_state = 8'h19; // brsh
                            4'hB : n_state = 8'h21; // brlo
                            4'hC : n_state = 8'h23; // sts
                            4'hD : n_state = 8'h24; // lds


                            // 4'hB : n_state = 8'h17; // load data mem
                            // 4'hC : n_state = 8'h19; // store direct
                            default : n_state = 8'hzz;
                        endcase
                    end
                8'h01 : n_state = 8'h00; // load->idle
                8'h02 : n_state = 8'h00; // move->idle
                8'h03 : n_state = 8'h04; // add1->add2
                8'h04 : n_state = 8'h05; // add2->add3
                8'h05 : n_state = 8'h00; // add3->idle

                8'h06 : n_state = 8'h07; // sub1->sub2
                8'h07 : n_state = 8'h08;
                8'h08 : n_state = 8'h00;

                8'h09 : n_state = 8'h0A; // inc
                8'h0A : n_state = 8'h0B;
                8'h0B : n_state = 8'h00;

                8'h0C : n_state = 8'h0D; // dec
                8'h0D : n_state = 8'h0E;
                8'h0E : n_state = 8'h00;

                8'h0F : n_state = 8'h10; // LSL
                8'h10 : n_state = 8'h11;
                8'h11 : n_state = 8'h00;

                8'h12 : n_state = 8'h13; // LSR
                8'h13 : n_state = 8'h14;
                8'h14 : n_state = 8'h00;

                8'h15 : n_state = 8'h16; // CP
                8'h16 : n_state = 8'h17;
                8'h17 : n_state = 8'h00;

                8'h18 : n_state = 8'h00; // RJMP k

                8'h19 : n_state = 8'h20; // BRSH k
                8'h20 : n_state = 8'h00;

                8'h21 : n_state = 8'h22; // BRLO k
                8'h22 : n_state = 8'h00;

                8'h23 : n_state = 8'h00; // sts addr
                8'h24 : n_state = 8'h00; // lds addr

                default : n_state = 8'h00;
            endcase
        end
    end

endmodule