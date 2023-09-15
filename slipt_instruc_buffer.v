module instruc_buffer (
    input wire clk,               // Señal de reloj
    input wire reset,             // Señal de reinicio asincrónico (opcional)
    input wire tx_done_tick,
    input wire enviar,
    input wire wr,
    input wire [31:0] entrada,    // Entrada de 32 bits
    output reg [7:0] parte,      // Parte de 8 bits a enviar
    output reg done,              // Señal que indica cuando se han enviado todas las partes
    output wire empty
);

reg [31:0] registro;             // Registro para almacenar la entrada actual
//reg [31:0] cola[0:7];             // Cola de entradas (hasta 8 entradas)
reg [31:0] cola[0:240];          //cola hasta 240 entrada (60 instrucciones)
reg [2:0] contador;              // Contador para rastrear las partes de 8 bits a enviar
//reg [2:0] contador_cola;         // Contador para rastrear las partes de 8 bits de la cola
integer contador_cola;
reg cola_llena;                  // Indica si la cola está llena
wire cola_vacia;                 // Indica si la cola está vacía
integer i=0;
assign cola_vacia = (contador_cola == 0 && contador==0);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Si la señal de reinicio es alta, borramos el registro, contador, y cola
        registro <= 32'h0;
        contador <= 3'b0;
         parte <= 0;
        for ( i = 0; i < 8; i = i + 1) begin
            cola[i] <= 32'h0;
        end
        cola_llena <= 0;
        //contador_cola <= 3'b0;
        contador_cola <= 0;
    end else begin
        // Capturamos la entrada nueva en la cola si no está llena
        if (!cola_llena && enviar) begin                          // SOLO GUARTDA CUANDO ALGO ME INDIQUE
            cola[contador_cola] <= entrada;
            //cola_llena <= (contador_cola == 3'b111);
            cola_llena <= (contador_cola == 240);
            contador_cola <= contador_cola + 1;
        end

        // Lógica para seleccionar la entrada actual
     //   if (contador == 3'b000 && !cola_vacia) begin
            registro <= cola[0];
      //  end

        // Lógica para enviar las partes de la entrada actual
        //if(tx_done_tick || wr)begin //envio si aprieto pulsador o cuando tx ya termino para comenzar con el siguiente
        if(tx_done_tick || wr)begin
        case (contador)       //para comenzar si o si debo aprentar el pulsado
            3'b000: parte <= registro[31:24];    //lo envio en el mismo clock
            3'b001: parte <= registro[23:16];
            3'b010: parte <= registro[15:8];
            3'b011: parte <= registro[7:0];                    //// cambie aca el = y en registo = cola
            default: parte <= 8'h0;
        endcase
        end
        // Lógica para actualizar el contador
        if (contador == 3'b011 && tx_done_tick) begin
            contador <= 3'b000;
            // Eliminamos la entrada actual de la cola
            if (!cola_vacia) begin
                for ( i = 0; i < 7; i = i + 1) begin
                    cola[i] <= cola[i + 1];
                end
                //cola[7] <= 32'h0;
                cola[contador_cola] <= 32'h0;
                contador_cola <= contador_cola - 1;     
                //cola_llena <= (contador_cola == 3'b111);
                cola_llena <= (contador_cola == 240);
               
            end
        end else begin
            //if(tx_done_tick || wr)begin
            if(tx_done_tick || wr)begin
            contador <= contador + 1;
        end
        end
    end
end

always @(posedge clk) begin
    // Determinar cuando se han enviado todas las partes
    done = (contador == 3'b011 && cola_vacia);
end

assign empty=~cola_vacia;

endmodule
