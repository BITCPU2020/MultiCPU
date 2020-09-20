`timescale 1ns / 1ps

module sim_ctrl();

	reg [5:0] opcode, funct;
	reg [4:0] rs, rt;
	wire sImme, sA0, sA, sB, sWRA0, sWRA, sWRD, sLoad, sByte, sign, dMemWe, regWe;
	wire [4:0] aluOP;
	wire [3:0] brOP;

		ControlUnit ctrl(
		.opcode						(opcode),
		.funct						(funct),
		.rs							(rs),
		.rt							(rt),
		.o_ContrlUnit_sImme			(sImme),
		.o_ContrlUnit_sA0			(sA0),
		.o_ContrlUnit_sA			(sA),
		.o_ContrlUnit_sB			(sB),
		.o_ContrlUnit_sWRA0			(sWRA0),
		.o_ContrlUnit_sWRA			(sWRA),
		.o_ContrlUnit_sWRD			(sWRD),
		.o_ContrlUnit_sLoad			(sLoad),
		.o_ContrlUnit_sByte			(sByte),
		.o_ContrlUnit_sign			(sign),
		.o_ContrlUnit_aluOP			(aluOP),
		.o_ContrlUnit_brOP			(brOP),
		.o_ContrlUnit_dMemWe		(dMemWe),
		.o_ContrlUnit_regWe			(regWe)
		);
	
	always begin
		#20
		opcode=6'b000000;
		funct=6'b100000;		// 0 add
		rs = 5'b11111;
		rt = 5'b11111;
		#20
		opcode=6'b000000;
		funct=6'b100001;		// 1 addu
		#20
		opcode=6'b000000;
		funct=6'b100010;		// 2 sub
		#20
		opcode=6'b000000;
		funct=6'b100011;		// 3 subu
		#20
		opcode=6'b000000;
		funct=6'b100100;		// 4 and
		#20
		opcode=6'b000000;
		funct=6'b100101;		// 5 or
		#20
		opcode=6'b000000;
		funct=6'b100110;		// 6 xor
		#20
		opcode=6'b000000;
		funct=6'b100111;		// 7 nor
		#20
		opcode=6'b000000;
		funct=6'b101010;		// 8 slt
		#20
		opcode=6'b000000;
		funct=6'b101011;		// 9 sltu
		#20
		opcode=6'b000000;
		funct=6'b000000;		// 10 sll
		#20
		opcode=6'b000000;
		funct=6'b000010;		// 11 srl
		#20
		opcode=6'b000000;
		funct=6'b000011;		// 12 sra
		#20
		opcode=6'b000000;
		funct=6'b000100;		// 13 sllv
		#20
		opcode=6'b000000;
		funct=6'b000110;		// 14 srlv
		#20
		opcode=6'b000000;
		funct=6'b000111;		// 15 srav
		#20
		opcode=6'b000000;
		funct=6'b001000;		// 16 jr
		#20
		opcode=6'b001000;		// 17 addi
		#20
		opcode=6'b001001;		// 18 addiu
		#20
		opcode=6'b001100;		// 19 andi
		#20
		opcode=6'b001101;		// 20 ori
		#20
		opcode=6'b001110;		// 21 xori
		#20
		opcode=6'b001111;		// 22 lui
		#20
		opcode=6'b100011;		// 23 lw
		#20
		opcode=6'b100000;		// 24 lb
		#20	
	 	opcode=6'b101011;		// 25 sw
		#20
		opcode=6'b101000;		// 26 sb
		#20
		opcode=6'b001010;		// 27 slti
		#20
		opcode=6'b001011;		// 28 sltiu
		#20
		opcode=6'b000001;		// 29 bltz
		rt = 5'b00000;
		#20
		opcode=6'b000001;		// 29 bgez
		rt = 5'b00001;
		#20
		opcode=6'b000001;		// 29 bltzal
		rt = 5'b10000;
		#20
		opcode=6'b000001;		// 29 bgezal
		rs = 5'b00000;
		rt = 5'b10001;
		#20
		opcode=6'b000001;		// 29 bal
		rs = 5'b11111;
		rt = 5'b10001;
		#20
		opcode=6'b000100;		// 30 beq
		rs = 5'b11111;
		rt = 5'b11111;
		#20
		opcode=6'b000100;		// 30 b
		rs = 5'b00000;
		rt = 5'b00000;
		#20
		opcode=6'b000101;		// 31 bne
		rs = 5'b11111;
		rt = 5'b11111;
		#20	
	 	opcode=6'b000110;		// 32 bnlez
		#20
		opcode=6'b000111;		// 33 bgtz
		#20
		opcode=6'b000010;		// 34 j
		#20
		opcode=6'b000011;		// 35 jal
	end
		
endmodule