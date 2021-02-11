include "hardware.inc"
include "constants.inc"

section "Header", ROM0[$100]
EntryPoint:
  di
  jp Start

rept $150 - $104
  db 0
endr

section "Data", wram0
include "variables.inc"

section "Game Code", ROM0
Start:
ld a, 0
ld [SELECTION], a
ld [MENU], a
ld [KEPT_DICE], a
ld [_PAD_PRESSED], a

call turnOffLCD
call initSound

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


.setup
  ld a, 0
  ld [slot1Value], a
  ld [slot2Value], a
  ld [slot3Value], a
  ld [slot4Value], a
  ld [slot5Value], a

  xor a
  ld [rLCDC], a
  ld hl, $8000
  ld de, TilesStart
  ld bc, TilesEnd - TilesStart

  ld a, TACF_START
  ld [rTAC], a
  ld a, [rDIV]
  ld [Seed], a
  ld a, [rDIV]
  ld [Seed+1], a
  ld a, [rDIV]
  ld [Seed+2], a

.copyTiles
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .copyTiles

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
  ld b, 20
  call .drawHorizontalBorder

  ld de, HorizontalBorderMapStart
  ld hl, BEGIN_HORIZONTAL_BORDER3
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

  ld de, JunctionTLMapStart
  ld hl, JUNC7
  ld a, [de]
  ld [hl], a

  ld de, JunctionTMapStart
  ld hl, JUNC8
  ld a, [de]
  ld [hl], a

  ld de, JunctionTMapStart
  ld hl, JUNC9
  ld a, [de]
  ld [hl], a

  ld de, JunctionTRMapStart
  ld hl, JUNC10
  ld a, [de]
  ld [hl], a

.drawDice
  call changeDice

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
  ld a, [ArrowMapStart]
  ld [_ARROW_NUM], a
  ld a, 0
  ld [_ARROW_ATT], a
  call .reset

.main
  jp input

.reset
  call turnOffLCD

  ld a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON
  ld [rLCDC], a
  ret

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

  ld a, MENU_X_CHANGE
  ld [ARROW_X_CHANGE], a

  ld a, MENU_Y_CHANGE
  ld [ARROW_Y_CHANGE], a

  ret

setKeepConstraints:
  ld a, DICE_Y_MIN
  ld [ARROW_MIN_Y], a
  ld a, DICE_Y_MAX
  ld [ARROW_MAX_Y], a

  ld a, DICE_X_MIN
  ld [ARROW_MIN_X], a
  ld a, DICE_X_MAX
  ld [ARROW_MAX_X], a

  ld a, DICE_X_CHANGE
  ld [ARROW_X_CHANGE], a

  ld a, DICE_Y_CHANGE
  ld [ARROW_Y_CHANGE], a

  ret

setCardConstraints:
  ld a, CARD_Y_MIN
  ld [ARROW_MIN_Y], a
  ld a, CARD_Y_MAX
  ld [ARROW_MAX_Y], a

  ld a, CARD_X_MIN
  ld [ARROW_MIN_X], a
  ld a, CARD_X_MAX
  ld [ARROW_MAX_X], a

  ld a, CARD_X_CHANGE
  ld [ARROW_X_CHANGE], a

  ld a, CARD_Y_CHANGE
  ld [ARROW_Y_CHANGE], a

  ret

incMenuSelection:
  ld a, [SELECTION]
  inc a
  ld [SELECTION], a
  ret

decMenuSelection:
  ld a, [SELECTION]
  dec a
  ld [SELECTION], a
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

resetDice:
  ld a, 0
  
  ld [slot1Value], a
  call changeDice.drawDiceSlot1
  ld [slot2Value], a
  call changeDice.drawDiceSlot1
  ld [slot3Value], a
  call changeDice.drawDiceSlot1
  ld [slot4Value], a
  call changeDice.drawDiceSlot1
  ld [slot5Value], a
  call changeDice.drawDiceSlot1

  ld [KEPT_DICE], a

  call changeDice
  call changeDice
  call changeDice
  call changeDice

  ret

changeDice:
  call .drawDiceSlot1
  call .drawDiceSlot2
  call .drawDiceSlot3
  call .drawDiceSlot4
  call .drawDiceSlot5
  ret

.drawDiceSlot1
  ld a, [KEPT_DICE]
  ld b, a
  ld a, [slot1Value]
  bit 0, b
  call z, .setupDie
  call nz, .setupInvertDie
  ld hl, BEGIN_SLOT_1
  call .copyDiceSlot
  ret

.drawDiceSlot2
  ld a, [KEPT_DICE]
  ld b, a
  ld a, [slot2Value]
  bit 1, b
  call z, .setupDie
  call nz, .setupInvertDie
  ld hl, BEGIN_SLOT_2
  call .copyDiceSlot
  ret

