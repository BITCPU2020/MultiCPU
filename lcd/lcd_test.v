`timescale 1ns / 1ps

module lcd_test(
	input clk,
	input rstn,
	input test_key,

	output O_cs1,
	output O_rs,
	output O_sclk,
	output O_sid,
	output O_reset
    );

parameter STATUS_INIT = 0;
parameter STATUS_READY = 1;
parameter STATUS_BUSY = 2;
parameter STATUS_FINISH = 3;

reg I_vram_we;
reg [6:0] I_row;
reg [1:0] I_col;
reg [31:0] I_data;

wire [1:0] status;

lcd_top U_lcd_top(
	.clk(clk),
	.rstn(rstn),
	.I_refresh(test_key),
	.I_vram_we(I_vram_we),
	.I_row(I_row),
	.I_col(I_col),
	.I_data(I_data),

	.O_status(status),
	.O_cs1(O_cs1),
	.O_rs(O_rs),
	.O_sclk(O_sclk),
	.O_sid(O_sid),
	.O_reset(O_reset)
	);

integer cnt;

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		// reset
		I_vram_we <= 0;
		I_row <= 0;
		I_col <= 0;
		I_data <= 32'h00000000;
		cnt <= 0;
	end
	else if (status == STATUS_READY) begin
		if (cnt == 0) begin
			I_vram_we <= 1;
			I_row <= 32;
			I_col <= 1;
			I_data <= 32'hffffffff;
			cnt <= cnt + 1;
		end
		else if (cnt == 1) begin
			I_vram_we <= 1;
			I_row <= 32;
			I_col <= 2;
			I_data <= 32'hf0f0f0f0;
			cnt <= cnt + 1;
		end
	end
end

endmodule
