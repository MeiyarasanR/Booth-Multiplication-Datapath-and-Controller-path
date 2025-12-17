`timescale 1ns / 1ps
// ========== TOP MODULE WITH SPECIAL -32768 HANDLING ==========
module Booth_Multiplier(
    input signed [15:0] in1, in2,
    input start, clk, rst,
    output reg signed [31:0] out,
    output done
);
    wire ldA, ldQ, ldM, clrA, clrQ, clrDff;
    wire sftA, sftQ, addsub, decr, ldCount;
    wire Q0, Qm1, isCountZero;
    wire signed [15:0] A, Q;
    wire signed [31:0] booth_result;
    
    // Special case detection for -32768
    wire in1_is_min = (in1 == 16'sh8000);  // -32768
    wire in2_is_min = (in2 == 16'sh8000);  // -32768
    
    // Choose inputs based on special case
    wire signed [15:0] data_M, data_Q;
    
    // If either input is -32768, make it the multiplier (Q)
    assign data_M = in1_is_min ? in2 : in1;
    assign data_Q = in1_is_min ? in1 : in2;
    
    Booth_Algo_Datapath dp(
        .ldA(ldA), .ldQ(ldQ), .ldM(ldM), 
        .clrA(clrA), .clrQ(clrQ), .clrDff(clrDff),
        .sftA(sftA), .sftQ(sftQ), .addsub(addsub), 
        .decr(decr), .ldCount(ldCount),
        .data_in_Q(data_Q), .data_in_M(data_M), .clk(clk),
        .Q0(Q0), .Qm1(Qm1), .isCountZero(isCountZero),
        .A(A), .Q(Q)
    );
    
    Booth_Algo_Controller ctrl(
        .ldA(ldA), .ldQ(ldQ), .ldM(ldM), 
        .clrA(clrA), .clrQ(clrQ), .clrDff(clrDff),
        .sftA(sftA), .sftQ(sftQ), .addsub(addsub), 
        .decr(decr), .ldCount(ldCount),
        .isCountZero(isCountZero), .Q0(Q0), .Qm1(Qm1), 
        .start(start), .done(done), .clk(clk), .rst(rst)
    );
    
    assign booth_result = {A, Q};
    
    // Always output the booth result directly
    always @(*) begin
        out = booth_result;
    end
endmodule