.drawDiceSlot3
  ld a, [KEPT_DICE]
  ld b, a
  bit 2, b
  ld a, [slot3Value]
  call z, .setupDie
  call nz, .setupInvertDie
  ld hl, BEGIN_SLOT_3
  call .copyDiceSlot
  ret

.drawDiceSlot4
  ld a, [KEPT_DICE]
  ld b, a
  bit 3, b
  ld a, [slot4Value]
  call z, .setupDie
  call nz, .setupInvertDie
  ld hl, BEGIN_SLOT_4
  call .copyDiceSlot
  ret

.drawDiceSlot5
  ld a, [KEPT_DICE]
  ld b, a
  bit 4, b
  ld a, [slot5Value]
  call z, .setupDie
  call nz, .setupInvertDie
  ld hl, BEGIN_SLOT_5
  call .copyDiceSlot
  ret

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

.setupInvertDie:
  cp a, 1
  jr z, .setDieToInvert1
  cp a, 2
  jr z, .setDieToInvert2
  cp a, 3
  jr z, .setDieToInvert3
  cp a, 4
  jr z, .setDieToInvert4
  cp a, 5
  jr z, .setDieToInvert5
  cp a, 6
  jr z, .setDieToInvert6

.setDieTo0:
  ld de, Dice0MapStart
  ret

.setDieTo1:
  ld de, Dice1MapStart
  ret

.setDieToInvert1
  ld de, InvertDice1MapStart
  ret

.setDieTo2:
  ld de, Dice2MapStart
  ret

.setDieToInvert2
  ld de, InvertDice2MapStart
  ret

.setDieTo3:
  ld de, Dice3MapStart
  ret

.setDieToInvert3
  ld de, InvertDice3MapStart
  ret

.setDieTo4:
  ld de, Dice4MapStart
  ret

.setDieToInvert4
  ld de, InvertDice4MapStart
  ret

.setDieTo5:
  ld de, Dice5MapStart
  ret

.setDieToInvert5
  ld de, InvertDice5MapStart
  ret

.setDieTo6:
  ld de, Dice6MapStart
  ret

.setDieToInvert6
  ld de, InvertDice6MapStart
  ret

.changeSlot1
  ld b, a
  ld a, [KEPT_DICE]
  bit 0, a
  ret nz

  ld a, b
  ld [slot1Value], a
  ret

.changeSlot2
  ld b, a
  ld a, [KEPT_DICE]
  bit 1, a
  ret nz

  ld a, b
  ld [slot2Value], a
  ret

.changeSlot3
  ld b, a
  ld a, [KEPT_DICE]
  bit 2, a
  ret nz

  ld a, b
  ld [slot3Value], a
  ret

.changeSlot4
  ld b, a
  ld a, [KEPT_DICE]
  bit 3, a
  ret nz

  ld a, b
  ld [slot4Value], a
  ret

.changeSlot5
  ld b, a
  ld a, [KEPT_DICE]
  bit 4, a
  ret nz

  ld a, b
  ld [slot5Value], a
  ret

.copyDiceSlot
  ld b, 3
  ld c, 3

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
  ld a, 29
  ld b, 3

.nextLineLoop
  inc hl
  dec a
  cp a, 0
  jr z, .copyDiceSlotLoop
  jr .nextLineLoop

.diceReturn
  ret

select:
  call setPress
  call SelectBeep

  ld a, [MENU]
  cp a, 0
  call z, changeMenu

  cp a, 1
  call z, selectDie

  ret

changeMenu:
  ld a, [SELECTION]
  cp a, 0
  call z, roll

  ld a, [SELECTION]
  cp a, 1
  call z, selectKeep

  ld a, [SELECTION]
  cp a, 2
  call z, selectCard
  ret

roll:
  ld a, [RN]
  call changeDice.changeSlot1
  call changeDice.drawDiceSlot1
  
  ld a, [RN+1]
  call changeDice.changeSlot2
  call changeDice.drawDiceSlot2

  ld a, [RN+2]
  call changeDice.changeSlot3
  call changeDice.drawDiceSlot3

  ld a, [RN+3]
  call changeDice.changeSlot4
  call changeDice.drawDiceSlot4

  ld a, [RN+4]
  call changeDice.changeSlot5
  call changeDice.drawDiceSlot5

  call changeDice
  call changeDice
  call changeDice
  ret

selectCard:
  ld a, 2
  ld [MENU], a

  ld a, 0
  ld [SELECTION], a

  call setCardConstraints

  call setCursor
  ret

selectDie:
  ld a, [SELECTION]
  cp a, 0
  jr z, .selectSlot1

  ld a, [SELECTION]
  cp a, 1
  jr z, .selectSlot2

  ld a, [SELECTION]
  cp a, 2
  jr z, .selectSlot3

  ld a, [SELECTION]
  cp a, 3
  jr z, .selectSlot4

  ld a, [SELECTION]
  cp a, 4
  jr z, .selectSlot5

.selectSlot1
  ld b, 0
  set 0, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  call changeDice.drawDiceSlot1
  ret

.selectSlot2
  ld b, 0
  set 1, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  call changeDice.drawDiceSlot2
  ret

.selectSlot3
  ld b, 0
  set 2, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  call changeDice.drawDiceSlot3
  ret

.selectSlot4
  ld b, 0
  set 3, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  call changeDice.drawDiceSlot4
  ret

.selectSlot5
  ld b, 0
  set 4, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  call changeDice.drawDiceSlot5
  ret

selectKeep:
  ld a, 1
  ld [MENU], a

  ld a, 0
  ld [SELECTION], a

  call setKeepConstraints

  call setCursor

  ret

changeToMainMenu:
  call setPress

  ld a, 0
  ld [SELECTION], a
  ld a, 0
  ld [MENU], a

  call setMenuCursorConstraints
  call setCursor
  ret


moveArrowUp:
  call setPress

  ld a, [ARROW_MIN_Y]
  ld b, a
  ld a, [_ARROW_Y]
  cp a, b

  call z, ErrorBeep
  jp z, inputReturn

  call Beep
  call decMenuSelection

  ld a, [ARROW_Y_CHANGE]
  ld b, a
  ld a, [_ARROW_Y]
  sub a, b
  ld [_ARROW_Y],a
  ret

moveArrowDown:
  call setPress
  ld a, [ARROW_MAX_Y]
  ld b, a
  ld a, [_ARROW_Y]
  cp a, b
  call z, ErrorBeep
  jp z, inputReturn

  call Beep
  call incMenuSelection

  ld a, [ARROW_Y_CHANGE]
  ld b, a
  ld a, [_ARROW_Y]
  add a, b
  ld [_ARROW_Y],a
  ret

moveArrowLeft:
  call setPress
  ld a, [ARROW_MIN_X]
  ld b, a
  ld a, [_ARROW_X]
  cp a, b

  call z, ErrorBeep
  jp z, inputReturn

  call Beep
  call decMenuSelection

  ld a, [ARROW_X_CHANGE]
  ld b, a
  ld a, [_ARROW_X]
  sub a, b
  ld [_ARROW_X],a
  ret

moveArrowRight:
  call setPress
  ld a, [ARROW_MAX_X]
  ld b, a
  ld a, [_ARROW_X]
  cp a, b

  call z, ErrorBeep
  jp z, inputReturn

  call Beep
  call incMenuSelection

  ld a, [ARROW_X_CHANGE]
  ld b, a
  ld a, [_ARROW_X]
  add a, b
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
  call Reseed
  call setRandomNumbers

  call Start.waitVBlank


  ; wait til button is released
  ld a, [_PAD]
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

  ; B
  ld		a, [_PAD]
	and    		%00000010
	call		nz, changeToMainMenu

  ; A
  ld		a, [_PAD]
	and    		%00000001
	call		nz, select

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
  jr turnOffLCD

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

setCursor:
  ld a, [ARROW_MIN_X]
  ld [_ARROW_X], a

  ld a, [ARROW_MIN_Y]
  ld [_ARROW_Y], a
  
  ld a, [ArrowMapStart]
  ld [_ARROW_NUM], a
  ld a, 0
  ld [_ARROW_ATT], a
  ret

initSound:
  ld a, %10000000
  ld [rNR52], a

  ld a, %01110111
  ld [rNR50], a

  ld a, %11111111
  ld [rNR51], a
  ret

ErrorBeep:
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


SelectBeep:
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

Beep:
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

setRandomNumbers:
  call RandomNumber
  ld [RN], a
  
  call RandomNumber
  ld [RN+1], a

  call RandomNumber
  ld [RN+2], a

  call RandomNumber
  ld [RN+3], a

  call RandomNumber
  ld [RN+4], a


Reseed:
  ld a, [rDIV]
  ld [Seed], a
  ld a, [rTIMA]
  ld [Seed+1], a
  ld a, [rDIV]
  ld b, a
  ld a, [rTIMA]
  xor b
  ld [Seed+2], a
  ret

RandomNumber:
  ld      hl,Seed
  ld      a,[hl+]
  sra     a
  sra     a
  sra     a
  xor     [hl]
  inc     hl
  rra
  rl      [hl]
  dec     hl
  rl      [hl]
  dec     hl
  rl      [hl]
  ld      a,[rDIV]

.randomness:
  add [hl]
  call mod6
  ld a, c
  ret

mod6:
  ld b, a
  ld c, 0

.loop
  dec b
  inc c
  ld a, 6
  cp a, c
  call z, .resetC

  ld a, 0
  cp a, b
  jr nz, .loop

  inc c
  ret

.resetC
  ld c, 0
  ret

ScoreDice:

; load value you want to count into A
.countValue


section "Tiles", ROM0
TilesStart:
include "assets/dice_tiles.inc"
TilesEnd:

section "Maps", ROM0
include "assets/dice_maps.inc"