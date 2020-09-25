`timescale 1ns / 1ps

module Test(
    input clk, rstn,
    output terminal,
    output[7:0] answer
    );
    reg is_terminal;
    assign terminal=is_terminal;
    assign answer= U_cpu.mem.data_memory.dmem[0][7:0];
    wire s_clk;
    assign s_clk = (terminal == 0) ? clk : 0;

    MultiCPU U_cpu(
    	.clk(s_clk),
    	.rstn(rstn)
    	);

    always @(posedge clk or negedge rstn) begin
    	if (!rstn) begin
    		is_terminal <= 0;
    	end
    	else if (U_cpu.ftc.program_counter.o_ProgramCounter_PC == 32'h0000_0054) begin
    		is_terminal <= 1;
    	end
    	
    end
endmodule