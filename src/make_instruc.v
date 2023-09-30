`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2023 22:23:45
// Design Name: 
// Module Name: make_instruc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module make_instruc
#( parameter       MEM_INST_SIZE       = 25)
(
    input   wire [7:0]  entrada,
    input   wire        i_clk,
    input   wire        i_rx_done,
    input   wire        i_reset,
    output  wire [31:0] o_registro,
    output  wire   [7:0]     test,
    output 	reg 	ready_instruc,
    output 	reg 	o_step,
    output  wire  [32 -1:0] o_address
    );

localparam INST_COUNT_SIZE = $clog2(MEM_INST_SIZE);

reg [31:0] temp=0;
reg [31:0] instruccion;
integer i=0;
integer j=0;
reg [7:0] aux;
reg               [ INST_COUNT_SIZE-1    :0]       address;

always @(posedge i_clk or posedge i_reset) begin    //solo guardo la entrada cuando rx done es 1
    ready_instruc<=1'b0;
    if (i_reset) begin
        i <= 0;
        j <= 0;
        aux <= 0;
        temp <= 0;
        instruccion <= 0;
        ready_instruc<=1'b0;
        address <= 0;
        o_step <= 0;
    end else if (i < 4 && i_rx_done) begin
        //ready_instruc<=1'b0;
        //if(j==2)begin //ignoro los dos primeros datos basura
        temp[8*(3-i) +: 8] <= entrada;        //guarda de mas significativo a menos 
        aux <= entrada;
        i <= i + 1;
        //end
        //else
        //j <= j + 1;
        end else begin if(i==4)begin
        ready_instruc<=1'b1;
        instruccion<=temp; 
        address <= address+4;
        o_step <= 1;
        //aux<=temp[31:24];                                                                        //envio recien cundo armo los 32 bits
        i <= 0;
        end
        
        end
end
assign o_address     = address;
assign o_registro = instruccion;  
assign test = aux;                     
endmodule
