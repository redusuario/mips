`timescale 1ns / 1ps


module ID_control
#(
	parameter				NB_OPCODE		=	6
)
(
	// INPUTS
    input wire	[NB_OPCODE-1:0]				i_opcode,

    // OUTPUTS
   	output wire								o_signal_control_mult_A,
   	output wire								o_signal_control_mult_B
);

	localparam 						R_instruc = 6'b000000;								

	reg       						signal_control_mult_A;
	reg       						signal_control_mult_B;

	always @(*) begin
		casez (i_opcode)
			
			R_instruc :
				begin
					signal_control_mult_A   = 1'b1;
					signal_control_mult_B   = 1'b1;
				end

			default :
				begin
					signal_control_mult_A   = 1'b0;
					signal_control_mult_B   = 1'b0;

				end
		endcase
	end

	// OUTPUT
	assign o_signal_control_mult_A 	= signal_control_mult_A;
	assign o_signal_control_mult_B  = signal_control_mult_B;


endmodule