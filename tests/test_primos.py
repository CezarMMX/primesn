"""Testes funcionais dos executáveis C e Fortran (somente biblioteca padrão)."""
from pathlib import Path
import os
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]
PASTA_BINARIOS = ROOT / ('bins_1.0a' if os.name == 'nt' else 'bin/linux-x86_64')
SUFIXO = '.exe' if os.name == 'nt' else ''
BINARIOS = [PASTA_BINARIOS / (nome + SUFIXO)
            for nome in ('primos-c', 'primos-fortran')]
PRIMOS = [True] * 10000
PRIMOS[:2] = [False, False]
for divisor in range(2, 100):
    if PRIMOS[divisor]:
        for multiplo in range(divisor * divisor, 10000, divisor):
            PRIMOS[multiplo] = False


class TestPrimos(unittest.TestCase):
    def executar(self, binario, entrada):
        return subprocess.run([str(binario)], input=entrada, text=True, encoding='utf-8',
                              capture_output=True, timeout=5)

    def conferir_intervalo(self, binario, entrada, inicio, fim, erros=0):
        resultado = self.executar(binario, entrada)
        self.assertEqual(resultado.returncode, 0, resultado.stderr)
        self.assertEqual(resultado.stdout.count('Entrada inválida:'), erros)
        partes = resultado.stdout.split('(inclusive):\n', 1)
        self.assertEqual(len(partes), 2, resultado.stdout)
        saida = partes[1].strip()
        obtidos = ([] if saida == 'Nenhum número primo no intervalo.'
                   else list(map(int, saida.split())))
        esperados = [n for n in range(inicio, fim + 1) if PRIMOS[n]]
        self.assertEqual(obtidos, esperados)

    def test_intervalos(self):
        casos = [
            ('0\n9999\n', 0, 9999), ('9999\n0\n', 0, 9999),
            ('0\n1\n', 0, 1), ('2\n2\n', 2, 2),
            ('9999\n9999\n', 9999, 9999), ('9973\n9999\n', 9973, 9999),
            ('10\n2\n', 2, 10), ('2\n11', 2, 11),
            ('0002\n0011\n', 2, 11), ('2\r3\n', 2, 3),
            ('2\r\n11\r\n', 2, 11),
        ]
        for binario in BINARIOS:
            for entrada, inicio, fim in casos:
                with self.subTest(binario=binario.name, entrada=entrada):
                    self.conferir_intervalo(binario, entrada, inicio, fim)

    def test_entradas_invalidas(self):
        invalidas = ['-1', '2.5', '2,5', '1e2', '+2', '10000', '00000',
                     '', ' 2', '2 ', 'abc', 'x' * 10000, '2\x00']
        for binario in BINARIOS:
            for entrada in invalidas:
                with self.subTest(binario=binario.name, entrada=entrada[:20]):
                    self.conferir_intervalo(binario, entrada + '\n2\n11\n',
                                            2, 11, erros=1)

    def test_fim_de_entrada(self):
        for binario in BINARIOS:
            for entrada in ['', '2\n', '-1']:
                with self.subTest(binario=binario.name, entrada=entrada):
                    self.assertNotEqual(self.executar(binario, entrada).returncode, 0)


if __name__ == '__main__':
    unittest.main(verbosity=2)
