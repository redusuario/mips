`timescale 1ns / 1ps

module EX_Unidad_Cortocircuito
    #(
        parameter RNBITS    =   5,
        parameter MUXBITS   =   3
    )
    (
        input   wire                i_EX_MEM_RegWrite,
        input   wire [RNBITS-1  :0] i_EX_MEM_Rd,
        input   wire                i_MEM_WR_RegWrite,
        input   wire [RNBITS-1  :0] i_MEM_WR_Rd, 
        input   wire [RNBITS-1  :0] i_rs,
        input   wire [RNBITS-1  :0] i_rt,
        
        output  wire [MUXBITS-1 :0] o_mux_A,
        output  wire [MUXBITS-1 :0] o_mux_B
    );
    
    reg [MUXBITS-1 :0]  mux_A;
    reg [MUXBITS-1 :0]  mux_B;
    
    always @(*)
    begin
        if(i_EX_MEM_RegWrite && (i_rs == i_EX_MEM_Rd))begin
            mux_A = 3'b001;
        end
        else if (i_MEM_WR_RegWrite && (i_rs == i_MEM_WR_Rd))begin
            mux_A = 3'b010;
        end
        else begin
            mux_A = 3'b000;
        end
    end
      
    always @(*)
    begin
        if (i_EX_MEM_RegWrite && (i_rt == i_EX_MEM_Rd)) begin
            mux_B = 3'b001;
        end
        else if (i_MEM_WR_RegWrite && (i_rt == i_MEM_WR_Rd)) begin
            mux_B = 3'b010;
        end
        else begin
            mux_B = 3'b000;
        end
    end


    assign  o_mux_A =   mux_A;
    assign  o_mux_B =   mux_B;

endmodule