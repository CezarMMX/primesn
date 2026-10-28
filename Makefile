CC = gcc
FC = gfortran
CFLAGS = -std=c17 -O2 -Wall -Wextra -Werror -pedantic -static -s
FFLAGS = -std=f2018 -O2 -Wall -Wextra -Werror -static -s
BIN = bin/linux-x86_64
WINCC = i686-w64-mingw32-gcc-win32
WINFC = i686-w64-mingw32-gfortran-win32
WINBIN = bins_1.0a

.PHONY: all windows test checksums checksums-windows
all: $(BIN)/primos-c $(BIN)/primos-fortran

windows: $(WINBIN)/primos-c.exe $(WINBIN)/primos-fortran.exe

$(BIN):
	mkdir -p $@

$(BIN)/primos-c: src/primos.c | $(BIN)
	$(CC) $(CFLAGS) $< -o $@

$(BIN)/primos-fortran: src/primos.f90 | $(BIN)
	$(FC) $(FFLAGS) $< -o $@

$(WINBIN):
	mkdir -p $@

$(WINBIN)/primos-c.exe: src/primos.c | $(WINBIN)
	$(WINCC) $(CFLAGS) $< -o $@

$(WINBIN)/primos-fortran.exe: src/primos.f90 | $(WINBIN)
	$(WINFC) $(FFLAGS) $< -o $@

test: all
	python3 tests/test_primos.py

checksums: all
	sha256sum $(BIN)/primos-c $(BIN)/primos-fortran > SHA256SUMS

checksums-windows: windows
	sha256sum $(WINBIN)/primos-c.exe $(WINBIN)/primos-fortran.exe > SHA256SUMS.windows
