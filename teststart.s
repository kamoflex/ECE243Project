_data:
.equ Timer, 0xFF202000
.equ PERIOD, 300000000
.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000
.equ MAX_X, 319
.equ MAX_Y, 239
.equ END_BOX_X, 95
#.equ END_BOX_Y, 165
#.equ BOX_START_X, 15
#.equ BOX_START_Y, 150
.equ END_BOX_Y, 150
.equ END_PTFM_X, 100
.equ END_PTFM_Y, 239
.equ BLOCK_START, 120
#.equ BW, 25
.equ EW, 100
.equ MW, 75
.equ HW, 50
.equ SW, 25
#.equ STACK, 0x3ffffffc #change stack address when using regular board and not simulator
.equ STACK, 0x17fff80 #comment out when using DE1 board


#r2		 	VGA base address					->		STILL USABLE
#r3		 	VGA CHAR base address				->		STILL USABLE
#r4		 	used for colors (TEMPORARY ) 		->		ASIGN TO THRESHOLD VALUE
#r5 		level count 						->		NOT USABLE
#r6 		used in subroutines/writing score 	-> 		
#r7			used in subroutines as iterator 	->	 	
#r8			used in subroutines 				-> 		STILL USABLE
#r9			used in subroutines 				->		Used for drawing y components
#r10		used in subroutines (ISR)			-> 		STILL USABLE
#r11		used in subroutines (ISR) 			-> 		STILL USABLE
#r12		X offset value 						-> 		NOT USABLE
#r13		Y offset value						-> 		NOT USABLE
#r14		used for checking if successful jump->		NOT USABLE
#r15		Don't use mid jump (Y part of jump)	->		KINDA USABLE
#r16											-> 		Level check
#r17											-> 		Holds Start of Block (x)
#r18											-> 		Holds end of block (x)
#r19											-> 		STILL USABLE
#r20											-> 		STILL USABLE
#r21											-> 		STILL USABLE
#r22											-> 		STILL USABLE
#r23											-> 		STILL USABLE
#r24											-> 		STILL USABLE
#r25											-> 		STILL USABLE
#r26											-> 		STILL USABLE
#r27											-> 		NOT USABLE
#r28
#r29
#r30											-> 		NOT USABLE

.global _start

_start:
  movia r2,ADDR_VGA
  movia r3, ADDR_CHAR
  movia sp, STACK
  movi r4, 2
  mov r5,r0
  mov r16, r0
  call DRAW_BGRND
  #call DRAW_LEVEL				UNCOMMENT WHEN LEVEL PROGRESSION WORKS
  call DRAW_BOX
  call DRAW_PLATFORM
  SCORE_INITIAL: 
	movui r6, 0x1111		#White pixel
	sthio r6, 0(r2)		#draw pixel at (0,0) apparently keeps my text white...
	movui r6, 0x53   		#S
	stbio r6, 292(r3)		#draws at (36,2)   x + y*128=292
	movui r6, 0x43   		#C
	stbio r6, 293(r3)		#draws at (37,2)   x + y*128=293
	movui r6, 0x4F  		#O
	stbio r6, 294(r3)		#draws at (38,2)
	movui r6, 0x52		   	#R
	stbio r6, 295(r3)		#draws at (39,2)
	movui r6, 0x45			#E
	stbio r6, 296(r3)		#draws at (40,2)
	movui r19, 0x30			#set score to zero
	stbio r19, 422(r3)		#draws at (38,3)
	movui r20, 0x30			#set score to zero
	stbio r20, 423(r3)		#draws at (39,3)
  
  br NewLevelCoords
  NewLevelCoords:
  	movi r12, 0 			#Init box X offset
  	movi r13, 0				#Init box y offset only change when jumping
	movi r14, 1				# X offset limit (changes with jump, compare to r12)
	movi r15, 0				# Y offset limit (changeds with jump, compare to r13)
	
	#br LoopForever
	br NEXT_LEVEL

LoopForever:
	br LoopForever

SuccessfulJump:
	call CLEAR_BLOCKS				#Draw BackGround Buffer
	#Generate new level (block layout)
	call BOX_SHADOW			#erases location of current block
	call NewLevelCoords
	call DRAW_BOX			#Reset block location
	br NewLevelCoords  			#THIS NEEDS TO BE ADJUSTED
	

Jump_0:							#When the user wants to move by 2 pixels to the right
	#movi r14, 45
	#movi r15, 22
	#beq r12,r14, DONE_JUMP 			#checking if done jumping or nah
	call BOX_SHADOW
	#bge r15, r12, Jump_0_rise		#checks if x offset is in the first half of the jump or nah
	addi r12,r12,1
	#addi r13,r13,1
	#br Jump_0_draws
	
	#Jump_0_rise:
	#addi r12,r12,1					#if not then increments x
	#subi r13,r13,1
	
	Jump_0_draws:
	#call DRAW_BGRND				#draw background
	#call DRAW_LEVEL				#draw same level 
