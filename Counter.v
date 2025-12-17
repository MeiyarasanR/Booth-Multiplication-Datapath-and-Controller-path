`timescale 1ns / 1ps
// ========== COUNTER ==========
module Counter(
    output reg [4:0] count,
    input clk,
    input ld,
    input decr
);
    initial count = 5'd0;
    
    always @(posedge clk) begin
        if (ld)
            count <= 5'd16;  
        else if (decr)
            count <= count - 1;
    end
endmodule