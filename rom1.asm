; z80asm -v -a rom1.asm

	org 0
	
	DEFC SCREEN = 61440
	DEFC STACKTOP = 33790
	DEFC MEMSTART = 32768	

	ld sp,STACKTOP
	
	ld  a,01h  ; first led
	out (0ffh),a

	; save something to RAM and see if we get it back
	ld hl, MEMSTART
	ld (hl), a
	ld d,(hl)

	cp d
	jr nz, fail
	
	ld  a,0AAh  ; every second led
	out (0ffh),a

fail:
	
	ld a, 22
	;  just to test that the RAM is working!
	push af
start:

startmessage:
	ld hl,SCREEN
	ld de,message
	ld a,(de)
	ld b,a
	inc de
msgloop:
	ld a,(de)
	ld (hl),a
	inc de
	inc hl
	ld a,@11001111 ; white on red flashing
	ld (hl),a
	inc hl
	djnz msgloop
	halt

; this is the high-speed character spew. We don't need that now.

	ld a,65
startscreen:
	ld hl,SCREEN
	
	ld b, 25
rowloop:
	push bc
	ld b,79	
lineloop:
	ld (hl),a
	inc hl
	inc hl
		
	djnz lineloop
	
	pop bc
	inc a
	djnz rowloop

	push af
	; toggle LED 6
	ld d,32
	in a,(0ffh)
	xor d
	out (0ffh),a
	pop af
	
	jp startscreen
	
message:
DEFB 50
DEFM "This is the FPGA vt100 emulator. Nothing works yet"

