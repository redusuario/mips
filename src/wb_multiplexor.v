`timescale 1ns / 1ps

module WB_multiplexor
#(
    parameter               NB_INST         =   32,         // Longitud de registro con signo
    parameter               NB_SELECTOR     =   2           // Longitud del selector
)
(
    // INPUTS   
    input   wire    [NB_INST-1:0]               i_data_alu,
    input   wire    [NB_INST-1:0]               i_data_mem,
    input   wire                                i_selector,
    output  wire    [NB_INST-1:0]               o_mux
);

    // INTERNAL
    reg         [NB_INST-1:0]               mux;

    always @(*) begin
      if(i_selector) begin               
            mux <= i_data_alu;
      end 
      else begin
            mux <= i_data_mem;
      end
    end


    // OUTPUT
    assign o_mux = mux;
endmodule