`timescale 1ns / 1ps

module ControlUnit(
		input wire [5:0] opcode, funct,
		input wire [4:0] rs, rt,
		output wire o_ContrlUnit_sImme, o_ContrlUnit_sA0, o_ContrlUnit_sA, o_ContrlUnit_sB, o_ContrlUnit_sWRA0, o_ContrlUnit_sWRA, o_ContrlUnit_sWRD, o_ContrlUnit_sLoad, o_ContrlUnit_sByte, o_ContrlUnit_sign,
		output wire [4:0] o_ContrlUnit_aluOP,
		output wire [3:0] o_ContrlUnit_brOP,
		output wire o_ContrlUnit_dMemWe, o_ContrlUnit_regWe
	);
	
	wire [5:0] i_type;
	assign i_type = (opcode==6'b001000) ? 17:							   // addi
					(opcode==6'b001001) ? 18:							   // addiu
					(opcode==6'b001100) ? 19:							   // andi
					(opcode==6'b001101) ? 20:							   // ori
					(opcode==6'b001110) ? 21:							   // xori
					(opcode==6'b001111) ? 22:							   // lui
					(opcode==6'b100011) ? 23:							   // lw
					(opcode==6'b100000) ? 24:							   // lb
					(opcode==6'b101011) ? 25:							   // sw
					(opcode==6'b101000) ? 26:							   // sb
					(opcode==6'b001010) ? 27:							   // slti
					(opcode==6'b001011) ? 28:							   // sltiu
					(opcode==6'b000001) ? 29:							   // b1
					(opcode==6'b000100) ? 30:							   // b100
					(opcode==6'b000101) ? 31:							   // bne
					(opcode==6'b000110) ? 32:							   // bnlez
					(opcode==6'b000111) ? 33:							   // bgtz
					(opcode==6'b000010) ? 34:							   // j
					(opcode==6'b000011) ? 35:							   // jal
					((opcode==6'b000000) && (funct==6'b100000)) ? 0 :	   // add
					((opcode==6'b000000) && (funct==6'b100001)) ? 1 :	   // addu
					((opcode==6'b000000) && (funct==6'b100010)) ? 2 :	   // sub
					((opcode==6'b000000) && (funct==6'b100011)) ? 3 :	   // subu
					((opcode==6'b000000) && (funct==6'b100100)) ? 4 :	   // and
					((opcode==6'b000000) && (funct==6'b100101)) ? 5 :	   // or
					((opcode==6'b000000) && (funct==6'b100110)) ? 6 :	   // xor
					((opcode==6'b000000) && (funct==6'b100111)) ? 7 :	   // nor
					((opcode==6'b000000) && (funct==6'b101010)) ? 8 :	   // slt
					((opcode==6'b000000) && (funct==6'b101011)) ? 9 :	   // sltu
					((opcode==6'b000000) && (funct==6'b000000)) ? 10 :	  // sll
					((opcode==6'b000000) && (funct==6'b000010)) ? 11 :	  // srl
					((opcode==6'b000000) && (funct==6'b000011)) ? 12 :	  // sra
					((opcode==6'b000000) && (funct==6'b000100)) ? 13 :	  // sllv
					((opcode==6'b000000) && (funct==6'b000110)) ? 14 :	  // srlv
					((opcode==6'b000000) && (funct==6'b000111)) ? 15 :	  // srav
					((opcode==6'b000000) && (funct==6'b001000)) ? 16 :	  // jr
					36;
	//
	assign o_ContrlUnit_brOP = (i_type==16) ? 1 :							// jrd
					(i_type==34) ? 2 :										// j
					(i_type==35) ? 3 :										// jal
					((i_type==29)&&(rs==5'b00000)&&(rt==5'b10001)) ? 4 :	// bal
					((i_type==29)&&(rt==5'b10001)) ? 5 :					// bgezal
					((i_type==29)&&(rt==5'b00000)) ? 6 :					// bltz
					((i_type==29)&&(rt==5'b00001)) ? 7 :					// bgez
					((i_type==29)&&(rt==5'b10000)) ? 8 :					// bltzal
					((i_type==30)&&(rs==5'b00000)&&(rt==5'b00000)) ? 9 :	// b
					(i_type==30) ? 10 :										// beq
					(i_type==31) ? 11 :										// bne
					(i_type==32) ? 12 :										// blez
					(i_type==33) ? 13 :										// bgtz
					0;														// err
	wire al;
	assign al = (o_ContrlUnit_brOP==3)||(o_ContrlUnit_brOP==4)||(o_ContrlUnit_brOP==5)||(o_ContrlUnit_brOP==8);

	assign o_ContrlUnit_aluOP = ((i_type==0)||(i_type==1)||(i_type==17)||(i_type==18)||(i_type==23)||(i_type==24)||(i_type==25)||(i_type==26)) ? 1:	// add
					((i_type==2)||(i_type==3)) ? 2 :						// sub
					((i_type==4)||(i_type==19)) ? 3 :						// and
					((i_type==5)||(i_type==20)) ? 4 :						// or
					((i_type==6)||(i_type==21)) ? 5 :						// xor
					i_type==7 ? 6 :											// nor
					((i_type==8)||(i_type==27)) ? 7 :						// slt
					((i_type==9)||(i_type==28)) ? 8 :						// sltu
					((i_type==10)||(i_type==13)) ? 9 :						// sl
					((i_type==11)||(i_type==14)) ? 10 :						// sr
					((i_type==12)||(i_type==15)) ? 11 :						// sra
					i_type==22 ? 12 :										// lui
					((al==1)||(i_type==35)) ? 13 :							// xal
					0;														// nop
	// imme or sa
	assign o_ContrlUnit_sImme = ((i_type>=10)&&(i_type<=12)) ? 1 : 0;
	// rs or pc
	assign o_ContrlUnit_sA0 = (al==1) ? 1 : 0;
	// rs or imme
	assign o_ContrlUnit_sA = ((i_type>=10)&&(i_type<=12)) ? 1 : 0;
	// rt or imme
	assign o_ContrlUnit_sB = ((i_type>=17)&&(i_type<=28)) ? 1 : 0;
	// rt or rd
	assign o_ContrlUnit_sWRA0 = (((i_type>=17)&&(i_type<=24))||(i_type==27)||(i_type==28)) ? 0 : 1;
	// normal or al
	assign o_ContrlUnit_sWRA = (al==1) ? 1 : 0;
	// alu or dmem
	assign o_ContrlUnit_sWRD = ((i_type==23)||(i_type==24)) ? 1 : 0;
	// write?
	assign o_ContrlUnit_dMemWe = ((i_type==25)||(i_type==26)) ? 1 : 0;
	// writr?
	assign o_ContrlUnit_regWe = ((i_type==25)||(i_type==26)||(i_type==16)||((i_type>=29)&&(i_type<=35))) ? 0 : 1;
	// lw or lb
	assign o_ContrlUnit_sLoad = ((i_type==23)||(i_type==24)) ? 1 : 0;
	// sw or sb
	assign o_ContrlUnit_sByte = ((i_type==24)||(i_type==26)) ? 1 : 0;
	// u?
	assign o_ContrlUnit_sign = ((i_type==1)||(i_type==3)||(i_type==9)||(i_type==18)||(i_type==28)) ? 0 : 1;
endmodule