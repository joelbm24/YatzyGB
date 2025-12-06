; vim: ft=gbasm

sounds:
.init
  ld a, %10000000
  ldh [rNR52], a

  ld a, %01110111
  ldh [rNR50], a

  ld a, %11111111
  ldh [rNR51], a
  ret

.ErrorBeep
  ld a, %01000011
  ldh [rNR10], a

  ld a, %10101011
  ldh [rNR11], a

  ld a, %11110110
  ldh [rNR12], a

  ld a, %10011011
  ldh [rNR13], a

  ld a, %11000000
  ldh [rNR14], a
  ret


.SelectBeep
  ld a, %01000011
  ldh [rNR10], a

  ld a, %10101011
  ldh [rNR11], a

  ld a, %11110110
  ldh [rNR12], a

  ld a, %10011011
  ldh [rNR13], a

  ld a, %11000101
  ldh [rNR14], a
  ret

.MoveBeep
  ld a, %01000011
  ldh [rNR10], a

  ld a, %10101011
  ldh [rNR11], a

  ld a, %11110110
  ldh [rNR12], a

  ld a, %11111011
  ldh [rNR13], a

  ld a, %11000101
  ldh [rNR14], a
  ret
