`timescale 1ns / 1ps



module IE_multiplexor_A
#(
    parameter               NB_INST         =   32,         // Longitud de registro con signo
    parameter               NB_SELECTOR     =   2           // Longitud del selector
)
(
    // INPUTS   
    input   wire    [NB_INST-1:0]               i_decodificador_rs,
    input   wire    [NB_INST-1:0]               i_sign_extend,
    input   wire                                i_selector,
    output  wire    [NB_INST-1:0]               o_mux
);

    // INTERNAL
    reg         [NB_INST-1:0]               mux;

    always @(*) begin
      if(i_selector) begin               
            mux <= i_sign_extend;
      end 
      else begin
            mux <= i_decodificador_rs;
      end
    end


    // OUTPUT
    assign o_mux = mux;
endmodule