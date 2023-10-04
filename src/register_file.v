`timescale 1ns / 1ps

module ID_register_file
#(
    parameter               NB_DATA         =   32,
    parameter               NB_REG          =   5,
    parameter               SIZE_REG        =   32
)
(
    // INPUTS
    input wire                            i_clk,  
    input wire                            i_enable,
    input wire                            i_reset, 
    input wire  [NB_REG-1:0]              i_address_1,
    input wire  [NB_REG-1:0]              i_address_2,  
    input wire  [NB_DATA-1:0]             i_data_input,
    input wire  [NB_REG-1:0]              i_address_data,
    //input wire                            i_write_debug_reg_file,
    input wire                            i_write_data,
    input wire  [NB_REG-1:0]              i_address_read_debug,
    //input wire  [NB_REG-1:0]              i_address_write_debug,///////////////////////////
    //input wire  [NB_DATA-1:0]             i_write_data_debug,//////////////////////////////
    output reg [NB_DATA-1:0]             o_data_1,
    output reg [NB_DATA-1:0]             o_data_2,
    output reg [NB_DATA-1:0]             o_data_read_debug
);

    reg [NB_DATA-1:0] banco_reg[SIZE_REG-1:0];
    integer           i;
    
    initial
    begin
        for (i = 0; i < SIZE_REG; i = i + 1) begin
                banco_reg[i] = i;
        end
    end

//R-Type
//SLL
//SRL
//SRA
//SLLV
//SRLV
//SRAV
//ADDU
//SUBU
//AND
//OR
//XOR
//NOR
//SLT
//      OPCODE      RS          RT      RD      SHAMT       FUNCT
//ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000


    //Write operation
    always @(posedge i_clk) begin               // Realizo la escritura durante el semiciclo positivo
        //if (i_write_debug_reg_file) begin             // del clock y la escritura se encuentre habilitada
         //   banco_reg[i_address_write_debug] <= i_write_data_debug; ahora cargo la data en for
        //end
        if(i_reset) begin
           for (i = 0; i < SIZE_REG; i = i + 1) begin
                banco_reg[i] = i;
             end
        end else if
        (i_write_data & i_enable) begin
            banco_reg[i_address_data] <= i_data_input;
        end
    end
    
    //OUTPUT

    //assign o_data_1 = banco_reg[i_address_1];
    //assign o_data_2 = banco_reg[i_address_2];
    //assign o_data_read_debug = banco_reg[i_address_read_debug];
    always @(*)
      begin
        o_data_1            <=   banco_reg[i_address_1];
        o_data_2            <=  banco_reg[i_address_2];
        o_data_read_debug      <=  banco_reg[i_address_read_debug];
      end
endmodule