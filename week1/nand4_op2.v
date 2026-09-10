`timescale 1ns/1ps

module nand4_op2 (
    input [3:0] a,
    output y
);
    assign y = ~&a;
endmodule