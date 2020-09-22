`timescale 1ns / 1ps

module lcd_transfer(
	input clk,
	input rstn,
	input I_we,
	input I_is_cmd,
	input [7:0] I_data,

	output [1:0] O_status,
	output O_cs1,
	output O_rs,
	output O_sclk,
	output O_sid
	);

//               we = 1                       we = 0
// rst -> READY -------> TRANSFER --> FINISH -------> READY

parameter DELAY = 1100;    // default delay: 11us
parameter DELAY_US = 100;

parameter STATUS_READY = 2'b00;
parameter STATUS_TRANSFER = 2'b01;
parameter STATUS_FINISH = 2'b10;

reg [1:0] status;
reg [3:0] trans_bit;
reg [7:0] cnt;

assign O_status = status;

reg reg_cs1;
reg reg_rs;
reg reg_sclk;
reg reg_sid;

assign O_cs1 = reg_cs1;
assign O_rs = reg_rs;
assign O_sclk = reg_sclk;
assign O_sid = reg_sid;

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		// reset
		status <= STATUS_READY;
		trans_bit <= 4'd8;
		cnt <= 0;
		reg_cs1 <= 0;
		reg_rs <= 0;
		reg_sclk <= 0;
		reg_sid <= 0;
	end
	else if (status == STATUS_READY) begin
		if (I_we == 1) begin
			status <= STATUS_TRANSFER;  // start transfer
			cnt <= 0;
			trans_bit <= 4'd7;
		end
	end
	else if (status == STATUS_TRANSFER) begin
		reg_cs1 <= 0;
		reg_rs <= ~I_is_cmd;
		if (trans_bit < 4'd8) begin
			if (cnt < DELAY_US) begin
				reg_sclk <= 0;
				reg_sid <= I_data[trans_bit];
				cnt <= cnt + 1;
			end
			else if (cnt < 2 * DELAY_US) begin
				reg_sclk <= 1;
				cnt <= cnt + 1;
			end
			else begin
				// current bit transfer finish
				cnt <= 0;
				trans_bit <= trans_bit - 1;
			end
		end
		else begin
			// transfer finish
			reg_cs1 <= 1;
			if (cnt < DELAY_US) begin
				cnt <= cnt + 1;
			end
			else begin
				cnt <= 0;
				status <= STATUS_FINISH;
			end
		end
	end
	else if (status == STATUS_FINISH) begin
		if (I_we == 0) begin
			status <= STATUS_READY;
		end
	end
end


endmodule