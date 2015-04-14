//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	Reset.s


//this mini function is called when the game restarts in any way. 
//It sets the ai health, the rock health and the huan health all back to default

.text

.globl Reset
Reset:
push	{r4-r10, lr}


	
	
	bl 	ResetHealth
	bl	ResetRockHealth
	bl	ResetAIHealth

	//ai health in r0
	//This section is used to reset each element in the array back to its coresponding health value
	mov	r1, #1						//pawns with health=1
	mov	r4, r0
	strb	r1, [r4]
	mov	r4, r0
	strb	r1, [r4, #1]
	mov	r4, r0
	strb	r1, [r4, #2]
	mov	r4, r0
	strb	r1, [r4, #3]
	mov	r4, r0
	strb	r1, [r4, #4]
	mov	r4, r0
	strb	r1, [r4, #5]
	mov	r4, r0
	strb	r1, [r4, #6]
	mov	r4, r0
	strb	r1, [r4, #7]
	mov	r4, r0
	strb	r1, [r4, #8]
	mov	r4, r0
	strb	r1, [r4, #9]


	mov 	r1, #3					//knights with health=3
	mov	r4, r0
	strb	r1, [r4, #10]
	mov	r4, r0
	strb	r1, [r4, #11]
	mov	r4, r0
	strb	r1, [r4, #12]
	mov	r4, r0
	strb	r1, [r4, #13]
	mov	r4, r0
	strb	r1, [r4, #14]

	mov 	r1, #10					//queens with health =10
	mov	r4, r0
	strb	r1, [r4, #15]
	mov	r4, r0
	strb	r1, [r4, #16]


pop	{r4-r10, pc}
bx lr
