`timescale 1ns / 1ps

module ControlUnit(
		input wire [5:0] i_ControlUnit_opcode,
		input wire [5:0] i_ControlUnit_funct,
		output wire o_ContrlUnit_sA1, o_ContrlUnit_sA2, o_ContrlUnit_sB, o_ContrlUnit_swa, o_ContrlUnit_swd, o_ContrlUnit_isLoad, o_ContrlUnit_sign
		output wire o_ContrlUnit_sALU,
		output wire o_ContrlUnit_BRop,
		output wire o_ContrlUnit_dMemWe, o_ContrlUnit_regWe
	);
	
	// todo

endmodule