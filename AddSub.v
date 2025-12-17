`timescale 1ns / 1ps

// ========== ADD/SUBTRACT WITH 17-BIT INTERNAL ARITHMETIC ==========
module AddSub(
    output [15:0] out,
    input  [15:0] in1,
    input  [15:0] in2,
    input oper
);
    wire signed [16:0] a_ext, m_ext, result;
    
    // Sign extend to 17 bits
    assign a_ext = {in1[15], in1};
    assign m_ext = {in2[15], in2};
    
    // Perform 17-bit arithmetic
    assign result = oper ? (a_ext - m_ext) : (a_ext + m_ext);
    
    // Return lower 16 bits
    assign out = result[15:0];
endmodule
