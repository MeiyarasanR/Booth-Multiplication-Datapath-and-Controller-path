`timescale 1ns / 1ps

// ========== DATAPATH WITH 17-BIT ACCUMULATOR ==========
module Booth_Algo_Datapath(
    ldA, ldQ, ldM, clrA, clrQ, clrDff,
    sftA, sftQ, addsub, decr, ldCount,
    data_in_Q, data_in_M, clk,
    Q0, Qm1, isCountZero, A, Q
);
    input ldA, ldQ, ldM, clrA, clrQ, clrDff, sftA, sftQ, addsub, decr, ldCount;
    input [15:0] data_in_Q, data_in_M;
    input clk;
    wire [15:0] M, Z;
    output [15:0] A, Q;
    output Q0, Qm1, isCountZero;
    wire [4:0] count;
    
    assign isCountZero = (count == 5'd0);
    assign Q0 = Q[0];
    
    shiftreg AR(.data_in(Z), .data_out(A), .SR_in(A[15]), .clk(clk), .ld(ldA), .clr(clrA), .sft(sftA));
    shiftreg QR(.data_in(data_in_Q), .data_out(Q), .SR_in(A[0]), .clk(clk), .ld(ldQ), .clr(clrQ), .sft(sftQ));
    Dff QM1(.d(Q[0]), .q(Qm1), .clk(clk), .clr(clrDff));
    PIPOReg MR(.data_in(data_in_M), .data_out(M), .clk(clk), .ld(ldM));
    AddSub AS(.out(Z), .in1(A), .in2(M), .oper(addsub));
    Counter C(.count(count), .clk(clk), .ld(ldCount), .decr(decr));
endmodule




