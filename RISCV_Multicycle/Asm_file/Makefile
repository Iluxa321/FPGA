DIR_OUTPUT = output
DIR_SRC = src
DIR_ASM = asm
SRC = $(wildcard $(DIR_SRC)/*.c)
ASM = $(wildcard $(DIR_ASM)/*.s)
OBJ = $(ASM:$(DIR_ASM)%.s=$(DIR_OUTPUT)%.o) $(SRC:$(DIR_SRC)%.c=$(DIR_OUTPUT)%.o) 
INCLUDEPATH=inc/

CC = riscv64-unknown-elf-gcc 
CCFLAGS = -mabi=ilp32 -march=rv32i -Wall -O0 -c -I $(INCLUDEPATH)


build: mkfile main.hex hex-update

main.hex: main.elf
	elf2hex --bit-width 32 --input $(DIR_OUTPUT)/$< --output $@

main.elf: $(OBJ)
	riscv64-unknown-elf-gcc -nostdlib -mabi=ilp32 -march=rv32i -T link.ld  $^ -o $(DIR_OUTPUT)/$@ -lgcc

# -Map=$(DIR_OUTPUT)/main.map

# main.o: main.s
# 	$(CC) $(CCFLAGS)  $(DIR_OUTPUT)/$< -o $(DIR_OUTPUT)/$@

# main.o: 
# 	$(CC) $(CCFLAGS)  $(DIR_SRC)/main.c -o $@

# startup.o: $(DIR_ASM)/%.s
# 	$(CC) $(CCFLAGS)  $(DIR_ASM)/startup.s -o $@

$(DIR_OUTPUT)/%.o: $(DIR_SRC)/%.c
	$(CC) $(CCFLAGS)  $< -o $@ 

$(DIR_OUTPUT)/%.o: $(DIR_ASM)/%.s
	$(CC) $(CCFLAGS)  $< -o $@

foo := a.o b.o l.a c.o
one := $(patsubst %.o,%.c,$(foo))
# This is a shorthand for the above
two := $(foo:%.o=%.c)
# This is the suffix-only shorthand, and is also equivalent to the above.
three := $(foo:.o=.c)

all:
	echo $(OBJ)


# core_test.o: core_test.s
# 	riscv64-unknown-elf-as $(CCFLAGS) $< -o $(DIR)/$@

# main.o: main.s
# 	riscv64-unknown-elf-as $(CCFLAGS) $(DIR)/$< -o $(DIR)/$@


# map: $(OBJ)
# 	riscv64-unknown-elf-ld -T link.ld -Map=qwe.map $(DIR_OUTPUT)/$<

mkfile:
	rm -rf output
	mkdir output 


clean:
	rm -rf $(DIR_OUTPUT)/
	rm main.hex


hex-update:
	cp main.hex ../ModelSim/TestMasterBusSlaves/ufm_onchip_flash_0.dat
	cp main.hex ../ModelSim/Main/ufm_onchip_flash_0.dat


objdump:
	riscv64-unknown-elf-objdump -d $(DIR_OUTPUT)/main.elf 
