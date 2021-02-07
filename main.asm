include "hardware.inc"

BEGIN_SLOT_1 equ $99C0
BEGIN_SLOT_2 equ $99C4
BEGIN_SLOT_3 equ $99C8
BEGIN_SLOT_4 equ $99CC
BEGIN_SLOT_5 equ $99D0

section "Header", ROM0[$100]
EntryPoint:
  di
  jp Start

rept $150 - $104
  db 0
endr

section "Scroll", wram0
slot1:
  ds 1

slot2:
  ds 1

section "Game Code", ROM0
Start:
call .waitVBlank
jp .setup

.waitVBlank
  ld a, [rLY]
  cp 144
  jr c, .waitVBlank
  reti

.setup
  xor a
  ld [rLCDC], a
  ld hl, $9000
  ld de, Empty
  ld bc, Dice6TilesEnd - Empty

.copyDiceTiles
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .copyDiceTiles

.drawDice
  ld hl, BEGIN_SLOT_1
  ld de, Dice6MapStart
  call .copyDiceSlot

  ld hl, BEGIN_SLOT_2
  ld de, Dice2MapStart
  call .copyDiceSlot

  ld hl, BEGIN_SLOT_3
  ld de, Dice3MapStart
  call .copyDiceSlot

  ld hl, BEGIN_SLOT_4
  ld de, Dice4MapStart
  call .copyDiceSlot

  ld hl, BEGIN_SLOT_5
  ld de, Dice5MapStart
  call .copyDiceSlot

.initDisplay
  ; Init display Registers
  ld a, %11100100
  ld [rBGP], a
  xor a
  ld [rSCY], a
  ld [rSCX], a

  call .reset
  jp .lockup

.reset
  ; Shutdown
  ld [rNR52], a

  ; Turn screen on, display background
  ld a, %10000001
  ld [rLCDC], a
  reti

.loop
  call .waitVBlank
  call .reset
  dec b
  ld a, b
  cp a, 0
  jr nz, .loop

.lockup
  ; ld hl, rSCX
  ; ld a, [hl]
  ; inc a
  ; ld [hl],a

  ld b, $1a
  jr .loop

.copyDiceSlot
  ld b, 4
  ld c, 4

.copyDiceSlotLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec b
  ld a, b
  cp a, 0
  jr nz, .copyDiceSlotLoop
  dec c
  cp c
  jr z, .diceReturn
  ld a, 28
  ld b, 4

.nextLineLoop
  inc hl
  dec a
  cp a, 0
  jr z, .copyDiceSlotLoop
  jr .nextLineLoop

.diceReturn
  reti

section "Tiles", ROM0
include "assets/dice_tiles.inc"

section "Dice Maps", ROM0
include "assets/dice_maps.inc"