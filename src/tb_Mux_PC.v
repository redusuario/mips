// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_Mux_PC();

    localparam      NBITS           =   32; 

    reg                            i_clk;
    reg                            i_Jump;
    reg                            i_JALR;
    reg    [NBITS-1      :0]       i_rs;
    reg                            i_pcSrc;
    reg    [NBITS-1      :0]       i_SumadorBranch;
    reg    [NBITS-1      :0]       i_sumador_pc4;
    reg    [NBITS-1      :0]       i_SumadorJump;
    wire   [NBITS-1      :0]       o_pc;

Mux_PC u_Mux_PC(
    .i_Jump(i_Jump),
    .i_JALR(i_JALR),
    .i_rs(i_rs),
    .i_pcSrc(i_pcSrc),
    .i_SumadorBranch(i_SumadorBranch),
    .i_sumador_pc4(i_sumador_pc4),        
    .i_SumadorJump(i_SumadorJump),
    .o_pc(o_pc) 
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk   = 1'b0;
        i_Jump  = 1'b0;
        i_JALR  = 1'b0;
        i_pcSrc = 1'b0;       
        #20
        i_Jump = 1'b1;
        #20
        i_SumadorJump  = 32'b100;
        #20
        i_Jump = 1'b0;

        #20
        i_JALR = 1'b1;
        #20
        i_rs  = 32'b101;
        #20
        i_JALR = 1'b0;

        #20
        i_pcSrc = 1'b1;
        #20
        i_SumadorBranch  = 32'b100;
        #20
        i_pcSrc = 1'b0;


        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule