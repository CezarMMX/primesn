# primesn

Programas equivalentes em C e Fortran que pedem dois números inteiros e
listam todos os primos entre eles, incluindo os limites. A ordem dos
números pode ser invertida. Se não houver primos, uma mensagem é exibida.

Cada entrada aceita de 1 a 4 algarismos, de **0 a 9999**. Negativos,
decimais (ponto ou vírgula), notação científica, sinais, espaços e letras
são rejeitados; o programa pede uma nova entrada. Os números 0 e 1 não
são primos. Fim de entrada antes de completar os dois números encerra
com código de erro.

## Arquivos

- `src/primos.c`: fonte C17.
- `src/primos.f90`: fonte Fortran; requer suporte ao padrão Fortran 2018.
- `bin/linux-x86_64/primos-c`: executável C para Linux x86-64.
- `bin/linux-x86_64/primos-fortran`: executável Fortran para Linux x86-64.
- `bins_1.0a/primos-c.exe`: executável C para Windows x86 (32 bits).
- `bins_1.0a/primos-fortran.exe`: executável Fortran para Windows x86 (32 bits).
- `tests/test_primos.py`: testes funcionais dos dois executáveis.

Os executáveis Linux são ELF estáticos para x86-64. Os executáveis Windows
são PE32 para x86, com os runtimes dos compiladores vinculados estaticamente.
Continuam usando as DLLs do próprio Windows. Para macOS ou outra arquitetura,
recompile os fontes com compiladores adequados.

## Executar os binários incluídos

Na raiz do repositório:

```sh
./bin/linux-x86_64/primos-c
./bin/linux-x86_64/primos-fortran
```

Exemplo: ao informar `10` e depois `2`, ambos mostram `2 3 5 7`.

Verifique a integridade dos executáveis com:

```sh
sha256sum -c SHA256SUMS
```

## Executar no Windows

No PowerShell, na raiz do repositório:

```powershell
chcp 65001
.\bins_1.0a\primos-c.exe
.\bins_1.0a\primos-fortran.exe
```

`chcp 65001` seleciona UTF-8 para exibir os acentos no terminal. Execute pelo
terminal para manter o resultado visível após o programa terminar.
Os executáveis x86 são destinados a Windows de 32 bits e também podem ser
usados em Windows x64 com suporte a aplicativos x86.

## Compilar para Windows x86 a partir do Linux

Não é necessário alterar os fontes C ou Fortran. A arquitetura e o formato
do executável são selecionados pelo compilador MinGW-w64 usado na compilação.
O alvo `windows` do Makefile usa a variante Win32 dos compiladores de 32 bits.

Em Debian 13, instale `make`, `gcc-mingw-w64-i686-win32` e
`gfortran-mingw-w64-i686-win32`. Depois execute:

```sh
make windows
make checksums-windows
sha256sum -c SHA256SUMS.windows
```

Para outra instalação que use os nomes genéricos dos compiladores cruzados:

```sh
make windows WINCC=i686-w64-mingw32-gcc WINFC=i686-w64-mingw32-gfortran
```

No próprio Windows, também é possível compilar com GCC e GNU Fortran de uma
instalação MinGW-w64 para **32 bits** (verifique o alvo com `gcc -dumpmachine`):

```sh
gcc -std=c17 -O2 -Wall -Wextra -pedantic -static -s src/primos.c -o bins_1.0a/primos-c.exe
gfortran -std=f2018 -O2 -Wall -Wextra -static -s src/primos.f90 -o bins_1.0a/primos-fortran.exe
```

Os binários Windows foram gerados com GCC/GNU Fortran 14.2.0 via MinGW-w64.
O formato PE32, a arquitetura i386, as dependências importadas e os checksums
foram verificados no Linux. A execução desses `.exe` em Windows ainda precisa
ser validada; a compilação cruzada não executa os programas.

## Compilar no Linux x86-64

Requisitos: GCC, GNU Fortran, GNU Make e bibliotecas estáticas do sistema.
Em Debian/Ubuntu, os pacotes usuais são `build-essential` e `gfortran`.

```sh
make
```

Para recompilar mesmo quando os binários já estão presentes:

```sh
make -B
make checksums
```

O Makefile usa compilação estática e otimização `-O2`, com avisos tratados
como erros. Para uma compilação dinâmica, substitua as opções pela linha
de comando, por exemplo:

```sh
make -B CFLAGS='-std=c17 -O2 -Wall -Wextra -pedantic' FFLAGS='-std=f2018 -O2 -Wall -Wextra'
make checksums
```

## Testar

Requisito adicional: Python 3, sem dependências externas.

```sh
python3 tests/test_primos.py
```

No Windows com Python instalado, execute `py tests/test_primos.py`.
O teste escolhe automaticamente os binários da plataforma e usa UTF-8 para
ler as mensagens dos processos.

São 27 cenários por executável (54 ao todo), agrupados em três testes:
intervalos, rejeição de entradas inválidas e fim de entrada. Incluem a
comparação de todos os 1229 primos entre 0 e 9999 com uma criva independente.
`make test` compila os arquivos desatualizados antes de testar.
