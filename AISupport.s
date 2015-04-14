//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	AISupport.s


.text
.globl Dead
Dead:						//this function allows the ai to be printed as black so 
						//that the speed of the game is maintained. It is stored here 
						//to save space and size in the AI File
						//r0 should contain x cor and r1 should contain y cor
	push	{r4-r10, lr}

	mov		r2, #20			//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #22			//y (height) of image -1
	ldr		r4, =knight		//use the picture of the knight (same size as pawn and queen)
	bl		DeleteImage		//draw the image black to maintain speed

	pop	{r4-r10, pc}
	bx lr
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.globl DrawAIP
DrawAIP:
						//This function allows the ai Pawns (hence the P) to be drawn 
						//it is stored in its own function to allow the AI file
						//to be reduced in size and simplicity
						//r0 should contain x cor and r1 should contain y cor

	push	{r4-r10, lr}

	mov		r2, #20			//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #22			//y (height) of image -1
	ldr		r4, =pawn		//pass in the pawn image
	bl		DrawImage		//branch to draw image

	pop	{r4-r10, pc}
	bx lr
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.globl DrawAIK
DrawAIK:
						//This function is used to print knights(hence the K)
						//it is  stored in its own function to reduce the size and 
						//complexity of the AI file
						//r0 should contain x cor and r1 should contain y cor

	push	{r4-r10, lr}

	mov		r2, #20			//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #22			//y (height) of image -1
	ldr		r4, =knight		//pass the knight in
	bl		DrawImage		//branch to the draw statement

	pop	{r4-r10, pc}
	bx lr
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.globl DrawAIQ
DrawAIQ:
						//This function is used to print queens(hence the Q)
						//it is  stored in its own function to reduce the size and 
						//complexity of the AI file
						//r0 should contain x cor and r1 should contain y cor
	push	{r4-r10, lr}

	mov		r2, #20			//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #22			//y (height) of image -1
	ldr		r4, =queen		//pass queen image in
	bl		DrawImage		//branch to draw

	pop	{r4-r10, pc}
	bx lr
