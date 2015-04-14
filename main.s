//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	Main.s


					//This file is our main function and drives the game, it contains the screens, order of turns
					// and game sequence logic. The file branches to multiple other functions to ensure clean code
					//that is easy to follow. 

.section    .init
.globl     _start

_start:
    	b       main			//branch to main

.section .text


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Set up the nesissary parts to the game
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main:
   	 mov     sp, #0x8000
	
	bl	EnableJTAG		//enable j tag	

	bl	InitFrameBuffer		//initialize frame buffer
	cmp	r0, #0
	beq 	haltLoop$		// branch to the halt loop if there was an error initializing the framebuffer

	bl	InitializeSNES		//initialize the snes

	bl	MainScreen		//load and setup main screen



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//used to terminate program if error
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
haltLoop$:
	b haltLoop$




/*
______________________________________________________________________________________________________________

	Game over screen draws a image onto the screen indicating the player has lost and branches to haltLoop$
______________________________________________________________________________________________________________

*/
.global GameOverScreen
GameOverScreen:

	bl 		ClearScreen
	
waitplz:

	ldr		r0, =450		//x
	ldr		r1, =400		//y
	mov		r2, #153		//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #15			//y (height) of image -1
	ldr		r4, =gameOver
	bl		DrawImage
	
	bl	ReadAllButtons	
	mov 	r4, r0
	cmp 	r4, #0
	beq 	waitplz

	bl 	MainScreen

/*
______________________________________________________________________________________________________________

	Win screen draws a image onto the screen indicating the player has won and branches to haltLoop$
______________________________________________________________________________________________________________

*/
.global WinScreen
WinScreen:

	bl 		ClearScreen
	
waitPlz:

	ldr		r0, =350		//x
	ldr		r1, =400		//y
	mov		r2, #372		//line length - 1!!!! arraytraverser starts at 0...
	mov		r3, #46			//y (height) of image -1
	ldr		r4, =youWin
	bl		DrawImage

	bl	ReadAllButtons	
	mov 	r4, r0
	cmp 	r4, #0
	beq 	waitPlz

	bl 	MainScreen
	

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//This contains the code to make the in game pause menu
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PauseMenu:
	push {lr, r4}


	ldr	r0, =400		//hardcode the x cordinate
	ldr	r1, =320		//hardcode the y cordinate
	mov	r2, #204		//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #101		//y (height) of image -1
	ldr	r4, =pauseMenu		//load image
	bl	DrawImage		//branch to drawimage
	
	ldr	r0, =465		//hardcode the x cordinate
	ldr	r1, =339		//hardcode the y cordinate
	mov	r2, #3			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #6			//y (height) of image -1
	ldr	r4, =pause_arrow	//load image
	bl	DrawImage		//branch to drawimage

	ldr 	r0, =string_Resume	//load arg
	mov 	r1, #6			//length
	ldr 	r2, =335		//hardcode the x cordinate
	ldr 	r3, =475		//hardcode the y cordinate
	bl	DrawString
	
	ldr 	r0, =string_Restart	//load arg
	mov	r1, #7			//length
	ldr 	r2, =360		//hardcode the x cordinate
	ldr 	r3, =475		//hardcode the y cordinate
	bl	DrawString
	
	ldr 	r0, =string_Quit	//load arg
	mov 	r1, #4			//length
	ldr 	r2, =385		//hardcode the x cordinate
	ldr 	r3, =475		//hardcode the y cordinate
	bl	DrawString

	bl WaitForController	//**LOCATION: (snes.s)**

	bl getSNESInput_Resume			



resume:
	ldr	r0, =465		//x
	ldr	r1, =363		//y go down 22 pixels
	mov	r2, #3			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #6			//y (height) of image -1
	ldr	r4, =purple		//load image
	bl	DrawImage		//branch to draw image

	ldr	r0, =465		//x
	ldr	r1, =339		//y
	mov	r2, #3			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #6			//y (height) of image -1
	ldr	r4, =pause_arrow	//load image
	bl	DrawImage		//branch to draw image



