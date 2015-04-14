//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	AI.s


//This file contains all of the artificial intelligence of the enemy. Itchecks to see if the pawns are dead,
//prints them as dead, it prints them as dead since the game needs to maintain a certain speed,
//This file branches to multiple other support files to help save space and cluster of code.









.section .data

AIHealth: 	.byte 	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 5, 5, 10, 10 
.align	
AIDir: 		.byte	1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1 
.align
AISHOT:		.word	0
.align
AICor:		.word	100, 176, 280, 335, 400, 530, 615, 700, 805, 911, 100, 300, 500, 730, 900, 200, 800
.align
AICory:		.word	300, 100, 325, 380, 418, 285, 345, 379, 405, 329, 163, 150, 180, 175, 169, 25, 80
.align





//
//AiCor is the current x location of the AI
//AIDir 0=left 1=right
//AIHealth is the amount of health that the ai's have remaining.
//All pawns are in the Y-Boundries (286 <= y <= 429)
//
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//	Quick Summary:
//	PAWNS:				KNIGHTS:
//	|AI |x-Boundries    | y   |	|AI  |x-Boundries    | y   |
//	---------------------------	---------------------------
//	|_A_|_000-130_(+20)_|_300_|	|_AA_|_000-280_(+20)_|_163_|
//	|_B_|_150-190_(+20)_|_400_|	|_BB_|_300-420_(+20)_|_150_|
//	|_C_|_210-300_(+20)_|_325_|	|_CC_|_440-700_(+20)_|_180_|
//	|_D_|_320-360_(+20)_|_380_|	|_AB_|_720-820_(+20)_|_175_|
//	|_E_|_380-500_(+20)_|_418_|	|_BB_|_840-1000(+20)_|_169_|
//	|_F_|_520-580_(+20)_|_285_|	QUEENS:
//	|_G_|_600-640_(+20)_|_345_|	|AAA|_000-1000_(+00)_|_025_|
//	|_H_|_660-780_(+20)_|_379_|	|BBB|_000-1000_(+00)_|_080_|
//	|_I_|_800-820_(+20)_|_405_|
//	|_J_|_840-1000(+20)_|_329_|
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


.section .text
.globl MoveAI
MoveAI:
	push	{r4-r10, lr}

	
	mov r8, #17					//This is a value of all of the guys to see if they are all dead
	
	ldr		r4, =AISHOT			//this is the random value 
	ldr		r5, [r4]			//load it into r5
	cmp		r5, #16				//compare the value to #16 to see if it is not going to select one of guys
	subgt		r5, #17			//if it is then subtract 17
	ldr		r4, =AISHOT			//load the value back in
	str		r5, [r4]			//store the value
	
					
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnA:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN A IS IN THE BOUNDRIES X: (0 <= x <= 130) and Y: (y=300)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 4 and 1
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					****UPDATE****
	ldrb	r5, [r4]			//Load pawn A health 			****UPDATE****
	cmp	r5, #0					//see if the pawn is dead
	bleq	ADead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir				//load Pawn A direction
	ldr	r6, =AICor				//load Pawn A cordinate
	ldr	r7, [r6]				//					****UPDATE****


//~Border Check~~~~~~~~~~~~
	ldr	r7, [r6]				//see if the pawn is at the right border
	cmp	r7, #130				//					****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir				//load Pawn A direction
	ldrb	r5, [r4]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4]			//update the AIDir			****UPDATE****

	ldr	r7, [r6]
	cmp	r7, #0					//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir				//load Pawn A direction
	ldrb	r5, [r4]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir				//load Pawn A direction
	ldrb	r5, [r4]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6]				//					****UPDATE****
	cmp	r5, #0					//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6]				//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7					//x
	ldr		r1, =300				//y					****UPDATE****
	bl		DrawAIP			//**LOCATION: AISupport.s**
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
	
	
	ldr		r4, =AISHOT
	ldr		r4, [r4]			//load the aishot into r4
	cmp 		r4, #0			//see if it is selecting that pawn 
	blne		skipA			//if it isnt skip ahead
	mov		r0, r7				//x
	ldr		r1, =300			//y
	bl		AIS				//**LOCATION: AIShoot.s**
	bl		skipA				//skip over dead


ADead:	
	sub r8, #1	
		
	ldr		r4, =AISHOT
	ldr		r4, [r4]			//load AIShot into r4
	cmp 		r4, #0			//see if the shot was equal to the current pawn
	addeq		r4, #1				//otherwise add 1 to ensure that a pawn fires 					****UPDATE****
	ldr		r5, =AISHOT			//load the address
	str		r4, [r5]			//store the value back in

	ldr		r6, =AICor			//load Pawn A cordinate
	ldr		r0, [r6]			//			
	mov		r1, #300			//x
	bl 		Dead			//**LOCATION: AISuport.s**
skipA:
	


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnB!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnB:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN B IS IN THE BOUNDRIES X: (150 <= x <= 190) and Y: (y=400)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 4 and 1
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					****UPDATE****
	ldrb	r5, [r4, #1]			//Load pawn B health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	BDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn B direction
	ldr	r6, =AICor			//load Pawn B cordinate
	ldr	r7, [r6, #4]			//					****UPDATE****
	



//~Border Check~~~~~~~~~~~~
	ldr	r7, [r6, #4]			//see if the pawn is at the right border
	cmp	r7, #190				//					****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn B direction
	ldrb	r5, [r4, #1]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #1]			//update the AIDir			****UPDATE****

	ldr	r7, [r6, #4]
	cmp	r7, #150			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn A direction
	ldrb	r5, [r4, #1]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #1]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn A direction
	ldrb	r5, [r4, #1]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #4]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #4]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =400		//y					****UPDATE****
	bl		DrawAIP
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #1
	blne		skipB
	mov		r0, r7			//x
	ldr		r1, =400		//y
	bl		AIS


	bl		skipB
BDead:	
	sub r8, #1	
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #1
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
				//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #4]			//			
	mov		r1, #400		//x
	bl 		Dead
skipB:						//					****UPDATE****


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnC!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnC:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN C IS IN THE BOUNDRIES X: (210 <= x <= 290) and Y: (y=325)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 8 and 2
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					****UPDATE****
	ldrb	r5, [r4, #2]			//Load pawn C health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	CDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn C direction
	ldr	r6, =AICor			//load Pawn C cordinate
	ldr	r7, [r6, #8]			//					****UPDATE****
	

//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn C cordinate
	ldr	r7, [r6, #8]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #300				//					****UPDATE****
	ldr	r6, =AICor			//load Pawn C cordinate
	ldr	r7, [r6, #8]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn C direction
	ldrb	r5, [r4, #2]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #2]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn C cordinate
	ldr	r7, [r6, #8]			//					****UPDATE****
	cmp	r7, #210			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn C direction
	ldrb	r5, [r4, #2]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #2]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn C direction
	ldrb	r5, [r4, #2]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #8]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #8]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =325		//y					****UPDATE****
	bl		DrawAIP
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #2
	blne		skipC
	mov		r0, r7			//x
	ldr		r1, =320		//y
	bl		AIS


	bl		skipC
CDead:
	sub r8, #1	
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #2
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
					//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #8]			//			
	ldr		r1, =325			//x
	bl 		Dead
skipC:					//					****UPDATE****


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnD:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN C IS IN THE BOUNDRIES X: (320 <= x <= 350) and Y: (y=380)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 12 and 3
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					****UPDATE****
	ldrb	r5, [r4, #3]			//Load pawn D health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	DDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn D direction
	ldr	r6, =AICor			//load Pawn D cordinate
	ldr	r7, [r6, #12]			//					****UPDATE****
	

//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn D cordinate
	ldr	r7, [r6, #12]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #360			//				****UPDATE****
	ldr	r6, =AICor			//load Pawn D cordinate
	ldr	r7, [r6, #12]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #3]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #3]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn D cordinate
	ldr	r7, [r6, #12]			//					****UPDATE****
	cmp	r7, #320			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #3]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #3]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #3]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #12]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #12]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =380		//y					****UPDATE****
	bl		DrawAIP
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #3
	blne		skipD
	mov		r0, r7			//x
	ldr		r1, =380		//y
	bl		AIS


	bl		skipD
DDead:
	sub r8, #1	
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #3
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
					//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #12]			//			
	ldr		r1, =380			//x
	bl 		Dead
skipD:					//					****UPDATE****

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnE:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN E IS IN THE BOUNDRIES X: (380 <= x <= 500) and Y: (y=418)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 16 and 4
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #4]			//Load pawn E health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	EDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn E direction
	ldr	r6, =AICor			//load Pawn E cordinate
	ldr	r7, [r6, #16]			//					****UPDATE****
	


//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn E cordinate
	ldr	r7, [r6, #16]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #500			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn E cordinate
	ldr	r7, [r6, #16]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn E direction
	ldrb	r5, [r4, #4]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #4]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn E cordinate
	ldr	r7, [r6, #16]			//					****UPDATE****
	cmp	r7, #380			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn E direction
	ldrb	r5, [r4, #4]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #4]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn E direction
	ldrb	r5, [r4, #4]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #16]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #16]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =418		//y					****UPDATE****
	bl		DrawAIP
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #4
	blne		skipE
	mov		r0, r7			//x
	ldr		r1, =418		//y
	bl		AIS


	bl		skipE
EDead:	
	sub r8, #1	
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #4
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
				//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #16]			//			
	ldr		r1, =418			//x
	bl 		Dead
skipE:						//					****UPDATE****

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnF!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnF:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN F IS IN THE BOUNDRIES X: (380 <= x <= 490) and Y: (y=285)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 20 and 5
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #5]			//Load pawn F health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	FDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn F direction
	ldr	r6, =AICor			//load Pawn F cordinate
	ldr	r7, [r6, #20]			//					****UPDATE****
	



//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn F cordinate
	ldr	r7, [r6, #20]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #580			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn F cordinate
	ldr	r7, [r6, #20]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn F direction
	ldrb	r5, [r4, #5]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #5]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn F cordinate
	ldr	r7, [r6, #20]			//					****UPDATE****
	cmp	r7, #520			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn F direction
	ldrb	r5, [r4, #5]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #5]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn F direction
	ldrb	r5, [r4, #5]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #20]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #20]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =285		//y					****UPDATE****
	bl		DrawAIP
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #5
	blne		skipF
	mov		r0, r7			//x
	ldr		r1, =285		//y
	bl		AIS


	bl		skipF
FDead:	
	sub r8, #1
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #5
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
					//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #20]			//			
	ldr		r1, =285			//x
	bl 		Dead
skipF:					//					****UPDATE****

	
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnG:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN G IS IN THE BOUNDRIES X: (600 <= x <= 640) and Y: (y=345)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 24 and 6
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #6]			//Load pawn G health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	GDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn G direction
	ldr	r6, =AICor			//load Pawn G cordinate
	ldr	r7, [r6, #24]			//					****UPDATE****
	


//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn G cordinate
	ldr	r7, [r6, #24]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #640			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn G cordinate
	ldr	r7, [r6, #24]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn G direction
	ldrb	r5, [r4, #6]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #6]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn G cordinate
	ldr	r7, [r6, #24]			//					****UPDATE****
	cmp	r7, #600			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn G direction
	ldrb	r5, [r4, #6]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #6]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn G direction
	ldrb	r5, [r4, #6]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #24]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #24]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =345		//y					****UPDATE****
	bl		DrawAIP
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #6
	blne		skipG
	mov		r0, r7			//x
	ldr		r1, =345		//y
	bl		AIS


	bl		skipG
GDead:	
	sub r8, #1	
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #6
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
				//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #24]			//			
	ldr		r1, =345			//x
	bl 		Dead
skipG:					//					****UPDATE****

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnH!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnH:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN H IS IN THE BOUNDRIES X: (660 <= x <= 780) and Y: (y=379)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 28 and 7
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #7]			//Load pawn H health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	HDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn H direction
	ldr	r6, =AICor			//load Pawn H cordinate
	ldr	r7, [r6, #28]			//					****UPDATE****
	


//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn H cordinate
	ldr	r7, [r6, #28]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #780			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn H cordinate
	ldr	r7, [r6, #28]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn H direction
	ldrb	r5, [r4, #7]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #7]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn H cordinate
	ldr	r7, [r6, #28]			//					****UPDATE****
	cmp	r7, #660			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn H direction
	ldrb	r5, [r4, #7]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #7]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn H direction
	ldrb	r5, [r4, #7]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #28]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #28]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =379		//y					****UPDATE****
	bl		DrawAIP
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #7
	blne		skipH
	mov		r0, r7			//x
	ldr		r1, =379		//y
	bl		AIS
	bl		skipH
HDead:	
	sub r8, #1
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #7
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
					//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #28]			//			
	ldr		r1, =379			//x
	bl 		Dead
skipH:						//					****UPDATE****

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnI!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnI:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN I IS IN THE BOUNDRIES X: (800 <= x <= 820) and Y: (y=405)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 32 and 8
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #8]			//Load pawn I health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	IDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn I direction
	ldr	r6, =AICor			//load Pawn I cordinate
	ldr	r7, [r6, #32]			//					****UPDATE****
	


//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn I cordinate
	ldr	r7, [r6, #32]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #820			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn I cordinate
	ldr	r7, [r6, #32]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn I direction
	ldrb	r5, [r4, #8]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #8]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn I cordinate
	ldr	r7, [r6, #32]			//					****UPDATE****
	cmp	r7, #800			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn I direction
	ldrb	r5, [r4, #8]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #8]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn I direction
	ldrb	r5, [r4, #8]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #32]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #32]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =405		//y					****UPDATE****
	bl		DrawAIP
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #8
	blne		skipI
	mov		r0, r7			//x
	ldr		r1, =405		//y
	bl		AIS

	bl		skipI
IDead:	
	sub r8, #1	
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #8
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
				//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #32]			//			
	ldr		r1, =405			//x
	bl 		Dead
skipI:					//					****UPDATE****

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PawnJ!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

pawnJ:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//PAWN J IS IN THE BOUNDRIES X: (840 <= x <= 1000) and Y: (y=329)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 36 and 9
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #9]			//Load pawn J health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	JDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn J direction
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #36]			//					****UPDATE****
	


//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #36]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #1000			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #36]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #9]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #9]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #36]			//					****UPDATE****
	cmp	r7, #840			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #9]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #9]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #9]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #36]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #36]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =329		//y					****UPDATE****
	bl		DrawAIP
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #9
	blne		skipJ
	mov		r0, r7			//x
	ldr		r1, =329		//y
	bl		AIS

	bl		skipJ
JDead:				
	sub r8, #1
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #9
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
		//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #36]			//			
	ldr		r1, =329			//x
	bl 		Dead
skipJ:


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!KnightAA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

knightAA:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//Knight AA IS IN THE BOUNDRIES X: (0 <= x <= 280) and Y: (y=200)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 40 and 10
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #10]			//Load pawn J health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	AADead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn J direction
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #40]			//					****UPDATE****
	


//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #40]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #280			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #40]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #10]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #10]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #40]			//					****UPDATE****
	cmp	r7, #5				//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #10]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #10]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #10]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #40]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #40]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =163		//y					****UPDATE****
	bl		DrawAIK
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #10
	blne		skipAA
	mov		r0, r7			//x
	ldr		r1, =163		//y
	bl		AIS

	bl		skipAA
AADead:	
	sub r8, #1
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #10
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]	
					//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #40]			//			
	mov		r1, #163			//x
	bl 		Dead
skipAA:					//					****UPDATE****

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!KnightBB!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

knightBB:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//Knight AA IS IN THE BOUNDRIES X: (0 <= x <= 500) and Y: (y=200)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 40 and 10
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #11]			//Load pawn J health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	BBDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn J direction
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #44]			//					****UPDATE****
	


//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #44]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #420			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #44]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #11]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #11]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #44]			//					****UPDATE****
	cmp	r7, #300			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #11]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #11]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #11]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #44]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #44]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =150		//y					****UPDATE****
	bl		DrawAIK
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #11
	blne		skipBB
	mov		r0, r7			//x
	ldr		r1, =150		//y
	bl		AIS

	bl		skipBB
BBDead:			
	sub r8, #1
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #11
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
			//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #44]			//			
	mov		r1, #150			//x
	bl 		Dead
skipBB:						//					****UPDATE****

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!KnightCC!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

knightCC:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//Knight AA IS IN THE BOUNDRIES X: (0 <= x <= 500) and Y: (y=200)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 40 and 10
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #12]			//Load pawn J health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	CCDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn J direction
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #48]			//					****UPDATE****
	



//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #48]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #700			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #48]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #12]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #12]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #48]			//					****UPDATE****
	cmp	r7, #440			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #12]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #12]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #12]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #48]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #48]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =180		//y					****UPDATE****
	bl		DrawAIK
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #12
	blne		skipCC
	mov		r0, r7			//x
	ldr		r1, =180		//y
	bl		AIS

	bl		skipCC
CCDead:		
	sub r8, #1
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #12
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
				//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #48]			//			
	mov		r1, #180			//x
	bl 		Dead
skipCC:					//					****UPDATE****

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!KnightDD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

knightDD:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//Knight AA IS IN THE BOUNDRIES X: (720 <= x <= 820) and Y: (y=200)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 40 and 10
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #13]			//Load pawn J health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	DDDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn J direction
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #52]			//					****UPDATE****
	



//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #52]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #820			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #52]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #13]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #13]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #52]			//					****UPDATE****
	cmp	r7, #720			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #13]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #13]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #13]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #52]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #52]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =175		//y					****UPDATE****
	bl		DrawAIK
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #13
	blne		skipDD
	mov		r0, r7			//x
	ldr		r1, =175		//y
	bl		AIS

	bl		skipDD
DDDead:	
	sub r8, #1		
	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #13
	addeq		r4, #1				//					****UPDATE****
	ldr		r5, =AISHOT
	str		r4, [r5]
			//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #52]			//			
	mov		r1, #175			//x
	bl 		Dead
skipDD:					//					****UPDATE****


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!KnightEE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

knightEE:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//Knight AA IS IN THE BOUNDRIES X: (0 <= x <= 500) and Y: (y=200)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 40 and 10
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #14]			//Load pawn J health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	EEDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn J direction
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #56]			//					****UPDATE****
	



//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #56]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #1000			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #56]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #14]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #14]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #56]			//					****UPDATE****
	cmp	r7, #840			//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #14]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #14]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #14]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #56]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #56]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =169		//y					****UPDATE****
	bl		DrawAIK
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	ldr		r4, =AISHOT
	ldr		r4, [r4]
	cmp 		r4, #14
	blne		skipEE
	mov		r0, r7			//x
	ldr		r1, =169		//y
	bl		AIS

	bl		skipEE
EEDead:	
	sub r8, #1				//					****UPDATE****
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #56]			//			
	ldr		r1, =169			//x
	bl 		Dead
skipEE:					//					****UPDATE****



//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!QueenAAA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

QueenAAA:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//Knight AA IS IN THE BOUNDRIES X: (0 <= x <= 500) and Y: (y=200)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 40 and 10
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #15]			//Load pawn J health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	AAADead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn J direction
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #60]			//					****UPDATE****
	



//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #60]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #1000			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #60]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #15]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #15]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #60]			//					****UPDATE****
	cmp	r7, #5				//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #15]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #15]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #15]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #60]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)
	ldr	r6, =AICor			//load Pawn J cordinate	
	str	r7, [r6, #60]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =25		//y					****UPDATE****
	bl		DrawAIQ
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//


	//ldr		r4, =AISHOT
	//ldr		r4, [r4]
	//cmp 		r4, #15
	//blne		skipAAA
	mov		r0, r7			//x
	ldr		r1, =25		//y
	bl		AIST

	bl		skipAAA

AAADead:
	sub r8, #1	
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #60]			//			
	mov		r1, #25			//x
	bl 		Dead
	
skipAAA:						//					****UPDATE****

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!QueenBBB!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

QueenBBB:
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						//Knight AA IS IN THE BOUNDRIES X: (0 <= x <= 500) and Y: (y=200)
						//Give a 20 buffer from last x cordiante to next pawn for the length of the ship (20)
						// r7=x   r5=left/right(0/1)
						//offest 40 and 10
						//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #16]			//Load pawn J health 			****UPDATE****
	cmp	r5, #0				//see if the pawn is dead
	bleq	BBBDead				//skip updating pawn a if it is dead	****UPDATE****		

	ldr	r4, =AIDir			//load Pawn J direction
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #64]			//					****UPDATE****
	



//~Border Check~~~~~~~~~~~~
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #64]			//see if the pawn is at the right border****UPDATE****
	cmp	r7, #1000			//					****UPDATE****
	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #64]			//see if the pawn is at the right border****UPDATE****
	subeq	r7, #2				//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #16]			//0 or 1 in r5				****UPDATE****
	subeq	r5, #1				//
	strb	r5, [r4, #16]			//update the AIDir			****UPDATE****


	ldr	r6, =AICor			//load Pawn J cordinate
	ldr	r7, [r6, #64]			//					****UPDATE****
	cmp	r7, #5				//see if the pawn is at the left border	****UPDATE****	
	addeq	r7, #2				//add 1 to move the enemy away from the buffer
	ldr	r4, =AIDir			//load Pawn D direction
	ldrb	r5, [r4, #16]			//0 or 1 in r5				****UPDATE****
	addeq	r5, #1				//add 1 to change the direction
	strb	r5, [r4, #16]			//update the AIDir			****UPDATE****


//~~~~~~~~~~~~~~~~~~~~~~~~~
//
	ldr	r4, =AIDir			//load Pawn J direction
	ldrb	r5, [r4, #16]			//0 or 1 in r5				****UPDATE****
	ldr	r7, [r6, #64]			//					****UPDATE****
	cmp	r5, #0				//See if it is moving left
	subeq	r7, #1				//move 1 px left if it is moving left	(0)
	addne	r7, #1				//move 1 px right if it is moving right (1)	
	str	r7, [r6, #64]			//update the AICor			****UPDATE****

//
//~Print new image~~~~~~~~~~~~~~~~
	mov		r0, r7			//x
	ldr		r1, =80		//y					****UPDATE****
	bl		DrawAIQ
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

	//ldr		r4, =AISHOT
	//ldr		r4, [r4]
	//cmp 		r4, #16
	//blne		skipBBB
	mov		r0, r7			//x
	ldr		r1, =80		//y
	bl		AIST


	bl		skipBBB
BBBDead:
	sub r8, #1
	ldr		r6, =AICor			//load Pawn J cordinate
	ldr		r0, [r6, #64]			//			
	mov		r1, #80			//x
	bl 		Dead
skipBBB:						//					****UPDATE****


randomize:
	ldr 	r0, =0x20003004
	ldr 	r1, [r0]
	and	r1, #0xF
	cmp	r1, #15
	bleq	randomize			
	ldr	r5, =AISHOT
	strb	r1, [r5]

	cmp r8, #0
	moveq r0, #1
	movne R0, #0




	pop	{r4-r10, pc}
	bx lr



//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!UPDATE AI!!!!!!!!!!!UPDATE AI!!!!!!!!!!UPDATE AI!!!UPDATE AI!!!UPDATE AI!!!!!!!!!!!!!!UPDATE AI!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//What update ai does is it is passed coordinates from when the humans bulit colides with something. This goes through a 
//series of checks to see what the bulit actually hit. From here it will then go to update rocks, pawns, or it will simply 
//continue through and update a queen and/or knight
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//ro in x
//r1 in y

.globl UpdateAI
UpdateAI:
	push	{r4-r10, lr}

	cmp r1, #25				// see of the collision is a with the score
	bllt	skipAll			//skip all of it
	cmp r1, #75				// see of the collision is a top queen
	bllt	queenAAACol
	cmp r1, #140				// see of the collision is lower queen
	bllt	queenBBBCol
	cmp r1, #280				// see of the collision is a knight
	bllt	knightCol
	cmp r1, #500				// see of the collision is a pawn
	bllt	pawnCol				//										**Location: UpdatePawns.s
	bl	UpdateRocks				//must be rocks							**LOCATION: UpdateRocks.s**
	bl	skipAll					
	


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PAWNS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
pawnCol:
	ldr	r2, =AIHealth
	mov	r2, r2
	bl	pawnCOL
	bl	skipAll

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!KNIGHTS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
knightCol:
	cmp r0, #840				//
	blge	ColEE				// |_EE_|_840-1000(+20)_|_169_|
	cmp r0, #720				//
	blge	ColDD				// |_DD_|_720-820(+20)_|_175_|
	cmp r0, #440				//
	blge	ColCC				// |_CC_|_440-700(+20)_|_180_|
	cmp r0, #300				//
	blge	ColBB				// |_BB_|_300-420_(+20)_|_150_|
	bl	ColAA				// |_AA_|_000-280_(+20)_|_163_|
ColAA:
	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #10]			//Load pawn A health 			****UPDATE****
	cmp	r5, #0
	bleq	skipAll
	
	cmp 	r5, #1			// compare AI health to 1
	moveq	r0, #1			// move type to r0
	bleq 	HumanKill		// branch to HumanKill if health is 1
	
	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r4, #10]			//Store pawn A health 			****UPDATE****
	bl	skipAll				//skip updating pawn a if it is dead	****UPDATE****
ColBB:
	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #11]			//Load pawn A health 			****UPDATE****
	cmp	r5, #0
	bleq	skipAll
	
	cmp 	r5, #1			// compare AI health to 1
	moveq	r0, #1			// move type to r0
	bleq 	HumanKill		// branch to HumanKill if health is 1
	
	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r4, #11]			//Store pawn A health 			****UPDATE****
	bl	skipAll				//skip updating pawn a if it is dead	****UPDATE****
ColCC:
	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #12]			//Load pawn A health 			****UPDATE****
	cmp	r5, #0
	bleq	skipAll
	
	cmp 	r5, #1			// compare AI health to 1
	moveq	r0, #1			// move type to r0
	bleq 	HumanKill		// branch to HumanKill if health is 1
	
	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r4, #12]			//Store pawn A health 			****UPDATE****
	bl	skipAll				//skip updating pawn a if it is dead	****UPDATE****
ColDD:
	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #13]			//Load pawn A health 			****UPDATE****
	cmp	r5, #0
	bleq	skipAll
	
	cmp 	r5, #1			// compare AI health to 1
	moveq	r0, #1			// move type to r0
	bleq 	HumanKill		// branch to HumanKill if health is 1
	
	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r4, #13]			//Store pawn A health 			****UPDATE****
	bl	skipAll				//skip updating pawn a if it is dead	****UPDATE****
ColEE:
	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #14]			//Load pawn A health 			****UPDATE****
	cmp	r5, #0
	bleq	skipAll
	
	cmp 	r5, #1			// compare AI health to 1
	moveq	r0, #1			// move type to r0
	bleq 	HumanKill		// branch to HumanKill if health is 1
	
	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r4, #14]			//Store pawn A health 			****UPDATE****
	bl	skipAll				//skip updating pawn a if it is dead	****UPDATE****
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!QUEENS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
queenAAACol:
	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #15]			//Load pawn A health 			****UPDATE****
	cmp	r5, #0
	bleq	skipAll
	
	cmp 	r5, #1			// compare AI health to 1
	moveq	r0, #2			// move type to r0
	bleq 	HumanKill		// branch to HumanKill if health is 1
	
	sub	r5, #1				//see if the pawn is dead
	ldr	r4, =AIHealth			//
	strb	r5, [r4, #15]			//Store pawn A health 			****UPDATE****
	bl	skipAll				//skip updating pawn a if it is dead	****UPDATE****
queenBBBCol:
	ldr	r4, =AIHealth			//					
	ldrb	r5, [r4, #16]			//Load pawn A health 			****UPDATE****
	cmp	r5, #0
	bleq	skipAll
	
	cmp 	r5, #1			// compare AI health to 1
	moveq	r0, #2			// move type to r0
	bleq 	HumanKill		// branch to HumanKill if health is 1
	
	sub	r5, #1				//see if the pawn is dead
	ldr	r4, =AIHealth			//
	strb	r5, [r4, #16]			//Store pawn A health 			****UPDATE****
	bl	skipAll				//skip updating pawn a if it is dead	****UPDATE****

skipAll:
	pop	{r4-r10, pc}
	bx lr



.globl ResetAIHealth
ResetAIHealth:
push	{r4-r10, lr}


	ldr	r0, =AIHealth
	mov	r0, r0

pop	{r4-r10, pc}
	bx lr
