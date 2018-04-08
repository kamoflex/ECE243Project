.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000
.equ MAX_X, 319
.equ MAX_Y, 239
.equ END_BOX_X, 100
.equ END_BOX_Y, 150
.equ END_PTFM_X, 100
.equ END_PTFM_Y, 239
.equ BLOCK_START, 120
.equ BLOCK_WIDTH, 25

.global _start

_start:
  movia r2,ADDR_VGA
  movia r3, ADDR_CHAR
  
#r6 - X bound max
#r7 - X counter
#r8 - Y bound max
#r9 - Y counter
#r10 - calculate X vga input, store X+Y after
#r11 - calculate Y vga input
#r12 - change pixel white, writing SCORE, comparison bit
#r13 - first value of score
#r14 - second value of score

SCORE_INITIAL: 
	movui r12, 0x1111		#White pixel
	sthio r12, 0(r2)		#draw pixel at (0,0) apparently keeps my text white...
	movui r12, 0x53   		#S
	stbio r12, 292(r3)		#draws at (37,2)   x + y*128=15370
    movui r12, 0x43   		#C
	stbio r12, 293(r3)		#draws at (37,2)   x + y*128=15370
    movui r12, 0x4F  		#O
	stbio r12, 294(r3)		#draws at (37,2)   x + y*128=15370
    movui r12, 0x52		   	#R
	stbio r12, 295(r3)		#draws at (37,2)   x + y*128=15370
    movui r12, 0x45			#E
    stbio r12, 296(r3)		#draws at (37,2)   x + y*128=15370
    movui r13, 0x30		#set score to zero
    stbio r13, 422(r3)		#draws at (37,2)   x + y*128=15370
    movui r14, 0x30		#set score to zero
    stbio r14, 423(r3)		#draws at (37,2)   x + y*128=15370


DRAW_BGRND:
	movui r4, 0x0000		#Black pixel 
	movi r6, MAX_X			#end of X
	mov r7, r0				#set X count to 0
	movi r8, MAX_Y			#end of Y
  Iterate_X: 
	mov r9,r0				#reset Y count to 0
  IterateY:
	muli r10, r7, 2			#calculate X
	muli r11, r9, 1024		#calculate Y
	add r10, r10, r11		#calculate offset
	add r2, r2, r10			#change address to draw pixel
	sthio r4, 0(r2)			#print each time loop
	sub r2, r2, r10			#reset to base VGA adress
	addi r9, r9, 1			#go through all y
	ble r9, r8, IterateY	#end of IterateY
	addi r7, r7, 1			#increment 1 x
	ble r7,r6, Iterate_X
  
DRAW_BOX:
	movui r4,0x009C			#Blue pixel
	movi r6, END_BOX_X		#max box pixels X
	movi r7, 75				#X count starts at pixel 15
	movi r8, END_BOX_Y		#max box pixels in Y
  Box_X:
	movi r9, 125			#reset Y count to 120
  Box_Y:
	muli r10, r7, 2
	muli r11, r9, 1024
	add r10, r10, r11
	add r2,r2,r10
	sthio r4, 0(r2)
	sub r2, r2, r10
	addi r9, r9, 1
	ble r9, r8, Box_Y
	addi r7, r7, 1
	ble r7, r6, Box_X

DRAW_PLATFORM:
	movui r4,0xA00A			#Blue pixel
	movi r6, END_PTFM_X		#max box pixels X
	movi r7, 0				#X count starts at pixel 0
	movi r8, END_PTFM_Y		#max box pixels in Y
  Platform_X:
	movi r9, 150			#reset Y count to 150
  Platform_Y:
	muli r10, r7, 2
	muli r11, r9, 1024
	add r10, r10, r11
	add r2,r2,r10
	sthio r4, 0(r2)
	sub r2, r2, r10
	addi r9, r9, 1
	ble r9, r8, Platform_Y
	addi r7, r7, 1
	ble r7, r6, Platform_X
    
  #120-144 Block 1
  #145-169 Block 2
  #170-194 Block 3
  #195-219 Block 4
  #220-244 Block 5
  #245-269 Block 6
  #270-294 Block 7
  #295-319Block 8
  
  
	#if platform success run Score:
Score:
	movui r12, 0x1111		#White pixel
	sthio r12, 0(r2)		#draw pixel at (0,0) apparently keeps my text white...
	movui r12, 0x39			#comparison for 9
    beq r12, r14, Increment_Big	#if first value is 9
    #else increment first value
    addi r14, r14, 1		#add 1 to score
    br Print
  Increment_Big:
    addi r13, r13, 1		#increment second by 1
    movui r14, 0x30			#set first to 0
  Print:
    stbio r13, 422(r3)		#draws at (37,2)   x + y*128=15370
    stbio r14, 423(r3)		#draws at (37,2)   x + y*128=15370
    br Score

  
  
#SuccessfulJump:
	#Draw BackGround Buffer
	#Generate new level (block layout)
	#Reset block location
	#br NewLevelCoords
#Jump_1:
	#set the new bounds by changing the end and start
	#dynamic bounds in the sense that you draw once completely with the changing Y and X
	#once you hit the max Y, you start to decrement until you hit the initial Y (at offset 0)
	#check the location of the X whether it overlaps with a box or not (similar to the sensor
	#conditions)
	#branch to appropriate function depending on success of jump
  

#test:  
#  movui r4,0x003A  /* White pixel */
#  movi  r5, 0x41   /* ASCII for 'A' */
#  sthio r4,1032(r2) /* pixel (4,1) is x*2 + y*1024 so (8 + 1024 = 1032) */
#  stbio r5,132(r3) /* character (4,1) is x + y*128 so (4 + 128 = 132) */

  
  