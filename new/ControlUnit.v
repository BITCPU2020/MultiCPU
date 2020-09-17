`timescale 1ns / 1ps

module ControlUnit(
		input wire [5:0] i_ControlUnit_opcode,
		input wire [5:0] i_ControlUnit_funct,
		output wire o_ContrlUnit_sA1, o_ContrlUnit_sA2, o_ContrlUnit_sB, o_ContrlUnit_swa, o_ContrlUnit_swd, o_ContrlUnit_isLoad, o_ContrlUnit_sign,
		output wire o_ContrlUnit_sALU,
		output wire o_ContrlUnit_BRop,
		output wire o_ContrlUnit_dMemWe, o_ContrlUnit_regWe
	);
	
	wire [5:0] i_type;
	assign i_type = (opcode==6'b001000) ? 16: // addi
                    (opcode==6'b001001) ? 17: // addiu
                    (opcode==6'b100011) ? 18: // andi
                    (opcode==6'b101011) ? 19: // ori
                    (opcode==6'b000100) ? 20: // xori
                    (opcode==6'b000010) ? 21: // lui
                    (opcode==6'b000101) ? 22: // lw
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 7 : 8;

endmodule