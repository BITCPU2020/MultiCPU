`timescale 1ns / 1ps

module sim_dmem();
	reg clk, rstn, i_DMem_we, i_DMem_sByte;
	reg [31:0] i_DMem_addr;
	reg [31:0] i_DMem_wData;
	wire [31:0] o_DMem_rData;

	DataMemory dmem(
		.clk(clk),
		.rstn(rstn),
		.i_DMem_we(i_DMem_we),
		.i_DMem_sByte(i_DMem_sByte),
		.i_DMem_addr(i_DMem_addr),
		.i_DMem_wData(i_DMem_wData),
		.o_DMem_rData(o_DMem_rData)
		);

	initial begin
		clk = 0;
		rstn = 0;
		# 5
		clk = ~clk;
		rstn = ~rstn;
		# 5
		//                                                    read 4 t10
		clk = ~clk;
		i_DMem_we = 0;
		i_DMem_sByte = 0;
		i_DMem_addr = 32'h0000_0004;
		i_DMem_wData = 32'h0000_0000;
		#10
		clk = ~clk;
		#10
		//                                                    read 4 b t30
		clk = ~clk;
		i_DMem_we = 0;
		i_DMem_sByte = 1;
		i_DMem_addr = 32'h0000_0004;
		i_DMem_wData = 32'h0000_0000;
		#10
		clk = ~clk;
		#10
		//                                                    write 4 t50
		clk = ~clk;
		i_DMem_we = 1;
		i_DMem_sByte = 0;
		i_DMem_addr = 32'h0000_0004;
		i_DMem_wData = 32'h0000_0000;
		#10
		clk = ~clk;
		#10
		//                                                    read 4 t70
		clk = ~clk;
		i_DMem_we = 0;
		i_DMem_sByte = 0;
		i_DMem_addr = 32'h0000_0004;
		i_DMem_wData = 32'h0000_0000;
		#10
		clk = ~clk;
		#10
		//                                                    write 8 b t90
		clk = ~clk;
		i_DMem_we = 1;
		i_DMem_sByte = 1;
		i_DMem_addr = 32'h0000_0008;
		i_DMem_wData = 32'h0000_0000;
		#10
		clk = ~clk;
		#10
		//                                                    read 8
		clk = ~clk;
		i_DMem_we = 0;
		i_DMem_sByte = 0;
		i_DMem_addr = 32'h0000_0008;
		i_DMem_wData = 32'h0000_0000;
	end

endmodule
