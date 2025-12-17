`timescale 1ns / 1ps
// ========== D FLIP-FLOP ==========
module Dff(
    input  d,
    output reg q,
    input  clk,
    input  clr
);
    initial q = 1'b0;
    
    always @(posedge clk) begin
        if (clr)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule