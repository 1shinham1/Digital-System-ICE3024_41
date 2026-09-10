WEEK ?= week1
TOP  ?= nand4_op1

SRC := $(WEEK)/$(TOP).v
TB  := $(WEEK)/$(TOP)_tb.v
OUT := $(WEEK)/$(TOP).out
VCD := $(WEEK)/$(TOP).vcd

.PHONY: sim wave clean help

sim: $(OUT)
	cd $(WEEK) && vvp $(TOP).out

$(OUT): $(SRC) $(TB)
	iverilog -o $(OUT) $(SRC) $(TB)

wave: sim
	gtkwave $(VCD) &

clean:
	rm -f $(WEEK)/*.out $(WEEK)/*.vcd

help:
	@echo "make sim   WEEK=week1 TOP=nand4_op1   # 컴파일 + 시뮬레이션"
	@echo "make wave  WEEK=week1 TOP=nand4_op1   # 시뮬레이션 후 GTKWave 실행"
	@echo "make clean WEEK=week1                 # 해당 주차 산출물 삭제"
