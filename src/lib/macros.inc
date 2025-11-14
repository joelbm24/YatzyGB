; vim: ft=gbasm

macro DrawNumber ; TO_AREA, TILES_START, AMOUNT
  ld hl, \1
  FOR N, \3-1, 0, -1
    ld a, [\2+{d:N}]
    add NUMBER_ZERO_TILE
    ld [hli], a
  ENDR
    ld a, [\2]
    add NUMBER_ZERO_TILE
    ld [hl], a
endm

; TODO: HL might be the better register for this.
macro ChangeCardNumber ; DISPLAY_TILES
  ld de, \1+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
endm

macro UpdateCardNumber ; POSSIBLE, DISPLAY_TILES
  xor a
  ld h, 0
  ld a, [\1]
  ld l, a
  ld de, \2
  call getDisplayNumber
endm

macro DrawRollCount
  DrawNumber BEGIN_ROLLS_NUMBER, ROLL_COUNT, 1
endm

macro DrawTotal
  DrawNumber BEGIN_TOTAL_NUMBERS, DISPLAY_TOTAL, 4
endm

macro DrawSubtotal
  DrawNumber BEGIN_SUBTOTAL_NUMBERS, DISPLAY_SUBTOTAL, 3
endm
