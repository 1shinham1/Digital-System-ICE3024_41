# Digital System (ICE3024_41)

Verilog 실습 코드 모음. 주차별 폴더에 설계 모듈과 테스트벤치를 함께 둔다.

## 구조

```
week1/
  nand4_op1.v      # 설계 모듈
  nand4_op1_tb.v   # 테스트벤치
Makefile           # 공용 빌드/시뮬레이션 스크립트
```

파일 이름은 `<모듈명>.v` / `<모듈명>_tb.v` 규칙을 따른다.
`.out`, `.vcd` 같은 빌드 산출물은 `.gitignore`로 제외된다.

## 사용법

```bash
make sim       WEEK=<주차> [TOP=<모듈명>]   # 컴파일 + 시뮬레이션 (TOP 생략 시 주차 전체)
make wave      WEEK=<주차> TOP=<모듈명>     # 시뮬레이션 후 GTKWave로 파형 확인
make clean     WEEK=<주차>                  # 해당 주차 산출물 삭제
make clean-all                              # 모든 주차 산출물 삭제
make help                                   # 사용법 출력
```

`TOP`을 생략하면 해당 주차 폴더에서 `<모듈명>_tb.v`가 있는 모듈을 모두 컴파일하고 차례로 실행한다.

예시:

```bash
make sim  WEEK=week2
make sim  WEEK=week1 TOP=half_adder
make wave WEEK=week2 TOP=bcd_adder
make clean WEEK=week2
```

필요 도구: `iverilog`, `vvp`, `gtkwave`

## 주차별 내용

| 주차 | 모듈 | 내용 |
|---|---|---|
| week1 | `nand4_op1` | 4입력 NAND — 비트별 AND 후 반전 (`~(a[0]&a[1]&a[2]&a[3])`) |
| week1 | `nand4_op2` | 4입력 NAND — 축약 연산자 사용 (`~&a`) |
| week1 | `nor_op` | 4비트 비트별 NOR (`~(a \| b)`) |
| week1 | `half_adder` | 반가산기 — `sum = a ^ b`, `cout = a & b` |
| week1 | `full_adder` | 전가산기 — `sum = a ^ b ^ cin`, `cout = ab + b·cin + a·cin` |
| week2 | `full_adder_g` | 전가산기 — 게이트 수준 모델링 |
| week2 | `add_sub_4bit` | 4비트 병렬 가감산기 — 게이트 프리미티브, B를 `sign`과 XOR 후 전가산기 4개 직렬 연결 (C0 = `sign`) |
| week2 | `bcd_adder` | 1자리 BCD 가산기 — 게이트 프리미티브, 4비트 이진 덧셈 후 `C = K + Z8·Z4 + Z8·Z2` 이면 6(0110) 더해 보정 |
