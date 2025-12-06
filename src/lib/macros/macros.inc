; vim: ft=gbasm

include "src/lib/macros/variable_ops.inc"

macro CopyMemory ; ToAddr, FromAddr
  ld hl, \1
  ld de, \2
  ld bc, \2.end - \2

.loop\@
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .loop\@
endm

macro EnableVBlankInterrupt
	ld a, IEF_VBLANK
  ld b, a
	ldh [rIE], a
	xor a, a
	ldh [rIF], a
  ei
endm

macro SetAllPalletes; Value
  ld a, \1
  ldh [rBGP], a
  ldh [rOBP0], a
  ldh [rOBP1], a
endm

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

; TODO: Should replace these function calls with jumps
macro CheckStatus ; STATUS, BIT
  ld a, [\1]
  bit \2, a
  call nz, .loadA
  call z, .unloadA
endm


macro DrawDiceSlot ; SLOT_VALUE, DICE_SLOT, BIT
  ld a, [KEPT_DICE]
  ld b, a
  bit \3, b
  ld a, [\1]
  call z, dice.setupDie
  call nz, dice.setupInvertDie
  ld hl, \2
  call dice.copyDiceSlot
endm

macro ResetDisplay
  ld b, a
  xor a
  ld [SCREEN_UPDATE], a
  ld a, b
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
