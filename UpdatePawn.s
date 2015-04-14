//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	UpdatePawn.s


.globl pawnCOL
pawnCOL:
	push	{r2-r10, lr}

	cmp 	r0, #840			// compare the x value to the rock location
	blge	ColJ				// |_J_|_840-1000(+20)_|_329_|
	cmp 	r0, #800			//
	blge	ColI				// |_I_|_800-820_(+20)_|_405_|
	cmp 	r0, #660			//
	blge	ColH				// |_H_|_660-780_(+20)_|_379_|
	cmp 	r0, #600			//
	blge	ColG				// |_G_|_600-640_(+20)_|_345_|
	cmp 	r0, #520			//
	blge	ColF				// |_F_|_520-580_(+20)_|_285_|
	cmp 	r0, #380			//
	blge	ColE				// |_E_|_380-500_(+20)_|_418_|
	cmp 	r0, #320			//
	blge	ColD				// |_D_|_320-360_(+20)_|_380_|
	cmp 	r0, #210			//
	blge	ColC				// |_C_|_210-300_(+20)_|_325_|
	cmp 	r0, #150			//
	blge	ColB				// |_B_|_150-190_(+20)_|_400_|
	bl	ColA				// |_A_|_000-130_(+20)_|_300_|



ColA:						
	ldrb	r5, [r2]
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead
	
	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r2]			//Store pawn A health 				****UPDATE****
	
	
	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill

	bl	skipAllPawns			//skip to end after updating			****UPDATE****


ColB:										
	ldrb	r5, [r2, #1]			//Load pawn B health 				****UPDATE****
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead

	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r2, #1]			//Store pawn A health 				****UPDATE****
	
	
	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill

	bl	skipAllPawns			//skip to end after updating			****UPDATE****



ColC:										
	ldrb	r5, [r2, #2]			//Load pawn C health 				****UPDATE****
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead

	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r2, #2]			//Store pawn A health 				****UPDATE****
	
	
	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill

	bl	skipAllPawns			//skip to end after updating			****UPDATE****



ColD:										
	ldrb	r5, [r2, #3]			//Load pawn D health 				****UPDATE****
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead

	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r2, #3]			//Store pawn A health 				****UPDATE****
	
	
	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill

	bl	skipAllPawns			//skip to end after updating			****UPDATE****



ColE:											
	ldrb	r5, [r2, #4]			//Load pawn E health 				****UPDATE****
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead

	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r2, #4]			//Store pawn A health 				****UPDATE****
	
	
	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill

	bl	skipAllPawns			//skip to end after updating			****UPDATE****



ColF:								
	ldrb	r5, [r2, #5]			//Load pawn F health 				****UPDATE****	
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead


	sub	r5, #1				//see if the pawn is dead			
	strb	r5, [r2, #5]			//Store pawn F health 				****UPDATE****


	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill
	bl	skipAllPawns			//skip to end after updating			****UPDATE****

ColG:									
	ldrb	r5, [r2, #6]			//Load pawn G health 				****UPDATE****	
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead

	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r2, #6]			//Store pawn G health 				****UPDATE****

	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill


	bl	skipAllPawns			//skip to end after updating			****UPDATE****


ColH:									
	ldrb	r5, [r2, #7]			//Load pawn H health 				****UPDATE****	
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead

	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r2, #7]			//Store pawn H health 				****UPDATE****
	
	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill


	bl	skipAllPawns			//skip to end after updating			****UPDATE****


ColI:								
	ldrb	r5, [r2, #8]			//Load pawn I health 				****UPDATE****
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead

	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r2, #8]			//Store pawn I health 				****UPDATE****

	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill


	bl	skipAllPawns			//skip to end after updating			****UPDATE****

				
ColJ:								
	ldrb	r5, [r2, #9]			//Load pawn J health 				****UPDATE****
	mov 	r5, r5			//Load pawn A health 				****UPDATE****
	cmp	r5, #0				//compare the health to 0
	bleq	skipAllPawns			//skip to end if pawn is dead

	sub	r5, #1				//see if the pawn is dead
	strb	r5, [r2, #9]			//Store pawn J health 				****UPDATE****

	cmp 	r5, #0
	moveq 	r0, #0
	bleq 	HumanKill


	bl	skipAllPawns			//skip to end after updating			****UPDATE****


skipAllPawns:
	pop	{r2-r10, pc}
	bx lr
