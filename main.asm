include "hardware.inc"

BEGIN_SLOT_1 equ $99C0
BEGIN_SLOT_2 equ $99C4
BEGIN_SLOT_3 equ $99C8
BEGIN_SLOT_4 equ $99CC
BEGIN_SLOT_5 equ $99D0

BEGIN_MENU_ROLL equ $980F
BEGIN_MENU_KEEP equ BEGIN_MENU_ROLL+$40
BEGIN_MENU_SCORE equ BEGIN_MENU_KEEP+$40

BEGIN_ONES equ $9801
BEGIN_TWOS equ BEGIN_ONES+$40
BEGIN_THREES equ BEGIN_TWOS+$40
BEGIN_FOURS equ BEGIN_THREES+$40
BEGIN_FIVES equ BEGIN_FOURS+$40
BEGIN_SIXES equ BEGIN_FIVES+$40
BEGIN_BONUS equ BEGIN_SIXES+$40

BEGIN_3KIND equ $9808
BEGIN_4KIND equ BEGIN_3KIND+$40
BEGIN_FULL equ BEGIN_4KIND+$40
BEGIN_SMALL equ BEGIN_FULL+$40
BEGIN_LARGE equ BEGIN_SMALL+$40
BEGIN_YATZY equ BEGIN_LARGE+$40
BEGIN_CHANCE equ BEGIN_YATZY+$40


BEGIN_ROLLS equ $98CE
BEGIN_SUBTOTAL equ BEGIN_ROLLS+$41
BEGIN_TOTAL equ BEGIN_SUBTOTAL+$60

BEGIN_VERTICAL_BORDER1 equ $9800
BEGIN_VERTICAL_BORDER2 equ $9807
BEGIN_VERTICAL_BORDER3 equ $980E
BEGIN_VERTICAL_BORDER4 equ $9813

BEGIN_HORIZONTAL_BORDER1 EQU $99A0
BEGIN_HORIZONTAL_BORDER2 EQU $98AF

JUNC1 equ $99A0
JUNC2 equ $99A7
JUNC3 equ $99AE
JUNC4 equ $99B3
JUNC5 equ $98AE
JUNC6 equ $98B3

MENU_Y_MIN equ $10
MENU_Y_MAX equ $30

MENU_X_MIN equ $80
MENU_X_MAX equ $80

_ARROW_Y     EQU     _OAMRAM
_ARROW_X     EQU     _OAMRAM+1
_ARROW_NUM   EQU     _OAMRAM+2
_ARROW_ATT   EQU     _OAMRAM+3

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

_PAD:
  ds 1

_PAD_PRESSED:
  ds 1

ARROW_MIN_Y:
  ds 1

ARROW_MAX_Y:
  ds 1

ARROW_MIN_X:
  ds 1

ARROW_MAX_X:
  ds 1

section "Game Code", ROM0
Start:
call turnOffLCD

.initDisplay
  ; Init display Registers
  ld a, %11100100
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  xor a
  ld [rSCY], a
  ld [rSCX], a

jp .setup

.waitVBlank
  ld a, [rLY]
  cp 144
  jr c, .waitVBlank
  ret

.copyTiles
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .copyTiles
  ret

.setup
  call resetPress

  ld a, 1
  ld [slot1Value], a
  ld a, 2
  ld [slot2Value], a
  ld a, 3
  ld [slot3Value], a
  ld a, 4
  ld [slot4Value], a
  ld a, 5
  ld [slot5Value], a

  xor a
  ld [rLCDC], a
  ld hl, $8000
  ld de, TilesStart
  ld bc, TilesEnd - TilesStart
  call .copyTiles

  ; xor a
  ; ld [rLCDC], a
  ; ld hl, _VRAM
  ; ld de, ArrowTile
  ; ld bc, ArrowTileEnd - ArrowTile
  ; call .copyTiles

.drawMenu
  ld de, RollMapStart
  ld hl, BEGIN_MENU_ROLL
  call drawTextTiles


  ld de, KeepMapStart
  ld hl, BEGIN_MENU_KEEP
  call drawTextTiles


  ld de, ScoreMapStart
  ld hl, BEGIN_MENU_SCORE
  call drawTextTiles

.drawUpperCard
  ld de, OnesMapStart
  ld hl, BEGIN_ONES
  call drawTextTiles

  ld de, TwosMapStart
  ld hl, BEGIN_TWOS
  call drawTextTiles

  ld de, ThreesMapStart
  ld hl, BEGIN_THREES
  call drawTextTiles

  ld de, FoursMapStart
  ld hl, BEGIN_FOURS
  call drawTextTiles

  ld de, FivesMapStart
  ld hl, BEGIN_FIVES
  call drawTextTiles

  ld de, SixesMapStart
  ld hl, BEGIN_SIXES
  call drawTextTiles

  ld de, BonusMapStart
  ld hl, BEGIN_BONUS
  call drawTextTiles

.drawLowerCard
  ld de, ThreeKindMapStart
  ld hl, BEGIN_3KIND
  call drawTextTiles

  ld de, FourKindMapStart
  ld hl, BEGIN_4KIND
  call drawTextTiles

  ld de, FullMapStart
  ld hl, BEGIN_FULL
  call drawTextTiles

  ld de, SmallMapStart
  ld hl, BEGIN_SMALL
  call drawTextTiles

    ld de, LargeMapStart
  ld hl, BEGIN_LARGE
  call drawTextTiles

  ld de, YatzyMapStart
  ld hl, BEGIN_YATZY
  call drawTextTiles

  ld de, ChanceMapStart
  ld hl, BEGIN_CHANCE
  call drawTextTiles

.drawInfo
  ld de, RollsMapStart
  ld hl, BEGIN_ROLLS
  call drawTextTiles

  ld de, SubtotalMapStart
  ld hl, BEGIN_SUBTOTAL
  call drawTextTiles

  ld de, TotalMapStart
  ld hl, BEGIN_TOTAL
  call drawTextTiles

.drawBorder
  ld de, VerticalBorderMapStart
  ld hl, BEGIN_VERTICAL_BORDER1
  ld b, 13
  call .drawVerticalBorder

  ld de, VerticalBorderMapStart
  ld hl, BEGIN_VERTICAL_BORDER2
  ld b, 13
  call .drawVerticalBorder

  ld de, VerticalBorderMapStart
  ld hl, BEGIN_VERTICAL_BORDER3
  ld b, 13
  call .drawVerticalBorder

  ld de, VerticalBorderMapStart
  ld hl, BEGIN_VERTICAL_BORDER4 
  ld b, 13
  call .drawVerticalBorder

  ld de, HorizontalBorderMapStart
  ld hl, BEGIN_HORIZONTAL_BORDER1
  ld b, 20
  call .drawHorizontalBorder

  ld de, HorizontalBorderMapStart
  ld hl, BEGIN_HORIZONTAL_BORDER2
  ld b, 4
  call .drawHorizontalBorder

  ld de, JunctionBLMapStart
  ld hl, JUNC1
  ld a, [de]
  ld [hl], a

  ld de, JunctionBMapStart
  ld hl, JUNC2
  ld a, [de]
  ld [hl], a

  ld de, JunctionBMapStart
  ld hl, JUNC3
  ld a, [de]
  ld [hl], a

  ld de, JunctionBRMapStart
  ld hl, JUNC4
  ld a, [de]
  ld [hl], a

  ld de, JunctionLMapStart
  ld hl, JUNC5
  ld a, [de]
  ld [hl], a

  ld de, JunctionRMapStart
  ld hl, JUNC6
  ld a, [de]
  ld [hl], a

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

.startSpriteClean
    call turnOffLCD
 
    ld hl, _OAMRAM
    ld de, 40*4

.spriteCleanLoop
    ld a, 0
    ld [hl], a
    dec de

    ld a, d
    or e
    jp z, .setupArrow
    inc hl
    jp .spriteCleanLoop

.setupArrow
  call setMenuCursorConstraints

  ld a, [ARROW_MIN_Y]
  ld [_ARROW_Y], a

  ld a, [ARROW_MIN_X]
  ld [_ARROW_X], a
  ld a, $5E
  ld [_ARROW_NUM], a
  ld a, 0
  ld [_ARROW_ATT], a
  call .reset

.main
  jp input

.reset
  call turnOffLCD
  ld [rNR52], a

  ld a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON
  ld [rLCDC], a
  reti

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

.drawVerticalBorder
  ld a, [de]
  ld [hli], a
  dec b
  ld a, b
  cp a, 0
  jr z, .vBorderReturn
  ld a, 31

.nextBorderLineLoop
  inc hl
  dec a
  cp a, 0
  jr z, .drawVerticalBorder
  jr .nextBorderLineLoop

.vBorderReturn
  reti

.drawHorizontalBorder
  ld a, [de]
  ld [hli], a
  dec b
  ld a, b
  cp a, 0
  jr z, .vBorderReturn
  jr .drawHorizontalBorder

setMenuCursorConstraints:
  ld a, MENU_Y_MIN
  ld [ARROW_MIN_Y], a
  ld a, MENU_Y_MAX
  ld [ARROW_MAX_Y], a

  ld a, MENU_X_MIN
  ld [ARROW_MIN_X], a
  ld a, MENU_X_MAX
  ld [ARROW_MAX_X], a
  ret

read_pad:
    ld      a, %00100000
    ld      [rP1], a
 
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
 
    and     $0F
    swap    a
    ld      b, a
 
    ld      a, %00010000
    ld      [rP1], a
 
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
    ld      a, [rP1]
 
    and     $0F
    or      b

    cpl
    ld      [_PAD], a
    ret

oneDice:
  ld a, 1
  ld [slot1Value], a
  ld a, 1
  ld [slot2Value], a
  ld a, 1
  ld [slot3Value], a
  ld a, 1
  ld [slot4Value], a
  ld a, 1
  ld [slot5Value], a
  call changeDice
  ret

resetDice:
  ld a, 0
  ld [slot1Value], a
  ld a, 0
  ld [slot2Value], a
  ld a, 0
  ld [slot3Value], a
  ld a, 0
  ld [slot4Value], a
  ld a, 0
  ld [slot5Value], a
  call changeDice
  ret

changeDice:
  call Start.waitVBlank
  ld a, [slot1Value]
  call Start.setupDie
  ld hl, BEGIN_SLOT_1
  call Start.copyDiceSlot

  call Start.waitVBlank
  ld a, [slot2Value]
  call Start.setupDie
  ld hl, BEGIN_SLOT_2
  call Start.copyDiceSlot

  call Start.waitVBlank
  ld a, [slot3Value]
  call Start.setupDie
  ld hl, BEGIN_SLOT_3
  call Start.copyDiceSlot

  call Start.waitVBlank
  ld a, [slot4Value]
  call Start.setupDie
  ld hl, BEGIN_SLOT_4
  call Start.copyDiceSlot

  call Start.waitVBlank
  ld a, [slot5Value]
  call Start.setupDie
  ld hl, BEGIN_SLOT_5
  call Start.copyDiceSlot

  call Start.reset
  ret

moveArrowUp:
  call setPress

  ld a, [ARROW_MIN_Y]
  ld b, a
  ld a, [_ARROW_Y]
  cp a, b

  jp z, inputReturn

  ld a, [_ARROW_Y]
  sub a, 16
  ld [_ARROW_Y],a
  ret

moveArrowDown:
  call setPress
  ld a, [ARROW_MAX_Y]
  ld b, a
  ld a, [_ARROW_Y]
  cp a, b

  jp z, inputReturn

  ld a, [_ARROW_Y]
  add a, 16
  ld [_ARROW_Y],a
  ret

moveArrowLeft:
  call setPress
  ld a, [ARROW_MIN_X]
  ld b, a
  ld a, [_ARROW_X]
  cp a, b

  jp z, inputReturn

  ld a, [_ARROW_X]
  sub a, 64
  ld [_ARROW_X],a
  ret

moveArrowRight:
  call setPress
  ld a, [ARROW_MAX_X]
  ld b, a
  ld a, [_ARROW_X]
  cp a, b

  jp z, inputReturn

  ld a, [_ARROW_X]
  add a, 64
  ld [_ARROW_X],a
  ret

inputReturn:
  ret

setPress:
  ld a, $01
  ld [_PAD_PRESSED], a
  ret

resetPress:
  ld a, $00
  ld [_PAD_PRESSED], a
  ret

input:
	call	read_pad
  call Start.waitVBlank

  ; wait til button is released
  ld		a, [_PAD]
	cp 0
  call z, resetPress

  ld a, [_PAD_PRESSED]
  cp a, 1
  jp z, input

  ; up
  ld		a, [_PAD]
	and    		%01000000
	call		nz, moveArrowUp

  ; down
	ld		a, [_PAD]
	and		%10000000
	call		nz, moveArrowDown

  ; left
 	ld		a, [_PAD]
	and    		%00100000
	call		nz, moveArrowLeft

  ; right
  ld		a, [_PAD]
	and    		%00010000
	call		nz, moveArrowRight

  ; A
  ld		a, [_PAD]
	and    		%00000010
	call		nz, resetDice

  ; B
  ld		a, [_PAD]
	and    		%00000001
	call		nz, resetDice

  ; Start
  ld		a, [_PAD]
	and    		%00001000
	call		nz, resetDice

  jr input

turnOffLCD:
    ld a,[rLCDC]
    rlca
    ret nc 
 
 
.waitVBlank
    ld a, [rLY]
    cp 145
    jr nz, .waitVBlank
 
    ld a,[rLCDC]
    res 7,a
    ld [rLCDC],a
    ret

slowdown:
.delay:
	dec bc
	ld a, b
	or c
	jr z, .end_delay
	nop
	jr .delay

.end_delay:
	ret

drawTextTiles:
  ld a, [de]
  ld [hli], a
  inc de
  ld a, [de]
  ld [hli], a
  inc de
  ld a, [de]
  ld [hli], a
  inc de
  ld a, [de]
  ld [hli], a
  inc de
  ret

section "Tiles", ROM0
TilesStart:
include "assets/dice_tiles.inc"
TilesEnd:

section "Dice Maps", ROM0
include "assets/dice_maps.inc"