#	subi sp,sp, 56
#	stw r2,  0(sp)
#	stw r3,  4(sp)
#	stw r4,  8(sp)
#	stw r5, 12(sp)
#	stw r6, 16(sp)
#	stw r7, 20(sp)
#	stw r8, 24(sp)
#	stw r9, 28(sp)
#	stw r10, 32(sp)
#	stw r11, 36(sp)
#	stw r12, 40(sp)
#	stw r13, 44(sp)
#	stw r14, 48(sp)
#	stw r15, 52(sp)
	call DRAW_BOX					#draw block
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
#	ldw r2,  0(sp)
#	ldw r3,  4(sp)
#	ldw r4,  8(sp)
#	ldw r5, 12(sp)
#	ldw r6, 16(sp)
#	ldw r7, 20(sp)
#	ldw r8, 24(sp)
#	ldw r9, 28(sp)
#	ldw r10, 32(sp)
#	ldw r11, 36(sp)
#	ldw r12, 40(sp)
#	ldw r13, 44(sp)
#	ldw r14, 48(sp)
#	ldw r15, 52(sp)
#	addi sp,sp, 56
	br Jump_0
	
		
	
Jump_1:
	movi r14, 45
	movi r15, 22
	beq r12,r14, DONE_JUMP 			#checking if done jumping or nah
	call BOX_SHADOW
	bge r15, r12, Jump_1_rise		#checks if x offset is in the first half of the jump or nah
	addi r12,r12,1
	addi r13,r13,1
	br Jump_1_draws
	
	Jump_1_rise:
	addi r12,r12,1					#if not then increments x
	subi r13,r13,1
	
	Jump_1_draws:
	#call DRAW_BGRND				#draw background
	#call DRAW_LEVEL				#draw same level 
#	subi sp,sp, 56
#	stw r2,  0(sp)
#	stw r3,  4(sp)
#	stw r4,  8(sp)
#	stw r5, 12(sp)
#	stw r6, 16(sp)
#	stw r7, 20(sp)
#	stw r8, 24(sp)
#	stw r9, 28(sp)
#	stw r10, 32(sp)
#	stw r11, 36(sp)
#	stw r12, 40(sp)
#	stw r13, 44(sp)
#	stw r14, 48(sp)
#	stw r15, 52(sp)
	call DRAW_BOX					#draw block
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
#	ldw r2,  0(sp)
#	ldw r3,  4(sp)
#	ldw r4,  8(sp)
#	ldw r5, 12(sp)
#	ldw r6, 16(sp)
#	ldw r7, 20(sp)
#	ldw r8, 24(sp)
#	ldw r9, 28(sp)
#	ldw r10, 32(sp)
#	ldw r11, 36(sp)
#	ldw r12, 40(sp)
#	ldw r13, 44(sp)
#	ldw r14, 48(sp)
#	ldw r15, 52(sp)
#	addi sp,sp, 56
	br Jump_1
	
Jump_2:
	movi r14, 95
	movi r15, 46
	beq r12,r14, DONE_JUMP 			#checking if done jumping or nah
	call BOX_SHADOW
	bge r15, r12, Jump_2_rise		#checks if x offset is in the first half of the jump or nah
	addi r12,r12,1
	addi r13,r13,1
	br Jump_2_draws
	
	Jump_2_rise:
	addi r12,r12,1					#if not then increments x
	subi r13,r13,1
	
	Jump_2_draws:
	#call DRAW_BGRND				#draw background
	#call DRAW_LEVEL				#draw same level 
#	subi sp,sp, 56
#	stw r2,  0(sp)
#	stw r3,  4(sp)
#	stw r4,  8(sp)
#	stw r5, 12(sp)
#	stw r6, 16(sp)
#	stw r7, 20(sp)
#	stw r8, 24(sp)
#	stw r9, 28(sp)
#	stw r10, 32(sp)
#	stw r11, 36(sp)
#	stw r12, 40(sp)
#	stw r13, 44(sp)
#	stw r14, 48(sp)
#	stw r15, 52(sp)
	call DRAW_BOX					#draw block
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
#	ldw r2,  0(sp)
#	ldw r3,  4(sp)
#	ldw r4,  8(sp)
#	ldw r5, 12(sp)
#	ldw r6, 16(sp)
#	ldw r7, 20(sp)
#	ldw r8, 24(sp)
#	ldw r9, 28(sp)
#	ldw r10, 32(sp)
#	ldw r11, 36(sp)
#	ldw r12, 40(sp)
#	ldw r13, 44(sp)
#	ldw r14, 48(sp)
#	ldw r15, 52(sp)
#	addi sp,sp, 56
	br Jump_2
	

	Jump_3:
	movi r14, 145
	movi r15, 72
	beq r12,r14, DONE_JUMP 			#checking if done jumping or nah
	call BOX_SHADOW
	bge r15, r12, Jump_3_rise		#checks if x offset is in the first half of the jump or nah
	addi r12,r12,1
	addi r13,r13,1
	br Jump_3_draws
	
	Jump_3_rise:
	addi r12,r12,1					#if not then increments x
	subi r13,r13,1
	
	Jump_3_draws:
	#call DRAW_BGRND				#draw background
	#call DRAW_LEVEL				#draw same level 
