// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_IF_pc();

    localparam NB_INST          = 32;
    localparam NB_ADDR          = 32;


    reg                        i_clk;
    reg                        i_enable;
    reg                        i_reset;
    reg    [NB_ADDR - 1:0]     i_pc;
    wire   [NB_ADDR - 1:0]     o_pc;


IF_pc u_pc
(
    .i_clk(i_clk),
    .i_enable(i_enable),
    .i_reset(i_reset),
    .i_pc(i_pc),
    .o_pc(o_pc) 
);


    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;
        i_reset = 1;

        #20
        i_reset = 0;
        i_clk = 1'b1;
        #20
        i_enable = 1'b1;

        #20
        i_pc = 32'b01;

        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule