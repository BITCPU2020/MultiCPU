`timescale 1ns / 1ps

module ControlUnit(
		input wire [5:0] i_ControlUnit_opcode, i_ControlUnit_funct,
		input wire [4:0] rs, rt,
		output wire o_ContrlUnit_sA1, o_ContrlUnit_sA2, o_ContrlUnit_sB, o_ContrlUnit_swa, o_ContrlUnit_swd, o_ContrlUnit_isLoad, o_ContrlUnit_sign,
		output wire [4:0] o_ContrlUnit_sALU,
		output wire [3:0] o_ContrlUnit_BRop,
		output wire o_ContrlUnit_dMemWe, o_ContrlUnit_regWe
	);
	
	wire [5:0] i_type;
	assign i_type = (opcode==6'b001000) ? 17: // addi
                    (opcode==6'b001001) ? 18: // addiu
                    (opcode==6'b001100) ? 19: // andi
                    (opcode==6'b001101) ? 20: // ori
                    (opcode==6'b001110) ? 21: // xori
                    (opcode==6'b001111) ? 22: // lui
                    (opcode==6'b100011) ? 23: // lw
                    (opcode==6'b100000) ? 24: // lb
                    (opcode==6'b101011) ? 25: // sw
                    (opcode==6'b101000) ? 26: // sb
                    (opcode==6'b001010) ? 27: // slti
                    (opcode==6'b001011) ? 28: // sltiu
                    (opcode==6'b000001) ? 29: // b1
                    (opcode==6'b000100) ? 30: // b100
                    (opcode==6'b000101) ? 31: // bne
                    (opcode==6'b000110) ? 32: // bnlez
                    (opcode==6'b000111) ? 33: // bgtz
                    (opcode==6'b000010) ? 34: // j
                    (opcode==6'b000011) ? 35: // jal
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 0 : // add
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 1 : // addu
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 2 : // sub
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 3 : // subu
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 4 : // and
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 5 : // or
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 6 : // xor
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 7 : // nor
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 8 : // slt
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 9 : // sltu
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 10 : // sll
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 11 : // srl
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 12 : // sra
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 13 : // sllv
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 14 : // srlv
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 15 : // srav
                    ((opcode==6'b000000) && (funct==6'b100000)) ? 16 : // jrd
                    36;
    assign o_ContrlUnit_BRop = (i_type==16) ? 0 :									// jrd
    						(i_type==34) ? 1 :										// j
    						(i_type==35) ? 2 :										// jal
    						((i_type==29)&&(rs==5'b00000)&&(rt==5'b10001)) ? 3 :	// bal
    						((i_type==29)&&(rt==5'b10001)) ? 4 :					// bgezal
    						((i_type==29)&&(rt==5'b00000)) ? 5 :					// bltz
    						((i_type==29)&&(rt==5'b00001)) ? 6 :					// bgez
    						((i_type==29)&&(rt==5'b10000)) ? 7 :					// bltzal
    						((i_type==30)&&(rs==5'b10000)&&(rt==5'b00000)) ? 8 :	// b
    						(i_type==30) ? 9 :										// beq
    						(i_type==31) ? 10 :										// bne
    						(i_type==32) ? 11 :										// blez
    						(i_type==33) ? 12 :										// bgtz
    						13;														// err
    wire al;
    assign al = (o_ContrlUnit_BRop==2)||(o_ContrlUnit_BRop==3)||(o_ContrlUnit_BRop==4)||(o_ContrlUnit_BRop==7);
    // 0前1后
    // sa和立即数做第一操作数(c)
    assign o_ContrlUnit_sA1 = ((i_type>=10)&&(i_type<=15)) ? 0 : 1;
    // rs和tempA做第一操作数(c3)
    assign o_ContrlUnit_sA2 = ((i_type>=17)&&(i_type<=22)) ? 0 : 1;
    // rt和立即数做第二操作数(c1)
    assign o_ContrlUnit_sB = ((i_type>=17)&&(i_type<=28)) ? 1 : 0;
    // rd和rt做目的寄存器(c2)
    assign o_ContrlUnit_swa = (i_type!=22) ? 0 : 1;
    // ALU和dMem做写回数据(c4)
    assign o_ContrlUnit_swd = 
    assign o_ContrlUnit_sALU = ((i_type==0)||(i_type==1)||(i_type==17)||(i_type==18)) ? 0:	// add
    						((i_type==2)||(i_type==3)) ? 1 :	// sub
    						((i_type==4)||(i_type==19)) ? 2 :	// and
    						((i_type==5)||(i_type==20)) ? 3 :	// or
    						((i_type==6)||(i_type==21)) ? 4 :	// xor
    						i_type==7 ? 5 :						// nor
    						i_type==8 ? 6 :						// slt
    						i_type==9 ? 7 :						// sltu
    						((i_type==10)||(i_type==13)) ? 8 :	// sl
    						((i_type==11)||(i_type==14)) ? 9 :	// sr
    						((i_type==12)||(i_type==15)) ? 10 :	// sra
    						i_type==22 ? 11 :					// lui
    						((al==1)||(i_type==35)) ? 12 :		// al
    						13;									// err
    assign o_ContrlUnit_dMemWe = ((i_type==25)||(i_type==26)) ? 1 : 0;
    assign o_ContrlUnit_regWe = ((i_type==25)||(i_type==26)||(i_type==16)||((i_type>=29)&&(i_type<=35))) ? 0 : 1;
    assign o_ContrlUnit_isLoad = ((i_type==23)||(i_type==24)) ? 1 : 0;
    assign o_ContrlUnit_sign = ((i_type==1)||(i_type==3)||(i_type==9)||(i_type==18)||(i_type==28)) ? 0 : 1;

endmodule