// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_IF_inc_pc();

    localparam NB_INST          = 32;//
    localparam NB_ADDR          = 32;//


    reg     [NB_ADDR - 1:0]     i_pc;
    wire    [NB_ADDR - 1:0]     o_pc;


IF_inc_pc u_inc_pc
(

    .i_pc(i_pc),
    .o_pc(o_pc) 
);


    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;
      
        i_pc =32'b00000000000000000000000000001000;
        #10
        i_pc =32'b00000000000000000000000000100000;
        //i_pc = 32'b10;

        #10
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    //always #10 i_clk = ~i_clk;

endmodule



