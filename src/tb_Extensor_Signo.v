// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_Mux_PC();

    localparam      NBITS           =   32; 
    localparam      i_NBITS         =   16;
    localparam      e_NBITS         =   16;
    localparam      o_NBITS         =   32;

    reg                             i_clk;
    reg    [i_NBITS-1  :0]          i_signal;
    reg    [1          :0]          i_extension_mode;
    wire   [o_NBITS-1  :0]          o_ext_signal;

Extensor_Signo u_Extensor_Signo(
    .i_signal(i_signal),
    .i_extension_mode(i_extension_mode),
    .o_ext_signal(o_ext_signal)
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk   = 1'b0;
        #20
        i_extension_mode = 2'b00;
        #20
        i_signal = 16'b1000_0000_0000_0000;
        #20
        i_extension_mode = 2'b01;
        #20
        i_signal = 16'b1000_0000_0000_0000;
        #20
        i_extension_mode = 2'b10;
        #20
        i_signal = 16'b1000_0000_0000_0000;
        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule