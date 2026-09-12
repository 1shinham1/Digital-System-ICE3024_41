`timescale 1ns / 1ps

module add_sub_4bit_tb;
    // 테스트 신호 정의
    reg [3:0] a, b;  // 4비트 입력 신호
    reg sign;        // S(sign): 0 = Add, 1 = Sub
    wire [3:0] s;    // 합 / 차
    wire c4;         // 최상위 캐리

    // 자동 검증용 변수
    integer i, j, k, full, errors;
    reg [3:0] exp_s;
    reg exp_c;

    // DUT (Device Under Test) 인스턴스
    add_sub_4bit dut (
        .a(a),
        .b(b),
        .sign(sign),
        .s(s),
        .c4(c4)
    );

    // 테스트 시나리오
    initial begin
        //.vcd 파일로 기록됨
        $dumpfile("add_sub_4bit.vcd");
        $dumpvars(0, add_sub_4bit_tb);

        // 시뮬레이션 시작 메시지
        $monitor("Time: %0t | sign: %b | a: %b | b: %b | c4: %b | s: %b",
                 $time, sign, a, b, c4, s);

        // 대표 테스트 케이스
        sign = 0; a = 4'b0011; b = 4'b0100; #10; //  3 +  4 =  7 -> c4=0, s=0111
        sign = 0; a = 4'b1001; b = 4'b0101; #10; //  9 +  5 = 14 -> c4=0, s=1110
        sign = 0; a = 4'b1111; b = 4'b0001; #10; // 15 +  1 = 16 -> c4=1, s=0000
        sign = 0; a = 4'b1100; b = 4'b1010; #10; // 12 + 10 = 22 -> c4=1, s=0110
        sign = 1; a = 4'b0111; b = 4'b0011; #10; //  7 -  3 =  4 -> c4=1, s=0100
        sign = 1; a = 4'b0101; b = 4'b0101; #10; //  5 -  5 =  0 -> c4=1, s=0000
        sign = 1; a = 4'b0011; b = 4'b0111; #10; //  3 -  7 = -4 -> c4=0, s=1100 (2의 보수)
        sign = 1; a = 4'b0000; b = 4'b0001; #10; //  0 -  1 = -1 -> c4=0, s=1111 (2의 보수)

        // 전체 조합 자동 검증 (sign 2 x a 16 x b 16 = 512가지)
        $monitoroff;
        errors = 0;
        for (i = 0; i < 2; i = i + 1)
            for (j = 0; j < 16; j = j + 1)
                for (k = 0; k < 16; k = k + 1) begin
                    sign = i; a = j; b = k; #10;

                    // 기대값: a + (b ^ sign) + sign 의 하위 4비트와 캐리
                    full  = j + (i ? (15 - k) : k) + i;
                    exp_s = full % 16;
                    exp_c = (full >= 16);

                    if (s !== exp_s || c4 !== exp_c) begin
                        $display("ERROR: sign=%b a=%b b=%b -> c4=%b s=%b (expected c4=%b s=%b)",
                                 sign, a, b, c4, s, exp_c, exp_s);
                        errors = errors + 1;
                    end
                end

        if (errors == 0) $display("PASS: all 512 cases");
        else             $display("FAIL: %0d errors", errors);

        // 시뮬레이션 종료
        $finish;
    end
endmodule
