`timescale 1ns / 1ps

module InstructionMemory(
        input wire clk, rstn,
		input wire [31:0] i_InstructionMemory_PC,
		output wire [31:0] o_InstructionMemory_inst
	);
	
	reg [7:0] imem[255:0];
	
	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			imem[3]<=8'h00;
			imem[2]<=8'h00;
			imem[1]<=8'h00;
			imem[0]<=8'h00;
			imem[7]<=8'h8c;
			imem[6]<=8'h04;
			imem[5]<=8'h00;
			imem[4]<=8'h00;
			imem[11]<=8'h28;
			imem[10]<=8'h81;
			imem[9]<=8'h00;
			imem[8]<=8'h02;
			imem[15]<=8'h14;
			imem[14]<=8'h20;
			imem[13]<=8'h00;
			imem[12]<=8'h0c;
			imem[19]<=8'h24;
			imem[18]<=8'h08;
			imem[17]<=8'h00;
			imem[16]<=8'h00;
			imem[23]<=8'h24;
			imem[22]<=8'h02;
			imem[21]<=8'h00;
			imem[20]<=8'h01;
			imem[27]<=8'h01;
			imem[26]<=8'h02;
			imem[25]<=8'h48;
			imem[24]<=8'h20;
			imem[31]<=8'h00;
			imem[30]<=8'h02;
			imem[29]<=8'h40;
			imem[28]<=8'h21;
			imem[35]<=8'h00;
			imem[34]<=8'h09;
			imem[33]<=8'h10;
			imem[32]<=8'h21;
			imem[39]<=8'h20;
			imem[38]<=8'h01;
			imem[37]<=8'h00;
			imem[36]<=8'h01;
			imem[43]<=8'h00;
			imem[42]<=8'h81;
			imem[41]<=8'h20;
			imem[40]<=8'h22;
			imem[47]<=8'h20;
			imem[46]<=8'h01;
			imem[45]<=8'h00;
			imem[44]<=8'h01;
			imem[51]<=8'h00;
			imem[50]<=8'h24;
			imem[49]<=8'h08;
			imem[48]<=8'h2a;
			imem[55]<=8'h14;
			imem[54]<=8'h20;
			imem[53]<=8'hff;
			imem[52]<=8'hf8;
			imem[59]<=8'h00;
			imem[58]<=8'h00;
			imem[57]<=8'h00;
			imem[56]<=8'h00;
			imem[63]<=8'h00;
			imem[62]<=8'h00;
			imem[61]<=8'h00;
			imem[60]<=8'h00;
			imem[67]<=8'hac;
			imem[66]<=8'h02;
			imem[65]<=8'h00;
			imem[64]<=8'h00;
			imem[71]<=8'h00;
			imem[70]<=8'h00;
			imem[69]<=8'h00;
			imem[68]<=8'h00;
			imem[75]<=8'h00;
			imem[74]<=8'h00;
			imem[73]<=8'h00;
			imem[72]<=8'h00;
			imem[79]<=8'h00;
			imem[78]<=8'h00;
			imem[77]<=8'h00;
			imem[76]<=8'h00;
			imem[83]<=8'h00;
			imem[82]<=8'h00;
			imem[81]<=8'h00;
			imem[80]<=8'h00;
			imem[87]<=8'h00;
			imem[86]<=8'h00;
			imem[85]<=8'h00;
			imem[84]<=8'h00;
			imem[91]<=8'h00;
			imem[90]<=8'h00;
			imem[89]<=8'h00;
			imem[88]<=8'h00;
			imem[95]<=8'h00;
			imem[94]<=8'h00;
			imem[93]<=8'h00;
			imem[92]<=8'h00;
			imem[99]<=8'h00;
			imem[98]<=8'h00;
			imem[97]<=8'h00;
			imem[96]<=8'h00;
			imem[103]<=8'h00;
			imem[102]<=8'h00;
			imem[101]<=8'h00;
			imem[100]<=8'h00;
			imem[107]<=8'h00;
			imem[106]<=8'h00;
			imem[105]<=8'h00;
			imem[104]<=8'h00;
			imem[111]<=8'h00;
			imem[110]<=8'h00;
			imem[109]<=8'h00;
			imem[108]<=8'h00;
			imem[115]<=8'h00;
			imem[114]<=8'h00;
			imem[113]<=8'h00;
			imem[112]<=8'h00;
			imem[119]<=8'h00;
			imem[118]<=8'h00;
			imem[117]<=8'h00;
			imem[116]<=8'h00;
			imem[123]<=8'h00;
			imem[122]<=8'h00;
			imem[121]<=8'h00;
			imem[120]<=8'h00;
			imem[127]<=8'h00;
			imem[126]<=8'h00;
			imem[125]<=8'h00;
			imem[124]<=8'h00;
			imem[131]<=8'h00;
			imem[130]<=8'h00;
			imem[129]<=8'h00;
			imem[128]<=8'h00;
			imem[135]<=8'h00;
			imem[134]<=8'h00;
			imem[133]<=8'h00;
			imem[132]<=8'h00;
			imem[139]<=8'h00;
			imem[138]<=8'h00;
			imem[137]<=8'h00;
			imem[136]<=8'h00;
			imem[143]<=8'h00;
			imem[142]<=8'h00;
			imem[141]<=8'h00;
			imem[140]<=8'h00;
			imem[147]<=8'h00;
			imem[146]<=8'h00;
			imem[145]<=8'h00;
			imem[144]<=8'h00;
			imem[151]<=8'h00;
			imem[150]<=8'h00;
			imem[149]<=8'h00;
			imem[148]<=8'h00;
			imem[155]<=8'h00;
			imem[154]<=8'h00;
			imem[153]<=8'h00;
			imem[152]<=8'h00;
			imem[159]<=8'h00;
			imem[158]<=8'h00;
			imem[157]<=8'h00;
			imem[156]<=8'h00;
			imem[163]<=8'h00;
			imem[162]<=8'h00;
			imem[161]<=8'h00;
			imem[160]<=8'h00;
			imem[167]<=8'h00;
			imem[166]<=8'h00;
			imem[165]<=8'h00;
			imem[164]<=8'h00;
			imem[171]<=8'h00;
			imem[170]<=8'h00;
			imem[169]<=8'h00;
			imem[168]<=8'h00;
			imem[175]<=8'h00;
			imem[174]<=8'h00;
			imem[173]<=8'h00;
			imem[172]<=8'h00;
			imem[179]<=8'h00;
			imem[178]<=8'h00;
			imem[177]<=8'h00;
			imem[176]<=8'h00;
			imem[183]<=8'h00;
			imem[182]<=8'h00;
			imem[181]<=8'h00;
			imem[180]<=8'h00;
			imem[187]<=8'h00;
			imem[186]<=8'h00;
			imem[185]<=8'h00;
			imem[184]<=8'h00;
			imem[191]<=8'h00;
			imem[190]<=8'h00;
			imem[189]<=8'h00;
			imem[188]<=8'h00;
			imem[195]<=8'h00;
			imem[194]<=8'h00;
			imem[193]<=8'h00;
			imem[192]<=8'h00;
			imem[199]<=8'h00;
			imem[198]<=8'h00;
			imem[197]<=8'h00;
			imem[196]<=8'h00;
			imem[203]<=8'h00;
			imem[202]<=8'h00;
			imem[201]<=8'h00;
			imem[200]<=8'h00;
			imem[207]<=8'h00;
			imem[206]<=8'h00;
			imem[205]<=8'h00;
			imem[204]<=8'h00;
			imem[211]<=8'h00;
			imem[210]<=8'h00;
			imem[209]<=8'h00;
			imem[208]<=8'h00;
			imem[215]<=8'h00;
			imem[214]<=8'h00;
			imem[213]<=8'h00;
			imem[212]<=8'h00;
			imem[219]<=8'h00;
			imem[218]<=8'h00;
			imem[217]<=8'h00;
			imem[216]<=8'h00;
			imem[223]<=8'h00;
			imem[222]<=8'h00;
			imem[221]<=8'h00;
			imem[220]<=8'h00;
			imem[227]<=8'h00;
			imem[226]<=8'h00;
			imem[225]<=8'h00;
			imem[224]<=8'h00;
			imem[231]<=8'h00;
			imem[230]<=8'h00;
			imem[229]<=8'h00;
			imem[228]<=8'h00;
			imem[235]<=8'h00;
			imem[234]<=8'h00;
			imem[233]<=8'h00;
			imem[232]<=8'h00;
			imem[239]<=8'h00;
			imem[238]<=8'h00;
			imem[237]<=8'h00;
			imem[236]<=8'h00;
			imem[243]<=8'h00;
			imem[242]<=8'h00;
			imem[241]<=8'h00;
			imem[240]<=8'h00;
			imem[247]<=8'h00;
			imem[246]<=8'h00;
			imem[245]<=8'h00;
			imem[244]<=8'h00;
			imem[251]<=8'h00;
			imem[250]<=8'h00;
			imem[249]<=8'h00;
			imem[248]<=8'h00;
			imem[255]<=8'h00;
			imem[254]<=8'h00;
			imem[253]<=8'h00;
			imem[252]<=8'h00;
		end
	end

	wire [7:0] addr = i_InstructionMemory_PC[7:0];
	assign o_InstructionMemory_inst = {imem[addr+3] , imem[addr+2], imem[addr+1], imem[addr]};
endmodule