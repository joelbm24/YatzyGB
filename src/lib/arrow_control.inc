; vim: ft=gbasm

arrow_control:
.initialize
  ld hl, _OAMRAM
  ld de, 40*4

.spriteCleanLoop
  xor a
  ld [hl], a
  dec de

  ld a, d
  or e
  ret z
  inc hl
  jp .spriteCleanLoop
  ret

.init:
  ld a, $10
  ld [arrowSprite_Tile], a
  xor a
  ld [arrowSprite_Attr], a
  ret

.setPosition
  ld a, [arrowData_MinX]
  ld [arrowData_XPos], a

  ld a, [arrowData_MinY]
  ld [arrowData_YPos], a
  ret

.jump
  ld a, [arrowData_Direction]
  set 4, a
  ld [arrowData_Direction], a

  ld a, 1
  ld [arrowData_Update], a
  ret

.up
  ld a, [arrowData_Direction]
  set 0, a
  ld [arrowData_Direction], a

  ld a, 1
  ld [arrowData_Update], a
  ret

.down
  ld a, [arrowData_Direction]
  set 1, a
  ld [arrowData_Direction], a

  ld a, 1
  ld [arrowData_Update], a
  ret

.left
  ld a, [arrowData_Direction]
  set 2, a
  ld [arrowData_Direction], a

  ld a, 1
  ld [arrowData_Update], a
  ret

.right
  ld a, [arrowData_Direction]
  set 3, a
  ld [arrowData_Direction], a

  ld a, 1
  ld [arrowData_Update], a
  ret

.move
  ld a, [arrowData_Direction]
  bit 0, a
  call nz, .moveUp

  ld a, [arrowData_Direction]
  bit 1, a
  call nz, .moveDown

  ld a, [arrowData_Direction]
  bit 2, a
  call nz, .moveLeft

  ld a, [arrowData_Direction]
  bit 3, a
  call nz, .moveRight

  ld a, [arrowData_Direction]
  bit 4, a
  call nz, .jumpToLocation

  xor a
  ld [arrowData_Direction], a

  ret

.moveRight
  ld a, [arrowData_XChange]
  ld b, a
  ld a, [arrowData_XPos]
  add a, b
  ld [arrowData_XPos], a
  ret

.moveLeft
  ld a, [arrowData_XChange]
  ld b, a
  ld a, [arrowData_XPos]
  sub a, b
  ld [arrowData_XPos], a
  ret

.moveDown
  ld a, [arrowData_YChange]
  ld b, a
  ld a, [arrowData_YPos]
  add a, b
  ld [arrowData_YPos], a
  ret

.moveUp
  ld a, [arrowData_YChange]
  ld b, a
  ld a, [arrowData_YPos]
  sub a, b
  ld [arrowData_YPos], a
  ret

.jumpToLocation
  ld a, [arrowData_MinX]
  ld [arrowData_XPos], a

  ld a, [arrowData_MinY]
  ld [arrowData_YPos], a
  ret

.draw
  ld a, [arrowData_YPos]
  ld [arrowSprite_YPos], a
  ld a, [arrowData_XPos]
  ld [arrowSprite_XPos], a
