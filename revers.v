//
// Copyright 1991-2015 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
// PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
// LICENSE TERMS.
//
// Simple SystemVerilog DPI Example - Verilog test module for fibonacci seq.
//
`timescale 1ns / 1ns
`define EOF -1

module top;

    parameter CLK_PD = 100;                 // system clock period
    parameter M = 14;                       // max number of sequences
    parameter TESTFILE = "./revers.dat";    // test vectors

    logic [19:0] n_l;                       // DUT input
	 logic [ 3:0] N;								  // N - number of digits
    logic [19:0] y_l;                       // DUT output
    bit clock = 0;                          // testbench clock
    logic [19:0] results [0:13];            // array of golden test values
    int FD;                                 // input file handle
    int e_cnt = 0;                          // counter for DATA MISMATCHES
    int v_cnt = 0;                          // verification counter
    int l_cnt = 0;                          // counter - loading results array

    // Make C function visible to verilog code
    import "DPI-C" context function int revers(input int data, N);
	 import "DPI-C" context function int countN(input int data);

    // clock generator
    always
        #(CLK_PD/2) clock = ~clock;

    // simulation control
    initial begin
        // Open input file - break simulation an error occurs
        FD = $fopen(TESTFILE, "r");
        if (FD == 0) begin
            $display("# ERROR: Failure opening \"%s\" for READING", TESTFILE);
            $finish;
        end

        // load results array
        while ($fscanf(FD, "%d", results[l_cnt]) != `EOF)
            ++l_cnt;

        // apply stimulus
        n_l = 20'd12345;
        repeat (M) begin
				N = countN(n_l);
				y_l = revers(n_l, N);
           @(negedge clock) vdata;
           n_l = n_l >> 1;
        end

        $display("\n# Simulation finished: DATA MISMATCHES = %0d\n", e_cnt);
        $fclose(FD);
        $finish;
    end

    // verify results & maintain error count
    task vdata;
        if (y_l !== results[v_cnt]) begin
            ++e_cnt;
            $display("# ERROR: %0d != %0d", y_l, results[v_cnt]);
        end
        if (n_l == M)
            v_cnt = 0;
        else
            ++v_cnt;
    endtask

endmodule
