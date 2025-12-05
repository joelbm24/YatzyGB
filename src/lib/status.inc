; vim: ft=gbasm

status:
.init
  xor a
  ld [SUBTOTAL], a
  ld [TOTAL], a
  ld [TOTAL+1], a
  ldh [DISPLAY_SUBTOTAL], a
  ldh [DISPLAY_SUBTOTAL+1], a
  ldh [DISPLAY_SUBTOTAL+2], a
  ldh [DISPLAY_TOTAL], a
  ldh [DISPLAY_TOTAL+1], a
  ldh [DISPLAY_TOTAL+2], a
  ldh [DISPLAY_TOTAL+3], a
  ret


.decreaseRollCount
  VariableDec ROLL_COUNT
  ret

.updateSubtotal
  xor a
  ld h, a
  ld a, [SUBTOTAL]
  ld l, a
  ld de, DISPLAY_SUBTOTAL
  call getDisplayNumber
  ret

.updateTotal
  ld a, [TOTAL]
  ld h, a
  ld a, [TOTAL+1]
  ld l, a
  ld de, DISPLAY_TOTAL
  call getDisplayNumber
  ret
