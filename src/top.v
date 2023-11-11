`timescale 1ns / 1ps

module TOP
    #(
        parameter NBITS             = 32,
        parameter DATA_BITS         = 8,
        parameter REGS              = 5,
        parameter SIZE_MEM_DATOS    = 16,
        parameter SIZE_MEM_INSTR    = 256,
        parameter SIZE_REGISTROS    = 32,
        parameter CLK_FREQ          = 50000000,
        parameter BAUD_RATE         = 9600,
        parameter RX_DIV_SAMP       = 16
    )
    (
        input   wire                                i_clk    ,
        input   wire                                i_reset  ,
        input   wire                                i_uart_rx,
        output  wire                                o_uart_tx,
        //output  wire   [DATA_BITS-1:0]       uart_rx_data,
        output  wire        [3:0]                   o_debug_state  //conozco el estado en el que esta el debug
    );
    
    localparam  MEM_REGS_SIZE  = $clog2(SIZE_REGISTROS);
    localparam  MEM_INSTR_SIZE = $clog2(SIZE_MEM_INSTR);
    
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
    wire                                uart_rx_data_ready;
    wire                                uart_tx_start;
    wire    [DATA_BITS-1:0]             uart_tx_data;
    wire                                uart_tx_done;
    wire                                control_clk_wiz;  //segun el modo o si esta en stop,(1,0) con 1 se incrementa el clock, es control
    wire                                halt;
    wire    [DATA_BITS-1:0]             uart_rx_data;
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

    UART #(
        .CLK_FR      (CLK_FREQ),
        .BAUD_RATE   (BAUD_RATE),
        .DBIT        (DATA_BITS),
        .RX_DIV_SAMP (RX_DIV_SAMP)
        
    )
    u_UART(
        .i_clk                  (clk_wz),
        .i_reset                (i_reset),
        .i_rx_reset             (uart_rx_reset),
        .i_tx_start             (uart_tx_start),
        .i_uart_rx              (i_uart_rx),
        .i_tx_data              (uart_tx_data),
        .o_uart_tx              (o_uart_tx),
        .o_tx_done              (uart_tx_done),
        .o_rx_done              (uart_rx_data_ready),
        .o_rx_data              (uart_rx_data)
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

    always @(posedge clk_wz)
        begin
            if(i_reset) begin
                clk_wiz_count = 0;
            end else if (control_clk_wiz) begin
                clk_wiz_count = clk_wiz_count + 1;
            end
        end

endmodule