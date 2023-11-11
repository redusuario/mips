`timescale 1ns / 1ps



module Debug
    #(
        parameter       MEM_REG_SIZE        = 32,
        parameter       MEM_DATA_SIZE       = 16,
        parameter       MEM_INST_SIZE       = 256,
        parameter       MEM_INST_BITS       = 8,
        parameter       DATA_BITS           = 8,
        parameter       NBITS               = 32,
        parameter       REGS                = 5
    )
    (
        input                                   i_clk,
        input                                   i_reset,
        input                                   i_uart_rx_ready,
        input           [DATA_BITS-1:0]         i_uart_rx_data,
        input                                   i_uart_tx_done,
        input                                   i_halt,
        input           [NBITS-1:0]             i_mips_pc,
        input           [NBITS-1 :0]            i_clk_wiz_count,
        input           [NBITS-1:0]             i_data_reg_file,
        input           [NBITS-1:0]             i_data_mem,
        output                                  o_uart_rx_reset,
        output          [DATA_BITS-1:0]         o_uart_tx_data,
        output                                  o_uart_tx_ready,
        output                                  o_control_clk_wiz,
        output          [REGS-1:0]              o_select_reg_dir,
        output          [NBITS-1:0]             o_select_mem_dir,
        output          [MEM_INST_BITS-1:0]     o_select_mem_ins_dir,
        output          [NBITS-1:0]             o_dato_mem_ins,
        output                                  o_instr_write,
        output          [3:0]                   o_debug_state
    );

    localparam IDLE           =   4'b0000; //estado inicial
    localparam CONTINUO       =   4'b0010; //'c' modo mips
    localparam STEP           =   4'b0001; //'s' modo mips
    localparam ENABLE_DATA    =   4'b0011; //'d' estado donde se habilita la escritura de la instruc, porque ya se armaron los 32 bits
    localparam SEND_DATA_TX   =   4'b0100; //  envio 8 btis
    localparam WAIT_TX        =   4'b0110; // si en contador es 0 pasa a data_init sino voy al estado para cargar otro dato, deplazo de a 8 para de los 32 solo enviar los 8 que quiero
    localparam LOAD_DATA_TX   =   4'b0111; //segun el contador se carga la data para enviar (pc, registros y ciclos)
    localparam DATA_INIT      =   4'b1000; //ARMO instruccion de 32 bits
    localparam WAIT_DATA      =   4'b1001; //Espero hatl o vuelvo a data init
    localparam CONTROL_STOP   =   2'b00; //modos para controlar el modulo clock e i_step
    localparam CONTROL_CONTINUO =   2'b01;
    localparam CONTROL_STEP     =   2'b11;
    localparam DIR_COUNT_SIZE = $clog2(MEM_INST_SIZE);
    localparam MEM_COUNT_SIZE = $clog2(MEM_DATA_SIZE);
    localparam REG_COUNT_SIZE = $clog2(MEM_REG_SIZE);


    reg                                                control_clk_wiz;
    reg               [4:0]                            state, state_next;
    reg               [3:0]                            debug_state, debug_state_next;
    reg                                                uart_rx_reset, uart_rx_reset_next;
    reg               [NBITS-1:0]                      instruccion_data, instruccion_data_next;
    reg                                                rx_inst_write, rx_inst_write_next;
    reg               [DIR_COUNT_SIZE-1:0]             count_dir_mem_instr=0, count_dir_mem_instr_next=0;
    reg               [1:0]                            rx_count_bytes=0, rx_count_bytes_next=0;
    reg               [DATA_BITS-1:0]                  uart_tx_data, uart_tx_data_next;
    reg                                                uart_tx_ready, uart_tx_ready_next;
    reg               [NBITS-1:0]                      tx_data_32, tx_data_32_next;
    reg               [1:0]                            tx_count_bytes, tx_count_bytes_next;
    reg               [2:0]                            tx_select_info_count, tx_select_info_count_next;
    reg               [REG_COUNT_SIZE-1:0]             tx_regs_count, tx_regs_count_next;
    reg               [MEM_COUNT_SIZE-1:0]             uart_tx_mem_count, uart_tx_mem_count_next;
    reg               [1:0]                            mode, mode_next;
    reg                                                mips_step, mips_step_next;

    always @ (posedge i_clk)
        begin
            if (i_reset)begin
                state                   <= IDLE;
                uart_rx_reset           <= 1;
                instruccion_data        <= 0;
                rx_count_bytes          <= 0;
                count_dir_mem_instr     <= 0;
                rx_inst_write           <= 0;
                uart_tx_data            <= 0;
                uart_tx_ready           <= 0;
                tx_count_bytes          <= 0;
                tx_select_info_count    <= 0;
                tx_regs_count           <= 0;
                uart_tx_mem_count       <= 0;
                tx_data_32              <= 0;
                mode                    <= CONTROL_STOP;
                mips_step               <= 0;
                debug_state             <= 0;
            end else begin
                debug_state             <= debug_state_next;
                state                   <= state_next;
                uart_rx_reset           <= uart_rx_reset_next;
                instruccion_data        <= instruccion_data_next;
                rx_count_bytes          <= rx_count_bytes_next;
                count_dir_mem_instr     <= count_dir_mem_instr_next;
                rx_inst_write           <= rx_inst_write_next;
                uart_tx_data            <= uart_tx_data_next;
                uart_tx_ready           <= uart_tx_ready_next;
                tx_count_bytes          <= tx_count_bytes_next;
                tx_select_info_count    <= tx_select_info_count_next;
                tx_regs_count           <= tx_regs_count_next;
                uart_tx_mem_count       <= uart_tx_mem_count_next;
                tx_data_32              <= tx_data_32_next;
                mode                    <= mode_next;
                mips_step               <= mips_step_next;
            end
        end

    always @*
    begin
        state_next                <= state;
        debug_state_next          <= debug_state;
        uart_rx_reset_next        <= uart_rx_reset;
        instruccion_data_next     <= instruccion_data;
        rx_count_bytes_next       <= rx_count_bytes;
        count_dir_mem_instr_next  <= count_dir_mem_instr;
        rx_inst_write_next        <= rx_inst_write;
        uart_tx_data_next         <= uart_tx_data;
        uart_tx_ready_next        <= uart_tx_ready;
        tx_count_bytes_next       <= tx_count_bytes;
        tx_select_info_count_next <= tx_select_info_count;
        tx_regs_count_next        <= tx_regs_count;
        uart_tx_mem_count_next    <= uart_tx_mem_count;
        tx_data_32_next           <= tx_data_32;
        mode_next                 <= mode;
        mips_step_next            <= mips_step;

        case (state)
            IDLE:
            begin
                debug_state_next <= 1;
                if (~i_uart_rx_ready) begin// Verifica si hay data ready desde rx
                    uart_rx_reset_next  <= 0;
                end else begin // Verifica el char recibido para ir a un estado
                    uart_rx_reset_next  <= 1;
                    case(i_uart_rx_data)
                        8'b01100011:    state_next          <= CONTINUO; //espero una c 
                        8'b01110011:    state_next          <= STEP; //espero una s
                        8'b01100100:    state_next          <= DATA_INIT; //d
                        default:        state_next          <= IDLE; //si no es nada bueno al inicio
                    endcase
                end
            end
            CONTINUO:
            begin
                mode_next  <= CONTROL_CONTINUO;
                if( i_halt ) begin
                    mode_next  <= CONTROL_STOP;
                    state_next      <= LOAD_DATA_TX;
                end
            end
            STEP:
            begin
                debug_state_next <= 2;
                mode_next      <= CONTROL_STEP;
                if( i_halt ) begin
                    mode_next  <= CONTROL_STOP;
                    state_next      <= LOAD_DATA_TX;
                end
                if(mips_step) begin
                    mips_step_next <= 0;
                    state_next     <= LOAD_DATA_TX;
                end else begin
                    if (~i_uart_rx_ready) begin// Verifica si hay datos listos desde la UART
                        uart_rx_reset_next  <= 0;
                    end else begin // Verifica si el char recibido es n (next)
                        uart_rx_reset_next  <= 1;
                        if( i_uart_rx_data == 8'b01101110) begin             //VERIFICO si es N, siguiente
                            mips_step_next <= 1;
                        end
                    end
                end
            end
            DATA_INIT:
            begin
                debug_state_next <= 3;
                if (~i_uart_rx_ready) begin// Verifica si hay datos listos desde la UART
                    uart_rx_reset_next  <= 0;
                end else begin // Verifica el char recibido
                    uart_rx_reset_next      <= 1;
                    instruccion_data_next   <= {instruccion_data [23:0], i_uart_rx_data};
                    rx_count_bytes_next     <= rx_count_bytes + 1;
                    state_next              <= ENABLE_DATA;
                end
            end
            ENABLE_DATA: //si desbordo el contador, es porque tengo los 32 bits y habilito la esritura sino sigo concatenando los 8 btis en data init
            begin
                debug_state_next <= 4; //solo indico que en estado estoy
                if(rx_count_bytes == 0) begin
                    rx_inst_write_next      <= 1; //habilito la escritura en el reg de instrucciones
                    state_next              <= WAIT_DATA;
                end else begin
                    state_next              <= DATA_INIT;
                end
            end
            WAIT_DATA: //si recibie un halt vuelvo el estaaado inicial, sino armaro otra instruccion de a 1 byte en data init
            begin
                debug_state_next                      <= 5;
                rx_inst_write_next                    <= 0;
                if(instruccion_data == 32'b11111111111111111111111111111111) begin //HALT
                    count_dir_mem_instr_next      <= 0;
                    state_next                    <= IDLE;
                end else begin
                    count_dir_mem_instr_next       <= count_dir_mem_instr + 4; //Aumenta en 4 la direccion
                    state_next                    <= DATA_INIT;
                end
            end
            LOAD_DATA_TX:
            begin
                debug_state_next <= 6;
                case(tx_select_info_count)
                    0: // Envia el dato de PC del MIPS
                    begin
                        tx_data_32_next           <= i_mips_pc;
                        tx_select_info_count_next <= tx_select_info_count + 1;
                        state_next                <= SEND_DATA_TX;
                    end
                    1: // se envia numero de ciclos realizados en total desde el inicio
                    begin
                        tx_data_32_next           <= i_clk_wiz_count;
                        tx_select_info_count_next <= tx_select_info_count + 1;
                        state_next                <= SEND_DATA_TX;
                    end
                    2: // envio data de los 32 registros
                    begin
                        tx_data_32_next         <= i_data_reg_file;
                        tx_regs_count_next      <= tx_regs_count + 1;
                        if(tx_regs_count == MEM_REG_SIZE-1) begin
                            tx_select_info_count_next <= tx_select_info_count + 1;
                        end
                        state_next              <= SEND_DATA_TX;
                    end
                    3: //Envio el contenido del reg de data memory
                    begin
                        tx_data_32_next        <= i_data_mem;
                        uart_tx_mem_count_next <= uart_tx_mem_count + 1;
                        if(uart_tx_mem_count == MEM_DATA_SIZE-1) begin
                            tx_select_info_count_next <= tx_select_info_count + 1;
                        end
                        state_next              <= SEND_DATA_TX;
                    end
                    4: // cuando termino de envitar toda la data y se vuelve a IDLE o STEP
                    begin
                        tx_select_info_count_next  <= 0;
                        if(mode  == CONTROL_STEP) begin
                            state_next           <= STEP;
                        end else begin
                            state_next           <= IDLE;
                        end
                    end
                    default:
                    begin
                        tx_select_info_count_next  <= 0;
                        state_next               <= IDLE;
                    end
                endcase
            end
            SEND_DATA_TX:
            begin
                debug_state_next <= 7;
                uart_tx_data_next       <= tx_data_32[ NBITS-1: NBITS - DATA_BITS];
                uart_tx_ready_next      <= 1;
                if(~i_uart_tx_done) begin
                   uart_tx_ready_next       <= 0;
                   tx_count_bytes_next      <= tx_count_bytes +1;
                   state_next               <= WAIT_TX;
                end
            end
            WAIT_TX:
            begin
                debug_state_next <= 8;
                if(i_uart_tx_done) begin
                    if(tx_count_bytes == 0) begin
                        state_next <= LOAD_DATA_TX;
                    end else begin
                        tx_data_32_next       <= tx_data_32 << 8;
                        state_next             <= SEND_DATA_TX;
                    end
                end
            end
           default:
                state_next <= IDLE; //default idle
         endcase
    end

    //Control el del modulo clock segun el modo
    always @*
    begin
        case(mode)
            CONTROL_CONTINUO:   control_clk_wiz <= 1'b1;
            CONTROL_STEP:       control_clk_wiz <= mips_step;
            CONTROL_STOP:       control_clk_wiz <= 1'b0;
            default:            control_clk_wiz <= 1'b0;
        endcase
    end

    assign o_debug_state        = debug_state;
    assign o_uart_tx_ready      = uart_tx_ready;
    assign o_uart_tx_data       = uart_tx_data;
    assign o_uart_rx_reset      = uart_rx_reset;
    assign o_control_clk_wiz    = control_clk_wiz;
    assign o_select_reg_dir     = tx_regs_count;
    assign o_select_mem_dir     = uart_tx_mem_count;
    assign o_select_mem_ins_dir = count_dir_mem_instr;
    assign o_dato_mem_ins       = instruccion_data;
    assign o_instr_write        = rx_inst_write;

endmodule