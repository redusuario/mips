`timescale 1ns / 1ps

module PC
    #(
        parameter   NBITS       =   32  
    )
    (
        input   wire                            i_clk,
        input   wire                            i_reset,
        input   wire                            i_step,
        input   wire                            i_pc_write,
        input   wire    [NBITS-1    :0]         i_NPC,
        output  wire    [NBITS-1    :0]         o_pc,
        output  wire    [NBITS-1    :0]         o_pc_4,
        output  wire    [NBITS-1    :0]         o_pc_8          
    );
    
    reg         [NBITS-1  :0]         pc;

    always @(negedge i_clk)
    begin
        if(i_reset) begin
            pc <= {NBITS{1'b0}};
        end 
        else if(i_pc_write & i_step) begin
            pc <= i_NPC;
        end 
    end


    assign  o_pc     =   pc;// burbuja       
    assign  o_pc_4   =   pc + 4;// incremento normal
    assign  o_pc_8   =   pc + 8;// JAL instruccion


endmodule
