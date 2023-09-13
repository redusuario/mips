// Code your design here
`timescale 1ns / 1ps

module IE_alu 
#(
    parameter NB_OP = 6,  
    parameter NB_DATA = 32,
    parameter NB_DATA_OUT = 32
)(   
    input wire      [NB_DATA-1:0]      i_data_1,
    input wire      [NB_DATA-1:0]      i_data_2,
    input wire      [NB_OP-1:0]        i_code,
    output wire     [NB_DATA_OUT-1:0]  o_alu_result
);
    
    localparam  ADD = 6'b100000;
    localparam  SUB = 6'b100010;
    localparam  AND = 6'b100100;
    localparam  OR  = 6'b100101;
    localparam  XOR = 6'b100110;
    localparam  SRA = 6'b000011;
    localparam  SRL = 6'b000010;
    localparam  NOR = 6'b100111;
    
    //auxiliar salida
    reg             [NB_DATA_OUT-1:0]  o_result;
     
    //Se simplifico el always a solo operaciones
    always @(*)
        begin
            case(i_code)
                ADD:
                o_result = i_data_1 + i_data_2;
                SUB:
                o_result = i_data_1 - i_data_2;
                AND:
                o_result = i_data_1 & i_data_2;
                OR:
                o_result = i_data_1 | i_data_2;
                XOR:
                o_result = i_data_1 ^ i_data_2;
                SRA:
                o_result = i_data_1 >>> i_data_2;
                SRL:
                o_result = i_data_1 >> i_data_2;
                NOR:
                o_result = ~(i_data_1 | i_data_2);  
                default:
                o_result = {NB_DATA_OUT{1'b0}};
            endcase
        end

    assign o_alu_result = o_result;

endmodule