#	subi sp,sp, 56
#	stw r2,  0(sp)
#	stw r3,  4(sp)
#	stw r4,  8(sp)
#	stw r5, 12(sp)
#	stw r6, 16(sp)
#	stw r7, 20(sp)
#	stw r8, 24(sp)
#	stw r9, 28(sp)
#	stw r10, 32(sp)
#	stw r11, 36(sp)
#	stw r12, 40(sp)
#	stw r13, 44(sp)
#	stw r14, 48(sp)
#	stw r15, 52(sp)
	call DRAW_BOX					#draw block
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
#	ldw r2,  0(sp)
#	ldw r3,  4(sp)
#	ldw r4,  8(sp)
#	ldw r5, 12(sp)
#	ldw r6, 16(sp)
#	ldw r7, 20(sp)
#	ldw r8, 24(sp)
#	ldw r9, 28(sp)
#	ldw r10, 32(sp)
#	ldw r11, 36(sp)
#	ldw r12, 40(sp)
#	ldw r13, 44(sp)
#	ldw r14, 48(sp)
#	ldw r15, 52(sp)
#	addi sp,sp, 56
	br Jump_3
	

	Jump_4:
	movi r14, 195
	movi r15, 97
	beq r12,r14, DONE_JUMP 			#checking if done jumping or nah
	call BOX_SHADOW
	bge r15, r12, Jump_4_rise		#checks if x offset is in the first half of the jump or nah
	addi r12,r12,1
	addi r13,r13,1
	br Jump_4_draws
	
	Jump_4_rise:
	addi r12,r12,1					#if not then increments x
	subi r13,r13,1
	
	Jump_4_draws:
	#call DRAW_BGRND				#draw background
	#call DRAW_LEVEL				#draw same level 
#	subi sp,sp, 56
#	stw r2,  0(sp)
#	stw r3,  4(sp)
#	stw r4,  8(sp)
#	stw r5, 12(sp)
#	stw r6, 16(sp)
#	stw r7, 20(sp)
#	stw r8, 24(sp)
#	stw r9, 28(sp)
#	stw r10, 32(sp)
#	stw r11, 36(sp)
#	stw r12, 40(sp)
#	stw r13, 44(sp)
#	stw r14, 48(sp)
#	stw r15, 52(sp)
	call DRAW_BOX					#draw block
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
	call DRAW_BOX
#	call DRAW_BOX
#	call DRAW_BOX
#	call DRAW_BOX
#	ldw r2,  0(sp)
#	ldw r3,  4(sp)
#	ldw r4,  8(sp)
#	ldw r5, 12(sp)
#	ldw r6, 16(sp)
#	ldw r7, 20(sp)
#	ldw r8, 24(sp)
#	ldw r9, 28(sp)
#	ldw r10, 32(sp)
#	ldw r11, 36(sp)
#	ldw r12, 40(sp)
#	ldw r13, 44(sp)
#	ldw r14, 48(sp)
#	ldw r15, 52(sp)
#	addi sp,sp, 56
	br Jump_4
	
	
	
DONE_JUMP:
	call BOX_SHADOW
	add r12,r12,r14							#currently r12 is the max X pixels column
	bge r12,r18, HANGING_OFFRIGHT			#if the far right is hanging off the right side	
	
	HANGING_OFFLEFT:						#Hanging off left side
	blt r12,r17,LOSER						#If completely out of range
	subi r12,r12, 25						
	ble r12,r17, NEXT_LEVEL					#successful landing
	HANGING_OFFRIGHT: 						
		subi r12,r12, 25					#r12 holds the left column of x pixels
		ble r12,r18,NEXT_LEVEL		#confirms that left column is within box
		br LOSER

	br DONE_JUMP 
	#set the new bounds by changing the end and start
	#dynamic bounds in the sense that you draw once completely with the changing Y and X
	#once you hit the max Y, you start to decrement until you hit the initial Y (at offset 0)
	#check the location of the X whether it overlaps with a box or not (similar to the sensor
	#conditions)
	#branch to appropriate function depending on success of jump

LOSER:
		br LOSER:
	
