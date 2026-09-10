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
make sim   WEEK=week1 TOP=nand4_op1   # 컴파일 + 시뮬레이션
make wave  WEEK=week1 TOP=nand4_op1   # 시뮬레이션 후 GTKWave로 파형 확인
make clean WEEK=week1                 # 해당 주차 산출물 삭제
```

필요 도구: `iverilog`, `vvp`, `gtkwave`

## 주차별 내용

| 주차 | 모듈 | 내용 |
|---|---|---|
| week1 | `nand4_op1` | 4입력 NAND — 비트별 AND 후 반전 (`~(a[0]&a[1]&a[2]&a[3])`) |
| week1 | `nand4_op2` | 4입력 NAND — 축약 연산자 사용 (`~&a`) |
| week1 | `nor_op` | 4비트 비트별 NOR (`~(a \| b)`) |