getSNESInput_Resume:
	bl	ReadSNES	//**LOCATION: (snes.s)**
	mov	r6,r0

	ldrb	r5, [r6, #8] 		//is A pressed?
	cmp 	r5, #0			//compare to 0
	bleq 	endPause

	ldrb 	r5, [r6, #5] 		//is [DOWN] pressed?
	cmp	r5, #0			//compare to 0
	bleq	restart
	
	ldrb 	r5, [r6, #3] 		//is [START] pressed?
	cmp 	r5, #0			//compare to 0
	bleq 	endPause


	bl getSNESInput_Resume
	


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//Used to Restart the game without quiting
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
restart:
	//Update arrow pointer
	ldr	r0, =465		//x
	ldr	r1, =339		//y
	mov	r2, #3			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #6			//y (height) of image -1
	ldr	r4, =purple		//load image
	bl	DrawImage		//branch to draw


	ldr	r0, =465		//x
	ldr	r1, =363		//y go down 22 pixels
	mov	r2, #3			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #6			//y (height) of image -1
	ldr	r4, =pause_arrow	//load image
	bl	DrawImage		//branch to draw

	bl WaitForController	//**LOCATION: (snes.s)**	
	bl WaitForController	//**LOCATION: (snes.s)**

	

getSNESInput_Restart:
	bl	ReadSNES
	mov 	r6,r0

	ldrb 	r5, [r6, #8] 		//is A pressed?
	cmp 	r5, #0			//compare to 0
	bleq 	DrawGame
	
	ldrb 	r5, [r6, #4] 		//is [UP] pressed?
	cmp 	r5, #0			//compare to 0
	bleq 	resume

	ldrb 	r5, [r6, #5] 		//is [DOWN] pressed?
	cmp 	r5, #0			//compare to 0
	bleq 	quit
	
	ldrb 	r5, [r6, #3] 		//is [START] pressed?
	cmp 	r5, #0			//compare to 0
	bleq 	endPause

	bl getSNESInput_Restart



//!!!!!!!!!!!!!!!!!!!!!
//Used to Quit the game
//!!!!!!!!!!!!!!!!!!!!!
quit:
	//Update arrow pointer
	ldr	r0, =465		//x
	ldr	r1, =363		//y
	mov	r2, #3			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #6			//y (height) of image -1
	ldr	r4, =purple		//load image
	bl	DrawImage		//branch to draw


	ldr	r0, =465		//x
	ldr	r1, =387		//y go down 22 pixels
	mov	r2, #3			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #6			//y (height) of image -1
	ldr	r4, =pause_arrow	//load image
	bl	DrawImage		//branch to draw

	bl WaitForController	//**LOCATION: (snes.s)**
	bl WaitForController	//**LOCATION: (snes.s)**

getSNESInput_Quit:
	bl	ReadSNES
	mov 	r6,r0

	ldrb 	r5, [r6, #8] 		//is A pressed?
	cmp 	r5, #0			//compare to 0
	bleq 	MainScreen

	ldrb 	r5, [r6, #4] 		//is [UP] pressed?
	cmp 	r5, #0			//compare to 0
	bleq 	restart_FromBottom
	
	ldrb 	r5, [r6, #3] 		//is [START] pressed?
	cmp 	r5, #0			//compare to 0
	bleq 	endPause

	bl 	getSNESInput_Quit

	
restart_FromBottom:
	ldr	r0, =465		//x
	ldr	r1, =387		//y go down 22 pixels
	mov	r2, #3			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #6			//y (height) of image -1
	ldr	r4, =purple		//load image
	bl	DrawImage		//branch to draw

	ldr	r0, =465		//x
	ldr	r1, =363		//y go down 22 pixels
	mov	r2, #3			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #6			//y (height) of image -1
	ldr	r4, =pause_arrow	//load image
	bl	DrawImage		//branch to draw

	bl WaitForController	//**LOCATION: (snes.s)**
	bl WaitForController	//**LOCATION: (snes.s)**

	bl getSNESInput_Restart




endPause:
					//delete the pause menu
	ldr 	r0, =400		//hardcode the x cordinate
	ldr 	r1, =320		//hardcode the y cordinate
	mov 	r2, #204 		//length
	mov 	r3, #101		//heigth
	bl	DeleteImage	
	
	bl	WaitForController
	bl 	WaitForController
exit:
	
	pop {pc, r4}
	bx lr






//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//This is where the main screen logo and images are loaded
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
MainScreen:
	push {lr, r5, r6}

	bl ClearScreen			//braNCH TO CLEAR THE SCREEN

	ldr	r0, =325		//x
	ldr	r1, =250		//y
	mov	r2, #190		//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #135		//y (height) of image -1
	ldr	r4, =titleA		//load image
	bl	DrawImage		//branch to draw
	
	ldr	r0, =515		//x
	ldr	r1, =250		//y
	mov	r2, #186		//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #137		//y (height) of image -1
	ldr	r4, =titleB		//laod to image
	bl	DrawImage		//branch to draw
	
	ldr 	r0, =string_PressStart
	mov 	r1,#11			//length
	ldr 	r2,=600			//x
	ldr 	r3,=450			//y
	bl	DrawString

	ldr 	r0, =string_Devs
	mov	r1,#41			//length
	ldr 	r2,=730			//x
	ldr 	r3,=630			//y
	bl	DrawString



CheckStartPressed:
		
	bl	ReadSNES
	mov 	r6,r0
	ldrb 	r5, [r6, #3] 		//is [START] pressed?
	cmp 	r5, #0
	
	bne  	CheckStartPressed
	
	bl 	WaitForController	// this makes the start press smooth and wont interfere with the pause ingame
	

	
startGame:

					//delete the press start message
	ldr 	r0, =300		//x
	ldr 	r1, =250		//y
	mov 	r2, #200		//length
	mov	 r3, #320		//heigth
	bl	DeleteImage

	bl	DrawGame
		

pop {pc, r5, r6}
bx lr




//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//This is to initialize the first images and thier locations of the game
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
DrawGame:
	push	{lr, r4, r5, r6, r7}

	bl 	Reset		//**LOCATION: (Reset.s)**		
	bl 	ClearScreen


//Draw the game screen (asteroids, enemies)
	ldr	r0, =204		//x
	ldr	r1, =631		//y
	mov	r2, #103		//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #35			//y (height) of image -1
	ldr	r4, =asteroid1		//load image
	bl	DrawImage

	ldr	r0, =460		//x
	ldr	r1, =631		//y
	mov	r2, #103		//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #35			//y (height) of image -1
	ldr	r4, =asteroid1		//load image
	bl	DrawImage

	ldr	r0, =716		//x
	ldr	r1, =631		//y
	mov	r2, #103		//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #35			//y (height) of image -1
	ldr	r4, =asteroid1		//load image
	bl	DrawImage



	ldr 	r0, =string_Score
	mov	r1,#7			//length
	ldr 	r2,=0			//x
	ldr 	r3,=445			//y

	bl	DrawString
	mov 	r0, #50
	bl 		Score
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//Draw the player, read the snes buttons to determine if the player needs to move (Game loop)
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	ldr 	r7, =491		//initialize the first x cordiante
	mov 	r9, #0			//initialize 
draw:	
	cmp	r9, #64
	subeq	r9, #64
	cmp 	r7, #5			//boundry check
	addls 	r7, #2			//
	cmp 	r7, #976		//boundry check
	subcs 	r7, #2			//


	mov	r0, r7			//x
	ldr	r1, =692		//y
	mov	r2, #44			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #74			//y (height) of image -1
	ldr	r4, =spaceship		//image
	bl	DrawImage		//draw

	
	bl	ReadSNES
	mov 	r6,r0

	
	ldrb 	r5, [r6, #3] 		//is [START] pressed?
	cmp 	r5, #0
	bleq 	PauseMenu


	ldrb 	r5, [r6, #7] 		//is -> pressed?
	cmp 	r5, #0
	moveq 	r8, r7	
	addeq 	r7, #1			//shift image by 1 pixel!
	

	ldrb 	r5, [r6, #6] 		//is <- pressed?
	cmp 	r5, #0
	moveq 	r8, r7
	subeq 	r7, #1			//shift image by 1 pixel!
	


//Get the address for bullets and then branch
//to boolit to print the bullets
//r0=current x location, r1= =bullets
	bl	ReadSNES
	mov 	r1, r0
	mov 	r0, r7
	bl 	Boolit



//now we update the movements of the ai
	bl 	MoveAI		//**LOCATION: (AI.s)**
	cmp 	r0, #1			//see if all enemies are dead
	bleq 	WinScreen							//CHANGE!!!!!!!!!!!!!!!@$#@%#@^$@^$#^#$&%^&#$^%#%^(^&*%#$%^&*^^%$%^&*^(*^^%$#&^*(&^%


//move the human agin for x2 speed compare to ai
	cmp	r9, #64
	subeq	r9, #64
	cmp 	r7, #5			//boundry check
	addls 	r7, #2			//
	cmp 	r7, #976		//boundry check
	subcs 	r7, #2			//


	mov	r0, r7			//x
	ldr	r1, =692		//y
	mov	r2, #44			//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #74			//y (height) of image -1
	ldr	r4, =spaceship		//image
	bl	DrawImage		//draw

	bl	ReadSNES
	mov 	r6,r0


	ldrb 	r5, [r6, #3] 		//is [START] pressed?
	cmp 	r5, #0
	bleq 	PauseMenu


	ldrb 	r5, [r6, #7] 		//is -> pressed?
	cmp 	r5, #0
	moveq 	r8, r7	
	addeq 	r7, #1			//shift image by 1 pixel!
	

	ldrb 	r5, [r6, #6] 		//is <- pressed?
	cmp 	r5, #0
	moveq 	r8, r7
	subeq 	r7, #1			//shift image by 1 pixel!


	bl 	draw

	pop {pc, r4, r5, r6, r7}
	bx lr



.section .data
.align 4

string_PressStart:	.asciz "Press Start"
string_Devs:		.asciz "Brendan Dueck, David Lian, Jaime Castillo"
string_Resume:		.asciz "Resume"
string_Restart:		.asciz "Restart"
string_Quit:		.asciz "Quit"
string_Score:		.asciz "Score: "


