// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_top();

        localparam NBITS             = 32;
        localparam DATA_BITS         = 8;
        localparam REGS              = 5;
        localparam SIZE_MEM_DATOS    = 16;
        localparam SIZE_MEM_INSTR    = 256;
        localparam SIZE_REGISTROS    = 32;
        localparam CLK_FREQ          = 50000000;
        localparam BAUD_RATE         = 9600;
        localparam RX_DIV_SAMP       = 16;
        
    localparam  MEM_REGS_SIZE  = $clog2(SIZE_REGISTROS);
    localparam  MEM_INSTR_SIZE = $clog2(SIZE_MEM_INSTR);
    
    reg                                 i_clk;
    reg                                 i_reset;
    wire                                o_uart_tx;
    wire        [3:0]                   o_debug_state;
    reg     [NBITS-1:0]                 clk_wiz_count;  //contador de ciclos a enviar
    wire                                clk_wz;
    wire    [NBITS-1:0]                 pc;
    wire    [MEM_REGS_SIZE-1:0]         select_reg_dir; //se incrementa en 1 para que mips manda a la salida el valor de ese reg_file
    wire    [NBITS-1:0]                 data_reg_file; //valor del reg_file enviado desde mips
    wire    [NBITS-1:0]                 select_mem_dir;
    wire    [NBITS-1:0]                 data_mem;
    wire    [MEM_INSTR_SIZE-1:0]        select_mem_ins_dir;    //lo mandamos pero no lo mostramos en pantalla
    wire    [NBITS-1:0]                 dato_mem_ins;
    wire                                write_mem_ins;   //cuando recibi el dato(rx) se pone a 1 para escribir mem instruc
    reg                                uart_rx_data_ready;
    wire                                uart_tx_start;
    wire    [DATA_BITS-1:0]             uart_tx_data;
    wire                                uart_tx_done;
    wire                                control_clk_wiz;  //segun el modo o si esta en stop, el clock se incrementa o no (1 o 0)
    wire                                halt;
    reg    [DATA_BITS-1:0]             uart_rx_data;
    wire                                uart_rx_reset;
    
   clk_wiz_0 clk_wiz
   (
    .clk_out1(clk_wz),     // output clk_out50MHz
    .reset(i_reset), // input reset
    .locked(locked),       // output locked
    .clk_in1(i_clk)
    );  
    
    
     MIPS #(
        .NBITS          (NBITS),
        .SIZE_REG       (SIZE_REGISTROS),
        .SIZE_M         (SIZE_MEM_DATOS),
        .SIZE_INSTRUC   (SIZE_MEM_INSTR),
        .REGS           (REGS)
    )
    u_MIPS
    (
        .i_clk                          (clk_wz),
        .i_reset                        (i_reset),
        .i_control_clk_wiz              (control_clk_wiz),
        .i_select_reg_dir               (select_reg_dir),
        .i_select_mem_dir               (select_mem_dir),
        .i_select_mem_ins_dir           (select_mem_ins_dir),
        .i_dato_mem_ins                 (dato_mem_ins),
        .i_write_mem_ins                (write_mem_ins),
        .o_pc                           (pc),
        .o_data_reg_file                (data_reg_file),
        .o_data_mem                     (data_mem),
        .o_mips_halt                    (halt)
    );



    tx #(
        .CLK_FR     (CLK_FREQ),
        .BAUD_RATE  (BAUD_RATE),
        .DBIT       (DATA_BITS)
    )
    u_tx (
        .i_clk                  (clk_wz),
        .i_reset                (i_reset),
        .i_tx_start             (uart_tx_start),
        .i_data                 (uart_tx_data),
        .o_tx_data              (o_uart_tx),
        .o_tx_done              (uart_tx_done)
    );

    Debug #(
        .DATA_BITS  (DATA_BITS),
        .NBITS      (NBITS)
    )
    u_Debug
    (
        .i_clk                  (clk_wz),
        .i_reset                (i_reset),
        .i_uart_rx_ready        (uart_rx_data_ready),
        .i_uart_rx_data         (uart_rx_data),
        .i_uart_tx_done         (uart_tx_done),
        .i_halt                 (halt),
        .i_clk_wiz_count        (clk_wiz_count),
        .i_mips_pc              (pc),
        .i_data_reg_file        (data_reg_file),
        .i_data_mem             (data_mem),
        .o_uart_rx_reset        (uart_rx_reset),
        .o_uart_tx_data         (uart_tx_data),
        .o_uart_tx_ready        (uart_tx_start),
        .o_control_clk_wiz      (control_clk_wiz),
        .o_select_reg_dir       (select_reg_dir),
        .o_select_mem_dir       (select_mem_dir),
        .o_select_mem_ins_dir   (select_mem_ins_dir),
        .o_dato_mem_ins         (dato_mem_ins),
        .o_instr_write          (write_mem_ins),
        .o_debug_state          (o_debug_state)
     );
    
    
    initial begin

      i_clk = 1'b0;
      uart_rx_data_ready=1'b0;
      i_reset=1'b1;
      #20
      i_reset=1'b0;
      #30
      uart_rx_data=8'b01100100;  //mando una d para que debug vaya al estado init
      uart_rx_data_ready=1'b1;
      #1110
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b00000000;
      #60
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b00000000;
      #60
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b00000000;
      #60
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b00000000;
      #60
      uart_rx_data_ready=1'b0;
   //      OPCODE      RS          RT      RD      SHAMT       FUNCT
    //ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
    //      000000     00001      00010   00100     00000       100000
  
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b00000000;
      #60
      uart_rx_data_ready=1'b0;    
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b00100010;
      #60
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data=8'b00100000;
      uart_rx_data_ready=1'b1;
      #60
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b00100000;
      #100
      uart_rx_data_ready=1'b0;
      #80
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b11111111;
      #100
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b11111111;
      #50
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b11111111;
      #50
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b11111111;
      #100
      uart_rx_data_ready=1'b0;
      #20
      uart_rx_data_ready=1'b1;
      uart_rx_data=8'b01100011;
      #200
      uart_rx_data_ready=1'b0;


       
      $finish();
    end
  
      // CLOCK_GENERATION
    always #10 i_clk = ~i_clk;
    
    always @(posedge clk_wz)
        begin
            if(i_reset) begin
                clk_wiz_count = 0;
            end else if (control_clk_wiz) begin
                clk_wiz_count = clk_wiz_count + 1;
            end
        end
endmodule