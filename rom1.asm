; z80asm -v -a rom1.asm

	SCREEN EQU 61440
	STACKTOP EQU 33790
	MEMSTART EQU 32768	

	ORG 00h
START:
	ld sp,STACKTOP
	JP MAIN

	ORG 08h

	ORG 10h
	
	ORG 20h
	
	ORG 28h
	
	ORG 30h
	
	ORG 38h
; interrupt handler
	ei
	reti

	ORG 66h
; NMI handler
	exx
	ex af,af'
	
	ld a, 'X'
	ld hl, SCREEN
	ld (hl), a
	
	ex af,af'
	exx
	retn

; CP/M style - real stuff starts here
	ORG 100h
MAIN:
	
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
	ld a,%11001111 ; white on red flashing
	ld (hl),a
	inc hl
	djnz msgloop
	
	; The first byte on the start of the 7th row (160*7 + 1)
	ld de, 960
	
	ld a,0
	ld c, '*'
	ld hl, SCREEN
	add hl, de
	
	ld b,8
row1:
	push bc
	ld b,16
col1:
	ld (hl),c
	inc hl
	ld (hl),a
	inc hl
	ld (hl),c
	inc hl
	ld (hl),a
	inc hl
	inc a
	djnz col1
	
	ld de, 96
	add hl, de
	
	pop bc
	djnz row1
	
	
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

