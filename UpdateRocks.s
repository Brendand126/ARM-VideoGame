//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	UpdateRocks.s

//this function is branched to from either update ai or update human and is used to decrement and 
//store the rock health. It is also used to print lower rock health pictures


.data
RockHealth:	.byte 15, 15, 15


.text

.globl UpdateRocks
UpdateRocks:
push	{r4-r10, lr}
rockCol:
	cmp r0, #700				// compare the x value to the rock location
	blge	rockC
	cmp r0, #460				// (x<700, x=A|B) compare the x value to the rock location
	blge	rockB				// if (450<x<700, X=B)
	bl	rockA					// if x<450,x=A)
//~~~~~~~~ROCK~A~~~~~~~~~~~~~~~~~~~~~~~~
rockA:
	ldr	r4, =RockHealth			//					
	ldrb	r5, [r4]			//Load rock A health 			****UPDATE****
	cmp	r5, #0
	bleq	delRockA
	ldr	r4, =RockHealth			//					
	ldrb	r5, [r4]			//Load rock A health 			****UPDATE****
	cmp	r5, #6
	bllt	lowRockA
	ldr	r4, =RockHealth			//					
	ldrb	r5, [r4]			//Load rock A health 			****UPDATE****
	cmp	r5, #11
	bllt	medRockA

	bl	doneA

delRockA:
	ldr		r0, =204			//x
	ldr		r1, =631			//y
	mov		r2, #103			//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #41				//y (height) of image -1
	ldr		r4, =asteroid2		
	bl		DeleteImage
	bl		doneA
medRockA:
	ldr		r0, =204			//x
	ldr		r1, =631			//y
	mov		r2, #103			//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #41				//y (height) of image -1
	ldr		r4, =asteroid2
	bl		DrawImage
	bl		doneA
lowRockA:
	ldr		r0, =204			//x
	ldr		r1, =631			//y
	mov		r2, #103			//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #35				//y (height) of image -1
	ldr		r4, =asteroid3
	bl		DrawImage
	bl		doneA
doneA:
	ldr		r4, =RockHealth			//					
	ldrb		r5, [r4]			//Load rock A health 			****UPDATE****
	cmp		r5, #0
	subne		r5, #1
	ldr		r4, =RockHealth			//
	strb		r5, [r4]
	
	bl skipAllB

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~ROCK~B~~~~~~~~~~~~~~~~~~~~~~~~
rockB:
	ldr	r4, =RockHealth			//					
	ldrb	r5, [r4, #1]			//Load Rock B health 			****UPDATE****
	cmp	r5, #0
	bleq	delRockB
	ldr	r4, =RockHealth			//					
	ldrb	r5, [r4, #1]			//Load Rovk B health 			****UPDATE****
	cmp	r5, #6
	bllt	lowRockB
	ldr	r4, =RockHealth			//					
	ldrb	r5, [r4, #1]			//Load rock b health 			****UPDATE****
	cmp	r5, #11
	bllt	medRockB

	bl	doneB

delRockB:
	ldr		r0, =460		//x
	ldr		r1, =631		//y
	mov		r2, #103		//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #41		//y (height) of image -1
	ldr		r4, =asteroid2
	bl		DeleteImage
	bl		doneB
medRockB:
	ldr		r0, =460		//x
	ldr		r1, =631		//y
	mov		r2, #103		//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #41		//y (height) of image -1
	ldr		r4, =asteroid2
	bl		DrawImage
	bl		doneB
lowRockB:
	ldr		r0, =460		//x
	ldr		r1, =631		//y
	mov		r2, #103		//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #35		//y (height) of image -1
	ldr		r4, =asteroid3
	bl		DrawImage
	bl		doneB
doneB:
	ldr		r4, =RockHealth			//					
	ldrb		r5, [r4, #1]			//Load pawn B health 			****UPDATE****
	cmp		r5, #0
	subne		r5, #1
	ldr		r4, =RockHealth			//
	strb		r5, [r4, #1]
	
	bl skipAllB
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~ROCK~C~~~~~~~~~~~~~~~~~~~~~~~~
rockC:
	ldr	r4, =RockHealth			//					
	ldrb	r5, [r4, #2]			//Load rock C health 			****UPDATE****
	cmp	r5, #0
	bleq	delRockC
	ldr	r4, =RockHealth			//					
	ldrb	r5, [r4, #2]			//Load rock C health 			****UPDATE****
	cmp	r5, #6
	bllt	lowRockC
	ldr	r4, =RockHealth			//					
	ldrb	r5, [r4, #2]			//Load rock C health 			****UPDATE****
	cmp	r5, #11
	bllt	medRockC

	bl	doneC

delRockC:
	ldr		r0, =716		//x
	ldr		r1, =631		//y
	mov		r2, #103		//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #41		//y (height) of image -1
	ldr		r4, =asteroid2
	bl		DeleteImage
	bl		doneC
medRockC:
	ldr		r0, =716		//x
	ldr		r1, =631		//y
	mov		r2, #103		//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #41		//y (height) of image -1
	ldr		r4, =asteroid2
	bl		DrawImage
	bl		doneC
lowRockC:
	ldr		r0, =716		//x
	ldr		r1, =631		//y
	mov		r2, #103		//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #35		//y (height) of image -1
	ldr		r4, =asteroid3
	bl		DrawImage
	bl		doneC
doneC:
	ldr		r4, =RockHealth			//					
	ldrb		r5, [r4, #2]			//Load rock C health 			****UPDATE****
	cmp		r5, #0
	subne		r5, #1
	ldr		r4, =RockHealth			//
	strb		r5, [r4, #2]
	
skipAllB:
	pop	{r4-r10, pc}
	bx lr






//This is branched to from reset and it accesses the health of the rocks and resets them to 15
.globl ResetRockHealth
ResetRockHealth:
push	{r4-r10, lr}


	mov	r1, #15
	ldr	r0, =RockHealth
	strb	r1, [r0]
	ldr	r0, =RockHealth
	strb	r1, [r0, #1]
	ldr	r0, =RockHealth
	strb	r1, [r0, #2]

pop	{r4-r10, pc}
	bx lr


