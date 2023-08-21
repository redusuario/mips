`timescale 1ns / 1ps

module IF_inc_pc
#(
    parameter NB_ADDR   = 32,
    parameter NBITS     = 32
)
(
    input       wire    [NB_ADDR - 1:0]     i_pc, 
    output      wire    [NB_ADDR - 1:0]     o_pc 
);

    reg    [NB_ADDR - 1:0]      pc_reg;

  always @(*) begin
        pc_reg<=i_pc + 4;
    end

    //OUTPUT
    assign o_pc = pc_reg;

endmodule