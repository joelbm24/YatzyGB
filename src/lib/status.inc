; vim: ft=gbasm

status:
.init
  xor a
  ld [SUBTOTAL], a
  ld [TOTAL], a
  ld [TOTAL+1], a
  ld [DISPLAY_SUBTOTAL], a
  ld [DISPLAY_SUBTOTAL+1], a
  ld [DISPLAY_SUBTOTAL+2], a
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

; .drawRollCount
;   DRAW_NUMBER BEGIN_ROLLS_NUMBER, ROLL_COUNT, 1
;   ret

.updateSubtotal
  xor a
  ld h, a
  ld a, [SUBTOTAL]
  ld l, a
  ld de, DISPLAY_SUBTOTAL
  call getDisplayNumber
  ret

.drawSubtotal
  DrawNumber BEGIN_SUBTOTAL_NUMBERS, DISPLAY_SUBTOTAL, 3
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
  DrawNumber BEGIN_TOTAL_NUMBERS, DISPLAY_TOTAL, 4
  ret
