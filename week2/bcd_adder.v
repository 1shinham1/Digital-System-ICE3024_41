`timescale 1ns / 1ps

// 1자리 BCD 가산기 (게이트 프리미티브)
//   1단 4Bit Binary Adder : Augend + Addend + Carry in -> K, Z8 Z4 Z2 Z1
//   보정 조건             : C = K + Z8·Z4 + Z8·Z2  (2진 합이 1010~1111 또는 K = 1)
//   2단 4Bit Binary Adder : Z + {0, C, C, 0}  (C = 1이면 +6 보정), 최상위 캐리는 버림
module bcd_adder (
    input  [3:0] a,     // Augend (BCD 0~9)
    input  [3:0] b,     // Addend (BCD 0~9)
    input        cin,   // Carry in
    output [3:0] s,     // BCD 합 S8 S4 S2 S1
    output       cout   // Carry out (= C)
    );
    // 1단 신호
    wire [3:0] z;       // 2진 합: z[3]=Z8, z[2]=Z4, z[1]=Z2, z[0]=Z1
    wire k;             // 2진 합 캐리 K
    wire [3:0] h1, g1, p1;  // 전가산기 내부: a^b, a&b, (a^b)&캐리 입력
    wire k1, k2, k3;        // 자리 사이 캐리

    // 보정 조건 신호
    wire t1, t2;        // Z8·Z4, Z8·Z2

    // 2단 신호
    wire [3:0] h2, g2, p2;  // 전가산기 내부
    wire d1, d2, d3, d4;    // 자리 사이 캐리 (d4는 사용하지 않음)

    // ---------------- 1단 4Bit Binary Adder ----------------
    // FA0: A0 + B0 + Carry in -> Z1, k1
    xor ADD1_FA0_X1 (h1[0], a[0], b[0]);
    xor ADD1_FA0_X2 (z[0],  h1[0], cin);
    and ADD1_FA0_A1 (g1[0], a[0], b[0]);
    and ADD1_FA0_A2 (p1[0], h1[0], cin);
    or  ADD1_FA0_O1 (k1,    g1[0], p1[0]);

    // FA1: A1 + B1 + k1 -> Z2, k2
    xor ADD1_FA1_X1 (h1[1], a[1], b[1]);
    xor ADD1_FA1_X2 (z[1],  h1[1], k1);
    and ADD1_FA1_A1 (g1[1], a[1], b[1]);
    and ADD1_FA1_A2 (p1[1], h1[1], k1);
    or  ADD1_FA1_O1 (k2,    g1[1], p1[1]);

    // FA2: A2 + B2 + k2 -> Z4, k3
    xor ADD1_FA2_X1 (h1[2], a[2], b[2]);
    xor ADD1_FA2_X2 (z[2],  h1[2], k2);
    and ADD1_FA2_A1 (g1[2], a[2], b[2]);
    and ADD1_FA2_A2 (p1[2], h1[2], k2);
    or  ADD1_FA2_O1 (k3,    g1[2], p1[2]);

    // FA3: A3 + B3 + k3 -> Z8, K
    xor ADD1_FA3_X1 (h1[3], a[3], b[3]);
    xor ADD1_FA3_X2 (z[3],  h1[3], k3);
    and ADD1_FA3_A1 (g1[3], a[3], b[3]);
    and ADD1_FA3_A2 (p1[3], h1[3], k3);
    or  ADD1_FA3_O1 (k,     g1[3], p1[3]);

    // ---------------- 보정 조건 C ----------------
    and G1 (t1, z[3], z[2]);        // Z8·Z4
    and G2 (t2, z[3], z[1]);        // Z8·Z2
    or  G3 (cout, k, t1, t2);       // C = K + Z8·Z4 + Z8·Z2

    // ---------------- 2단 4Bit Binary Adder ----------------
    // 입력: Z8 Z4 Z2 Z1 + 0 C C 0, 캐리 입력 0
    // FA0: Z1 + 0 + 0 -> S1, d1
    xor ADD2_FA0_X1 (h2[0], z[0], 1'b0);
    xor ADD2_FA0_X2 (s[0],  h2[0], 1'b0);
    and ADD2_FA0_A1 (g2[0], z[0], 1'b0);
    and ADD2_FA0_A2 (p2[0], h2[0], 1'b0);
    or  ADD2_FA0_O1 (d1,    g2[0], p2[0]);

    // FA1: Z2 + C + d1 -> S2, d2
    xor ADD2_FA1_X1 (h2[1], z[1], cout);
    xor ADD2_FA1_X2 (s[1],  h2[1], d1);
    and ADD2_FA1_A1 (g2[1], z[1], cout);
    and ADD2_FA1_A2 (p2[1], h2[1], d1);
    or  ADD2_FA1_O1 (d2,    g2[1], p2[1]);

    // FA2: Z4 + C + d2 -> S4, d3
    xor ADD2_FA2_X1 (h2[2], z[2], cout);
    xor ADD2_FA2_X2 (s[2],  h2[2], d2);
    and ADD2_FA2_A1 (g2[2], z[2], cout);
    and ADD2_FA2_A2 (p2[2], h2[2], d2);
    or  ADD2_FA2_O1 (d3,    g2[2], p2[2]);

    // FA3: Z8 + 0 + d3 -> S8, d4 (버림)
    xor ADD2_FA3_X1 (h2[3], z[3], 1'b0);
    xor ADD2_FA3_X2 (s[3],  h2[3], d3);
    and ADD2_FA3_A1 (g2[3], z[3], 1'b0);
    and ADD2_FA3_A2 (p2[3], h2[3], d3);
    or  ADD2_FA3_O1 (d4,    g2[3], p2[3]);

endmodule
