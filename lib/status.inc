status:
.init
  xor a
  ld [SUBTOTAL], a
  ld [TOTAL], a
  ld [TOTAL+1], a
  ld [DISPLAY_SUBTOTAL], a
  ld [DISPLAY_SUBTOTAL+1], a
  ld [DISPLAY_TOTAL], a
  ld [DISPLAY_TOTAL+1], a
  ld [DISPLAY_TOTAL+2], a
  ld [DISPLAY_TOTAL+3], a
  ret


.decreaseRollCount
  ld a, [ROLL_COUNT]
  dec a
  ld [ROLL_COUNT], a
  ret

.resetRollCount
  ld a, 3
  ld [ROLL_COUNT], a
  ret

.drawRollCount
  ld hl, BEGIN_ROLLS+4
  ld a, [ROLL_COUNT]
  add $BF
  ld [hl], a
  ret

.updateSubtotal
  xor a
  ld h, a
  ld a, [SUBTOTAL]
  ld l, a
  ld de, DISPLAY_SUBTOTAL
  call getDisplayNumber
  ret

.drawSubtotal
  ld hl, BEGIN_SUBTOTAL+33
  ld de, DISPLAY_SUBTOTAL+2
  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.updateTotal
  ld a, [TOTAL]
  ld h, a
  ld a, [TOTAL+1]
  ld l, a
  ld de, DISPLAY_TOTAL
  call getDisplayNumber
  ret

.drawTotal
  ld hl, BEGIN_TOTAL+32
  ld de, DISPLAY_TOTAL+3

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret