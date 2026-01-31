; 8-bit atan2
; src https://codebase64.net/doku.php?id=base:8bit_atan2_8-bit_angle

; might be more precise to add a clc adc #$01 after each eor #$ff, you have to modify all the preceding bcs *+4/ bcc *+4 to *+7 to get the branches correct. also you can omit the clc where bcs is used. adding a SEC before all sbc's might increase the accuracy even further. :) /Oswald


;; Calculate the angle, in a 256-degree circle, between two points.
;; The trick is to use logarithmic division to get the y/x ratio and
;; integrate the power function into the atan table. Some branching is
;; avoided by using a table to adjust for the octants.
;; In otherwords nothing new or particularily clever but nevertheless
;; quite useful.
;;
;; by Johan Forslöf (doynax)



;octant		= $fb			;; temporary zeropage variable
; use temp04 as octant


	; XXX modified from codebase64
	; use arctan256 instead
arctan2:		
	; uses collision registers
	; uses temp00 as octant
	; destroys x, y
	; returns direction in A
	sec
	lda collision_0_x
	sbc collision_1_x
	bcs .skip_x_abs
	eor #$ff
	clc
	adc #$01
.skip_x_abs
	tax
	rol temp00

	sec
	lda collision_0_y
	sbc collision_1_y
	bcs .skip_y_abs
	eor #$ff
	clc
	adc #$01
.skip_y_abs
	tay
	rol temp00

	sec
	lda log2_table,x
	sbc log2_table,y
	bcc .skip_log_abs
	eor #$ff
	clc
	adc #$01
.skip_log_abs
	tax

	lda temp00
	rol
	and #%111
	tay

	lda atan_table,x
	eor octant_adjust,y
	rts


octant_adjust:
	; octant ccw order:
	;   2 6 7 3 1 5 4 0
	byte %11100000 ; 0 x+ y- adx>ady
	byte %10011111 ; 1 x- y+ adx>ady
	byte %00011111 ; 2 x+ y- adx>ady
	byte %01100000 ; 3 x- y- adx>ady ; order backwards?
	byte %11011111 ; 4 x+ y- adx<ady
	byte %10100000 ; 5 x- y+ adx<ady
	byte %00100000 ; 6 x+ y- adx<ady
	byte %01011111 ; 7 x- y- adx<ady


/*
| Angle | Meaning |
| ----: | ------- |
|     0 | right   |
|    64 | down    |
|   128 | left    |
|   192 | up      |
*/

;;;;;;;; atan(2^(x/32))*128/pi ;;;;;;;;

atan_table:
	hex 00000001010202030303040405050606
	hex 06070708080809090a0a0a0b0b0c0c0c
	hex 0d0d0d0e0e0e0f0f0f10101011111111
	hex 12121212131313131414141415151515
	hex 16161616161717171717171818181818
	hex 1819191919191919191a1a1a1a1a1a1a
	hex 1a1b1b1b1b1b1b1b1b1b1b1b1c1c1c1c
	hex 1c1c1c1c1c1c1c1c1c1d1d1d1d1d1d1d
	hex 1d1d1d1d1d1d1d1d1d1d1d1d1e1e1e1e
	hex 1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e
	hex 1e1e1e1e1e1e1e1e1e1e1e1e1f1f1f1f
	hex 1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f
	hex 1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f
	hex 1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f
	hex 1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f
	hex 1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f



;;;;;;;; log2(x)*32 ;;;;;;;;

log2_table:
	hex 00002032404a525960656a6e7276797d
	hex 808285878a8c8e9092949698999b9d9e
	hex a0a1a2a4a5a6a7a9aaabacadaeafb0b1
	hex b2b3b4b5b6b7b8b9b9babbbcbdbdbebf
	hex c0c0c1c2c2c3c4c4c5c6c6c7c7c8c9c9
	hex cacacbcccccdcdcececfcfd0d0d1d1d2
	hex d2d3d3d4d4d5d5d5d6d6d7d7d8d8d9d9
	hex d9dadadbdbdbdcdcdddddddedededfdf
	hex e0e0e0e1e1e1e2e2e2e3e3e3e4e4e4e5
	hex e5e5e6e6e6e7e7e7e7e8e8e8e9e9e9ea
	hex eaeaeaebebebececececededededeeee
	hex eeeeefefefeff0f0f0f1f1f1f1f1f2f2
	hex f2f2f3f3f3f3f4f4f4f4f5f5f5f5f5f6
	hex f6f6f6f7f7f7f7f7f8f8f8f8f9f9f9f9
	hex f9fafafafafafbfbfbfbfbfcfcfcfcfc
	hex fdfdfdfdfdfdfefefefefeffffffffff

atan_velocity_1875_lo:
	hex fffefaf4ece1d4c5b4a28e78614a3119
	hex 00e6ceb59e87715d4b3a2b1e130b0501
	hex 0001050b131e2b3a4b5d71879eb5cee6
	hex ff19314a61788ea2b4c5d4e1ecf4fafe
atan_velocity_1875_hi:
	hex 00000000000000000000000000000000
	hex 00ffffffffffffffffffffffffffffff
	hex ffffffffffffffffffffffffffffffff
	hex ff000000000000000000000000000000


arctan256: subroutine
	; uses collision registers
	; uses temp00 as octant
	; uses temp02, temp03 for adx, ady
	; destroys x, y
	; returns direction in A
	lda #$00
	sta temp00
	; dx = x1 - x0
	sec
	lda collision_1_x
	sbc collision_0_x
	sta temp02
	bcs .dx_done
	; abs(dx)
	eor #$ff
	clc
	adc #$01
	sta temp02
	; update octant
	lda temp00
	ora #$01
	sta temp00
.dx_done
	lda temp02
	; dy = y1 - y0
	sec
	lda collision_1_y
	sbc collision_0_y
	sta temp03
	bcs .dy_done
	; abs(dy)
	eor #$ff
	clc
	adc #$01
	sta temp03
	; update octant
	lda temp00
	ora #$02
	sta temp00
.dy_done
	lda temp03
	; log2(adx) - log2(ady)
	ldx temp02
	ldy temp03
	sec
	lda log2_table,x
	sbc log2_table,y
	bcs .ratio_pos
	; abs(log diff)
	eor #$ff
	clc
	adc #$01
	tax
	lda temp00
	ora #$04
	sta temp00
	jmp .ratio_done
.ratio_pos
	tax
.ratio_done
	; octant index
	ldy temp00
	; final maths
	lda atan_table,x
	eor octant_adjust,y
	rts

