//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	AIShoot.s



					//***This file is used to allow the Pawns and Knights to shoot at the human
					//AIBullets is a on/off switch to check if there is a current bullet being shot.
					//AIBulletCor is the x/y cordinates of the shot to maintain it throughout the game.
					//only one bullet can be shot at any given time (for the pawns and knights). 
					//a certain pawn/knight randomly choosen (see AI.s) and its x and y cordinate are passed in
					//this allows the bullet to be printed at the correct spot
					//if there is a collision this file will pass cordinates to updateAI (located in AI)
					//this will update the health of the object that was hit. 
.section .data
AIBullets:	.byte 0
.align
AIBulletCor:	.word 0, 0
.align




.text
.globl	AIS
AIS:
	push 	{r4 - r10, lr}

newShot:

	ldr	r4, =AIBullets		//load AIBullets into r4
	ldrb	r5, [r4]		//load 1st object into r5
	cmp	r5, #1			//check to see if there is a bullet being shot (ie. =1)
	bleq	skipNewAIShot		//if there is a current bullet being shot skip creating a new one

//~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Update bullet to on (1)
//~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ldr	r4, =AIBullets		//load the register address
	ldrb	r5, [r4]		//load current bullet check
	add	r5, #1			//change bullet to on
	ldr	r4, =AIBullets		//load the address
	strb	r5, [r4]		//store the answer back in
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



	mov	r4, r1			//using the passed y value place in r4
	mov	r5, r0			//load current x position in r5
	add	r5, #9			//add 9 to get the center of the ship
	add	r4, #22			//add 22 to get to the front of the ship
	
	ldr	r6, =AIBulletCor	//load the bullet cordinates
	str	r5, [r6]		//store the x position of the bullet in the array

	ldr	r6, =AIBulletCor	//load the bullet cordinates
	str	r4, [r6, #4]		//store the y position of the bullet in the array

	mov 	r0, r5			//mov updated x into r0
	mov 	r1, r4			//mov updated y into r1
	ldr 	r2, =0xFFFF		//move white color into r2
	bl	DrawPixel		//branch to draw pixel

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Create a loop to draw a 5px long bullet
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	mov	r9, #0			//set the counter for the loop
AILoopA:
	cmp	r9, #6			//check to see if end the loop
	bleq	EndAILoopA		//branch to EndAILoopA if the loop is done

	ldr	r4, =AIBulletCor	//load the adress into r4
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save the address (since load auto-deletes)

	ldr	r4, =AIBulletCor	//reload the address
	ldr	r1, [r4,#4]		//load the y value in r1
	add	r1, #1			//subtract 1 pixel from the y cordinates
	mov	r1, r1			//save reg
		
	ldr	r4, =AIBulletCor	//load the address into r4
	str	r1, [r4,#4]		//store the updated y value in skipNewAIShot

	ldr	r2, =0xFFFF		//load white into r2 to be passed
	bl	DrawPixel		//branch to draw pixel
	add	r9, #1			//increment the counter
	bl	AILoopA		//restart loop

EndAILoopA:				//end of loop

	bl	endAIShoot		//since we just created a new bullet we want to end



//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//This is Where We Branch To If There is Already a bullet being shot
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
skipNewAIShot:
	ldr	r4, =AIBullets		//load the address in r4
	ldrb	r5, [r4]		//load the bullet in r5
	cmp	r5, #0			//double check there is a bullet being shot
	bleq	endAIShoot		//skip if there is not a bullet being shot



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//loop to draw and delete next/last 5 px
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	mov	r9, #6			//set the counter for loop

AILoopB:				//top of the loop
	cmp	r9, #0			//cmp counter to 0
	bleq	endAIShoot		//branch if equal to end of function

	ldr	r4, =AIBulletCor	//load the register into r4
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg
	
	ldr	r4, =AIBulletCor	//load the register into r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg
	add	r1, #1			//move 1 pixel down

	ldr	r4, =AIBulletCor	//load the register into r4
	str	r1, [r4,#4]		//store the updated y value

	cmp	r1, #440		//check to see if less than 440
	bllt	avoidFF			//if it is skip check px to avoid  friendly fire

	bl CheckPixel			//check the pixel color (infront of bullet)
	cmp 	r0, #0x0		//compare to black
	blne	passAIValue		//if it is not black update since we have a colision



avoidFF:				//avoid friendly fire branch
	ldr	r4, =AIBulletCor	//load address in r4
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg
	
	ldr	r4, =AIBulletCor	//load address in r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg

	cmp	r1, #740		//see if it is out of bounds
	bleq	deleteShot		//if it is, branch to delete the shot

	ldr	r2, =0xFFFF		//load white into r2
	bl	DrawPixel		//draw the next pixel

	ldr	r4, =AIBulletCor	//load address in r4
	ldr	r0, [r4]		//load the x value in r0
	mov 	r0, r0			//save the register

	ldr	r4, =AIBulletCor	//load address in r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg
	sub	r1, #7			//subtract 7 to delete the last pixel from current cor

	ldr	r2, =0x0		//load black into r2
	bl	DrawPixel		//branch to draw pixel

	sub	r9, #1			//subtract the counter
	bl	AILoopB			//restart the loop



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Pass the x and y cordinate if something was hit
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
passAIValue:	
	ldr	r4, =AIBulletCor	//load the address into r4
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save the reg
	
	ldr	r4, =AIBulletCor	//load the address into r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save the reg

	bl	UpdateHuman		//branch to UpdateHuman



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Delete the shot if it hit something or it is OB
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
deleteShot:				//delete the shot branch

	mov	r8, #0			//set the counter
AILoopC:				//top of loop
	cmp	r8, #8			//see if loop is done
	bleq	EndAILoopC		//branch to end of loop if over

	ldr	r4, =AIBulletCor	//load the address into r4	
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg

	ldr	r4, =AIBulletCor	//load the address into r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save the reg
	sub	r1, r8			//reach the back of shot y-r8,y-(r8+1),...

	mov	r2, #0x0		//mov black into r2
	bl	DrawPixel		//branch to draw pixel

	add	r8, #1			//increment loop counter
	bl	AILoopC			//branch to top of loop
EndAILoopC:				//end of loop
	


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//reset the bullet to available
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ldr	r4, =AIBullets		//load the address into r4
	ldrb	r5, [r4]		//load current bullet status

	sub	r5, #1			//change bullet to available =0

	ldr	r4, =AIBullets		//load the address into r4
	strb	r5, [r4]		//store the answer back in




endAIShoot:				//end of function


	pop 	{r4 - r10, pc}
	bx 	lr
