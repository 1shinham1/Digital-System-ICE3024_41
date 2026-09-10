`timescale 1ns / 1ps // 앞의 단위가 #10의 단위가 되고 뒤가 정밀도가 된다.

module nand4_op1_tb;
    // 테스트 신호 정의
    reg [3:0] a;  // 4비트 입력 신호
    wire y;       // NAND 연산 결과

    // DUT (Device Under Test) 인스턴스
    nand4_op1 dut (
        .a(a),
        .y(y)
    );

    // 테스트 시나리오
    initial begin
        //.vcd 파일로 기록됨
        $dumpfile("nand4_op1.vcd");
        $dumpvars(0, nand4_op1_tb);

        // 시뮬레이션 시작 메시지
        $monitor("Time: %0t | a: %b | y: %b", $time, a, y);

        // 4비트 입력의 모든 조합을 테스트 (0000~1111)
        a = 4'b0000; #10;
        a = 4'b0001; #10;
        a = 4'b0010; #10;
        a = 4'b0011; #10;
        a = 4'b0100; #10;
        a = 4'b0101; #10;
        a = 4'b0110; #10;
        a = 4'b0111; #10;
        a = 4'b1000; #10;
        a = 4'b1001; #10;
        a = 4'b1010; #10;
        a = 4'b1011; #10;
        a = 4'b1100; #10;
        a = 4'b1101; #10;
        a = 4'b1110; #10;
        a = 4'b1111; #10; // 마지막 조합

        // 시뮬레이션 종료
        $finish;
    end
endmodule
