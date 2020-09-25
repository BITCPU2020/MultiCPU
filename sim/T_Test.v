`timescale 1ns / 1ps

module T_Test();
    reg clk, rstn;
    wire terminal;
    wire [7:0] answer;
    
    Test test(
    .clk        (clk),
    .rstn       (rstn),
    .terminal   (terminal),
    .answer     (answer));
    
    initial begin
	   clk = 0;
	   rstn = 0;
    end
    
    always begin
        #20
        clk = ~clk;
    end
    
    always begin
        #25
        rstn = ~rstn;
        #2000000000
        rstn = ~rstn;
    end
endmodule
