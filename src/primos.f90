program primos
    use iso_fortran_env, only: input_unit, output_unit, iostat_end, iostat_eor
    implicit none
    integer :: inicio, fim, auxiliar, numero
    logical :: encontrou, sucesso

    call ler_inteiro('Primeiro número: ', inicio, sucesso)
    if (.not. sucesso) stop 1
    call ler_inteiro('Segundo número: ', fim, sucesso)
    if (.not. sucesso) stop 1
    if (inicio > fim) then
        auxiliar = inicio
        inicio = fim
        fim = auxiliar
    end if
    write(*, '(A,I0,A,I0,A)') 'Primos entre ', inicio, ' e ', fim, ' (inclusive):'
    encontrou = .false.
    do numero = inicio, fim
        if (eh_primo(numero)) then
            write(*, '(I0,1X)', advance='no') numero
            encontrou = .true.
        end if
    end do
    if (.not. encontrou) write(*, '(A)', advance='no') 'Nenhum número primo no intervalo.'
    write(*, *)

contains

    subroutine ler_inteiro(mensagem, valor, sucesso)
        character(len=*), intent(in) :: mensagem
        integer, intent(out) :: valor
        logical, intent(out) :: sucesso
        character :: caractere
        integer :: estado, quantidade, digito, numero
        logical :: valido

        sucesso = .false.
        do
            write(output_unit, '(A)', advance='no') mensagem
            flush(output_unit)
            quantidade = 0
            numero = 0
            valido = .true.
            do
                read(input_unit, '(A)', advance='no', iostat=estado) caractere
                if (estado /= 0) exit
                quantidade = min(quantidade + 1, 5)
                digito = iachar(caractere) - iachar('0')
                if (digito < 0 .or. digito > 9 .or. quantidade > 4) then
                    valido = .false.
                else if (valido) then
                    numero = numero * 10 + digito
                end if
            end do
            if (estado == iostat_end .and. quantidade == 0) then
                write(*, '(/,A)') 'Entrada encerrada.'
                return
            end if
            if (estado /= iostat_eor .and. estado /= iostat_end) return
            if (valido .and. quantidade >= 1 .and. quantidade <= 4) then
                valor = numero
                sucesso = .true.
                return
            end if
            write(*, '(A)') 'Entrada inválida: use de 1 a 4 algarismos (0 a 9999).'
            if (estado == iostat_end) return
        end do
    end subroutine ler_inteiro

    logical function eh_primo(numero)
        integer, intent(in) :: numero
        integer :: divisor
        eh_primo = .false.
        if (numero < 2) return
        divisor = 2
        do while (divisor <= numero / divisor)
            if (mod(numero, divisor) == 0) return
            divisor = divisor + 1
        end do
        eh_primo = .true.
    end function eh_primo
end program primos
