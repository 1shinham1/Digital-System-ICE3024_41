WEEK ?= week1
TOP  ?=

# TOP 을 생략하면 해당 주차에서 테스트벤치(<모듈명>_tb.v)가 있는 모듈을 모두 실행
TOPS := $(if $(TOP),$(TOP),$(sort $(patsubst $(WEEK)/%_tb.v,%,$(wildcard $(WEEK)/*_tb.v))))

.PHONY: sim wave clean clean-all help

sim: $(TOPS:%=$(WEEK)/%.out)
	@test -n "$(TOPS)" || { echo "$(WEEK) 에 테스트벤치(*_tb.v)가 없습니다"; exit 1; }
	@for t in $(TOPS); do \
		echo "===== $(WEEK)/$$t ====="; \
		(cd $(WEEK) && vvp $$t.out) || exit 1; \
	done

$(WEEK)/%.out: $(WEEK)/%.v $(WEEK)/%_tb.v
	iverilog -o $@ $^

ifeq ($(TOP),)
wave:
	@echo "wave 는 TOP 을 지정해야 합니다: make wave WEEK=$(WEEK) TOP=<모듈명>"; exit 1
else
wave: sim
	gtkwave $(WEEK)/$(TOP).vcd &
endif

clean:
	rm -f $(WEEK)/*.out $(WEEK)/*.vcd

clean-all:
	rm -f week*/*.out week*/*.vcd

help:
	@echo "make sim       WEEK=<주차> [TOP=<모듈명>]   # 컴파일 + 시뮬레이션 (TOP 생략 시 주차 전체)"
	@echo "make wave      WEEK=<주차> TOP=<모듈명>     # 시뮬레이션 후 GTKWave 실행"
	@echo "make clean     WEEK=<주차>                  # 해당 주차 산출물 삭제"
	@echo "make clean-all                              # 모든 주차 산출물 삭제"
	@echo ""
	@echo "예) make sim  WEEK=week2"
	@echo "    make sim  WEEK=week1 TOP=half_adder"
	@echo "    make wave WEEK=week2 TOP=bcd_adder"
