# .section .data
# A: .word 0xFFAACCBB
# arr_start: .word 1, 2, 3, 4, 5, 6
.section .text
.global _start
.global _stop

_start:
    la sp, _estack
    la t0, _etext        # src
    la t1, _sdata        # dst
    la t2, _edata
    sub t2, t2, t1      # N byte
    addi t3, zero, 0    # i 
load_data:
    beq t3, t2, end_load_data
    add t5, t0, t3
    add t6, t1, t3
    lbu t4, 0(t5) # 
    sb t4, 0(t6) # 
    addi t3, t3, 1
    j load_data
end_load_data:

    la t1, _sbss        # dst
    la t2, _ebss
    sub t2, t2, t1      # N byte
    addi t3, zero, 0    # i 
load_bss_data:
    beq t3, t2, end_load_bss_data
    add t6, t1, t3
    sb zero, 0(t6)
    addi t3, t3, 1
    j load_bss_data
end_load_bss_data:
    la ra, end_prog
    j main



end_prog:
    addi gp, zero, 0xFF
    j end_prog


_stop:
    addi gp, zero, 0xFE
    j _stop

# _start:
#     lui s3, %hi(A)
# 	addi s3, s3, %lo(A)
#     lw s4, 0(s3)
# 	lb s4, 0(s3)
# 	lb s4, 1(s3)
# 	lb s4, 2(s3)
# 	lb s4, 3(s3)
# 	lh s5, 0(s3)
# 	lh s5, 1(s3)
#     lbu s4, 0(s3)
# 	lbu s4, 1(s3)
# 	lbu s4, 2(s3)
# 	lbu s4, 3(s3)
# 	lhu s5, 0(s3)
# 	lhu s5, 1(s3)
    
#     lui t0, 0x33221
#     addi t0, t0, 0xA
#     sw t0, 0(s3)
#     addi t0, zero, 0xAF
#     sb t0, 0(s3) 
#     addi t0, zero, 0xCC
#     sb t0, 1(s3)
#     addi t0, zero, 0xBB
#     sb t0, 2(s3)
#     addi t0, zero, 0x44
#     sb t0, 3(s3)
    
    
    