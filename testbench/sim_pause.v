`timescale 1ns / 1ps
module sim_pause();

reg clk;
reg rstn;

reg [31:0] back_exe;
reg [31:0] back_mem;
reg [31:0] back_wrt;

reg [4:0] ra1;
reg [4:0] ra2;
reg [31:0] rd1;
reg [31:0] rd2;

reg [4:0] wa;
reg we;

reg isLoad;

wire o_pause;
wire [31:0] o_rd1;
wire [31:0] o_rd2;

PauseUnit pause_unit(
	.clk						(clk),
	.rstn						(rstn),
	.i_PauseUnit_aluOutE		(back_exe),
	.i_PauseUnit_dMemRDataM		(back_mem),
	.i_PauseUnit_rstW 			(back_wrt),
	.i_PauseUnit_ra1			(ra1),
	.i_PauseUnit_ra2			(ra2),
	.i_PauseUnit_rd1			(rd1),
	.i_PauseUnit_rd2			(rd2),
	.i_PauseUnit_regWa			(wa),
	.i_PauseUnit_regWe			(we),
	.i_PauseUnit_isLoad			(isLoad),
	.o_PauseUnit_pause			(o_pause),
	.o_PauseUnit_rd1			(o_rd1),
	.o_PauseUnit_rd2			(o_rd2));

initial begin
	clk = 0;
	rstn = 1;
	back_exe = 0;
	back_mem = 0;
	back_wrt = 0;
	ra1 = 0;
	ra2 = 0;
	rd1 = 0;
	rd2 = 0;
	wa = 0;
	we = 0;
	isLoad = 0;
	#20;
	rstn = 0;
	#20;
	rstn = 1;
end

always begin
	clk = ~clk;
	#10;
end

integer cnt = 0;

always @(posedge clk) begin
	case(cnt)
		3: begin
			ra1 <= 0;
			rd1 <= 0;
			ra2 <= 0;
			rd2 <= 0;
			wa <= 1;
			we <= 1;
			isLoad <= 0;
			back_exe <= 0;
			back_mem <= 0;
			back_wrt <= 0;
		end
		4: begin
			ra1 <= 2;
			rd1 <= 32'h22;
			ra2 <= 3;
			rd2 <= 32'h33;
			wa <= 2;
			we <= 1;
			isLoad <= 0;
			back_exe <= 32'h11;
			back_mem <= 32'h0;
			back_wrt <= 32'h0;
		end
		5: begin
			ra1 <= 1;
			rd1 <= 32'h0;
			ra2 <= 2;
			rd2 <= 32'h0;
			wa <= 3;
			we <= 1;
			isLoad <= 0;
			back_exe <= 32'h222;
			back_mem <= 32'h11;
			back_wrt <= 32'h0;
		end
		6: begin
			ra1 <= 1;
			rd1 <= 32'h0;
			ra2 <= 3;
			rd2 <= 32'h0;
			wa <= 1;
			we <= 1;
			isLoad <= 1;
			back_exe <= 32'h33;
			back_mem <= 32'h222;
			back_wrt <= 32'h11;
		end
		7: begin
			ra1 <= 1;
			rd1 <= 32'h11;
			ra2 <= 2;
			rd2 <= 32'h0;
			wa <= 4;
			we <= 0;
			isLoad <= 0;
			back_exe <= 32'h12345678;
			back_mem <= 32'h33;
			back_wrt <= 32'h222;
		end
		8: begin
			ra1 <= 1;
			rd1 <= 32'h11;
			ra2 <= 2;
			rd2 <= 32'h222;
			wa <= 4;
			we <= 0;
			isLoad <= 0;
			back_exe <= 32'h0;
			back_mem <= 32'h111;
			back_wrt <= 32'h33;
		end
		9: begin
			ra1 <= 4;
			rd1 <= 32'h4;
			ra2 <= 5;
			rd2 <= 32'h0;
			wa <= 0;
			we <= 0;
			isLoad <= 0;
			back_exe <= 32'h44;
			back_mem <= 32'h0;
			back_wrt <= 32'h111;
		end
	endcase

	cnt <= cnt + 1;
end

endmodule
