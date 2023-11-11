`timescale 1ns / 1ps

module Memory_Data
    #(
        parameter NBITS     = 32    ,
        parameter TAM       = 16
    )
    (
        input   wire                        i_clk,
        input   wire                        i_reset,
        input   wire                        i_step,
        input   wire    [NBITS-1    :0]     i_ALUaddress,
        input   wire    [NBITS-1    :0]     i_debug_address,
        input   wire    [NBITS-1    :0]     i_data_reg,
        input   wire                        i_MemRead,
        input   wire                        i_MemWrite,
        output  reg     [NBITS-1    :0]     o_data_read,
        output  reg     [NBITS-1    :0]     o_debug_data
    );
    
    reg     [NBITS-1  :0]     memory[TAM-1:0];

    integer i;
    
 
    always @(negedge i_clk)
    begin
        if(i_MemWrite & i_step) begin
            memory[i_ALUaddress]  <=  i_data_reg;
        end
    end

    //output

    initial 
    begin
        for (i = 0; i < TAM; i = i + 1) begin
                memory[i] <= i;
        end
        o_debug_data  <=  0;
    end
    
    always @(i_debug_address)
    begin
        o_debug_data  <=  memory[i_debug_address];
    end

    always @(*)
    begin
        if (i_MemRead & i_step) begin
            o_data_read    <=  memory[i_ALUaddress];
        end else begin
            o_data_read    <=  0;
        end
    end


endmodule