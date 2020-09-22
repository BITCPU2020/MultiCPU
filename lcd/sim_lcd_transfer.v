`timescale 1ns / 1ps

module sim_lcd_transfer();

parameter STATUS_READY = 2'b00;
parameter STATUS_TRANSFER = 2'b01;
parameter STATUS_FINISH = 2'b10;

reg clk;
reg rstn;
reg we;
reg is_cmd;
reg [7:0] data;

wire [1:0] status;
wire cs1;
wire rs;
wire sclk;
wire sid;

lcd_transfer U_lcd_transfer(
	.clk(clk),
	.rstn(rstn),
	.I_we(we),
	.I_is_cmd(is_cmd),
	.I_data(data),
	.O_status(status),
	.O_cs1(cs1),
	.O_rs(rs),
	.O_sclk(sclk),
	.O_sid(sid)
	);

initial begin
	clk = 0;
	rstn = 0;
	#5;
	rstn = 1;
end

always begin
	clk = ~clk;
	#5;
end

integer cnt;

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		// reset
		cnt <= 0;
	end
	else if (cnt == 0) begin
		if (status == STATUS_READY) begin
			we <= 1;
			is_cmd <= 1;
			data <= 8'h2c;
			cnt <= cnt + 1;
		end
	end
	else if (cnt == 1) begin
		if (status == STATUS_FINISH) begin
			we <= 0;
			cnt <= cnt + 1;
		end
	end
	else if (cnt == 2) begin
		if (status == STATUS_READY) begin
			we <= 1;
			is_cmd <= 0;
			data <= 8'h12;
			cnt <= cnt + 1;
		end
	end
	else if (cnt == 3) begin
		if (status == STATUS_FINISH) begin
			we <= 0;
		end
	end
end

endmodule
