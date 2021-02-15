include "lib/hardware.inc"
include "lib/constants.inc"

section "Header", ROM0[$100]
EntryPoint:
  di
  jp Start

rept $150 - $104
  db 0
endr

section "Data", wram0
include "lib/variables.inc"

section "Game Code", ROM0
Start:
xor a
ld [SELECTION], a
ld [MENU], a
ld [KEPT_DICE], a
ld [_PAD_PRESSED], a
ld [CARD], a
call status.init
call scorecard.init

.initDisplay
  ; Init display Registers
  ld a, %11100100
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  xor a
  ld [rSCY], a
  ld [rSCX], a

.setup
  ld a, 3
  ld [ROLL_COUNT], a

  ld a, 1
  ld [DISABLE_KEEP_SCORE], a

  xor a
  ld [slot1Value], a
  ld [slot2Value], a
  ld [slot3Value], a
  ld [slot4Value], a
  ld [slot5Value], a

  ld a, TACF_START
  ld [rTAC], a
  ld a, [rDIV]
  ld [Seed], a
  ld a, [rDIV]
  ld [Seed+1], a
  ld a, [rDIV]
  ld [Seed+2], a

  call LCDControl.waitVBlank
  call LCDControl.turnOff
  

.copyTiles
  ld hl, $8000
  ld de, TilesStart
  ld bc, TilesEnd - TilesStart

.copyTilesLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .copyTilesLoop

.drawGameScreen
  ld hl, _SCRN0
  ld de, GameScreenMap
  ld bc, GameScreenEnd - GameScreenMap

.drawTilesLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .drawTilesLoop

.main
  call sounds.init
  call setMenuCursorConstraints
  call arrow.initialize
  call arrow.setPosition
  call arrow.jump
  call LCDControl.turnOn

  jp input

include "lib/arrow.inc"
include "lib/lcd_control.inc"
include "lib/dice.inc"
include "lib/sounds.inc"
include "lib/status.inc"
include "lib/scorecard.inc"
include "lib/calc_score.inc"

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

changeScoreCard:
  ret

select:
  call setPress

  ld a, [MENU]
  cp a, 0
  call z, changeMenu
  ret z

  ld a, [MENU]
  cp a, 1
  call z, selectDie

  ld a, [MENU]
  cp a, 2
  call z, selectCategory

  ret

changeMenu:
  call sounds.SelectBeep
  
  ld a, [SELECTION]
  cp a, 0
  call z, roll
  ret z

  ld a, [DISABLE_KEEP_SCORE]
  cp a, 1
  call z, sounds.ErrorBeep
  ret z

  ld a, [SELECTION]
  cp a, 1
  call z, selectKeep
  ret z

  ld a, [SELECTION]
  cp a, 2
  call z, selectCard
  ret z

  ret

roll:
  call calcScore.calcPossibleScore
  call scorecard.update
  call status.decreaseRollCount
  call enableKeepScore

  ld a, [RN]
  call changeDice.changeSlot1
  ld a, [RN+1]
  call changeDice.changeSlot2
  ld a, [RN+2]
  call changeDice.changeSlot3
  ld a, [RN+3]
  call changeDice.changeSlot4
  ld a, [RN+4]
  call changeDice.changeSlot5

  ld a, [ROLL_COUNT]
  cp a, 0
  call z, selectCard

  ret

selectCard:
  ld a, 2
  ld [MENU], a

  ld a, 0
  ld [SELECTION], a

  call disableBack
  call setCardConstraints
  call arrow.jump
  ret

selectCategory:
  call scorecard.check
  ld a, b
  cp a, 1
  call z, sounds.ErrorBeep
  ret z

  call sounds.SelectBeep
  call scorecard.setScore
  call enableBack
  call scorecard.clear
  call disableKeepScore
  call changeDice.resetDice
  call status.resetRollCount
  call changeToMainMenu
  ret

