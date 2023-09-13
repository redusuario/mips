// Code your testbench here
// or browse Examples

// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_ID();


    localparam               NB_ADDR         =   32;
    localparam               NB_INST         =   32;
    localparam               NB_OPCODE       =   6;
    localparam               NB_FUNCT        =   6;
    localparam               NB_REG          =   5;     // Longitud del campo RS,RT,RD
    localparam               NB_IMMEDIATE    =   16;


    localparam ADD             = 32'b000000_00010_00001_00000_00000_100000;
 

    reg                              i_clk;
    reg   [NB_ADDR-1:0]              i_pc;
    reg   [NB_INST-1:0]              i_instruction;
    wire  [NB_REG-1:0]               o_rs;
    wire  [NB_REG-1:0]               o_rt;
    wire  [NB_REG-1:0]               o_rd;
    wire  [NB_FUNCT-1:0]             o_funct;
    wire  [NB_IMMEDIATE-1:0]         o_immediate;
    wire  [NB_INST-1:0]              o_instruction;
    wire  [NB_ADDR-1:0]              o_pc;

ID_decodificador u_decodificador
(
    .i_pc(i_pc),
    .i_instruction(i_instruction),
    .o_rs(o_rs),
    .o_rt(o_rt),
    .o_rd(o_rd),
    .o_funct(o_funct),
    .o_immediate(o_immediate),
    .o_instruction(o_instruction),
    .o_pc(o_pc)
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        #20
        i_pc = 32'b1;
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00010      00000   00001     00000       100000
        i_instruction=32'b000000_00010_00001_00000_00000_100000;
        #20
        i_pc = 32'b10;
        #20
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00010      00000   00001     00000       100000
        //i_instruction=32'b10000000001000100010000000100000;
        i_pc = 32'b11;
        #20
        i_pc = 32'b100;
        i_instruction=32'b000000_10000_00000_01000_00000_100000;
        #100
        
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule