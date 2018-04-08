_data:

.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000
.equ MAX_X, 319
.equ MAX_Y, 239
.equ END_BOX_X, 35
.equ END_BOX_Y, 165
.equ BOX_START_X, 15
.equ BOX_START_Y, 150
#.equ STACK, 0x3ffffffc #change stack address when using regular board and not simulator
.equ STACK, 0x17fff80
.global _start

_start:
  movia r2,ADDR_VGA
  movia r3, ADDR_CHAR
  movia sp, STACK
  
  call DRAW_BGRND
  
  br NewLevelCoords
  NewLevelCoords:
  	movi r12, 0 			#Init box X offset
  	movi r13, 0			#Init box y offset only change when jumping
	movi r14, 1			#offset limit (changes with jump, compare to r12)
  


#end of draw background  

  DRAW_BOX:
	movui r4,0x09C			#Blue pixel
	movi r6, END_BOX_X		#max box pixels X
	movi r7, 15			#X count starts at pixel 15
	add r7,r7,r12			#adding X offset to box
	movi r8, END_BOX_Y		#max box pixels in Y
	add r8, r8 ,r13			#adding Y offset to box
	br Box_X
  Box_X:
	movi r9, 150			#reset Y count to 150
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
	ble r7, r6, Box_X #
	br LoopForever

LoopForever:
	br LoopForever

SuccessfulJump:
	#Draw BackGround Buffer
	#Generate new level (block layout)
	#Reset block location
	br NewLevelCoords
	
  DRAW_BGRND:
	subi sp,sp, 68
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
	movui r4, 0x0000		#Black pixel 
	movi r6, MAX_X			#end of X
	mov r7, r0			#set X count to 0
	movi r8, MAX_Y			#end of Y
	br Iterate_X
  	Iterate_X: 
		mov r9,r0			#reset Y count to 0
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
	addi sp, sp, 68
	ret

  DRAW_LEVEL:
	subi sp,sp, 68
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
	movui r4, 0x0000		#Black pixel 
	movi r6, MAX_X			#end of X
	mov r7, r0			#set X count to 0
	movi r8, MAX_Y			#end of Y
	br Iterate_X
  	Iterate_X: 
		mov r9,r0			#reset Y count to 0
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
	addi sp, sp, 68
	ret
	
Jump_1:
	movi r14, 45
	addi r12,r12,1
	call DRAW_BGRND				#draw background
	#call DRAW_LEVEL				#draw level
	#draw block
	
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

  
  
