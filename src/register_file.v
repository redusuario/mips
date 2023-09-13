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
    input wire  [NB_REG-1:0]              i_address_1,
    input wire  [NB_REG-1:0]              i_address_2,  
    input wire  [NB_DATA-1:0]             i_data_input,
    input wire  [NB_REG-1:0]              i_address_data,
    input wire                            i_write,
    output wire [NB_DATA-1:0]             o_data_1,
    output wire [NB_DATA-1:0]             o_data_2

);

    reg [NB_DATA-1:0] banco_reg[SIZE_REG-1:0];



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
        if (i_write)                            // del clock y la escritura se encuentre habilitada
            banco_reg[i_address_data] <= i_data_input;                                        
    end
    
    //OUTPUT

    assign o_data_1 = banco_reg[i_address_1];
    assign o_data_2 = banco_reg[i_address_2];

endmodule