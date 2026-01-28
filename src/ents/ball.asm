
; ent_r0 sine counter lo
; ent_r1 sine counter hi

ent_ball_spawn: subroutine
	jsr ent_find_slot
	txa
	bmi .done
	lda #ent_ball_id
	sta ent_type,x
	; load baddie position
	lda temp05
	sta ent_x,x
	lda temp06
	sta ent_y,x
.done
	rts


ent_ball_update: subroutine

/*
	lda ent_x_lo,x
	clc
	adc #$97
	sta ent_x_lo,x
	lda ent_x,x
	adc #$01
	sta ent_x,x
*/
	; update sine counter
	clc
	lda ent_r0,x
	adc #$97
	sta ent_r0,x
	lda ent_r1,x
	adc #$00
	sta ent_r1,x

	; update position
	lda ent_r1,x
	tay
	lda sine_table,y
	lsr
	clc
	adc #$40
	sta ent_x,x
	sta $a0
	lda ent_r1,x
	clc
	adc #$40
	tay
	lda sine_table,y
	lsr
	clc
	adc #$20
	sta ent_y,x
	sta $a1

	; arctan2 test
	lda ent_x,x
	sta collision_0_x
	lda ent_y,x
	sta collision_0_y
	lda #$80
	sta $c0
	sta collision_1_x
	sec
	sbc ent_x,x
	sta $e0
	lda #$60
	sta $c1
	sta collision_1_y
	sec
	sbc ent_y,x
	sta $e1
	jsr arctan2_gpt
	ldx ent_slot
	ldy ent_spr_ptr

	; spawn laser
	lda wtf
	and #$07
	bne .dont_spawn_laser
	lda ent_x,x
	sta temp05
	lda ent_y,x
	sta temp06
	jsr ent_laser_spawn
	ldx ent_slot
.dont_spawn_laser


ent_ball_render: subroutine

	lda ent_x,x
	sta spr_x,y
	lda ent_y,x
	sta spr_y,y

	lda #$00
	sta spr_a,y

	lda #$30
	sta spr_p,y

	iny
	iny
	iny
	iny

	rts
