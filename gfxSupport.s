//			U of C 
//		Assignment 2 - CPSC 359
//	Brendan Dueck, David Lian, Jamie Castillo
//		Last Updated: 28/03/15
//
//File:	gfxSupport.s

//this file is used to help assist in the drawing and deletion of any images or pixels.
//this file also contains other parts that are dependant on the frame buffer ex check pixel.


.section .data
.align 12


//!!!!
//Font
//!!!!
.globl font
font:		.incbin	"font.bin"



//!!!!!!!!!!!!!!!!!!!!!!!!
//Frame Buffer Information
//!!!!!!!!!!!!!!!!!!!!!!!!
.globl FrameBufferInfo
FrameBufferInfo:
    .int    1024    // 0 - Width
    .int    768     // 4 - Height
    .int    1024    // 8 - vWidth 1024
    .int    768   	// 12 - vHeight 768
    .int    0       // 16 - GPU - Pitch

    .int    16      // 20 - Bit Depth
    .int    0       // 24 - X
    .int    0       // 28 - Y
    .int    0       // 32 - GPU - Pointer
    .int    0       // 36 - GPU - Size

	
.align 4
.globl FrameBufferPointer
FrameBufferPointer:
	.int	0

.section .text

/* Initialize the Frame Buffer
 * Return:
 *  r0 - result
 */
.globl InitFrameBuffer
InitFrameBuffer:
    infoAdr .req r4
    	push    {r4, lr}
   	ldr     infoAdr, =FrameBufferInfo       // get framebuffer info address
    
	result  .req r0

   	mov     r0, infoAdr                     // store fb info address as mail message
	add	r0,	#0x40000000		// set bit 30; tell GPU not to cache changes
    	mov     r1, #1                          // mailbox channel 1
    	bl      MailboxWrite                    // write message
    
    	mov     r0, #1                          // mailbox channel 1
    	bl      MailboxRead                     // read message
    
    	teq     result, #0
    	movne   result, #0
   	popne   {r4, pc}                        // return 0 if message from mailbox is 0
    



//!!!!!!!!!!!!!!!!!!!!!!!
//Used to wait till ready
//!!!!!!!!!!!!!!!!!!!!!!!
pointerWait$:
   	ldr     result, [infoAdr, #32]
   	teq	result, #0
    	beq     pointerWait$                    // loop until the pointer is set
	
	ldr	r1, =FrameBufferPointer
	str	result,	[r1]			// store the framebuffer pointer
    
    	mov     result, infoAdr                 // set result to address of fb info struct
   	pop     {r4, pc}                        // return
    
    	.unreq  result
    	.unreq  infoAdr





//!!!!!!!!!!!!!!!
//DRAW PIXEL CODE
//!!!!!!!!!!!!!!!
/* Draw Pixel
 *  r0 - x
 *  r1 - y
 *	r2 - color
 */
.globl DrawPixel
DrawPixel:
    	px      .req r0
    	py      .req r1
	color	.req r2
    	addr    .req r3


	push	{r4}
    

    	ldr     addr,   =FrameBufferInfo
    

    	height  .req r4
    	ldr     height, [addr, #4]
    	sub     height, #1
    	cmp     py,     height
    	movhi   pc,     lr
    	.unreq  height
  
  
    	width   .req r4
    	ldr     width,  [addr, #0]
    	sub     width,  #1
    	cmp     px,     width
    	movhi   pc,     lr
   
 
    	ldr     addr,   =FrameBufferPointer
	ldr		addr,	[addr]

	
    	add     width,  #1
   
 
    	mla     px,     py, width, px    	// px = (py * width) + px
    	.unreq  width
    	.unreq  py
    

    	add     addr,   px, lsl #1		// addr += (px * 2) (ie: 16bpp = 2 bytes per pixel)
    	.unreq  px
    
    	strh    color,  [addr]
    
    	.unreq  addr   
pop	{r4}
bx	lr





//!!!!!!!!!!!!!!!!!
//Check Pixel Color
//!!!!!!!!!!!!!!!!!
/* Check Pixel
 *  r0 - x
 *  r1 - y
 *	r2 - color, return value
 */
.global CheckPixel
CheckPixel:
    	px      .req    r0
    	py      .req    r1
    	addr    .req    r3

	push	{r4}
    
    	ldr     addr,   =FrameBufferInfo
  
  
    	height  .req    r4
    	ldr     height, [addr, #4]
    	sub     height, #1
    	cmp     py,     height
    	movhi   pc,     lr
    	.unreq  height
 
   
    	width   .req    r4
    	ldr     width,  [addr, #0]
    	sub     width,  #1
    	cmp     px,     width
    	movhi   pc,     lr
 
   
    	ldr     addr,   =FrameBufferPointer
	ldr		addr,	[addr]

	
    	add     width,  #1
  
   
    	mla     px,     py, width, px       // px = (py * width) + px
    	.unreq  width
    	.unreq  py
    
    	add     addr,   px, lsl #1			// addr += (px * 2) (ie: 16bpp = 2 bytes per pixel)
    	.unreq  px
    
    	ldrh    r0,  [addr]
    
    	.unreq  addr
    
pop	{r4}
bx	lr







//!!!!!!!!!!!!!!!!!!!!
//Write to the mailbox
//!!!!!!!!!!!!!!!!!!!!
/* Write to mailbox
 * Args:
 *  r0 - value (4 LSB must be 0)
 *  r1 - channel
 */
.globl MailboxWrite
MailboxWrite:
tst     r0, #0b1111                     // if lower 4 bits of r0 != 0 (must be a valid message)
movne   pc, lr                          //  return
    
    	cmp     r1, #15                         // if r1 > 15 (must be a valid channel)
    	movhi   pc, lr                          //  return
    
    	channel .req r1
    	value   .req r2
    	mov     value, r0
    
    	mailbox .req r0
	ldr     mailbox,=0x2000B880
    
wait1$:
    	status  .req r3
    	ldr     status, [mailbox, #0x18]        // load mailbox status
    
    	tst     status, #0x80000000             // test bit 32
    	.unreq  status
    	bne     wait1$                          // loop while status bit 32 != 0
    
    	add     value, channel                  // value += channel
    	.unreq  channel
    
    	str     value, [mailbox, #0x20]         // store message to write offset
    
    	.unreq  value
    	.unreq  mailbox
    
bx	lr






//!!!!!!!!!!!!!!!!!!!!
//Read from the mailbox
//!!!!!!!!!!!!!!!!!!!!
/* Read from mailbox
 * Args:
 *  r0 - channel
 * Return:
 *  r0 - message
 */
.globl MailboxRead
MailboxRead:
    	cmp     r0, #15                         // return if invalid channel (> 15)
    	movhi   pc, lr
    
    	channel .req r1
    	mov     channel, r0
    
    	mailbox .req r0
	ldr     mailbox,=0x2000B880
    
rightmail$:
wait2$:
    	status  .req r2
    	ldr     status, [mailbox, #0x18]        // load mailbox status
    
    	tst     status, #0x4000000              // test bit 30
    	.unreq  status
    	bne     wait2$                          // loop while status bit 30 != 0
    
    	mail    .req r2
    	ldr     mail, [mailbox, #0]             // retrieve message
    
    	inchan  .req r3
    	and     inchan, mail, #0b1111           // mask out lower 4 bits of message into inchan
    
    	teq     inchan, channel
    	.unreq  inchan
    	bne     rightmail$                      // if not the right channel, loop
    
    	.unreq  mailbox
    	.unreq  channel
    
    	and     r0, mail, #0xfffffff0           // mask out channel from message, store in return (r0)
    	.unreq  mail   
bx		lr








/*********************************************************************
//Receives 5 inputs: X, Y, image width-1 (imgX), image heigth-1 (imgY), pointer to colourArray
//
*********************************************************************/
.globl DrawImage
DrawImage:
	push	{r4-r10, fp, lr}

	//save r3 (image height-1) onto the stack to keep it safe until I need it
	mov 	fp, sp
	sub 	sp, #12				//make space for 3 ints in the stack
	str 	r3, [fp]			//line heigth
	str 	r0, [fp, #-4] 			//originalXcord
	str 	r1, [fp, #-8]			//originalYcord

	counter			.req	r5
	lineLength		.req	r6
	arrayTraverse		.req	r7	
	xcord			.req	r8
	ycord			.req	r9
	arrayofColorPointer	.req	r10

	
//xcord and ycord will change through the loops
	mov 	xcord, r0
	mov	ycord, r1
	mov 	lineLength, r2
	mov 	counter, #0			//initialize counter to 1
	mov 	arrayTraverse, #0		// this counts from 0 to the total number of pixels (21x24)



//load the base address of the array of the image to use in the loop. I do this once.
	mov arrayofColorPointer, r4 		// r9 = address of numbers[0]



/////////////////////////Do-while//////////////////////
preLoop:
	mov	r0, xcord			//changes...
	mov	r1, ycord
//get the colours from the array : )
	add	r3, arrayofColorPointer, arrayTraverse, LSL #2 //this does the offset with just one instruction! arrayofColorPointer + (arrayTraverse*4)
	ldr	r2, [r3]	
	bl	DrawPixel


	
	add 	counter, #1
	add 	arrayTraverse, #1
	add 	xcord, #1
	cmp 	counter, lineLength		//compare counter and length to determine when the line has been drawn
	ble 	preLoop

		

//load original xcord from the stackerino
	ldr 	r2, [fp, #-4]			//r2 is a scratch register that will hold originalXCord...
	add	ycord, #1
	mov	counter, #0
	mov	xcord, r2 			//r2 holds originalXCord


//load original ycord from the stackerino
	ldr 	r2, [fp, #-8]			//r2 is a scratch register that will hold originalYCord...
//load the image height from the stack into r1 to use it for comparison
	ldr 	r1, [fp]

	add	r0, r2,	r1
	cmp	ycord, r0			//r0 = (y of location)+ 23 (y of image-1), r1 is image width, r2 is originalYCord
	ble	preLoop

	.unreq	counter
	.unreq 	lineLength
	.unreq 	arrayTraverse
	.unreq 	xcord
	.unreq 	ycord
	.unreq 	arrayofColorPointer
	
	add 	sp, #12

pop	{r4-r10, fp, pc}
bx 	lr







/*********************************************************************
//Receives 4 inputs: X, Y, image width-1 (imgX), image heigth-1 (imgY)
//
*********************************************************************/
.globl DeleteImage
DeleteImage:
	push	{r5-r8, fp, lr}

//save r3 (image height-1) onto the stack to keep it safe until I need it
	mov 	fp, sp
	sub 	sp, #12				//make space for 3 ints in the stack
	str 	r3, [fp]			//line heigth
	str 	r0, [fp, #-4] 			//originalXcord
	str 	r1, [fp, #-8]			//originalYcord

	counter			.req	r5
	lineLength		.req	r6
	xcord			.req	r7
	ycord			.req	r8
	
//xcord and ycord will change through the loops
	mov 	xcord,	r0
	mov 	ycord,	r1
	mov 	lineLength, r2
	mov 	counter, #0			//initialize counter to 1

/////////////////////////Do-while//////////////////////
delLoop:
	mov	r0, xcord			//changes...
	mov	r1, ycord
	ldr	r2,		=0x0
	bl	DrawPixel


	
	add 	counter, #1
	add 	xcord, #1
	cmp 	counter, lineLength		//compare counter and length to determine when the line has been drawn
	ble 	delLoop

	

//load original xcord from the stackerino
	ldr 	r2, [fp, #-4]			//r2 is a scratch register that will hold originalXCord...
	add	ycord, #1
	mov	counter, #0
	mov	xcord, r2 			//r2 holds originalXCord


//load original ycord from the stackerino
	ldr 	r2, [fp, #-8]			//r2 is a scratch register that will hold originalYCord...
//load the image height from the stack into r1 to use it for comparison
	ldr 	r1, [fp]

	add	r0,	r2,	r1
	cmp	ycord, r0			//r0 = (y of location)+ 23 (y of image-1), r1 is image width, r2 is originalYCord
	ble	delLoop

	.unreq	counter
	.unreq	lineLength
	.unreq 	xcord
	.unreq 	ycord
	

	add 	sp, #12

pop	{r5-r8, fp, pc}
bx lr








/*********************************************************************
//Clears the screen (all pixels black)
//
*********************************************************************/
.globl ClearScreen
ClearScreen:
	push	{r4-r8, lr}

	counter			.req	r5
	lineLength		.req	r6
	xcord			.req	r7
	ycord			.req	r8
	heigth			.req	r4
	
//xcord and ycord will change through the loops
	mov 	xcord,	#0
	mov 	ycord,	#0
	ldr 	lineLength,	=1023
	ldr 	heigth, =767
	mov 	counter, #0			//initialize counter to 0

/////////////////////////Do-while//////////////////////
clearLoop:
	mov	r0, xcord			//changes...
	mov	r1, ycord
	ldr	r2,		=0x0
	bl	DrawPixel


		
	add 	counter, #1
	add 	xcord, #1
	cmp 	counter, lineLength		//compare counter and length to determine when the line has been drawn
	ble 	clearLoop

		
	add	ycord, #1
	mov	counter, #0
	mov	xcord, #0 			//r2 holds originalXCord

	cmp	ycord, heigth			
	ble	clearLoop

	.unreq	counter
	.unreq 	lineLength
	.unreq 	xcord
	.unreq 	ycord
	.unreq 	heigth
	
pop	{r4-r8, pc}
bx lr





/******************************************************************************
//Receives 4 inputs: a String (defined in data section), length of String, X, Y
//
*******************************************************************************/
.globl DrawString
DrawString:
	push	{r4-r9, lr}
	counter		.req	r4
	string		.req	r5
	stringLength	.req	r6
	xCoordinate	.req	r8
	yCoordinate	.req	r9
	
	mov 	yCoordinate, r3
	mov 	xCoordinate, r2
	mov 	stringLength, r1		//save length in r6	
	mov 	string,	r0			//save string in r5
	mov 	counter, #1			//initialize counter to 1

/////////////////////////Do-while//////////////////////
doWhile:
	ldrb	r7,	[string], #1		//this reads a byte (8 bits) from r0 (where i passed my string in main) -post increment-

	mov 	r0, r7				//prepare for charDraw function
	mov 	r1, xCoordinate			//x needs to change: move contents of passed r2 to r1, post-increment by 10 pixels
	mov 	r2, yCoordinate
	bl	DrawCharacter
		
	add 	yCoordinate, #8
	add 	counter, #1
	cmp 	counter, stringLength		//compare counter and length of string
	ble 	doWhile

endDrawString:
	.unreq	counter
	.unreq string
	.unreq stringLength
	.unreq xCoordinate
	.unreq yCoordinate

pop	{r4-r9, pc}
bx 	lr





//!!!!!!!!!!!!!!
//DRAW CHARACTER
//!!!!!!!!!!!!!!
.globl DrawCharacter
DrawCharacter:
	push	{r4-r10, lr}

	chAdr		.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask		.req	r8
	Somethingx 	.req 	r9
	Somethingy 	.req 	r10

	mov 	Somethingx, r1
	mov 	Somethingy, r2


	ldr	chAdr,	=font			// load the address of the font map
	
	add	chAdr,	r0, lsl #4		// char address = font base + (char * 16)

	mov	py, Somethingx			// init the Y coordinate (pixel coordinate)

charLoop$:
	mov	px, Somethingy			// init the X coordinate

	mov	mask, #0x01			// set the bitmask to 1 in the LSB
	
	ldrb	row, [chAdr], #1		// load the row byte, post increment chAdr

rowLoop$:
	tst	row,	mask			// test row byte against the bitmask
	beq	noPixel$

	mov	r0, px
	mov	r1, py
	ldr	r2, =0xFFFF			// 0xFFFFFF
	//ldr r2, =0xf8f8f8
	bl	DrawPixel			// draw red pixel at (px, py)

noPixel$:
	add	px, #1				// increment x coordinate by 1
	lsl	mask, #1			// shift bitmask left by 1

	tst	mask, #0x100			// test if the bitmask has shifted 8 times (test 9th bit)
	beq	rowLoop$

	add	py, #1				// increment y coordinate by 1

	tst	chAdr, #0xF
	bne	charLoop$			// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask

pop	{r4-r10, pc}
bx 	lr
