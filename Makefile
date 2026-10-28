CC = gcc
FC = gfortran
CFLAGS = -std=c17 -O2 -Wall -Wextra -Werror -pedantic -static -s
FFLAGS = -std=f2018 -O2 -Wall -Wextra -Werror -static -s
BIN = bin/linux-x86_64

.PHONY: all test checksums
all: $(BIN)/primos-c $(BIN)/primos-fortran

$(BIN):
	mkdir -p $@

$(BIN)/primos-c: src/primos.c | $(BIN)
	$(CC) $(CFLAGS) $< -o $@

$(BIN)/primos-fortran: src/primos.f90 | $(BIN)
	$(FC) $(FFLAGS) $< -o $@

test: all
	python3 tests/test_primos.py

checksums: all
	sha256sum $(BIN)/primos-c $(BIN)/primos-fortran > SHA256SUMS