selectDie:
  call sounds.SelectBeep

  ld a, [SELECTION]
  cp a, 0
  call z, changeDice.selectSlot1

  ld a, [SELECTION]
  cp a, 1
  call z, changeDice.selectSlot2

  ld a, [SELECTION]
  cp a, 2
  call z, changeDice.selectSlot3

  ld a, [SELECTION]
  cp a, 3
  call z, changeDice.selectSlot4

  ld a, [SELECTION]
  cp a, 4
  call z, changeDice.selectSlot5
  ret

selectKeep:
  ld a, 1
  ld [MENU], a

  ld a, 0
  ld [SELECTION], a

  call setKeepConstraints
  call arrow.jump

  ret

goBack:
  call setPress

  ld a, [NO_BACK]
  cp a, 1
  call z, sounds.ErrorBeep
  ret z

  ld a, [MENU]
  cp a, 1
  call z, changeToMainMenu
  call z, enableKeepScore
  ret

changeToMainMenu:
  ld a, 0
  ld [SELECTION], a
  ld a, 0
  ld [MENU], a

  call setMenuCursorConstraints
  call arrow.jump
  ret

enableBack:
  ld a, 0
  ld [NO_BACK], a
  ret

disableBack:
  ld a, 1
  ld [NO_BACK], a
  ret

enableKeepScore:
  ld a, 0
  ld [DISABLE_KEEP_SCORE], a
  ret

disableKeepScore:
  ld a, 1
  ld [DISABLE_KEEP_SCORE], a
  ret

moveArrowUp:
  call setPress

  ld a, [ARROW_MIN_Y]
  ld b, a
  ld a, [ARROW_Y]
  cp a, b

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  call decMenuSelection

  call arrow.up
  ret

moveArrowDown:
  call setPress
  ld a, [ARROW_MAX_Y]
  ld b, a
  ld a, [ARROW_Y]
  cp a, b
  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  call incMenuSelection

  call arrow.down
  ret

moveArrowLeft:
  call setPress
  ld a, [ARROW_MIN_X]
  ld b, a
  ld a, [ARROW_X]
  cp a, b

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  ld a, [MENU]
  cp a, 2
  call z, scorecard.changeToCard0
  call arrow.left
  ret z

  call decMenuSelection

  ret

moveArrowRight:
  call setPress
  ld a, [ARROW_MAX_X]
  ld b, a
  ld a, [ARROW_X]
  cp a, b

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  ld a, [MENU]
  cp a, 2
  call z, scorecard.changeToCard1
  call arrow.right
  ret z
  call incMenuSelection

  call arrow.right
  ret

setPress:
  ld a, $01
  ld [_PAD_PRESSED], a
  ret

resetPress:
  ld a, $00
  ld [_PAD_PRESSED], a
  ret

moveArrow:
  ld a, [ARROW_UPDATE]
  bit 0, a
  ret z

  call arrow.move

  xor a
  ld [ARROW_UPDATE], a

  ret

draw:
  call status.drawRollCount
  call status.drawTotal
  call status.drawSubtotal
  call drawDice
  call LCDControl.resetUpdate
  ret

input:
	call read_pad

  ld a, [_PAD]
	cp a, 0
  call z, resetPress

  ; wait til button is released
  ld a, [_PAD_PRESSED]
  cp a, 1
  jp z, input

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
	call		nz, goBack

  ; A
  ld		a, [_PAD]
	and    		%00000001
	call		nz, select

  ; Start
  ld		a, [_PAD]
	and    		%00001000
	call		nz, changeDice.resetDice


  call LCDControl.waitVBlank
  call moveArrow
  call draw
  call scorecard.drawPossibleLower
  call scorecard.drawPossibleUpper

  call LCDControl.waitVBlank
  call scorecard.drawPossibleLower
  call scorecard.drawPossibleUpper
  call scorecard.drawPossibleLower
  call scorecard.drawPossibleUpper

  call Reseed
  call setRandomNumbers

  jr input

include "lib/helpers.inc"


section "Tiles", ROM0
TilesStart:
include "assets/tiles.inc"
TilesEnd:

section "Maps", ROM0
include "assets/maps.inc"