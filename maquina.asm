#-----------------------------------------------------------------------
# Trabalho 1 
# Simulador: MARS 4.5
#
# Descricao: Software para maquina de venda automatica.
# O programa calcula o valor total inserido pelo cliente, e compara com o
# preco do produto, calcula o troco, determina a quantidade otimizada
# de cedulas e moedas a serem devolvidas e detalha o troco.
#
# Cédulas: R$20, R$10, R$5, R$2
# Moedas:  R$1, R$0.50, R$0.25, R$0.10
#-----------------------------------------------------------------------

.data
# --- Bloco de dados: declaração de todas as strings ---
msg_pago:         .asciiz "Valor pago: R$"
msg_produto:      .asciiz "\nValor do produto selecionado: R$"
msg_troco:        .asciiz "\nTroco: R$"
msg_insuficiente: .asciiz "Valor insuficiente para compra."
virgula:          .asciiz ","
zero_centavo:     .asciiz "0"

# --- Strings para o detalhamento do troco ---
msg_detalhes_troco: .asciiz "\n\n--- Detalhes do Troco ---\n"
str_s0: .asciiz " cedula(s) de R$20.00\n"
str_s1: .asciiz " cedula(s) de R$10.00\n"
str_s2: .asciiz " cedula(s) de R$5.00\n"
str_s3: .asciiz " cedula(s) de R$2.00\n"
str_s4: .asciiz " moeda(s) de R$1.00\n"
str_s5: .asciiz " moeda(s) de R$0.50\n"
str_s6: .asciiz " moeda(s) de R$0.25\n"
str_s7: .asciiz " moeda(s) de R$0.10\n"

.text
.globl main

main:
    # --- Calcula o valor total inserido (em centavos) ---
    # O valor total pago sera acumulado no registrador $t1.
    li $t1, 0 # $t1 = total_pago. Inicia com 0.

    # Calcula e soma o valor das cedulas de R$20,00 ($s0)
    li $t2, 2000
    mul $t3, $s0, $t2
    add $t1, $t1, $t3
    
    # Calcula e soma o valor das cédulas de R$10,00 ($s1)
    li $t2, 1000
    mul $t3, $s1, $t2
    add $t1, $t1, $t3
    
    # Calcula e soma o valor das cédulas de R$5,00 ($s2)
    li $t2, 500
    mul $t3, $s2, $t2
    add $t1, $t1, $t3
    
    # Calcula e soma o valor das cédulas de R$2,00 ($s3)
    li $t2, 200
    mul $t3, $s3, $t2
    add $t1, $t1, $t3
    
    # Calcula e soma o valor das moedas de R$1,00 ($s4)
    li $t2, 100
    mul $t3, $s4, $t2
    add $t1, $t1, $t3
    
    # Calcula e soma o valor das moedas de R$0,50 ($s5)
    li $t2, 50
    mul $t3, $s5, $t2
    add $t1, $t1, $t3
    
    # Calcula e soma o valor das moedas de R$0,25 ($s6)
    li $t2, 25
    mul $t3, $s6, $t2
    add $t1, $t1, $t3
    
    # Calcula e soma o valor das moedas de R$0,10 ($s7)
    li $t2, 10
    mul $t3, $s7, $t2
    add $t1, $t1, $t3

    # --- Compara o valor pago com o preço do produto ---
    # $t1 contém o valor pago total em centavos.
    # $t9 contém o preco do produto, ja em centavos.
    blt $t1, $t9, valor_insuficiente

