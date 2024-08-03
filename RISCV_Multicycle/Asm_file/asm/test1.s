.section .text
.global _test_go


_test_go:
    addi gp, zero, 0x3
    j _test_go
    