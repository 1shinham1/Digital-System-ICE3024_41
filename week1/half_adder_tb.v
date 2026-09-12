`timescale 1ns / 1ps

module half_adder_tb;
    // 테스트 신호 정의
    reg a, b;        // 1비트 입력 신호
    wire sum, cout;  // 합, 캐리 출력

    // DUT (Device Under Test) 인스턴스
    half_adder dut (
        .a(a),
        .b(b),
        .sum(sum),
        .cout(cout)
    );

    // 테스트 시나리오
    initial begin
        //.vcd 파일로 기록됨
        $dumpfile("half_adder.vcd");
        $dumpvars(0, half_adder_tb);

        // 시뮬레이션 시작 메시지
        $monitor("Time: %0t | a: %b | b: %b | sum: %b | cout: %b",
                 $time, a, b, sum, cout);

        // 테스트 케이스 (모든 입력 조합)
        a = 0; b = 0; #10; // sum=0, cout=0
        a = 0; b = 1; #10; // sum=1, cout=0
        a = 1; b = 0; #10; // sum=1, cout=0
        a = 1; b = 1; #10; // sum=0, cout=1

        // 시뮬레이션 종료
        $finish;
    end
endmodule
