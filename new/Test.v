`timescale 1ns / 1ps

module Test(
    input clk, rstn,
    output terminal, correct
    );
    reg is_terminal, is_correct;
    assign terminal=is_terminal;
    assign correct=is_correct;
    wire s_clk;
    assign s_clk = (terminal == 0) ? clk : 0;

    MultiCPU U_cpu(
    	.clk(s_clk),
    	.rstn(rstn)
    	);

    always @(posedge clk or negedge rstn) begin
    	if (!rstn) begin
    		is_terminal <= 0;
    		is_correct <= 0;
    	end
    	else if (U_cpu.ftc.program_counter.o_ProgramCounter_PC == 32'h0000_0050) begin
    		is_terminal <= 1;
    		if (U_cpu.mem.data_memory.dmem[0] == 32'h0000_0037) begin
    		  is_correct <= 1;
    	   end
    	end
    	
    end
endmodule