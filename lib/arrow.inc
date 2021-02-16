arrow:
.initialize
  ld hl, _OAMRAM
  ld de, 40*4

.spriteCleanLoop
  ld a, 0
  ld [hl], a
  dec de

  ld a, d
  or e
  ret z
  inc hl
  jp .spriteCleanLoop
  ret

.setPosition
  ld a, [ARROW_MIN_X]
  ld [_ARROW_X], a
  ld [ARROW_X], a

  ld a, [ARROW_MIN_Y]
  ld [_ARROW_Y], a
  ld [ARROW_Y], a
  
  ld a, [ArrowMapStart]
  ld [_ARROW_NUM], a
  ld a, 0
  ld [_ARROW_ATT], a
  ret

.jump
  ld a, [ARROW_DIRECTION]
  set 4, a
  ld [ARROW_DIRECTION], a

  ld a, 1
  ld [ARROW_UPDATE], a
  ret

.up
  ld a, [ARROW_DIRECTION]
  set 0, a
  ld [ARROW_DIRECTION], a

  ld a, 1
  ld [ARROW_UPDATE], a
  ret

.down
  ld a, [ARROW_DIRECTION]
  set 1, a
  ld [ARROW_DIRECTION], a

  ld a, 1
  ld [ARROW_UPDATE], a
  ret

.left
  ld a, [ARROW_DIRECTION]
  set 2, a
  ld [ARROW_DIRECTION], a

  ld a, 1
  ld [ARROW_UPDATE], a
  ret

.right
  ld a, [ARROW_DIRECTION]
  set 3, a
  ld [ARROW_DIRECTION], a

  ld a, 1
  ld [ARROW_UPDATE], a
  ret

.move
  ld a, [ARROW_DIRECTION]
  bit 0, a
  call nz, .moveUp

  ld a, [ARROW_DIRECTION]
  bit 1, a
  call nz, .moveDown

  ld a, [ARROW_DIRECTION]
  bit 2, a
  call nz, .moveLeft

  ld a, [ARROW_DIRECTION]
  bit 3, a
  call nz, .moveRight

  ld a, [ARROW_DIRECTION]
  bit 4, a
  call nz, .jumpToLocation

  xor a
  ld [ARROW_DIRECTION], a

  ret

.moveRight
  ld a, [ARROW_X_CHANGE]
  ld b, a
  ld a, [_ARROW_X]
  add a, b
  ld [_ARROW_X],a
  ld [ARROW_X], a
  ret

.moveLeft
  ld a, [ARROW_X_CHANGE]
  ld b, a
  ld a, [ARROW_X]
  sub a, b
  ld [_ARROW_X],a
  ld [ARROW_X], a
  ret

.moveDown
  ld a, [ARROW_Y_CHANGE]
  ld b, a
  ld a, [ARROW_Y]
  add a, b
  ld [_ARROW_Y],a
  ld [ARROW_Y], a
  ret

.moveUp
  ld a, [ARROW_Y_CHANGE]
  ld b, a
  ld a, [ARROW_Y]
  sub a, b
  ld [_ARROW_Y],a
  ld [ARROW_Y], a
  ret

.jumpToLocation
  ld a, [ARROW_MIN_X]
  ld [_ARROW_X], a
  ld [ARROW_X], a

  ld a, [ARROW_MIN_Y]
  ld [_ARROW_Y], a
  ld [ARROW_Y], a
  ret

.draw
  ld a, [ARROW_Y]
  ld [_ARROW_Y], a

  ld a, [ARROW_X]
  ld [_ARROW_X], a