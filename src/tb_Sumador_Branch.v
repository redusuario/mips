// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_Sumador_Branch();

    localparam      NBITS           =   32; 

    reg                            i_clk;

    reg    [NBITS-1      :0]   i_extension_data;
    reg    [NBITS-1      :0]   i_sumador_pc4;
    wire   [NBITS-1      :0]   o_mux_sumador_branch;


Sumador_Branch u_Sumador_Branch(
    .i_extension_data(i_extension_data),
    .i_sumador_pc4(i_sumador_pc4),
    .o_mux_sumador_branch(o_mux_sumador_branch)  
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        #20
        i_extension_data = 32'b01;
        i_sumador_pc4    = 32'b01;
        #20

        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule