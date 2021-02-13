scorecard:
.changeToCard1
  ld a, 1
  ld [CARD], a

  ld a, [SELECTION]
  add 9
  ld [SELECTION], a

  ld a, [ARROW_MAX_Y]
  add a, 16
  ld [ARROW_MAX_Y], a

  ret

.changeToCard0
  xor a
  ld [CARD], a

  ld a, [ARROW_MAX_Y]
  sub a, 16
  ld [ARROW_MAX_Y], a

  ld a, [SELECTION]
  cp a, 16
  call z, .adjustArrow

  ld a, [SELECTION]
  sub 9
  ld [SELECTION], a

  ret

.adjustArrow
  dec a
  ld [SELECTION], a
  call arrow.up
  ret
