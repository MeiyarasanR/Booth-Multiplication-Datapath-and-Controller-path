`timescale 1ns / 1ps
// ========== SHIFT REGISTER ==========
module shiftreg(
    input  [15:0] data_in,
    output reg [15:0] data_out,
    input  SR_in,
    input  clk,
    input  ld,
    input  clr,
    input  sft
);
    initial data_out = 16'd0;
    
    always @(posedge clk) begin
        if (clr)
            data_out <= 16'd0;
        else if (ld)
            data_out <= data_in;
        else if (sft)
            data_out <= {SR_in, data_out[15:1]};
    end
endmodule

