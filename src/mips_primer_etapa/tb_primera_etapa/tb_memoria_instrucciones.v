// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_IF_memoria_instrucciones();

    localparam NB_INST          = 32;
    localparam NB_ADDR          = 32;

    localparam ADDU             = 32'b000000_00001_00010_00110_00000_100001;
    localparam XOR              = 32'b000000_00010_00011_00110_00000_100100;
    localparam SLL              = 32'b000000_00001_00100_00110_00011_000000;
    localparam LB               = 32'b100000_00000_00000_0000000000001000;
    localparam LH               = 32'b100001_00001_00000_0000000000011000;
    localparam LW               = 32'b100011_00010_00000_0000000000111000;
    localparam LBU              = 32'b100100_00000_00000_0000000000001000;
    localparam LHU              = 32'b100101_00001_00000_0000000000011000;
    localparam LWU              = 32'b100111_00010_00000_0000000000111000;
    localparam SB               = 32'b101000_00000_00000_0000000000001000;
    localparam SH               = 32'b101001_00001_00000_0000000000011000;
    localparam SW               = 32'b101011_00010_00000_0000000000111000;
    localparam ADDI             = 32'b001000_00011_00100_1000000000001111;
    localparam LUI              = 32'b001111_00000_00000_0000000000000011;
    localparam BEQ              = 32'b000100_00100_00100_0000000011111111;
    localparam BNE              = 32'b000101_00011_00100_0000111111111111;
    localparam J                = 32'b000010_00000000000000000000000001;
    localparam JAL              = 32'b000011_00000000000000000000000010;
    localparam JR               = 32'b000000_00011_00000_00000_00000_001000;
    localparam JALR             = 32'b000000_00010_00000_00110_00000_001001;
    localparam HALT             = 32'b0;

    reg                             i_clk;
    reg                             i_reset;
    reg  [NB_ADDR - 1:0]            i_pc;    
    reg                             i_write;
    reg  [NB_INST - 1:0]            i_instruction;
    reg  [NB_ADDR - 1:0]            i_address;
    wire [NB_INST- 1:0]             o_instruction;


IF_memoria_instrucciones u_memoria_instrucciones
(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_pc(i_pc),
    .i_write(i_write),
    .i_instruction(i_instruction),
    .i_address(i_address),
    .o_instruction(o_instruction)
);


    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;
        i_reset = 1;

        #20
        i_clk = 1'b0;
        i_reset = 0;

        #20
        //i_enable = 1'b0;

        #20
        i_pc = 32'b0;
        i_write =  1'b1;

        #20
        i_address = 32'b1;
        #20
        i_instruction = ADDU;
        #20
        i_pc = 32'b0;
        #20
        i_pc = 32'b1;

        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule