; vim: ft=gbasm

sounds:
.init
  ld a, %10000000
  ld [rNR52], a

  ld a, %01110111
  ld [rNR50], a

  ld a, %11111111
  ld [rNR51], a
  ret

.ErrorBeep
  ld a, %01000011
  ld [rNR10], a

  ld a, %10101011
  ld [rNR11], a

  ld a, %11110110
  ld [rNR12], a

  ld a, %10011011
  ld [rNR13], a

  ld a, %11000000
  ld [rNR14], a
  ret


.SelectBeep
  ld a, %01000011
  ld [rNR10], a

  ld a, %10101011
  ld [rNR11], a

  ld a, %11110110
  ld [rNR12], a

  ld a, %10011011
  ld [rNR13], a

  ld a, %11000101
  ld [rNR14], a
  ret

.MoveBeep
  ld a, %01000011
  ld [rNR10], a

  ld a, %10101011
  ld [rNR11], a

  ld a, %11110110
  ld [rNR12], a

  ld a, %11111011
  ld [rNR13], a

  ld a, %11000101
  ld [rNR14], a
  ret
