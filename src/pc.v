`timescale 1ns / 1ps

module IF_pc
#(
	parameter NB_ADDR = 32	//Tamaño de la memoria de instrucciones 4 GB
)
(
	input      wire                    i_clk,
	input      wire                    i_enable,//Detiene el contador de pograma
	input      wire                    i_reset,
	input      wire    [NB_ADDR - 1:0] i_pc,
	output     wire    [NB_ADDR - 1:0] o_pc
);

    //INTERNAL
    //reg [NB_ADDR - 1:0] pc_reg=0, pc_next=0; // la direccion inicial en 0
    reg [NB_ADDR - 1:0] pc_reg=0; 
    reg [NB_ADDR - 1:0] pc_next=0;

    always@(posedge i_clk)
    begin
        if (i_reset)
            pc_reg<={NB_ADDR{1'b0}};
        else if (i_enable)   
            pc_reg<=pc_next;
    end
    
    always @(*)
        pc_next = i_pc;//
        

    //OUTPUT
    assign o_pc = pc_reg;

endmodule