
; ent_r0 target direction
ent_laser_spawn: subroutine
	jsr ent_find_slot
	txa
	bmi .done
	lda #ent_laser_id
	sta ent_type,x
	; load baddie position
	lda temp06
	sta ent_x,x
	sta collision_0_x
	lda temp07
	sta ent_y,x
	sta collision_0_y
	; stash laser ent slot
	;stx temp07
	/*
	; get target position
	lda #$80
	sta collision_1_x
	lda #$60
	sta collision_1_y
	jsr arctan256
	ldx temp07
	*/
	; setup direction
	lda temp05
	sta ent_r0,x
	lsr
	lsr
	tay
	lda atan_velocity_1875_lo,y
	sta ent_h_lo,x
	lda atan_velocity_1875_hi,y
	sta ent_h,x
	lda ent_r0,x
	clc
	adc #$40
	lsr
	lsr
	tay
	lda atan_velocity_1875_lo,y
	sta ent_v_lo,x
	lda atan_velocity_1875_hi,y
	sta ent_v,x
.done
	rts


ent_laser_update: subroutine

	ent_move_by_velocity

	lda ent_x,x
	cmp #$02
	bcc .do_despawn
	lda ent_y,x
	cmp #249
	bcc .dont_despawn
.do_despawn
	ent_despawn
	rts
.dont_despawn


ent_laser_render: subroutine

	lda ent_x,x
	sta spr_x,y
	lda ent_y,x
	sta spr_y,y

	lda #$00
	sta spr_a,y

	lda #$21
	sta spr_p,y

	iny
	iny
	iny
	iny

	rts
	
	

