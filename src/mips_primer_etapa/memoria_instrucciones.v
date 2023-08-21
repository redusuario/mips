`timescale 1ns / 1ps


module IF_memoria_instrucciones
#(
    parameter NB_ADDR        = 32,              //direccionamiento hasta 4GB. 
    parameter NB_INST        = 32,              //Tamaño de las instrucciones
    parameter NB_ROM_SIZE    = 10,              //Tamaño de la memoria de 1MB es 10
    parameter TAM            = 2**NB_ROM_SIZE                    
) 
(
    input  wire                            i_clk,
    input  wire                            i_reset,
    input  wire [NB_ADDR - 1:0]            i_pc,    
    input  wire                            i_write,
    input  wire [NB_INST - 1:0]            i_instruction,
    input  wire [NB_ADDR - 1:0]            i_address,
    output wire [NB_INST- 1:0]             o_instruction
);
    
    //direcciones 32 bits
    //memoria 1MB
    
    reg [NB_INST-1:0] memory[TAM-1:0];
    integer                   i;
    
    initial 
    begin
        for (i = 0; i < TAM; i = i + 1) begin
            memory[i] = 0;
        end  
    end

//    initial
//    begin
//        memory[4]  <= 32'b00000000010000110000100000100001; //addu r1,r2,r3
//        memory[8]  <= 32'b00001000000000000000000000001011; //j 11
//        memory[12] <= 32'b00000000001000010010000000100111; //nor r4,r1,r1
//        memory[16] <= 32'b00000000000000000000000000000000; //nop
//    end


    //Write operation
    always @(posedge i_clk) begin               // Realizo la escritura durante el semiciclo positivo
        if (i_write)                            // del clock y la escritura se encuentre habilitada
            memory[i_address] <= i_instruction;                                        
    end
	
  	//OUTPUT
    //read operation 
  	assign o_instruction = (i_write) ? memory[i_pc] : memory[i_address]; // El dato se lee al instante y se asigna a la salida
  	                                             // De igual modo cuando se escribe se disponibiliza

endmodule