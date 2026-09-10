`timescale 1ns / 1ps

module nor_op_tb;
    // 테스트 신호 정의
    reg [3:0] a;  // 4비트 입력 신호
    reg [3:0] b;  // 4비트 입력 신호
    wire [3:0] y; // NOR 연산 결과

    // DUT (Device Under Test) 인스턴스
    nor_op dut (
        .a(a),
        .b(b),
        .y(y)
    );

    // 테스트 시나리오
    initial begin
        //.vcd 파일로 기록됨
        $dumpfile("nor_op.vcd");
        $dumpvars(0, nor_op_tb);

        // 시뮬레이션 시작 메시지
        $monitor("Time: %0t | a: %b | b: %b | y: %b", $time, a, b, y);

        // 테스트 케이스 (다양한 조합 테스트)
        a = 4'b0000; b = 4'b0000; #10; // NOR(0000, 0000) = 1111
        a = 4'b0001; b = 4'b0000; #10; // NOR(0001, 0000) = 1110
        a = 4'b0000; b = 4'b0001; #10; // NOR(0000, 0001) = 1110
        a = 4'b0011; b = 4'b0001; #10; // NOR(0011, 0001) = 1100
        a = 4'b0101; b = 4'b0011; #10; // NOR(0101, 0011) = 1000
        a = 4'b1111; b = 4'b0000; #10; // NOR(1111, 0000) = 0000
        a = 4'b0000; b = 4'b1111; #10; // NOR(0000, 1111) = 0000
        a = 4'b1010; b = 4'b0101; #10; // NOR(1010, 0101) = 0000
        a = 4'b1111; b = 4'b1111; #10; // NOR(1111, 1111) = 0000

        // 시뮬레이션 종료
        $finish;
    end
endmodule
