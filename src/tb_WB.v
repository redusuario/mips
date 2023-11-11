// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_WB();

    localparam      NBITS           = 32;
    localparam      HWORDBITS       = 16;
    localparam      BYTENBITS       = 8;
    localparam      REGS            = 5;
    localparam      TNBITS          = 2; 


    
    reg                            i_clk;

    reg                            MEM_WB_LUI;
    reg    [NBITS-1        :0]     MEM_WB_Extension;
    reg    [NBITS-1        :0]     MEM_WB_DatoMemoria;
    reg    [1              :0]     MEM_WB_TamanoFiltroL;
    reg                            MEM_WB_ZeroExtend;
    reg                            MEM_WB_MemToReg;
    reg    [NBITS-1        :0]     MEM_WB_ALU;
    reg                            MEM_WB_JAL;
    reg    [NBITS-1        :0]     MEM_WB_PC8;
    reg    [REGS-1         :0]     MEM_WB_RegistroDestino;

    wire   [NBITS-1        :0]     WB_DatoEscritura_o;
    wire   [NBITS-1        :0]     WB_EscribirDato_o;
    wire   [REGS-1         :0]     WB_RegistroDestino_o;


WB u_WB(
    .MEM_WB_LUI(MEM_WB_LUI),
    .MEM_WB_Extension(MEM_WB_Extension),
    .MEM_WB_DatoMemoria(MEM_WB_DatoMemoria),
    .MEM_WB_TamanoFiltroL(MEM_WB_TamanoFiltroL),
    .MEM_WB_ZeroExtend(MEM_WB_ZeroExtend),
    .MEM_WB_MemToReg(MEM_WB_MemToReg),
    .MEM_WB_ALU(MEM_WB_ALU),
    .MEM_WB_JAL(MEM_WB_JAL),
    .MEM_WB_PC8(MEM_WB_PC8),
    .MEM_WB_RegistroDestino(MEM_WB_RegistroDestino),
    .WB_DatoEscritura_o(WB_DatoEscritura_o),
    .WB_EscribirDato_o(WB_EscribirDato_o),
    .WB_RegistroDestino_o(WB_RegistroDestino_o)
);

    initial begin
      
        $dumpfile("dump.vcd"); $dumpvars;

        #20
        i_clk = 1'b0;
        //reset = 1'b1;
        #20
        //reset = 1'b0;
        #20

        #100
        $display("############# Test OK ############");
        $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;

endmodule