DRAW_BGRND:					#draws background
	subi sp,sp, 72
	stw ra,  0(sp)
	stw r8,  4(sp)
	stw r9,  8(sp)
	stw r10, 12(sp)
	stw r11, 16(sp)
	stw r12, 20(sp)
	stw r13, 24(sp)
	stw r14, 28(sp)
	stw r15, 32(sp)
	stw r16, 36(sp)
	stw r17, 40(sp)
	stw r18, 44(sp)
	stw r19, 48(sp)
	stw r20, 52(sp)
	stw r21, 56(sp)
	stw r22, 60(sp)
	stw r23, 64(sp)
	stw r7, 68(sp)
	movui r4, 0x0000		#Black pixel 
	movi r6, MAX_X			#end of X
	mov r7, r0			#set X count to 0
	movi r8, MAX_Y			#end of Y
	br Iterate_X_BGRND
	
  	Iterate_X_BGRND: 
		mov r9,r0			#reset Y count to 0
		br IterateY_BGRND
		
	IterateY_BGRND:
		muli r10, r7, 2			#calculate X
		muli r11, r9, 1024		#calculate Y
		add r10, r10, r11		#calculate offset
		add r2, r2, r10			#change address to draw pixel
		sthio r4, 0(r2)			#print each time loop	
		sub r2, r2, r10			#reset to base VGA adress
		addi r9, r9, 1			#go through all y
		ble r9, r8, IterateY_BGRND		#end of IterateY
		addi r7, r7, 1			#increment 1 x
		ble r7,r6, Iterate_X_BGRND
		br Draw_end_BGRND
		
	Draw_end_BGRND:
		ldw ra, 0(sp)
		ldw r8, 4(sp)
		ldw r9, 8(sp)
		ldw r10, 12(sp)
		ldw r11, 16(sp)
		ldw r12, 20(sp)
		ldw r13, 24(sp)
		ldw r14, 28(sp)
		ldw r15, 32(sp)
		ldw r16, 36(sp)
		ldw r17, 40(sp)
		ldw r18, 44(sp)
		ldw r19, 48(sp)
		ldw r20, 52(sp)
		ldw r21, 56(sp)
		ldw r22, 60(sp)
		ldw r23, 64(sp)
		ldw r7, 68(sp)
		addi sp, sp, 72
		ret

DRAW_LEVEL: 					#draws current level
	subi sp,sp, 72
	stw ra,  0(sp)
	stw r8,  4(sp)
	stw r9,  8(sp)
	stw r10, 12(sp)
	stw r11, 16(sp)
	stw r12, 20(sp)
	stw r13, 24(sp)
	stw r14, 28(sp)
	stw r15, 32(sp)
	stw r16, 36(sp)
	stw r17, 40(sp)
	stw r18, 44(sp)
	stw r19, 48(sp)
	stw r20, 52(sp)
	stw r21, 56(sp)
	stw r22, 60(sp)
	stw r23, 64(sp)
	stw r7, 68(sp)
	movui r4, 0x09C		#Black pixel 
	movi r6, MAX_X			#end of X
	mov r7, r0			#set X count to 0
	movi r8, MAX_Y			#end of Y
	br Iterate_X
	
  	Iterate_X: 
		movi r9,200			#reset Y count to 0
		br IterateY
		
	IterateY:
		muli r10, r7, 2			#calculate X
		muli r11, r9, 1024		#calculate Y
		add r10, r10, r11		#calculate offset
		add r2, r2, r10			#change address to draw pixel
		sthio r4, 0(r2)			#print each time loop	
		sub r2, r2, r10			#reset to base VGA adress
		addi r9, r9, 1			#go through all y
		ble r9, r8, IterateY		#end of IterateY
		addi r7, r7, 1			#increment 1 x
		ble r7,r6, Iterate_X
		br Draw_end
	Draw_end:
		ldw ra, 0(sp)
		ldw r8, 4(sp)
		ldw r9, 8(sp)
		ldw r10, 12(sp)
		ldw r11, 16(sp)
		ldw r12, 20(sp)
		ldw r13, 24(sp)
		ldw r14, 28(sp)
		ldw r15, 32(sp)
		ldw r16, 36(sp)
		ldw r17, 40(sp)
		ldw r18, 44(sp)
		ldw r19, 48(sp)
		ldw r20, 52(sp)
		ldw r21, 56(sp)
		ldw r22, 60(sp)
		ldw r23, 64(sp)
		ldw r7, 68(sp)
		addi sp, sp, 72
		ret
	
