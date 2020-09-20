`timescale 1ns / 1ps

module DataMemory(
		input wire clk, rstn,
		input wire i_DMem_dMemWe, i_DMem_sByte,
		input wire [31:0] i_DMem_addr,
		input wire [31:0] i_DMem_wData,
		output wire [31:0] o_DMem_rData
	);

	reg [7:0] dmem [255:0];

	// read
	wire [7:0] addr = i_DMem_addr[7:0];
	assign o_DMem_rData = (i_DMem_sByte == 1) ? {8'b0, 8'b0, 8'b0, dmem[addr]} :
						{dmem[addr+3], dmem[addr+2], dmem[addr+1], dmem[addr]};

	// write
	always @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			$readmemh("D:/data.txt", dmem);
		end else if(i_DMem_dMemWe) begin
			if(i_DMem_sByte==1) begin
				dmem[addr] <= i_DMem_wData[7:0];
				dmem[addr+1] <= dmem[addr+1];
				dmem[addr+2] <= dmem[addr+2];
				dmem[addr+3] <= dmem[addr+3];
			end else begin
				dmem[addr] <= i_DMem_wData[7:0];
				dmem[addr+1] <= i_DMem_wData[15:8];
				dmem[addr+2] <= i_DMem_wData[23:16];
				dmem[addr+3] <= i_DMem_wData[31:24];
			end
		end
	end
endmodule