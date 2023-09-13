
// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_IE();


    localparam   NB_OP         = 6;  
    localparam   NB_DATA       = 32;
    localparam   NB_DATA_OUT   = 32;


    localparam ADD             = 32'b000000_00010_00001_00000_00000_100000;

    reg                         i_clk;
    reg      [NB_DATA-1:0]      i_data_1;
    reg      [NB_DATA-1:0]      i_data_2;
    reg      [NB_OP-1:0]        i_code;
    wire     [NB_DATA_OUT-1:0]  o_alu_result;


IE u_IE
(
    .i_data_1(i_data_1),
    .i_data_2(i_data_2),
    .i_code(i_code),
    .o_alu_result(o_alu_result)
);


    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        #20
        i_data_1 = 32'b1;
        i_data_2 = 32'b1;
        i_code = 6'b100000;
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00001      00010   00100     00000       100000
        #20
        i_data_1 = 32'b1;
        i_data_2 = 32'b10;
        #20
        i_data_1 = 32'b10;
        i_data_2 = 32'b10;
        #20
        i_data_1 = 32'b10;
        i_data_2 = 32'b11;
        #20
        i_data_1 = 32'b11;
        i_data_2 = 32'b11;
        #100
        
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule