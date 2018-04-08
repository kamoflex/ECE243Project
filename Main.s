.equ ADDR_JP1, 0xFF200060
.global _start

_start:
	movia r8, ADDR_JP1
	movia r9, 0x07F557FF
	stwio r9, 4(r8)
	#get value from sensor and put it into r11
	ldwio r11, 0(r8)
	srli r12, r11, 27
	
LIGHT_INTENSITY:
	beq r12, r0, LIGHT_INTENSITY
	movi r13, 0x02					#between 0-3
	ble r12, r13, THRESHOLD1
	movi r13, 0x06					#between 4-7
	ble r12, r13, THRESHOLD2
	movi r13, 0x09					#between 8-11
	ble r12, r13, THRESHOLD3
	movi r13, 0x0A					#between 12-15
	bge r12, r13, THRESHOLD4

THRESHOLD1:
#jump 2 spaces


THRESHOLD2:
#jump 4 spaces


THRESHOLD3:
#jump 6 spaces


THRESHOLD4:
#jump 8 spaces


LEVEL_GEN:
LEVEL1:
#solid 4 spaces block
LEVEL2:
#solid 3 spaces block
LEVEL3:
#solid 2 spaces block
LEVEL4:
#1 space block
#has to fall on location 2 4 6 8
LEVEL5:
#2 block different spaces