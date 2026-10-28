#include <stdio.h>

static int ler_inteiro(const char *mensagem, int *valor)
{
    for (;;) {
        int caractere, quantidade = 0, numero = 0, valido = 1;
        fputs(mensagem, stdout);
        fflush(stdout);
        while ((caractere = getchar()) != '\n' && caractere != '\r' && caractere != EOF) {
            if (quantidade < 5) ++quantidade;
            if (caractere < '0' || caractere > '9' || quantidade > 4)
                valido = 0;
            else if (valido)
                numero = numero * 10 + caractere - '0';
        }
        if (caractere == '\r') {
            int seguinte = getchar();
            if (seguinte != '\n' && seguinte != EOF) ungetc(seguinte, stdin);
        }
        if (caractere == EOF && quantidade == 0) return 0;
        if (valido && quantidade >= 1) {
            *valor = numero;
            return 1;
        }
        puts("Entrada inválida: use de 1 a 4 algarismos (0 a 9999).");
        if (caractere == EOF) return 0;
    }
}

static int eh_primo(int numero)
{
    if (numero < 2) return 0;
    for (int divisor = 2; divisor <= numero / divisor; ++divisor)
        if (numero % divisor == 0) return 0;
    return 1;
}

int main(void)
{
    int inicio, fim, encontrou = 0;
    if (!ler_inteiro("Primeiro número: ", &inicio) ||
        !ler_inteiro("Segundo número: ", &fim)) {
        puts("\nEntrada encerrada.");
        return 1;
    }
    if (inicio > fim) {
        int auxiliar = inicio;
        inicio = fim;
        fim = auxiliar;
    }
    printf("Primos entre %d e %d (inclusive):\n", inicio, fim);
    for (int numero = inicio; numero <= fim; ++numero) {
        if (eh_primo(numero)) {
            printf("%d ", numero);
            encontrou = 1;
        }
    }
    if (!encontrou) printf("Nenhum número primo no intervalo.");
    putchar('\n');
    return 0;
}
