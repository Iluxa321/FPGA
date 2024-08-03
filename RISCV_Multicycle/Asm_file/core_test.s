.section .text
.global _test
_test:
    addi s0, zero, 11
    addi s1, zero, 11
    beq s0,s1, _stop
    bne s0,s1, _stop
    blt s0,s1, _stop
    bge s0,s1, _stop
    bltu s0,s1, _stop
    bgeu s0,s1, _stop

_stop:
    ret    
