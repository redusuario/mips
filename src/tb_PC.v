// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_PC();

    localparam      NBITS           =   32; 

    reg                            i_clk;
    reg                            i_reset;
    reg                            i_step;
    reg                            i_pc_write;
    reg    [NBITS-1    :0]         i_NPC;
    wire   [NBITS-1    :0]         o_pc;
    wire   [NBITS-1    :0]         o_pc_4;
    wire   [NBITS-1    :0]         o_pc_8;


PC u_PC(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_step(i_step),
    .i_pc_write(i_pc_write),
    .i_NPC(i_NPC),
    .o_pc(o_pc),
    .o_pc_4(o_pc_4),
    .o_pc_8(o_pc_8)  
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        i_reset = 1'b1;
        #20
        i_reset = 1'b0;
        #20
        i_step = 1'b1;
        i_pc_write = 1'b1;
        #20
        i_NPC = 32'b01;
        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule