`timescale 1ns / 1ps

module register_file
    #(
        parameter   REGS        =   5,
        parameter   NBITS       =   32,
        parameter   TAM         =   32  
    )
    (
        input   wire                        i_clk,
        input   wire                        i_reset,
        input   wire                        i_RegWrite,
        input   wire                        i_step,
        input   wire    [REGS-1:0]          i_dir_rs, //Leer registro 1
        input   wire    [REGS-1:0]          i_dir_rt, //Leer registro 2
        input   wire    [REGS-1:0]          i_RD, //Escribir registro
        input   wire    [REGS-1:0]          i_RegDebug, //Leer registro debug
        input   wire    [NBITS-1:0]         i_DatoEscritura, //Escribir dato
        output  reg     [NBITS-1:0]         o_data_rs, // Dato leido 1
        output  reg     [NBITS-1:0]         o_data_rt, // Dato leido 2
        output  reg     [NBITS-1:0]         o_RegDebug
    );
    
    reg     [NBITS-1:0]         memory[TAM-1:0];
    reg     [NBITS-1:0]         rs;
    reg     [NBITS-1:0]         rt;
    reg     [NBITS-1:0]         Reg_Debug;
    integer                     i;
    
    initial
    begin
        for (i = 0; i < TAM; i = i + 1) begin
                memory[i] = i;
        end
    end
    

    always @(*)
    begin
        o_data_rs       <=  memory[i_dir_rs];
        o_data_rt       <=  memory[i_dir_rt];
        o_RegDebug      <=  memory[i_RegDebug];
    end

    always @(negedge i_clk )
    begin
        if(i_reset) begin
            for (i = 0; i < TAM; i = i + 1) begin
                memory[i] <= i;
            end
        end else if(i_RegWrite & i_step)
        begin
            memory[i_RD] <= i_DatoEscritura ;
        end
    end
endmodule

