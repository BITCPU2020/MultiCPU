`timescale 1ns / 1ps

module lcd_game(
	input clk,
	input rstn,
	input key_1,

	output O_cs1,
	output O_rs,
	output O_sclk,
	output O_sid,
	output O_reset
    );

parameter DELAY_MS = 100000;

parameter STATUS_INIT = 0;
parameter STATUS_IDLE = 1;
parameter STATUS_RUNNING = 2;
parameter STATUS_OVER = 3;

parameter STATUS_LCD_INIT = 0;
parameter STATUS_LCD_READY = 1;
parameter STATUS_LCD_BUSY = 2;
parameter STATUS_LCD_FINISH = 3;

reg [1:0] status;

reg lcd_refresh;
reg lcd_vram_we;
reg [6:0] lcd_row;
reg [1:0] lcd_col;
reg [31:0] lcd_in_data;

wire [31:0] lcd_out_data;
wire [1:0] lcd_status;

lcd_top U_lcd(
	.clk(clk),
	.rstn(rstn),
	.I_refresh(lcd_refresh),
	.I_vram_we(lcd_vram_we),
	.I_row(lcd_row),
	.I_col(lcd_col),
	.I_data(lcd_in_data),

	.O_data(lcd_out_data),
	.O_status(lcd_status),
	.O_cs1(O_cs1),
	.O_rs(O_rs),
	.O_sclk(O_sclk),
	.O_sid(O_sid),
	.O_reset(O_reset)
	);

wire [127:0] map = 128'hffff000000000000ffff000000000000;
wire [127:0] map_d = 128'h00000000ffff000000000000ffff0000;

reg [31:0] cnt_time;
integer cnt_step;
reg [5:0] cnt_pos;

integer i;

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		// reset
		status <= STATUS_INIT;
		lcd_refresh <= 0;
		lcd_vram_we <= 0;
		lcd_row <= 0;
		lcd_col <= 0;
		lcd_in_data <= 0;
		cnt_time <= 0;
		cnt_step <= 0;
		cnt_pos <= 0;
	end
	
	else if (status == STATUS_INIT) begin
		if (lcd_status == STATUS_LCD_READY) begin
			if (cnt_step < 128) begin
				lcd_vram_we <= 1;
				lcd_row <= cnt_step / 4;
				lcd_col <= cnt_step % 4;
				if (cnt_step % 2 == 0) begin
					lcd_in_data <= map[63:32];
				end
				else begin
					lcd_in_data <= map[31:0];
				end
				cnt_step <= cnt_step + 1;
			end
			else if (cnt_step < 256) begin
				lcd_vram_we <= 1;
				lcd_row <= 32 + (cnt_step - 128) / 4;
				lcd_col <= cnt_step % 4;
				if (cnt_step % 2 == 0) begin
					lcd_in_data <= map[31:0];
				end
				else begin
					lcd_in_data <= map[63:32];
				end
				cnt_step <= cnt_step + 1;
			end
			else if (cnt_step == 256) begin
				lcd_vram_we <= 0;
				lcd_refresh <= 1;
				cnt_step <= cnt_step + 1;
			end
		end
		else if (cnt_step == 257 && lcd_status == STATUS_LCD_FINISH) begin
			lcd_refresh <= 0;
			cnt_step <= 0;
			status <= STATUS_IDLE;
		end
	end

	else if (status == STATUS_IDLE) begin
		if (key_1 == 1) begin
			status <= STATUS_RUNNING;
			cnt_step <= 0;
			cnt_time <= 0;
			cnt_pos <= 0;
		end
	end

	else if (status == STATUS_RUNNING) begin
		if (cnt_time == 200 * DELAY_MS) begin
			if (cnt_step < 256) begin
				lcd_vram_we <= 1;
				lcd_row <= cnt_step / 4;
				lcd_col <= cnt_step % 4;
				for (i = 0; i < 32; i = i + 1) begin
					if (cnt_step < 128) begin
						lcd_in_data[i] <= map[(96 - (cnt_step % 2) * 32) - (cnt_pos % 64) + i];
					end
					else begin
						lcd_in_data[i] <= map_d[(96 - (cnt_step % 2) * 32) - (cnt_pos % 64) + i];
					end
				end
				cnt_step <= cnt_step + 1;
			end
			else if (cnt_step == 256) begin
				lcd_vram_we <= 0;
				lcd_refresh <= 1;
				cnt_step <= cnt_step + 1;
			end
			else if (cnt_step == 257 && lcd_status == STATUS_LCD_FINISH) begin
				lcd_refresh <= 0;
				cnt_step <= 0;
				cnt_time <= 0;
				cnt_pos <= cnt_pos + 1;
			end
		end
		else begin
			cnt_time <= cnt_time + 1;
		end
	end
end

endmodule