DRAW_BOX:
	subi sp,sp, 72
	stw ra,  0(sp)
	stw r8,  4(sp)
	stw r9,  8(sp)
	stw r10, 12(sp)
	stw r11, 16(sp)
	stw r12, 20(sp)
	stw r13, 24(sp)
	stw r14, 28(sp)
	stw r15, 32(sp)
	stw r16, 36(sp)
	stw r17, 40(sp)
	stw r18, 44(sp)
	stw r19, 48(sp)
	stw r20, 52(sp)
	stw r21, 56(sp)
	stw r22, 60(sp)
	stw r23, 64(sp)
	stw r7, 68(sp)
	movui r4,0x09C			#Blue pixel
	movi r6, END_BOX_X		#max box pixels X
	add r6,r6, r12			#adding offset to X component
	movi r7, 70			#X count starts at pixel 15
	add r7,r7,r12			#adding X offset to box
	movi r8, END_BOX_Y		#max box pixels in Y
	add r8, r8 ,r13			#adding Y offset to box
	br Box_X
  Box_X:
	movi r9, 125			#reset Y count to 125
	add r9, r9,r13
	br Box_Y
  Box_Y:
	muli r10, r7, 2 		#storing X component in r10
	muli r11, r9, 1024 		#storing Y component in r11
	add r10, r10, r11 		#adding both X and Y to same 32 bits
	add r2,r2,r10			#adding the offset to storing in address
	sthio r4, 0(r2)
	sub r2, r2, r10
	addi r9, r9, 1
	ble r9, r8, Box_Y
	addi r7, r7, 1
	ble r7, r6, Box_X 
	Draw_box_end:
		ldw ra, 0(sp)
		ldw r8, 4(sp)
		ldw r9, 8(sp)
		ldw r10, 12(sp)
		ldw r11, 16(sp)
		ldw r12, 20(sp)
		ldw r13, 24(sp)
		ldw r14, 28(sp)
		ldw r15, 32(sp)
		ldw r16, 36(sp)
		ldw r17, 40(sp)
		ldw r18, 44(sp)
		ldw r19, 48(sp)
		ldw r20, 52(sp)
		ldw r21, 56(sp)
		ldw r22, 60(sp)
		ldw r23, 64(sp)
		ldw r7, 68(sp)
		addi sp, sp, 72
	ret
  
BOX_SHADOW:
	subi sp,sp, 72
	stw ra,  0(sp)
	stw r8,  4(sp)
	stw r9,  8(sp)
	stw r10, 12(sp)
	stw r11, 16(sp)
	stw r12, 20(sp)
	stw r13, 24(sp)
	stw r14, 28(sp)
	stw r15, 32(sp)
	stw r16, 36(sp)
	stw r17, 40(sp)
	stw r18, 44(sp)
	stw r19, 48(sp)
	stw r20, 52(sp)
	stw r21, 56(sp)
	stw r22, 60(sp)
	stw r23, 64(sp)
	stw r7, 68(sp)
	movui r4,0x0000			#Blue pixel
	movi r6, END_BOX_X		#max box pixels X
	add r6,r6, r12			#adding offset to X component
	movi r7, 15			#X count starts at pixel 15
	add r7,r7,r12			#adding X offset to box
	movi r8, END_BOX_Y		#max box pixels in Y
	add r8, r8 ,r13			#adding Y offset to box
	br Box_X
  Shadow_Box_X:
	movi r9, 150			#reset Y count to 150
	add r9, r9,r13
	br Shadow_Box_Y
  Shadow_Box_Y:
	muli r10, r7, 2 		#storing X component in r10
	muli r11, r9, 1024 		#storing Y component in r11
	add r10, r10, r11 		#adding both X and Y to same 32 bits
	add r2,r2,r10			#adding the offset to storing in address
	sthio r4, 0(r2)
	sub r2, r2, r10
	addi r9, r9, 1
	ble r9, r8, Shadow_Box_Y
	addi r7, r7, 1
	ble r7, r6, Shadow_Box_X 
	Draw_Shadowbox_end:
		ldw ra, 0(sp)
		ldw r8, 4(sp)
		ldw r9, 8(sp)
		ldw r10, 12(sp)
		ldw r11, 16(sp)
		ldw r12, 20(sp)
		ldw r13, 24(sp)
		ldw r14, 28(sp)
		ldw r15, 32(sp)
		ldw r16, 36(sp)
		ldw r17, 40(sp)
		ldw r18, 44(sp)
		ldw r19, 48(sp)
		ldw r20, 52(sp)
		ldw r21, 56(sp)
		ldw r22, 60(sp)
		ldw r23, 64(sp)
		ldw r7, 68(sp)
		addi sp, sp, 72
	ret  
	
DRAW_PLATFORM:
	subi sp,sp, 72
	stw ra,  0(sp)
	stw r8,  4(sp)
	stw r9,  8(sp)
	stw r10, 12(sp)
	stw r11, 16(sp)
	stw r12, 20(sp)
	stw r13, 24(sp)
	stw r14, 28(sp)
	stw r15, 32(sp)
	stw r16, 36(sp)
	stw r17, 40(sp)
	stw r18, 44(sp)
	stw r19, 48(sp)
	stw r20, 52(sp)
	stw r21, 56(sp)
	stw r22, 60(sp)
	stw r23, 64(sp)
	stw r7, 68(sp)
	movui r4,0xA00A			#Blue pixel
	movi r6, END_PTFM_X		#max box pixels X
	movi r7, 0			#X count starts at pixel 0
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
	ldw ra, 0(sp)
		ldw r8, 4(sp)
		ldw r9, 8(sp)
		ldw r10, 12(sp)
		ldw r11, 16(sp)
		ldw r12, 20(sp)
		ldw r13, 24(sp)
		ldw r14, 28(sp)
		ldw r15, 32(sp)
		ldw r16, 36(sp)
		ldw r17, 40(sp)
		ldw r18, 44(sp)
		ldw r19, 48(sp)
		ldw r20, 52(sp)
		ldw r21, 56(sp)
		ldw r22, 60(sp)
		ldw r23, 64(sp)
		ldw r7, 68(sp)
		addi sp, sp, 72
	ret
	
	
	
