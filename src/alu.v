`timescale 1ns / 1ps

module ALU #(
        parameter   NBITS   =   32,
        parameter   RNBITS  =   5,
        parameter   NB_OP   =   4      
    )
    (
        input   wire    [NBITS-1    :0]     i_data_1,
        input   wire    [NBITS-1    :0]     i_data_2,
        input   wire    [RNBITS-1   :0]     i_shamt,
        input   wire                        i_UShamt,
        input   wire    [NB_OP-1    :0]     i_operation,
        output  wire                        o_cero,
        output  wire    [NBITS-1    :0]     o_result    
    );
    
    localparam  ADD = 4'b0010; 
    localparam  SUB = 4'b0110; 
    localparam  AND = 4'b0000; 
    localparam  OR  = 4'b0001; 
    localparam  XOR = 4'b1101;
    localparam  SRA = 4'b0101; // A>>>B
    localparam  SRL = 4'b0100; // A>>B(shamt)
    localparam  NOR = 4'b1100; 
    localparam  SLL = 4'b0011; // A<<B(shamt)
    localparam  SLT = 4'b0111; // A es menor que B


    reg [NBITS-1:0]     result;
      
    always @(*)
        begin : operations
            case(i_operation)
                AND:
                result  =   i_data_1   &   i_data_2;
                OR:
                result  =   i_data_1   |   i_data_2;
                ADD:
                result  =   i_data_1   +   i_data_2;
                SUB:
                result  =   i_data_1   -   i_data_2;
                SLT:
                result  =   i_data_1   <   i_data_2 ? 1:0;
                NOR:
                result  =   ~(i_data_1 |   i_data_2);
                XOR:
                result  =   i_data_1   ^   i_data_2;
                SLL:
                result  =   (i_UShamt) ? (i_data_2 << i_shamt) : (i_data_2 << i_data_1);
                SRL:
                result  =   (i_UShamt) ? (i_data_2 >> i_shamt) : (i_data_2 >> i_data_1);
                SRA:
                result  =   (i_UShamt) ? ($signed(i_data_2) >>> i_shamt) : ($signed(i_data_2) >>> i_data_1);
                default:
                result  =   -1;
            endcase
        end

    assign o_result =   result;
    assign o_cero   =   (result==0); //

endmodule
