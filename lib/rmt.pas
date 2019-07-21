unit RMT;
(*
 @type: unit
 @author: Tomasz Biela (Tebe)
 @name: Raster Music Player library
 @version: 1.0

 @description:
 <http://atariki.krap.pl/index.php/Rmt>
*)

{

TRMT.Init
TRMT.Play
TRMT.Sfx
TRMT.Stop

}

interface

type	TRMT = Object
(*
@description:
object for controling RMT player
*)
	player: pointer;	// memory address of player
	modul: pointer;		// memory address of a module

	procedure Init(a: byte); assembler;	// Initializes
	procedure Play; assembler;
	procedure Sfx(effect, channel, note: byte); assembler;
	procedure Stop; assembler;		// Stops Music

	end;


implementation


procedure TRMT.Init(a: byte); assembler;
(*
@description:
Initialize RMT player

@param: a - song number
*)
asm
{	txa:pha

	mwa TRMT :bp2

	ldy #0
	lda (:bp2),y
	add #3		; jsr player+3
	sta adr
	iny
	lda (:bp2),y
	adc #0
	sta adr+1

	iny
	lda (:bp2),y
	tax		; low byte of RMT module to X reg
	iny
	lda (:bp2),y
	tay		; hi byte of RMT module to Y reg

	lda a		; starting song line 0-255 to A reg
	jsr $ffff
adr	equ *-2

	pla:tax
};
end;


procedure TRMT.Sfx(effect, channel, note: byte); assembler;
(*
@description:
Play sound effect

@param: effect - sound effect number
@param: channel
@param: note
*)
asm
{	txa:pha

	mwa TRMT :bp2

	ldy #0
	lda (:bp2),y
	add #15		; jsr player+15
	sta adr
	iny
	lda (:bp2),y
	adc #0
	sta adr+1

	lda effect
	asl @
	tay

	ldx channel
	lda note

	jsr $ffff
adr	equ *-2

	pla:tax
};
end;


procedure TRMT.Play; assembler;
(*
@description:
Play music, call this procedure every VBL frame
*)
asm
{	txa:pha

	mwa TRMT ptr

	ldy #1
cptr	lda $ffff,y
ptr	equ *-2
	sta adr,y
	dey
	bpl cptr

	jsr $ffff
adr	equ *-2

	pla:tax
};
end;


procedure TRMT.Stop; assembler;
(*
@description:
Halt RMT player
*)
asm
{	txa:pha

	mwa TRMT :bp2

	ldy #0
	lda (:bp2),y
	add #9		; jsr player+9
	sta adr
	iny
	lda (:bp2),y
	adc #0
	sta adr+1

	jsr $ffff
adr	equ *-2

	pla:tax
};
end;


end.

