//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	snes.s


					//This file contains the code to read the snes
					//this function returns the address for buttons in r0
					//this file also includes initialize snes which initializes the three pins
					//that er used for the snes controller




.section .data
.align 12
buttons: 	.byte 	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
Position: 	.byte 	0, 0


.section .text


//!!!!!!!!!!!!!!!!!!!!!!!!
//Initialize the Snes Pins
//!!!!!!!!!!!!!!!!!!!!!!!!

.globl InitializeSNES
InitializeSNES:

	push	{lr}


//~~~~~~~~~~~~~~~~~~~~
//initialize the Data
//~~~~~~~~~~~~~~~~~~~~
InitDATA:				//initialize the data pin to 0
	ldr 	r0, =0x20200004		//load the address into r0
	ldr 	r1, [r0]		//load the data into r1
	mov 	r2, #7			//move 7 into r2

	bic 	r1, r2			//bitclear the data with r2
	str 	r1, [r0]		//store the result into r0
	

//~~~~~~~~~~~~~~~~~~~~
//initialize the clock
//~~~~~~~~~~~~~~~~~~~~
initCLK:				
	ldr 	r0, =0x20200004		//load register address
	ldr 	r1, [r0] 		//copy GPSEL into r1
	mov 	r2, #7			//b0111
	lsl 	r2, #3			//index of 1st bit in pin 11
					//r2 = 0 111 000
	bic 	r1, r2			//clear pin 11 bits
	mov 	r3, #1			//output function code
	lsl 	r3, #3			//r3 = 0 001 000
	orr 	r1, r3			//set pin 11 function in r1
	str 	r1, [r0] 		//Write back to GPSEL1


//~~~~~~~~~~~~~~~~~~~~
//initialize the Latch
//~~~~~~~~~~~~~~~~~~~~
initLATCH:
	ldr 	r0, =0x20200000		//load register address
	ldr 	r1, [r0]		//copy GPSEL into r1
	mov  	r2, #7			//b0111
	lsl 	r2, #27			//index of 1st bit 
					
	bic 	r1, r2			//clear pin 9 bits
	mov 	r3, #1			//output function code
	lsl 	r3, #27			//shift it over 3
	orr 	r1, r3			//set pin function in r1
	str 	r1, [r0]		//Write back to GPSEL0	

	pop	{pc}
	bx lr




//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//The Function that reads the Snes Controller
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
.globl ReadSNES
ReadSNES:
	push	{r4-r5, lr}



//~~~~~~~~~~~~~~~~~~~~
//Write the Clock to 1
//~~~~~~~~~~~~~~~~~~~~
writeCLK:	
	mov 	r1, #1
	mov 	r0, #11
	ldr 	r2, =0x20200000
	mov 	r3, #1
	lsl 	r3, r0
	teq 	r1, #0
	streq 	r3, [r2, #40]
	strne 	r3, [r2, #28]
	



//~~~~~~~~~~~~~~~~~~~~
//Write the Latch to 1
//~~~~~~~~~~~~~~~~~~~~
writeLATCH:
	mov 	r1, #1
	mov 	r0, #9
	ldr 	r2, =0x20200000
	mov 	r3, #1
	lsl 	r3, r0
	teq 	r1, #0
	streq 	r3, [r2, #40]
	strne 	r3, [r2, #28]




//~~~~~~~~~~~~~~~~~~~~
//Wait 12 MS
//~~~~~~~~~~~~~~~~~~~~
wait:	
	ldr 	r0, =0x20003004
	ldr 	r1, [r0]
	add 	r1, #12

waitLoop:	
	ldr 	r2, [r0]
	cmp 	r1, r2 
	bhi 	waitLoop
	



//~~~~~~~~~~~~~~~~~~~~
//Write the Latch to 0
//~~~~~~~~~~~~~~~~~~~~
writeLATCH1:
	mov 	r1, #0
	mov 	r0, #9
	ldr 	r2, =0x20200000
	mov 	r3, #1
	lsl 	r3, r0
	teq 	r1, #0
	streq 	r3, [r2, #40]
	strne 	r3, [r2, #28]
	
	i	.req r8
	mov 	i, #0
	ldr 	r5, =buttons
	



//~~~~~~~~~~~~~~~~~~~~~~~
//Pulse loop to read snes
//~~~~~~~~~~~~~~~~~~~~~~~
pulseLoop:

	cmp 	i, #16			//counter
	bleq 	end			//branch to loop over
	

wait1:
	ldr 	r0, =0x20003004
	ldr 	r1, [r0]
	add 	r1, #6
waitLoop1:	
	ldr 	r2, [r0]
	cmp 	r1, r2 
	bhi 	waitLoop1



//~~~~~~~~~~~~~~~~
//Write clock to 0
//~~~~~~~~~~~~~~~~	
writeCLK1:	
	mov 	r1, #0
	mov 	r0, #11
	ldr 	r2, =0x20200000
	mov 	r3, #1
	lsl 	r3, r0
	teq 	r1, #0
	streq 	r3, [r2, #40]
	strne 	r3, [r2, #28]	


//~~~~~~~~~~~~~~~~
//Wait 6 MS
//~~~~~~~~~~~~~~~~	
wait2:
	ldr 	r0, =0x20003004
	ldr 	r1, [r0]
	add 	r1, #6

waitLoop2:		
	ldr 	r2, [r0]
	cmp 	r1, r2 
	bhi 	waitLoop2



//~~~~~~~~~~~~~~~~~~~~~~~~~~~
//Read the data and record it
//~~~~~~~~~~~~~~~~~~~~~~~~~~~
readDATA:
	mov 	r0, #10
	ldr 	r2, =0x20200000
	ldr 	r1, [r2, #52]
	mov 	r3, #1
	lsl 	r3, r0
	and 	r1, r3
	teq 	r1, #0
	moveq 	r4, #0
	movne	r4, #1 

	strb 	r4, [r5, i]		//store in memory
	

//~~~~~~~~~~~~~~~~
//Write clock to 1
//~~~~~~~~~~~~~~~~
writeCLK2:	
	mov 	r1, #1
	mov 	r0, #11
	ldr 	r2, =0x20200000
	mov 	r3, #1
	lsl 	r3, r0
	teq 	r1, #0
	streq 	r3, [r2, #40]
	strne 	r3, [r2, #28]
	add 	i, i, #1
	
	bl	 	pulseLoop	//reread the info (pulseloop)

end:

	ldr 	r0, =buttons		//pass the address in r0
	.unreq 	i			//unreq

	pop	{r4-r5, pc}
	bx lr



//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//Wait loop generalized for program
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
.globl WaitForController
WaitForController:
	push {lr}
	

	ldr 	r0, =0x20003004
	ldr 	r1, [r0]
	ldr	r3, =90000
	add 	r1, r3

	wait4Controller:	
		ldr 	r2, [r0]
		cmp 	r1, r2 
		bhi 	wait4Controller
		
	pop {pc}
	bx lr

.global ReadAllButtons
ReadAllButtons:

	push	{r4 - r6, lr}
	
	i 	.req 	r5
	addr 	.req 	r4
	button 	.req 	r6	

	mov 	i, #0
	
	bl 	ReadSNES	
	
readButtons:

	cmp 	i, #13
	bgt	bNotPressed
	ldr	r7, =buttons	
	ldrb 	button, [r7, i]
	mov	button, button
	cmp 	button, #0
	beq 	bPressed

	add 	i, #1	

	b 	readButtons 	

bPressed:

	mov 	r0, #1
	b 	stopA	
	
bNotPressed:

	mov 	r0, #0

stopA:
	
	.unreq 	i
	.unreq 	addr
	.unreq 	button
	
	pop 	{r4 - r6, pc}
	bx 	lr
	
