`timescale 1ns / 1ps

module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
    );
    assign sum  = a ^ b ^ cin;                       // 합: 1의 개수가 홀수일 때 1
    assign cout = (a & b) | (b & cin) | (a & cin);   // 캐리: 1이 2개 이상일 때 1

endmodule
