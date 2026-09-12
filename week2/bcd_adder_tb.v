`timescale 1ns / 1ps

module bcd_adder_tb;
    // 테스트 신호 정의
    reg [3:0] a, b;  // BCD 입력 신호 (0~9)
    reg cin;         // 캐리 입력
    wire [3:0] s;    // BCD 합
    wire cout;       // 캐리 출력

    // 자동 검증용 변수
    integer i, j, k, total, errors;
    reg [3:0] exp_s;
    reg exp_c;

    // DUT (Device Under Test) 인스턴스
    bcd_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    // 테스트 시나리오
    initial begin
        //.vcd 파일로 기록됨
        $dumpfile("bcd_adder.vcd");
        $dumpvars(0, bcd_adder_tb);

        // 시뮬레이션 시작 메시지
        $monitor("Time: %0t | a: %b | b: %b | cin: %b | cout: %b | s: %b",
                 $time, a, b, cin, cout, s);

        // 대표 테스트 케이스
        a = 4'b0000; b = 4'b0000; cin = 0; #10; // 0 + 0     =  0 -> cout=0, s=0000
        a = 4'b0011; b = 4'b0100; cin = 0; #10; // 3 + 4     =  7 -> cout=0, s=0111
        a = 4'b0101; b = 4'b0100; cin = 0; #10; // 5 + 4     =  9 -> cout=0, s=1001 (보정 없음)
        a = 4'b0101; b = 4'b0101; cin = 0; #10; // 5 + 5     = 10 -> cout=1, s=0000 (보정)
        a = 4'b0110; b = 4'b0111; cin = 0; #10; // 6 + 7     = 13 -> cout=1, s=0011 (슬라이드 예: 1101 + 0110)
        a = 4'b0100; b = 4'b0101; cin = 1; #10; // 4 + 5 + 1 = 10 -> cout=1, s=0000 (보정)
        a = 4'b1000; b = 4'b0111; cin = 0; #10; // 8 + 7     = 15 -> cout=1, s=0101 (보정)
        a = 4'b1001; b = 4'b1001; cin = 0; #10; // 9 + 9     = 18 -> cout=1, s=1000 (1단 캐리 K=1)
        a = 4'b1001; b = 4'b1001; cin = 1; #10; // 9 + 9 + 1 = 19 -> cout=1, s=1001 (최댓값)

        // 전체 유효 조합 자동 검증 (a 10 x b 10 x cin 2 = 200가지)
        $monitoroff;
        errors = 0;
        for (i = 0; i < 10; i = i + 1)
            for (j = 0; j < 10; j = j + 1)
                for (k = 0; k < 2; k = k + 1) begin
                    a = i; b = j; cin = k; #10;

                    // 기대값: 10진 합의 1의 자리와 10의 자리
                    total = i + j + k;
                    exp_s = total % 10;
                    exp_c = (total >= 10);

                    if (s !== exp_s || cout !== exp_c) begin
                        $display("ERROR: a=%0d b=%0d cin=%b -> cout=%b s=%b (expected cout=%b s=%b)",
                                 a, b, cin, cout, s, exp_c, exp_s);
                        errors = errors + 1;
                    end
                end

        if (errors == 0) $display("PASS: all 200 cases");
        else             $display("FAIL: %0d errors", errors);

        // 시뮬레이션 종료
        $finish;
    end
endmodule
