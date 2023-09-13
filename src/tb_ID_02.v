
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
    localparam               NB_DATA         =   32;
    localparam               SIZE_REG        =   32;


    localparam ADD             = 32'b000000_00010_00001_00000_00000_100000;
 

    reg                              i_clk;
    reg   [NB_DATA-1:0]              i_data_input;
    reg   [NB_REG-1:0]               i_address_data;
    reg                              i_write;

    reg   [NB_ADDR-1:0]              i_pc;
    reg   [NB_INST-1:0]              i_instruction;
    wire  [NB_FUNCT-1:0]             o_funct;
    wire  [NB_IMMEDIATE-1:0]         o_immediate;
    wire  [NB_INST-1:0]              o_instruction;
    wire  [NB_ADDR-1:0]              o_pc;

    wire  [NB_DATA-1:0]              o_data_1;
    wire  [NB_DATA-1:0]              o_data_2;

    wire  [NB_INST-1:0]              o_sign_extend;

ID u_ID
(
    .i_clk(i_clk),
    .i_data_input(i_data_input),
    .i_address_data(i_address_data),
    .i_write(i_write),

    .i_pc(i_pc),
    .i_instruction(i_instruction),
    .o_funct(o_funct),

    //.o_immediate(o_immediate),
    .o_instruction(o_instruction),
    .o_pc(o_pc),

    .o_data_1(o_data_1),
    .o_data_2(o_data_2),

    .o_sign_extend(o_sign_extend)
);


    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        #20
        i_pc = 32'b1;
        i_write = 1'b1;
        #20
        i_address_data = 32'b10;
        i_data_input   = 32'b00010;
        #20
        i_address_data = 32'b11;
        i_data_input   = 32'b00011;
        #20
        
      
      
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00010      00000   00001     00000       100000
        i_instruction=32'b000000_00010_00001_00011_00000_100000;
        #20
        i_address_data = 5'b10;
        i_data_input   = 32'b00010;
        #20
        i_address_data = 5'b11;
        i_data_input   = 32'b00011;
        #20
        i_pc = 32'b10;
        #20
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00010      00000   00001     00000       100000
        //i_instruction=32'b10000000001000100010000000100000;
        i_pc = 32'b11;
        #20
        #20
        i_address_data = 5'b100;
        i_data_input   = 32'b100;
        #20
        i_address_data = 5'b101;
        i_data_input   = 32'b101;      
        #20      
        i_pc = 32'b100;
        i_instruction=32'b000000_00100_00000_00101_00000_100000;
        #100
        
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule