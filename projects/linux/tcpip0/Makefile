CC      := gcc
CFLAGS  := -Wall -Wextra -std=c99 -g -O2
BIN     := tcpip

SRCS :=
OBJS :=

all: $(BIN)

debug: $(BIN)
	@rm -f $(BIN)
	$(CC) -Wall -Wextra -std=c99 -g -O0 -DDEBUG -o $@ $(SOURCES)

# 7) 拉成分
SOURCES := $(wildcard src/*.c)
HEADERS := $(wildcard src/*.h)

$(BIN): $(SOURCES) $(HEADERS)
	@mkdir -p build
	$(CC) $(CFLAGS) -o $@ $(SOURCES)

clean:
	rm -f $(BIN) $(wildcard build/*.o) $(wildcard build/*.d)

run: $(BIN)
	sudo ./$(BIN) --ip 10.0.0.2 --mask 255.255.255.0

gdb: $(BIN)
	gdb -ex run --args ./$(BIN)

.PHONY: all clean run gdb test
