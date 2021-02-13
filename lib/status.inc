status:
.decreaseRollCount
  ld a, [ROLL_COUNT]
  dec a
  ld [ROLL_COUNT], a
  ret

.resetRollCount
  ld a, 3
  ld [ROLL_COUNT], a
  ret

.getNumberTile
  ld de, NumberMap
  ld b, a
  ld a, [de]
  add b
  ret

.drawRollCount
    ld hl, BEGIN_ROLLS+4
    ld a, [ROLL_COUNT]
    call .getNumberTile
    ld [hl], a
    ret