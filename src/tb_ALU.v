// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_ALU();

    localparam   NBITS   =   32;
    localparam   RNBITS  =   5;
    localparam   NB_OP   =   4; 

    reg                        i_clk;
    reg    [NBITS-1    :0]     i_data_1;
    reg    [NBITS-1    :0]     i_data_2;
    reg    [RNBITS-1   :0]     i_shamt;
    reg                        i_UShamt;
    reg    [NB_OP-1    :0]     i_operation;
    wire                       o_cero;
    wire   [NBITS-1    :0]     o_result;


ALU u_ALU(
    .i_data_1(i_data_1),
    .i_data_2(i_data_2),
    .i_shamt(i_shamt),
    .i_UShamt(i_UShamt),
    .i_operation(i_operation),
    .o_cero(o_cero),
    .o_result(o_result)
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        #20
        i_data_1 = 32'b10;
        i_data_2 = 32'b01;
        #20
        i_operation = 4'b0010;//ADD
        #20
        i_operation = 4'b0110;//SUB
        #20 
        i_operation = 4'b0000;//AND
        #20
        i_operation  = 4'b0001;//OR
        #20
        i_operation = 4'b1101;//XOR
        #20
        //i_operation = 4'b0101;//SRA A>>>B
        //#20
        //i_operation = 4'b0100;//SRL A>>B(shamt)
        //#20
        i_operation = 4'b1100;//NOR
        #20
        //i_operation = 4'b0011;//SLL A<<B(shamt)
        //#20
        i_operation = 4'b0111;//SLT A es menor que B
        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule