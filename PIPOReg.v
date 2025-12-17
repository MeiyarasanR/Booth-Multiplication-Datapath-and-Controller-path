`timescale 1ns / 1ps
// ========== PIPO REGISTER ==========
module PIPOReg(
    input  [15:0] data_in,
    output reg [15:0] data_out,
    input  clk,
    input  ld
);
    initial data_out = 16'd0;
    
    always @(posedge clk) begin
        if (ld)
            data_out <= data_in;
    end
endmodule
