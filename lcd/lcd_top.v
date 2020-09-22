`timescale 1ns / 1ps

module lcd_top(
	input clk,
	input rstn,
	input I_refresh,
	input I_vram_we,
	input [6:0] I_row,
	input [1:0] I_col,
	input [31:0] I_data,
	
	output [1:0] O_status,
	output O_cs1,
	output O_rs,
	output O_sclk,
	output O_sid,
	output O_reset
	);

parameter DELAY = 1100;    // default delay: 11us
parameter DELAY_US = 100;

//                refresh = 1                   refresh = 0
// INIT -> READY ------------> BUSY --> FINISH ------------> READY
//           ^
//           |  vram_we = 1
//          data

parameter STATUS_INIT = 0;
parameter STATUS_READY = 1;
parameter STATUS_BUSY = 2;
parameter STATUS_FINISH = 3;

parameter STATUS_TRANS_READY = 2'b00;
parameter STATUS_TRANS_TRANSFER = 2'b01;
parameter STATUS_TRANS_FINISH = 2'b10;

reg [127:0] vram[127:0];

reg [1:0] status;

reg [31:0] cnt;
reg [3:0] c_page;

// for transfer module
reg we;
reg is_cmd;
reg [7:0] data;
reg reset;

assign O_status = status;
assign O_reset = reset;

wire [1:0] trans_status;

lcd_transfer U_lcd_transfer(
	.clk(clk),
	.rstn(rstn),
	.I_we(we),
	.I_is_cmd(is_cmd),
	.I_data(data),
	.O_status(trans_status),
	.O_cs1(O_cs1),
	.O_rs(O_rs),
	.O_sclk(O_sclk),
	.O_sid(O_sid)
	);

integer i;
integer j;

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		// reset
		for (i = 0; i < 128; i = i + 1) begin
			for (j = 0; j < 128; j = j + 1) begin
				vram[i][j] <= 0;
			end
		end
	end
	else if (status == STATUS_READY && I_vram_we == 1) begin
		for (i = 0; i < 32; i = i + 1) begin
			vram[I_row][I_col * 32 + i] <= I_data[31 - i];
		end
	end
end

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		// reset
		status <= STATUS_INIT;
		cnt <= 0;
	end

	else if (status == STATUS_INIT) begin
		// reset = 0;
		// delay(500);
		if (cnt < 500 * DELAY) begin
			reset <= 0;
			cnt <= cnt + 1;
		end
	
		// reset = 1;
		// delay(100);
		else if (cnt < 600 * DELAY) begin
			reset <= 1;
			cnt <= cnt + 1;
		end
		
		// cmd: 0x2c
		else if (cnt < 600 * DELAY + 1) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h2c;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 600 * DELAY + 2) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
		
		// delay(200);
		else if (cnt < 800 * DELAY) begin
			cnt <= cnt + 1;
		end
	
		// cmd: 0x2e
		else if (cnt < 800 * DELAY + 1) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h2e;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 800 * DELAY + 2) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
		// delay(200);
		else if (cnt < 1000 * DELAY) begin
			cnt <= cnt + 1;
		end
	
		// cmd: 0x2f
		else if (cnt < 1000 * DELAY + 1) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h2f;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1000 * DELAY + 2) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
		// delay(10);
		else if (cnt < 1010 * DELAY) begin
			cnt <= cnt + 1;
		end
	
	    // cmd: 0xae
		else if (cnt < 1010 * DELAY + 1) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'hae;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 2) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x38
		else if (cnt < 1010 * DELAY + 3) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h38;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 4) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0xb8
		else if (cnt < 1010 * DELAY + 5) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'hb8;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 6) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0xc8
		else if (cnt < 1010 * DELAY + 7) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'hc8;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 8) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0xa0
		else if (cnt < 1010 * DELAY + 9) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'ha0;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 10) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x44
		else if (cnt < 1010 * DELAY + 11) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h44;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 12) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x00
		else if (cnt < 1010 * DELAY + 13) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h00;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 14) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x40
		else if (cnt < 1010 * DELAY + 15) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h40;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 16) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x00
		else if (cnt < 1010 * DELAY + 17) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h00;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 18) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0xab
		else if (cnt < 1010 * DELAY + 19) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'hab;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 20) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x67
		else if (cnt < 1010 * DELAY + 21) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h67;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 22) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x26
		else if (cnt < 1010 * DELAY + 23) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h26;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 24) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x81
		else if (cnt < 1010 * DELAY + 25) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h81;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 26) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x36
		else if (cnt < 1010 * DELAY + 27) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h36;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 28) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x54
		else if (cnt < 1010 * DELAY + 29) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h54;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 30) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0xf3
		else if (cnt < 1010 * DELAY + 31) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'hf3;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 32) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x04
		else if (cnt < 1010 * DELAY + 33) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h04;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 34) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0x93
		else if (cnt < 1010 * DELAY + 35) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'h93;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 36) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end
	
	    // cmd: 0xaf
		else if (cnt < 1010 * DELAY + 37) begin
			if (trans_status == STATUS_TRANS_READY) begin
				we <= 1;
				is_cmd <= 1;
				data <= 8'haf;
				cnt <= cnt + 1;
			end
		end
		else if (cnt < 1010 * DELAY + 38) begin
			if (trans_status == STATUS_TRANS_FINISH) begin
				we <= 0;
				cnt <= cnt + 1;
			end
		end	

		// init finish
		else begin
			cnt <= 0;
			status <= STATUS_READY;
		end
	end

	else if (status == STATUS_READY) begin
		if (I_refresh == 1) begin
			cnt <= 0;
			c_page <= 0;
			status <= STATUS_BUSY;
			is_cmd <= 1;
		end
	end

	else if (status == STATUS_BUSY) begin
		if (is_cmd == 1) begin
			// set address
			// 0xb0 + page
			if (cnt == 0) begin
				if (trans_status == STATUS_TRANS_READY) begin
					we <= 1;
					is_cmd <= 1;
					data <= (8'hb0 + c_page);
					cnt <= cnt + 1;
				end
			end
			else if (cnt == 1) begin
				if (trans_status == STATUS_TRANS_FINISH) begin
					we <= 0;
					cnt <= cnt + 1;
				end
			end
			// 0x10 + col_high
			else if (cnt == 2) begin
				if (trans_status == STATUS_TRANS_READY) begin
					we <= 1;
					is_cmd <= 1;
					data <= 8'h10;
					cnt <= cnt + 1;
				end
			end
			else if (cnt == 3) begin
				if (trans_status == STATUS_TRANS_FINISH) begin
					we <= 0;
					cnt <= cnt + 1;
				end
			end
			// col_low
			else if (cnt == 4) begin
				if (trans_status == STATUS_TRANS_READY) begin
					we <= 1;
					is_cmd <= 1;
					data <= 8'h00;
					cnt <= cnt + 1;
				end
			end
			else if (cnt == 5) begin
				if (trans_status == STATUS_TRANS_FINISH) begin
					we <= 0;
					cnt <= cnt + 1;
				end
			end
			// address finish
			else begin
				cnt <= 0;
				is_cmd <= 0;
			end
		end
		else begin
			// show current page
			if (cnt == 128 * 4) begin
				// finish current page
				if (c_page == 4'd15) begin
					// finish all
					cnt <= 0;
					status <= STATUS_FINISH;
				end
				else begin
					c_page <= c_page + 1;
					cnt <= 0;
				end
			end
			if (cnt % 2 == 0) begin
				if (trans_status == STATUS_TRANS_READY) begin
					we <= 1;
					is_cmd <= 0;
					data <= {vram[c_page * 8 + 0][cnt / 4], 
							 vram[c_page * 8 + 1][cnt / 4], 
							 vram[c_page * 8 + 2][cnt / 4],
							 vram[c_page * 8 + 3][cnt / 4],
							 vram[c_page * 8 + 4][cnt / 4],
							 vram[c_page * 8 + 5][cnt / 4],
							 vram[c_page * 8 + 6][cnt / 4],
							 vram[c_page * 8 + 7][cnt / 4]};
					cnt <= cnt + 1;
				end
			end
			else if (cnt % 2 == 1) begin
				if (trans_status == STATUS_TRANS_FINISH) begin
					we <= 0;
					cnt <= cnt + 1;
				end
			end
		end
	end

	else if (status == STATUS_FINISH) begin
		if (I_refresh == 0) begin
			status <= STATUS_READY;
		end
	end
end

endmodule