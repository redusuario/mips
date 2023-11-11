// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_MEM();

    localparam      NBITS           =   32;
    localparam      TNBITS          = 2;
    localparam      TAM_M           = 10;

    
    reg                            i_clk;
    reg                            reset;
    reg                            i_mips_clk_ctrl;
    reg    [NBITS-1        :0]     EX_MEM_ALU;
    reg    [NBITS-1        :0]     i_mips_mem_debug;
    reg                            EX_MEM_MemRead;
    reg                            EX_MEM_MemWrite;
    reg    [NBITS-1        :0]     EX_MEM_Registro2;
    reg    [1              :0]     EX_MEM_TamanoFiltro;
    wire   [NBITS-1        :0]     MEM_DatoMemoria_o;
    wire   [NBITS-1        :0]     MEM_DatoMemoriaDebug_o;


MEM u_MEM(
        .clk(i_clk),
        .reset(reset),
        .i_mips_clk_ctrl(i_mips_clk_ctrl),
        .EX_MEM_ALU(EX_MEM_ALU),
        .i_mips_mem_debug(i_mips_mem_debug),
        .EX_MEM_MemRead(EX_MEM_MemRead),
        .EX_MEM_MemWrite(EX_MEM_MemWrite),
        .EX_MEM_Registro2(EX_MEM_Registro2),
        .EX_MEM_TamanoFiltro(EX_MEM_TamanoFiltro),
        .MEM_DatoMemoria_o(MEM_DatoMemoria_o),
        .MEM_DatoMemoriaDebug_o(MEM_DatoMemoriaDebug_o)
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        reset = 1'b1;
        #20
        reset = 1'b0;
        #20

        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule