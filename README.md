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
- `tests/test_primos.py`: testes funcionais dos dois executáveis.

Os binários incluídos são ELF estáticos para Linux x86-64. Para Windows,
macOS ou outra arquitetura, recompile os fontes com compiladores adequados.

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

São 27 cenários por executável (54 ao todo), agrupados em três testes:
intervalos, rejeição de entradas inválidas e fim de entrada. Incluem a
comparação de todos os 1229 primos entre 0 e 9999 com uma criva independente.
`make test` compila os arquivos desatualizados antes de testar.
