//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	boolit.s.s





.data
bullets:	.byte 0
.align
bulletCor:	.word 0, 690
.align




.text
.global Boolit

//must pass current x position in r0
//must pass in the address for buttons in r1
Boolit:
	push 	{r4 - r10, lr}
	

	mov 	r6,  r1
	ldrb 	r5, [r6, #8]		//a is pressed?
	cmp 	r5, #0			//check to see if b is pressed
	bleq	newShot			//if b has been pressed go through and add the new bullet
	bl	skipNewShot		//if b has not been pressed update the existing shot


newShot:

	ldr	r4, =bullets		//load bullets into r4
	ldrb	r5, [r4]		//load 1st bullet into r5
	cmp	r5, #1			//check to see if there is a bullet being shot
	bleq	skipNewShot		//if there is a current bullet being shot skip this part

//~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Update bullet
//~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ldr	r4, =bullets
	ldrb	r5, [r4]		//load current bullet check
	add	r5, #1			//change bullet to on
	ldr	r4, =bullets
	strb	r5, [r4]		//store the answer back in
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	ldr	r4, =689		//hardcode the first y coordinate
	mov	r4, r4
	mov	r5, r0			//load current x position in r5
	add	r5, #21			//add x to get the center of the ship
	
	ldr	r6, =bulletCor		//load the bullet cordinates
	str	r5, [r6]		//store the x position of the bullet in the array

	mov 	r0, r5			//move x into r0
	mov 	r1, r4			//move y into r1
	ldr 	r2, =0xFFFF		//move color into r2
	bl	DrawPixel		//draw pixel


	mov	r9, #6			//set the counter
loopTop:
	cmp	r9, #0			//check to see if end the loop
	bleq	endLoop

	ldr	r4, =bulletCor
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0

	ldr	r4, =bulletCor
	ldr	r1, [r4,#4]		//load the y value in r1
	sub	r1, #1			//subtract 1 pixel from the y cordinates
	mov	r1, r1			//save reg
	
	ldr	r4, =bulletCor
	str	r1, [r4,#4]		//store the updated y value in bulletCor

	ldr	r2, =0xFFFF
	bl	DrawPixel	
	sub	r9, #1
	bl	loopTop			//restart loop
endLoop:

	bl	skipUpdB


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
skipNewShot:
	ldr	r4, =bullets
	ldrb	r5, [r4]		//see if there is not a current bullet
	cmp	r5, #0
	bleq	skipUpdB		//skip if there is not a bullet being shot

//delete old 5 and draw the next 5 pixels
	mov	r9, #6
loopTopB:
	cmp	r9, #0
	bleq	skipUpdB

	ldr	r4, =bulletCor
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg
	
	ldr	r4, =bulletCor
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg
	sub	r1, #1			//move 1 pixel up

	ldr	r4, =bulletCor
	str	r1, [r4,#4]		//store the updated y value in bulletCor

	bl CheckPixel
	cmp 	r0, #0x0
	blne	passValue
	
	ldr	r4, =bulletCor
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg
	
	ldr	r4, =bulletCor
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg

	cmp	r1, #2		//see if it is out of bounds
	bleq	deleteShot		//delete the shot

	
	ldr	r2, =0xFFFF
	bl	DrawPixel		//draw the next pixel

	ldr	r4, =bulletCor
	ldr	r0, [r4]		//load the x value in r0
	mov 	r0, r0
	ldr	r4, =bulletCor
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg
	add	r1, #7			//delete the last pixel
	ldr	r2, =0x0
	bl	DrawPixel

	sub	r9, #1			//subtract the counter
	bl	loopTopB		//restart the loop


passValue:	
	ldr	r4, =bulletCor
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg
	
	ldr	r4, =bulletCor
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg
	bl	UpdateAI


deleteShot:
	mov	r8, #0			//set the counter
loopTopC:
	cmp	r8, #8
	bleq	skipUpdA

	ldr	r4, =bulletCor
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg
	ldr	r4, =bulletCor
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save the reg
	add	r1, r8			//delete y+12,11,10...7
	mov	r2, #0x0
	bl	DrawPixel
	add	r8, #1			//decr counter
	bl	loopTopC

skipUpdA:	
	ldr	r4, =bulletCor
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1
	ldr	r1, =690		//reset the y cordinate
	mov	r7, r1
	ldr	r4, =bulletCor
	str	r7, [r4,#4]		//load the y value in r1
	

	mov	r7, #0
	ldr	r4, =bulletCor
	str	r7, [r4]		//load the y value in r1	
	
	ldr	r4, =bullets
	ldrb	r5, [r4]		//load current bullet check
	sub	r5, #1			//change bullet to available
	ldr	r4, =bullets
	strb	r5, [r4]		//store the answer back in

skipUpdB:


	pop 	{r4 - r10, pc}
	bx 	lr

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

