

.text

.globl Score
Score:
push	{r4-r10, lr}
	
	curScore	.req 	r8
	i			.req 	r9

	FirstDig 		.req 	r4
	secondDig 		.req 	r5
	thirdDig 		.req 	r6
	sum			.req 	r7
	
	mov 	FirstDig, #0
	mov 	secondDig, #0
	mov 	thirdDig, #0
	
	mov 	curScore, r0
	mov 	i, curScore

FirstLoop:
	
	cmp 	i, #100
	blt 	secondLoop
	
	sub 	i,#100
	add 	FirstDig, #1

	bl 		FirstLoop
	
	
secondLoop:	
	
	cmp		i, #10
	blt 	thirdLoop
	
	sub 	i, #10
	add 	secondDig, #1
	
	bl 		secondLoop
	
thirdLoop:	

	cmp 	i, #1
	blt 	done2
	
	sub 	i, #1
	add 	thirdDig, #1
	
	bl 		thirdLoop
	
done2:

	add 	FirstDig, #48
	add 	secondDig, #48
	add 	thirdDig, #48
	
	








//PRINT
	
	mov 	r0, FirstDig
	ldr 	r1, =0
	ldr 	r2, =500
	bl	DrawCharacter

	mov 	r0, secondDig
	ldr 	r1, =0
	ldr 	r2, =509
	bl	DrawCharacter

	mov 	r0, thirdDig
	ldr 	r1, =0
	ldr 	r2, =518
	bl	DrawCharacter


	.unreq 	curScore
	.unreq 	i

	.unreq 	FirstDig
	.unreq 	secondDig
	.unreq 	thirdDig
	.unreq 	sum
	
	pop	{r4-r10, pc}
	bx lr
	
	