CLEAR_BLOCKS:
	subi sp,sp, 72
	stw ra,  0(sp)
	stw r8,  4(sp)
	stw r9,  8(sp)
	stw r10, 12(sp)
	stw r11, 16(sp)
	stw r12, 20(sp)
	stw r13, 24(sp)
	stw r14, 28(sp)
	stw r15, 32(sp)
	stw r16, 36(sp)
	stw r17, 40(sp)
	stw r18, 44(sp)
	stw r19, 48(sp)
	stw r20, 52(sp)
	stw r21, 56(sp)
	stw r22, 60(sp)
	stw r23, 64(sp)
	stw r7, 68(sp)
	movui r4,0x0000			#Black pixel
	movi r6, MAX_X			#max box pixels X
	movi r7, 100			#X count starts at pixel 0
	movi r8, MAX_Y			#max box pixels in Y
  Clear_X:
	movi r9, 125			#reset Y count to 150
  Clear_Y:
	muli r10, r7, 2
	muli r11, r9, 1024
	add r10, r10, r11
	add r2,r2,r10
	sthio r4, 0(r2)
	sub r2, r2, r10
	addi r9, r9, 1
	ble r9, r8, Clear_Y
	addi r7, r7, 1
	ble r7, r6, Clear_X
		ldw r8, 4(sp)
		ldw r9, 8(sp)
		ldw r10, 12(sp)
		ldw r11, 16(sp)
		ldw r12, 20(sp)
		ldw r13, 24(sp)
		ldw r14, 28(sp)
		ldw r15, 32(sp)
		ldw r16, 36(sp)
		ldw r17, 40(sp)
		ldw r18, 44(sp)
		ldw r19, 48(sp)
		ldw r20, 52(sp)
		ldw r21, 56(sp)
		ldw r22, 60(sp)
		ldw r23, 64(sp)
		ldw r7, 68(sp)
		addi sp, sp, 72
		
ret
	
	
	

	
	
#BRANCH TO HERE AFTER CLEARING BLOCKS FROM LAST LEVEL	
	
NEXT_LEVEL:
  	movi r12, 0 			#Init box X offset
  	movi r13, 0				#Init box y offset only change when jumping
	movi r14, 1				# X offset limit (changes with jump, compare to r12)
	movi r15, 0				# Y offset limit (changeds with jump, compare to r13)
	addi r5, r5, 1
	movi r16, 6
	blt r5, r16, EASY		#do up to 5 do easy mode
	movi r16, 11
	blt r5, r16, MEDIUM		#do up to 10 do medium mode
	movi r16, 16
	blt r5, r16, HARD		#do up to 15 do hard mode
	movi r16, 21
	blt r5, r16, SUPER		#do up to 20 do super mode
	br WIN				#when count reaches 21 go to win screen

EASY:
	call CLEAR_BLOCKS
	call DRAW_BOX
	mov r15, r0
	beq r4, r15, Pos1E
	addi r15, r15, 1
	beq r4, r15, Pos3E
	addi r15, r15, 1
	beq r4, r15, Pos5E
	addi r15, r15, 1
	beq r4, r15, Pos2E
	addi r15, r15, 1
	beq r4, r15, Pos4E
	addi r15, r15, 1
	beq r4, r15, Pos5E
	addi r15, r15, 1
	beq r4, r15, Pos3E
	addi r15, r15, 1
	beq r4, r15, Pos2E
	addi r15, r15, 1
	beq r4, r15, Pos2E
	addi r15, r15, 1
	beq r4, r15, Pos4E
	addi r15, r15, 1
	beq r4, r15, Pos1E

Pos1E:
	movi r6, BLOCK_START+EW			#max block pixels X
	movi r7, BLOCK_START			#X count starts at pixel 0
	br BLOCK_DRAW
Pos2E:
	movi r6, BLOCK_START+EW+25		#max block pixels X
	movi r7, BLOCK_START+25			#X count starts at pixel 0
	br BLOCK_DRAW
Pos3E:
	movi r6, BLOCK_START+EW+50		#max block pixels X
	movi r7, BLOCK_START+50		#X count starts at pixel 0
	br BLOCK_DRAW
Pos4E:
	movi r6, BLOCK_START+EW+75		#max block pixels X
	movi r7, BLOCK_START+75		#X count starts at pixel 0
	br BLOCK_DRAW
