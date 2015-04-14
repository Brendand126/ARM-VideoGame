.data
PlayerPoints: 	.word 50

/*
_________________________________________________________________________________________________________________________________

	UpdateHuman handles changes to the points of the player. Branches to GameOverScreen in main once points are zero, adds points 
	to total points if player kills an enemy
_________________________________________________________________________________________________________________________________

*/



.text
.globl UpdateHuman
UpdateHuman:
	push	{r4-r10, lr}

	
	ldr 	r2, =685
	cmp 	r1, r2				// see of the collision is a rock
	bgt		playerHit			// skip update rocks if y coordinate of bullet is where player y is
	bl		UpdateRocks			// branch to UpdateRocks if a rock was hit
	b 		done				// skip over playerHit if a rock was hit
	
playerHit:

	ldr 	r4, =PlayerPoints	// load playerPoints
	ldr 	r5, [r4]			// load it into a register

	cmp 	r5, #0				// see if the player is dead
	blle 	playerDead			// branch to playerDead if points is zero
	
	sub 	r5, #10				// sub 10 points from playerPoints
	str 	r5, [r4]			// store it back into memory

	ldr 	r4, =PlayerPoints	// load playerPoints
	ldr 	r5, [r4]			// load it into a register

	//DELETE Score
	ldr	r0, =500		//x
	ldr	r1, =0		//y
	mov	r2, #100		//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #100			//y (height) of image -1
	bl	DeleteImage

	ldr 	r4, =PlayerPoints	// load playerPoints
	ldr 	r5, [r4]			// load it into a register
	mov 	r0, r5
	bl 	Score
	 

	cmp	 	r5, #0				// after the sub see if player was killed
	blle 	playerDead 			// branch if player was killed

	b 		done

playerDead:
	
	b		GameOverScreen		// branch to GameOverScreen in main
	
done: 							// if player wasnt killed or rock was hit, return to calling code
	
	mov 	r0, r0
	mov 	r0, r0
	mov 	r0, r0

	pop	{r4-r10, pc}
	bx lr

.global HumanKill
HumanKill:

	type 	.req 	r0			// pawn, knight, queen
	addr	.req 	r4			// address of playerPoints
	pts	.req 	r5			// value stored in playerPoints
	pawn  	.req 	r6			// value of pawn
	knight 	.req 	r7			// value of knight
	queen 	.req 	r8			// value of queen

	push 	{r4 - r8, lr}
	
	mov 	pawn, #0			// pawn value is 0
	mov 	knight, #1			// knight value is 1
	mov 	queen, #2			// queen value is 2
	
	ldr 	addr, =PlayerPoints		// load address of PlayerPoints into addr
	ldr 	pts, [addr]				// load points from PlayerPoints into pts

	cmp	type, pawn			// compare value of pawn to the type passed in
	bne 	next				// skip add points to the next comparison if type not pawn
		
	addeq 	pts, #5				// if type was pawn add 5 points
	str 	pts, [addr]			// store pts back into address of PlayerPoints
	b 		stop				// skip over the rest of the checks for knight and queen

next:
	
	ldr 	addr, =PlayerPoints		
	ldr 	pts, [addr]	
	
	cmp 	type, knight		// compare value of knight to type passed in
	bne 	next1				// skip add points to the next comparison if type not knight
		
	addeq 	pts, #10			// if type was knight add 10 points
	str 	pts, [addr]			// store pts back into address of PlayerPoints 
	b 		stop				// skip over the check for queen 

next1:
	
	ldr 	addr, =PlayerPoints	
	ldr 	pts, [addr]
	
	cmp 	type, queen 		// compare type with value passed in
	addeq 	pts, #100			// if type was queen add 100 points 
	str 	pts, [addr]			// store pts back into address of PlayerPoints

stop:

	//DELETE Score
	ldr	r0, =500		//x
	ldr	r1, =0		//y
	mov	r2, #100		//line length - 1!!!! arraytraverser starts at 0...
	mov	r3, #100			//y (height) of image -1
	bl	DeleteImage

	ldr 	addr, =PlayerPoints	
	ldr 	pts, [addr]	
	mov 	r0, pts
	bl 	Score

	.unreq 	type
	.unreq 	addr
	.unreq 	pts
	.unreq 	pawn
	.unreq 	knight
	.unreq 	queen
		
	pop 	{r4 - r8, pc}
	bx 	lr

.globl ResetHealth
ResetHealth:
push	{r4-r10, lr}


	mov 	r4, #50
	ldr 	r6, =PlayerPoints
	str 	r4, [r6]

pop	{r4-r10, pc}
	bx lr
	
