`timescale 1ns / 1ps

module ID_EX
#(
	parameter               NB_REG          =   5
)
(
    input wire  [NB_REG-1:0]                i_rd,
    input wire                              i_clk,
    input wire                              i_reset,
    input wire                              i_step, 
    output wire  [NB_REG-1:0]               o_address_read_debug
);

    reg [NB_REG-1:0]  rd; 

    always@(posedge i_clk)
        if (i_reset)
        begin    
            rd<=0;
        end  
        else if(i_step) 
          begin 
            rd<=i_rd;
        end
    

           //OUTPUT
    assign o_address_read_debug = rd;
endmodule