// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_WB();

    localparam    NB_INST         =   32;         // Longitud de registro con signo
    localparam    NB_SELECTOR     =   2;          // Longitud del selector

    reg                       i_clk;
    reg    [NB_INST-1:0]      i_data_alu;
    reg    [NB_INST-1:0]      i_data_mem;
    reg                       i_selector;
    wire   [NB_INST-1:0]      o_mux;


WB u_WB
(
    .i_data_alu(i_data_alu), 
    .i_data_mem(i_data_mem),
    .i_selector(i_selector),
    .o_mux(o_mux)
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        #20
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00001      00011   00010     00000       100000
        #20
        i_data_alu = 1'b01;
        i_data_mem = 1'b10;
        #20
        i_selector = 1'b1;
        #20
        i_selector = 1'b0;
        #20
        i_data_alu = 1'b101;
        i_data_mem = 1'b110;
        #20
        i_selector = 1'b1;
        #20
        i_selector = 1'b0;
        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule