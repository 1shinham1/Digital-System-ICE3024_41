`timescale 1ns / 1ps

module half_adder (
    input a,
    input b,
    output sum,
    output cout
    );
    assign sum  = a ^ b;  // 합: 두 입력이 다를 때 1
    assign cout = a & b;  // 캐리: 두 입력이 모두 1일 때 1

endmodule
