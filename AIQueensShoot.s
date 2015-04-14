//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	AIQueensShoot.s

					//***This file is used to allow the Queens to shoot at the human player
					//QAIBullet is a on/off switch to check if there is a current bullet being shot.
					//QAIBulletCor is the x/y cordinates of the shot to maintain it throughout the game.
					//only one bullet can be shot at any given time (for the Queens). 
					//a certain queen is randomly choosen (see AI.s) and its x and y cordinate are passed in
					//this allows the bullet to be printed at the correct spot
					//if there is a collision this file will pass cordinates to updateAI (located in AI)
					//which will update the health of the object that was hit. 

.section .data
QAIBullet:	.byte 0
.align
QAIBulletCor:	.word 0, 0
.align




.text
.globl	AIST
AIST:
	push 	{r4 - r10, lr}
	



newShotT:

	ldr	r4, =QAIBullet		//load QAIBullet into r4
	ldrb	r5, [r4]		//load 1st bullet into r5
	cmp	r5, #1			//check to see if there is a bullet being shot
	bleq	skipNewQAIShot		//if there is a current bullet being shot skip this part

//~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Update bullet to on (1)
//~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ldr	r4, =QAIBullet		//load address into r4
	ldrb	r5, [r4]		//load current bullet check
	add	r5, #1			//change bullet to on
	ldr	r4, =QAIBullet
	strb	r5, [r4]		//store the answer back in
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



	mov	r4, r1			//pass in the y coordinate into r4
	mov	r5, r0			//load current x position in r5
	add	r5, #9			//add 9 to get the center of the ship
	add	r4, #22			//add 22 to get to front of ship
	
	ldr	r6, =QAIBulletCor	//load the bullet cordinates
	str	r5, [r6]		//store the x position of the bullet in the array

	ldr	r6, =QAIBulletCor	//load the bullet cordinates
	str	r4, [r6, #4]		//store the x position of the bullet in the array

	mov 	r0, r5			//move x into r0
	mov 	r1, r4			//move y into r1
	ldr 	r2, =0xFFFF		//move color into r2
	bl	DrawPixel		//branch to draw pixel




//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Create a loop to draw a 5px long bullet
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	mov	r9, #0			//set the counter
QAILoopA:				//top of loop
	cmp	r9, #6			//check to see if end the loop
	bleq	EndQAILoopA

	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0

	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r1, [r4,#4]		//load the y value in r1
	add	r1, #1			//subtract 1 pixel from the y cordinates
	mov	r1, r1			//save reg
	
	ldr	r4, =QAIBulletCor	//load address into r4
	str	r1, [r4,#4]		//store the updated y value in skipNewQAIShot

	ldr	r2, =0xFFFF		//load white into r2
	bl	DrawPixel		//branch to draw pixel

	add	r9, #1			//increment the counter
	bl	QAILoopA		//restart loop

EndQAILoopA:

	bl	EndQAIShoot




//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//This is Where We Branch To If There is Already a bullet being shot
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
skipNewQAIShot:				//skip if there is a new shot
	ldr	r4, =QAIBullet		//load address into r4
	ldrb	r5, [r4]		//see if there is not a current bullet
	cmp	r5, #0			//double check there is a bullet being shot
	bleq	EndQAIShoot		//skip if there is not a bullet being shot


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//delete old 5 and draw the next 5 pixels
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	mov	r9, #6			//initialize the counter
QAILoopB:				//queen ai loop b

	cmp	r9, #0			//compare the counter to 0
	bleq	EndQAIShoot		//skip if it is over to end of function

	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg
	
	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg
	add	r1, #1			//move 1 pixel down

	ldr	r4, =QAIBulletCor	//load address into r4
	str	r1, [r4,#4]		//store the updated y value

	cmp	r1, #440		//check to avoid FF
	bllt	QFF			//branch to avoid FF

	bl CheckPixel			//check to see if there is a colision
	cmp 	r0, #0x0		//compare to black
	blne	passQAIValue		//if collision branch to pass value to update ai (in AI)



QFF:					//queen friendly fire
	
	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg
	
	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg

	cmp	r1, #740		//see if it is out of bounds
	bleq	deleteQShot		//delete the queens shot if true

	
	ldr	r2, =0xFFFF		//otherwise load white into r2
	bl	DrawPixel		//draw the next pixel

	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r0, [r4]		//load the x value in r0
	mov 	r0, r0			//sve the register

	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg

	sub	r1, #7			//delete the last pixel ofset 7

	ldr	r2, =0x0		//load black into r2
	bl	DrawPixel		//branch to draw pixel

	sub	r9, #1			//subtract the counter
	bl	QAILoopB		//restart the loop




//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Pass the x and y cordinate if something was hit
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
passQAIValue:				//pass queen ai value
	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg
	
	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save reg

	bl	UpdateHuman		//branch to update human function




//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Delete the shot if it hit something or it is OB
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
deleteQShot:				//delete the queens shot

	mov	r8, #0			//set the counter

QAILoopC:
	cmp	r8, #8			//compare the counter to 8
	bleq	EndQAILoopC		//branch to end of loop if over

	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r0, [r4]		//load the x value in r0
	mov	r0, r0			//save reg

	ldr	r4, =QAIBulletCor	//load address into r4
	ldr	r1, [r4,#4]		//load the y value in r1
	mov	r1, r1			//save the reg
	sub	r1, r8			//delete y-r8...

	mov	r2, #0x0		//move black into the r2 reg
	bl	DrawPixel		//branch to draw pixel

	add	r8, #1			//inc counter
	bl	QAILoopC		//restart the loop
EndQAILoopC:		




//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//reset the bullet to available
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	ldr	r4, =QAIBullet		//load address into r4
	ldrb	r5, [r4]		//load current bullet check
	sub	r5, #1			//change bullet to available

	ldr	r4, =QAIBullet		//load address into r4
	strb	r5, [r4]		//store the answer back in




EndQAIShoot:				//end of function


	pop 	{r4 - r10, pc}
	bx 	lr
