`timescale 1ns / 1ps

//=============================================================================
// Testbench for Booth Multiplier
// Tests signed 16-bit multiplication using Booth's algorithm
//=============================================================================

module Booth_Multiplier_TB;
    
    // Testbench signals
    reg clk, start, rst;
    reg signed [15:0] in1, in2;
    wire done;
    wire signed [31:0] out;
    
    // Test statistics
    integer pass_count = 0;
    integer fail_count = 0;
    
    // Instantiate the Booth Multiplier
    Booth_Multiplier uut(
        .in1(in1),
        .in2(in2),
        .start(start),
        .clk(clk),
        .rst(rst),
        .out(out),
        .done(done)
    );
    
    // Clock generation: 10ns period (100MHz)
    initial clk = 0;
    always #5 clk = ~clk;
    
    //=========================================================================
    // Task: Run a single multiplication test
    //=========================================================================
    task run_test;
        input signed [15:0] A, B;
        reg signed [31:0] expected;
    begin
        // Apply reset
        rst = 1;
        start = 0;
        #20;
        rst = 0;
        #10;
        
        // Load operands
        in1 = A;
        in2 = B;
        expected = A * B;
        
        // Start multiplication
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        
        // Wait for completion
        wait(done == 1);
        @(posedge clk);
        #10;
        
        // Verify result
        if ($signed(out) === expected) begin
            $display("PASS: %6d x %6d = %11d", A, B, expected);
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: %6d x %6d = %11d (Got: %11d) [HEX: in1=%h in2=%h out=%h expected=%h]", 
                     A, B, expected, $signed(out), A, B, out, expected);
            fail_count = fail_count + 1;
        end
        
        #50; // Delay between tests
    end
    endtask
    
    //=========================================================================
    // Main test sequence
    //=========================================================================
    initial begin
        $display("\n========================================");
        $display("  Booth Multiplier Testbench");
        $display("========================================\n");
        
        // Initialize
        rst = 1;
        start = 0;
        in1 = 0;
        in2 = 0;
        #30;
        rst = 0;
        #20;
        
        // Basic Tests
        $display("--- Basic Tests ---");
        run_test(16'sd0, 16'sd0);           // 0 x 0
        run_test(16'sd1, 16'sd1);           // 1 x 1
        run_test(16'sd5, 16'sd3);           // 5 x 3
        run_test(16'sd12, 16'sd15);         // 12 x 15
        
        // Negative number tests
        $display("\n--- Negative Number Tests ---");
        run_test(-16'sd5, 16'sd3);          // -5 x 3
        run_test(16'sd5, -16'sd3);          // 5 x -3
        run_test(-16'sd5, -16'sd3);         // -5 x -3
        run_test(-16'sd50, -16'sd78);       // -50 x -78
        
        // Mixed tests
        $display("\n--- Mixed Value Tests ---");
        run_test(16'sd89, 16'sd78);         // 89 x 78
        run_test(16'sd40, -16'sd9);         // 40 x -9
        run_test(-16'sd25, 16'sd11);        // -25 x 11
        run_test(-16'sd30, -16'sd18);       // -30 x -18
        
        // Edge cases - CRITICAL TESTS
        $display("\n--- Edge Cases (Critical) ---");
        run_test(16'sd32767, 16'sd1);       // Max positive x 1
        run_test(16'sd1, -16'sd32768);      // 1 x Min negative (SWAPPED ORDER)
        run_test(16'sd32767, 16'sd2);       // Max positive x 2
        run_test(-16'sd1, -16'sd32768);     // -1 x Min negative (SWAPPED ORDER)
        
        // Additional edge case tests
        $display("\n--- Additional Edge Cases ---");
        run_test(-16'sd32768, 16'sd1);      // Min negative x 1 (original order)
        run_test(-16'sd32768, -16'sd1);     // Min negative x -1 (original order)
        run_test(-16'sd32768, 16'sd2);      // Min negative x 2
        run_test(16'sd2, -16'sd32768);      // 2 x Min negative
        
        // Large values
        $display("\n--- Large Value Tests ---");
        run_test(16'sd1000, 16'sd1000);     // 1000 x 1000
        run_test(16'sd5000, 16'sd6);        // 5000 x 6
        run_test(-16'sd10000, 16'sd3);      // -10000 x 3
        
        // Summary
        $display("\n========================================");
        $display("  Test Summary");
        $display("========================================");
        $display("  PASSED: %0d", pass_count);
        $display("  FAILED: %0d", fail_count);
        $display("  TOTAL:  %0d", pass_count + fail_count);
        
        if (fail_count == 0)
            $display("\n  >> All tests passed! <<\n");
        else
            $display("\n  >> Some tests failed. <<\n");
        
        $finish;
    end
    
    // Timeout watchdog (prevents infinite simulation)
    initial begin
        #200000; // 200us timeout
        $display("\nERROR: Simulation timeout!");
        $display("========================================\n");
        $finish;
    end
    
endmodule