Pos5E:
	movi r6, BLOCK_START+EW+100		#max block pixels X
	movi r7, BLOCK_START+100		#X count starts at pixel 0
	br BLOCK_DRAW

MEDIUM:
	call CLEAR_BLOCKS
	call DRAW_BOX
	mov r15, r0
	beq r4, r15, Pos6M
	addi r15, r15, 1
	beq r4, r15, Pos3M
	addi r15, r15, 1
	beq r4, r15, Pos5M
	addi r15, r15, 1
	beq r4, r15, Pos2M
	addi r15, r15, 1
	beq r4, r15, Pos3M
	addi r15, r15, 1
	beq r4, r15, Pos6M
	addi r15, r15, 1
	beq r4, r15, Pos5M
	addi r15, r15, 1
	beq r4, r15, Pos4M
	addi r15, r15, 1
	beq r4, r15, Pos4M
	addi r15, r15, 1
	beq r4, r15, Pos2M
	addi r15, r15, 1
	beq r4, r15, Pos1M

Pos1M:
	movi r6, BLOCK_START+MW			#max block pixels X
	movi r7, BLOCK_START			#X count starts at pixel 0
	br BLOCK_DRAW
Pos2M:
	movi r6, BLOCK_START+MW+25		#max block pixels X
	movi r7, BLOCK_START+25			#X count starts at pixel 0
	br BLOCK_DRAW
Pos3M:
	movi r6, BLOCK_START+MW+50		#max block pixels X
	movi r7, BLOCK_START+50			#X count starts at pixel 0
	br BLOCK_DRAW
Pos4M:
	movi r6, BLOCK_START+MW+75		#max block pixels X
	movi r7, BLOCK_START+75			#X count starts at pixel 0
	br BLOCK_DRAW
Pos5M:
	movi r6, BLOCK_START+MW+100		#max block pixels X
	movi r7, BLOCK_START+100		#X count starts at pixel 0
	br BLOCK_DRAW
Pos6M:
	movi r6, BLOCK_START+MW+125		#max block pixels X
    	movi r7, BLOCK_START+125		#X count starts at pixel 0
	br BLOCK_DRAW

HARD:
	call CLEAR_BLOCKS
	call DRAW_BOX
	mov r15, r0
	beq r4, r15, Pos4H
	addi r15, r15, 1
	beq r4, r15, Pos7H
	addi r15, r15, 1
	beq r4, r15, Pos6H
	addi r15, r15, 1
	beq r4, r15, Pos5H
	addi r15, r15, 1
	beq r4, r15, Pos3H
	addi r15, r15, 1
	beq r4, r15, Pos2H
	addi r15, r15, 1
	beq r4, r15, Pos5H
	addi r15, r15, 1
	beq r4, r15, Pos4H
	addi r15, r15, 1
	beq r4, r15, Pos2H
	addi r15, r15, 1
	beq r4, r15, Pos3H
	addi r15, r15, 1
	beq r4, r15, Pos1H

Pos1H:
	movi r6, BLOCK_START+HW			#max block pixels X
	movi r7, BLOCK_START			#X count starts at pixel 0
	br BLOCK_DRAW
Pos2H:
	movi r6, BLOCK_START+HW+25		#max block pixels X
	movi r7, BLOCK_START+25			#X count starts at pixel 0
	br BLOCK_DRAW
Pos3H:
	movi r6, BLOCK_START+HW+50		#max block pixels X
	movi r7, BLOCK_START+50			#X count starts at pixel 0
	br BLOCK_DRAW
Pos4H:
	movi r6, BLOCK_START+HW+75		#max block pixels X
	movi r7, BLOCK_START+75			#X count starts at pixel 0
	br BLOCK_DRAW
Pos5H:
	movi r6, BLOCK_START+HW+100		#max block pixels X
	movi r7, BLOCK_START+100		#X count starts at pixel 0
	br BLOCK_DRAW
Pos6H:
	movi r6, BLOCK_START+HW+125		#max block pixels X
	movi r7, BLOCK_START+125		#X count starts at pixel 0
	br BLOCK_DRAW
Pos7H:
	movi r6, BLOCK_START+HW+150		#max block pixels X
	movi r7, BLOCK_START+150		#X count starts at pixel 0
	br BLOCK_DRAW
    
SUPER:
	call CLEAR_BLOCKS
	call DRAW_BOX
	mov r15, r0
	beq r4, r15, Pos8S
	addi r15, r15, 1
	beq r4, r15, Pos5S
	addi r15, r15, 1
	beq r4, r15, Pos3S
	addi r15, r15, 1
	beq r4, r15, Pos2S
	addi r15, r15, 1
	beq r4, r15, Pos7S
	addi r15, r15, 1
	beq r4, r15, Pos6S
	addi r15, r15, 1
	beq r4, r15, Pos1S
	addi r15, r15, 1
	beq r4, r15, Pos4S
	addi r15, r15, 1
	beq r4, r15, Pos6S
	addi r15, r15, 1
	beq r4, r15, Pos8S
	addi r15, r15, 1
	beq r4, r15, Pos2S

