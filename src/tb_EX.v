// Code your testbench here
// or browse Examples

// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_EX();

    localparam   NB_OP         = 6;  
    localparam   NB_DATA       = 32;
    localparam   NB_DATA_OUT   = 32;
    localparam   NB_INST       = 32;         // Longitud de registro con signo
    localparam   NB_SELECTOR   = 2;          // Longitud del selector


    localparam ADD             = 32'b000000_00010_00001_00000_00000_100000;
 

    reg                       i_clk;
    reg    [NB_INST-1:0]      i_pc;
    reg    [NB_INST-1:0]      i_sign_extend;
    reg    [NB_DATA-1:0]      i_data_1;
    reg    [NB_DATA-1:0]      i_data_2;
    reg    [NB_OP-1:0]        i_code;
    reg                       i_selector_mux_A;
    reg                       i_selector_mux_B;
    wire   [NB_DATA_OUT-1:0]  o_alu_result;

EX u_EX
(
    .i_pc(i_pc),
    .i_sign_extend(i_sign_extend),
    .i_data_1(i_data_1),
    .i_data_2(i_data_2),
    .i_code(i_code),
    .i_selector_mux_A(i_selector_mux_A),
    .i_selector_mux_B(i_selector_mux_B),
    .o_alu_result(o_alu_result)
);


    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        #20
        i_pc = 32'b1;
        i_sign_extend = 32'b1;
        i_data_1 = 32'b1111;
        i_data_2 = 32'b11110000;
        #20
        i_selector_mux_A = 32'b1;
        i_selector_mux_B = 32'b1;
        #20
        i_code = 6'b100000;
        #20
        //      OPCODE      RS          RT      RD      SHAMT       FUNCT
        //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
        //      000000     00010      00000   00001     00000       100000
        //i_instruction=32'b000000_00010_00001_00011_00000_100000;
        #100
        
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule