
// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_control();


    localparam   NB_OPCODE     =  6;

    localparam ADD             = 32'b000000_00010_00001_00000_00000_100000;

    reg                         i_clk;
    reg      [NB_OPCODE-1:0]    i_opcode;
    wire                        o_signal_control_mult_A;
    wire                        o_signal_control_mult_B;


ID_control u_control
(
    .i_opcode(i_opcode),
    .o_signal_control_mult_A(o_signal_control_mult_A),
    .o_signal_control_mult_B(o_signal_control_mult_B)
);


    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        #20
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00001      00010   00100     00000       100000
        #20
        i_opcode = 1'b100000;
        #20
        i_opcode = 1'b000000;
        #20
        i_opcode = 1'b000001;
        #100
        
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule