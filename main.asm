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

section "Data", wram0
slotValuesStart:
slot1Value:
  ds 1

slot2Value:
  ds 1

slot3Value:
  ds 1

slot4Value:
  ds 1

slot5Value:
  ds 1
slotValuesEnd:

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
  ld a, 1
  ld [slot1Value], a
  ld a, 3
  ld [slot2Value], a
  ld a, 2
  ld [slot3Value], a
  ld a, 5
  ld [slot4Value], a
  ld a, 6
  ld [slot5Value], a

  xor a
  ld [rLCDC], a
  ld hl, $9000
  ld de, Empty
  ld bc, Dice6TilesEnd - Empty

.copyTiles
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .copyTiles

.drawDice
  ld a, [slot1Value]
  call .setupDie
  ld hl, BEGIN_SLOT_1
  call .copyDiceSlot

  ld a, [slot2Value]
  call .setupDie
  ld hl, BEGIN_SLOT_2
  call .copyDiceSlot

  ld a, [slot3Value]
  call .setupDie
  ld hl, BEGIN_SLOT_3
  call .copyDiceSlot

  ld a, [slot4Value]
  call .setupDie
  ld hl, BEGIN_SLOT_4
  call .copyDiceSlot

  ld a, [slot5Value]
  call .setupDie
  ld hl, BEGIN_SLOT_5
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

.setupDie:
  cp a, 0
  jr z, .setDieTo0
  cp a, 1
  jr z, .setDieTo1
  cp a, 2
  jr z, .setDieTo2
  cp a, 3
  jr z, .setDieTo3
  cp a, 4
  jr z, .setDieTo4
  cp a, 5
  jr z, .setDieTo5
  cp a, 6
  jr z, .setDieTo6

.setDieTo0:
  ld de, Dice0MapStart
  reti

.setDieTo1:
  ld de, Dice1MapStart
  reti

.setDieTo2:
  ld de, Dice2MapStart
  reti

.setDieTo3:
  ld de, Dice3MapStart
  reti

.setDieTo4:
  ld de, Dice4MapStart
  reti

.setDieTo5:
  ld de, Dice5MapStart
  reti

.setDieTo6:
  ld de, Dice6MapStart
  reti

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