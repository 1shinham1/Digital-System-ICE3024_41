`timescale 1ns / 1ps

// 4비트 병렬 가감산기 (게이트 프리미티브)
//   sign = 0 : s = a + b
//   sign = 1 : s = a - b  (B를 반전하고 C0 = sign = 1 로 +1 -> a + ~b + 1)
module add_sub_4bit (
    input  [3:0] a,     // A3~A0
    input  [3:0] b,     // B3~B0
    input        sign,  // S(sign): 0 = Add, 1 = Sub
    output [3:0] s,     // S3~S0
    output       c4     // C4 (뺄셈에서는 1이면 빌림 없음, 즉 a >= b)
    );
    wire [3:0] bx;      // B XOR sign -> 전가산기 입력
    wire [3:0] h;       // 전가산기 내부: a ^ bx
    wire [3:0] g;       // 전가산기 내부: a & bx
    wire [3:0] p;       // 전가산기 내부: (a ^ bx) & 캐리 입력
    wire c1, c2, c3;    // 자리 사이 캐리 (C0 = sign)

    // B 입력을 sign과 XOR
    xor X0 (bx[0], b[0], sign);
    xor X1 (bx[1], b[1], sign);
    xor X2 (bx[2], b[2], sign);
    xor X3 (bx[3], b[3], sign);

    // FA0: A0 + (B0^sign) + C0(sign) -> S0, C1
    xor FA0_X1 (h[0], a[0], bx[0]);
    xor FA0_X2 (s[0], h[0], sign);
    and FA0_A1 (g[0], a[0], bx[0]);
    and FA0_A2 (p[0], h[0], sign);
    or  FA0_O1 (c1,   g[0], p[0]);

    // FA1: A1 + (B1^sign) + C1 -> S1, C2
    xor FA1_X1 (h[1], a[1], bx[1]);
    xor FA1_X2 (s[1], h[1], c1);
    and FA1_A1 (g[1], a[1], bx[1]);
    and FA1_A2 (p[1], h[1], c1);
    or  FA1_O1 (c2,   g[1], p[1]);

    // FA2: A2 + (B2^sign) + C2 -> S2, C3
    xor FA2_X1 (h[2], a[2], bx[2]);
    xor FA2_X2 (s[2], h[2], c2);
    and FA2_A1 (g[2], a[2], bx[2]);
    and FA2_A2 (p[2], h[2], c2);
    or  FA2_O1 (c3,   g[2], p[2]);

    // FA3: A3 + (B3^sign) + C3 -> S3, C4
    xor FA3_X1 (h[3], a[3], bx[3]);
    xor FA3_X2 (s[3], h[3], c3);
    and FA3_A1 (g[3], a[3], bx[3]);
    and FA3_A2 (p[3], h[3], c3);
    or  FA3_O1 (c4,   g[3], p[3]);

endmodule
