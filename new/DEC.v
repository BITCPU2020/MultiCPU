`timescale 1ns / 1ps

module DEC(

    );
    
    RegistorFile registor_file();
    NumExtend num_extend();
    BranchUnit branch_unit();
    PauseUnit pause_unit();
    mux #5 muxWA();
    
endmodule
