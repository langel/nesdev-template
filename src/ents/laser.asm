
; ent_r0 target direction
ent_laser_spawn: subroutine
	jsr ent_find_slot
	txa
	bmi .done
	lda #ent_laser_id
	sta ent_type,x
	; load baddie position
	lda temp05
	sta ent_x,x
	sta collision_0_x
	lda temp06
	sta ent_y,x
	sta collision_0_y
	; get target position
	lda #$80
	sta collision_1_x
	lda #$60
	sta collision_1_y
	jsr arctan2_gpt
	ldx ent_slot
	ldy ent_spr_ptr
	sta ent_r0,x
.done
	rts


ent_laser_update: subroutine


	lda ent_y_lo,x
	clc
	adc #$27
	sta ent_y_lo,x
	lda ent_y,x
	adc #$02
	sta ent_y,x

	cmp #249
	bcc .dont_despawn
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
	
	