Pos1S:
	movi r6, BLOCK_START+SW			#max block pixels X
	movi r7, BLOCK_START			#X count starts at pixel 0
	br BLOCK_DRAW
Pos2S:
	movi r6, BLOCK_START+SW+25		#max block pixels X
	movi r7, BLOCK_START+25			#X count starts at pixel 0
	br BLOCK_DRAW
Pos3S:
	movi r6, BLOCK_START+SW+50		#max block pixels X
	movi r7, BLOCK_START+50			#X count starts at pixel 0
	br BLOCK_DRAW
Pos4S:
	movi r6, BLOCK_START+SW+75		#max block pixels X
	movi r7, BLOCK_START+75			#X count starts at pixel 0
	br BLOCK_DRAW
Pos5S:
	movi r6, BLOCK_START+SW+100		#max block pixels X
	movi r7, BLOCK_START+100		#X count starts at pixel 0
	br BLOCK_DRAW
Pos6S:
	movi r6, BLOCK_START+SW+125		#max block pixels X
	movi r7, BLOCK_START+125		#X count starts at pixel 0
	br BLOCK_DRAW
Pos7S:
	movi r6, BLOCK_START+SW+150	#max block pixels X
	movi r7, BLOCK_START+150		#X count starts at pixel 0
	br BLOCK_DRAW
Pos8S:
	movi r6, BLOCK_START+SW+175	#max block pixels X
	movi r7, BLOCK_START+175		#X count starts at pixel 0
	br BLOCK_DRAW

BLOCK_DRAW:
	
	mov r17,r7  			#block start
	mov r18,r6				#block end
	movui r4,0x04F0			#Green pixel
	movi r8, END_PTFM_Y		#max box pixels in Y
  BlockDraw_X:
	movi r9, 150			#reset Y count to 150
  BlockDraw_Y:
	muli r10, r7, 2
	muli r11, r9, 1024
	add r10, r10, r11
	add r2,r2,r10
	sthio r4, 0(r2)
	sub r2, r2, r10
	addi r9, r9, 1
	ble r9, r8, BlockDraw_Y
	addi r7, r7, 1
	ble r7, r6, BlockDraw_X
	
Score:
	movui r6, 0x1111		#White pixel
	sthio r6, 0(r2)		#draw pixel at (0,0) apparently keeps my text white...
	movui r6, 0x39			#comparison for 9
	beq r6, r20, Increment_Big	#if first value is 9
	#else increment first value
	addi r20, r20, 1		#add 1 to score
	br Print
  Increment_Big:
	addi r19, r19, 1		#increment second by 1
	movui r20, 0x30			#set first to 0
  Print:
	stbio r19, 422(r3)		#draws at (38,3)
	stbio r20, 423(r3)		#draws at (39,3)
	br Interrupt_EXIT


	
	
	
WIN:
	movui r6, 0x1111		#White pixel
	sthio r6, 0(r2)		#draw pixel at (0,0) apparently keeps my text white...
	movui r6, 0x59   		#Y
	stbio r6, 675(r3)		#draws at (35,5)   x + y*128=675
	movui r6, 0x4F   		#O
	stbio r6, 676(r3)		#draws at (36,2)
	movui r6, 0x55  		#U
	stbio r6, 677(r3)		#draws at (37,2)
	movui r6, 0x57		   	#W
	stbio r6, 679(r3)		#draws at (39,2)
	movui r6, 0x49			#I
	stbio r6, 680(r3)		#draws at (40,2)
	movui r6, 0x4E			#N
	stbio r6, 681(r3)		#draws at (41,2)
	movui r6, 0x21			#!
	stbio r6, 682(r3)		#draws at (42,2)
	
#INTERRUPTTTTTTTTTTTTTTTTTTTTT
	
.section .exceptions, "ax"
	TIMES_UP:

	addi sp,sp, -8
	rdctl et, ctl1
	stw et, 0(sp)		
	stw ea, 4(sp)	
	rdctl et, ctl4	
	andi et, et, 1	
	beq et, r0, Timer_Interrupt

		
	Timer_Interrupt:
	
	xori r11, r11, 1	
	movia et, LED	
	stwio r11, 0(r10)	
	movia et, Timer	
	stwio r0, 0(et) # acknowledge timer	
	movia et, 0x01	 
	wrctl ctl0, et
	
	br Interrupt_EXIT			#NEED TO REPLACE THIS BRANCH WITH THE JUMP STUFF
		

Interrupt_EXIT:

	ldw et, 0(sp)	
	ldw ea, 4(sp)	
	wrctl ctl1, et
	addi sp, sp, 8	
	subi ea, ea, 4	
eret
	
