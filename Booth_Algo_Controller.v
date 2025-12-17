`timescale 1ns / 1ps
// ========== CONTROLLER ==========
module Booth_Algo_Controller(
    ldA, ldQ, ldM, clrA, clrQ, clrDff,
    sftA, sftQ, addsub, decr, ldCount,
    isCountZero, Q0, Qm1, start, done, clk, rst
);
    input Qm1, Q0, start, isCountZero, clk, rst;
    output reg ldA, ldQ, ldM, clrA, clrQ, clrDff;
    output reg sftA, sftQ, addsub, decr, ldCount, done;
    reg [2:0] state, next_state;
    
    localparam IDLE   = 3'b000,
               LOAD   = 3'b001,
               CHECK  = 3'b010,
               ADD    = 3'b011,
               SUB    = 3'b100,
               SHIFT  = 3'b101,
               DONE   = 3'b110;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always @(*) begin
        case(state)
            IDLE:  next_state = start ? LOAD : IDLE;
            LOAD:  next_state = CHECK;
            CHECK: begin
                if (isCountZero)
                    next_state = DONE;
                else begin
                    case({Q0, Qm1})
                        2'b01:   next_state = ADD;
                        2'b10:   next_state = SUB;
                        default: next_state = SHIFT;
                    endcase
                end
            end
            ADD:   next_state = SHIFT;
            SUB:   next_state = SHIFT;
            SHIFT: next_state = CHECK;
            DONE:  next_state = start ? DONE : IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    always @(*) begin
        ldA = 0; ldQ = 0; ldM = 0; 
        clrA = 0; clrQ = 0; clrDff = 0;
        sftA = 0; sftQ = 0; 
        addsub = 0; decr = 0; ldCount = 0; 
        done = 0;
        
        case(state)
            LOAD: begin 
                ldM = 1;
                ldQ = 1;
                clrA = 1;
                clrDff = 1;
                ldCount = 1;
            end
            ADD: begin 
                ldA = 1;
                addsub = 0;
            end
            SUB: begin 
                ldA = 1;
                addsub = 1;
            end
            SHIFT: begin 
                sftA = 1;
                sftQ = 1;
                decr = 1;
            end
            DONE: begin
                done = 1;
            end
        endcase
    end
endmodule