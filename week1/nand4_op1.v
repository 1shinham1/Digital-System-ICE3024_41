`timescale 1ns / 1ps

module nand4_op1 (
    input [3:0] a,
    output y
    );
    assign y = ~(a[0] & a[1] & a[2] & a[3]);
    
endmodule

// iverilog -o nand4_tb.out nand4_op1.v nand4_op1_TB.v && vvp nand4_tb.out