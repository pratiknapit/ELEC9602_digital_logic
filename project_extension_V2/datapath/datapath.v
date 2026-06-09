module datapath(
        input clk, reset,
        input[15:0] r_en_OH, tri_controller_OH,
        input A_en, G_en, G_out, status_reg_en, status_reg_out,
        input[2:0] ALU_mux,
        input DMEM_out, DMEM_in,
        input[7:0] DMEM_addr,
        input extern_en,
        input[7:0] extern_data,
        output wire[15:0] bus
    );

    wire[15:0] register_out [0:15];
    wire[15:0] ALU_arg1, ALU_result;
    wire[15:0] status_reg_value;
    wire[15:0] G_value;

    genvar i;
    generate
        for (i=0; i < 16; i=i+1) begin : gen_regs
            sixteenbit_reg_enable my_regs(.clk(clk), .reset(reset), .en(r_en_OH[i]), .d_in(bus), .q_out(register_out[i]));
        end
    endgenerate
    
    generate
        for (i=0; i < 16; i=i+1) begin : gen_tri_bufs
            tri_state_buffer tri_bufs(.en(tri_controller_OH[i]), .in(register_out[i]), .out(bus));
        end
    endgenerate

    // FIXED: Proper sign extension allows JUMP and BRSH to jump backwards!
    wire [15:0] extern_data_padded = {8'b0, extern_data};
    
    tri_state_buffer extern_tri(.en(extern_en), .in(extern_data_padded), .out(bus));
    
    sixteenbit_reg_enable A_reg(.clk(clk), .reset(reset), .en(A_en), .d_in(bus), .q_out(ALU_arg1));
    ALU my_ALU(.A(ALU_arg1), .B(bus), .ALU_sig(ALU_mux), .result(ALU_result));

    sixteenbit_reg_enable G_reg(.clk(clk), .reset(reset), .en(G_en), .d_in(ALU_result), .q_out(G_value));
    tri_state_buffer G_tri_state(.en(G_out), .in(G_value), .out(bus));

    sixteenbit_reg_enable status_reg(.clk(clk), .reset(reset), .en(status_reg_en), .d_in(bus), .q_out(status_reg_value));
    tri_state_buffer sreg_tri_state(.en(status_reg_out), .in(status_reg_value), .out(bus));

    DMEM dmem_memory(.clk(clk), .we(DMEM_in), .re(DMEM_out), .address(DMEM_addr), .d_in(bus), .d_out(bus));

endmodule