# --- Ramo de execução para PAGAMENTO BEM-SUCEDIDO ---
compra_ok:
    # Especificação: Se o valor for suficiente para a compra, o registrador $t0 deve retornar 0.
    li $t0, 0
    
    # Calcula o troco em centavos: $t2 = $t1 (pago) - $t9 (preco)
    sub $t2, $t1, $t9      # $t2 agora contem o valor do troco
    
    # --- Exibe as informações no visor da máquina ---
    li $v0, 4
    la $a0, msg_pago
    syscall
    
    move $a0, $t1
    jal imprimir_valor_monetario
    
    li $v0, 4
    la $a0, msg_produto
    syscall
    
    move $a0, $t9
    jal imprimir_valor_monetario

    li $v0, 4
    la $a0, msg_troco
    syscall
    
    move $a0, $t2
    jal imprimir_valor_monetario
    
    # --- Calcula a quantidade de cedulas/moedas do troco ---
    # Troco para R$20,00
    li $t3, 2000
    div $t2, $t3
    mflo $s0
    mfhi $t2
    
    # Troco para R$10,00
    li $t3, 1000
    div $t2, $t3
    mflo $s1
    mfhi $t2
    
    # Troco para R$5,00
    li $t3, 500
    div $t2, $t3
    mflo $s2
    mfhi $t2
    
    # Troco para R$2,00
    li $t3, 200
    div $t2, $t3
    mflo $s3
    mfhi $t2
    
    # Troco para R$1,00
    li $t3, 100
    div $t2, $t3
    mflo $s4
    mfhi $t2
    
    # Troco para R$0,50
    li $t3, 50
    div $t2, $t3
    mflo $s5
    mfhi $t2
    
    # Troco para R$0,25
    li $t3, 25
    div $t2, $t3
    mflo $s6
    mfhi $t2
    
    # Troco para R$0,10
    li $t3, 10
    div $t2, $t3
    mflo $s7
    mfhi $t2
    
    # --- Imprime os detalhes do troco ---
    imprimir_detalhes_troco:
        li $v0, 4
        la $a0, msg_detalhes_troco
        syscall
        
    # Checa e imprime para R$20,00 ($s0)
    blez $s0, proximo_s1
    li $v0, 1
    move $a0, $s0
    syscall
    li $v0, 4
    la $a0, str_s0
    syscall
proximo_s1:
    # Checa e imprime para R$10,00 ($s1)
    blez $s1, proximo_s2
    li $v0, 1
    move $a0, $s1
    syscall
    li $v0, 4
    la $a0, str_s1
    syscall
proximo_s2:
    # Checa e imprime para R$5,00 ($s2)
    blez $s2, proximo_s3
    li $v0, 1
    move $a0, $s2
    syscall
    li $v0, 4
    la $a0, str_s2
    syscall
proximo_s3:
    # Checa e imprime para R$2,00 ($s3)
    blez $s3, proximo_s4
    li $v0, 1
    move $a0, $s3
    syscall
    li $v0, 4
    la $a0, str_s3
    syscall
proximo_s4:
    # Checa e imprime para R$1,00 ($s4)
    blez $s4, proximo_s5
    li $v0, 1
    move $a0, $s4
    syscall
    li $v0, 4
    la $a0, str_s4
    syscall
proximo_s5:
    # Checa e imprime para R$0,50 ($s5)
    blez $s5, proximo_s6
    li $v0, 1
    move $a0, $s5
    syscall
    li $v0, 4
    la $a0, str_s5
    syscall
proximo_s6:
    # Checa e imprime para R$0,25 ($s6)
    blez $s6, proximo_s7
    li $v0, 1
    move $a0, $s6
    syscall
    li $v0, 4
    la $a0, str_s6
    syscall
proximo_s7:
    # Checa e imprime para R$0,10 ($s7)
    blez $s7, fim_detalhes
    li $v0, 1
    move $a0, $s7
    syscall
    li $v0, 4
    la $a0, str_s7
    syscall
fim_detalhes:
    
    j fim_programa

# --- Ramo de execução para PAGAMENTO INSUFICIENTE ---
valor_insuficiente:
    li $t0, 1
    li $v0, 4
    la $a0, msg_insuficiente
    syscall
    j fim_programa


# --- Sub-rotina: imprimir_valor_monetario ---
imprimir_valor_monetario:
    subu $sp, $sp, 4
    sw $ra, 0($sp)
    
    move $t4, $a0
    li $t5, 100
    div $t4, $t5
    mflo $t4
    mfhi $t5

    li $v0, 1
    move $a0, $t4
    syscall

    li $v0, 4
    la $a0, virgula
    syscall

    li $t6, 10
    blt $t5, $t6, imprimir_zero_antes
imprimir_centavos:
    li $v0, 1
    move $a0, $t5
    syscall
    j fim_impressao_valor
imprimir_zero_antes:
    li $v0, 4
    la $a0, zero_centavo
    syscall
    j imprimir_centavos
fim_impressao_valor:
    lw $ra, 0($sp)
    addu $sp, $sp, 4
    jr $ra


# --- Termina a execução do programa ---
fim_programa:
    li $v0, 10
    syscall
