; vim: ft=gbasm

include "lib/hardware.inc"
include "lib/hardware_compat.inc"
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
  ; TODO set stack to top of ram
  ld a, TACF_START
  ld [rTAC], a
  ld a, [rDIV]
  ld [Seed], a
  ld a, [rDIV]
  ld [Seed+1], a
  ld a, [rDIV]
  ld [Seed+2], a

.initDisplay
  ld a, %00000000
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  xor a
  ld [rSCY], a
  ld [rSCX], a

  call LCDControl.waitVBlank
  call LCDControl.turnOff

.copyTitleTiles
  ld hl, $8000
  ld de, TitleTiles
  ld bc, TitleTiles.end - TitleTiles

.copyTitleTilesLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .copyTitleTilesLoop

  call drawTitleScreen
  call LCDControl.turnOn
  call fadeIn

.lockup
  call read_pad

  ld a, [_PAD]
	cp a, 0
  call z, resetPress

  ld a, [_PAD_PRESSED]
  cp a, 1
  jr z, .lockup

  ld		a, [_PAD]
	and    		%00001000
	jr		nz, .copyTiles
  jr .lockup

.copyTiles
  xor a
  ld [_PAD], a
  call setPress
  call fadeOut
  call LCDControl.waitVBlank
  call LCDControl.turnOff

  ld hl, $8000
  ld de, Tiles
  ld bc, Tiles.end - Tiles

.copyTilesLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .copyTilesLoop

setupGame:
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
  ld [SELECTION], a
  ld [MENU], a
  ld [KEPT_DICE], a
  ld [CARD], a
  ld [_PAD], a
  ld [GAME_FINISHED], a
  ld [NO_BACK], a
  call status.init
  call scorecard.init
  call sounds.init

.main
  call drawGameScreen
  call drawWindow
  call setMenuCursorConstraints
  call arrow.initialize
  call arrow.setPosition
  call arrow.jump
  call scorecard.drawPossibleLower
  call scorecard.drawPossibleUpper
  call status.drawSubtotal
  call status.drawTotal
  call LCDControl.turnOn
  call fadeIn


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
    ld a, %00100000
    ld [rP1], a

    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]

    and $0F
    swap a
    ld b, a

    ld a, %00010000
    ld [rP1], a

    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]

    and $0F
    or b

    cpl
    ld [_PAD], a
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
  call calcScore.init
  call scorecard.clear

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

  call calcScore.calcPossibleScore
  call status.decreaseRollCount
  call scorecard.update
  call enableKeepScore

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
  call status.updateSubtotal
  call status.updateTotal
  call changeToMainMenu

  call scorecard.checkFinished
  ld a, [GAME_FINISHED]
  cp a, 1
  jp z, launchFinishScreen

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

  ld a, [_PAD]
	and PADF_UP
	call nz, moveArrowUp

  ; down
	ld a, [_PAD]
	and	PADF_DOWN
	call nz, moveArrowDown

  ; left
 	ld a, [_PAD]
	and PADF_LEFT
	call nz, moveArrowLeft

  ; right
  ld a, [_PAD]
	and PADF_RIGHT
	call nz, moveArrowRight

  ; B
  ld a, [_PAD]
	and PADF_B
	call nz, goBack

  ; A
  ld a, [_PAD]
	and PADF_A
	call nz, select

  ; Start
  ld a, [_PAD]
	and PADF_START
	jp nz, selectPause

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

pauseInput:
  call read_pad

  ld a, [_PAD]
	cp a, 0
  call z, resetPress

  ; wait til button is released
  ld a, [_PAD_PRESSED]
  cp a, 1
  jp z, pauseInput

  ; Start
  ld a, [_PAD]
	and PADF_START
	jp nz, closeWindow

  ; up
  ld a, [_PAD]
	and PADF_UP
	call nz, pauseMoveUp

  ; down
	ld a, [_PAD]
	and PADF_DOWN
	call nz, pauseMoveDown

  ; B
  ld a, [_PAD]
	and PADF_B
	jr nz, closeWindow

  ; A
  ld a, [_PAD]
	and PADF_A
	jr nz, selectYesNo

  call LCDControl.waitVBlank
  call arrow.draw

  jr pauseInput

slowdown:
  ld bc, $1fff

.slowLoop
  dec bc
  ld a, b
  cp a, 0
  jr nz, .slowLoop
  ret

openWindow:
  call slowdown
	ld	a, [rLCDC]
  set 5, a
	ld	[rLCDC], a
  ret

selectPause:
  call setPress

  call saveArrowPosition
  call openWindow

  ld a, 1
  ld [PAUSE_SELECTION], a
  ld a, PAUSE_Y_MAX
  ld [ARROW_Y], a

  ld a, PAUSE_X_MIN
  ld [ARROW_X], a

  call LCDControl.waitVBlank
  call arrow.draw

  jr pauseInput

setOldArrowPosition:
  ld a, [OLD_X]
  ld [ARROW_X], a

  ld a, [OLD_Y]
  ld [ARROW_Y], a
  ret

saveArrowPosition:
  ld a, [ARROW_X]
  ld [OLD_X], a

  ld a, [ARROW_Y]
  ld [OLD_Y], a
  ret

restartGame:
  call LCDControl.waitVBlank
  call LCDControl.turnOff
  jp setupGame

selectYesNo:
  call setPress
  call sounds.SelectBeep

  call slowdown
  ld a, [PAUSE_SELECTION]
  cp a, 0
  jr z, restartGame

closeWindow:
  call setPress
  xor a
  ld [_PAD], a

  call slowdown

	ld	a, [rLCDC]
	res 5, a
	ld	[rLCDC], a

  call setOldArrowPosition
  call LCDControl.waitVBlank
  call arrow.draw
  jp input

pauseMoveUp:
  call setPress

  ld a, PAUSE_Y_MIN
  ld b, a
  ld a, [ARROW_Y]
  cp a, b

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  ld a, [PAUSE_SELECTION]
  dec a
  ld [PAUSE_SELECTION], a

  ld a, [ARROW_Y]
  sub a, 16
  ld [ARROW_Y], a
  ret

pauseMoveDown:
  call setPress

  ld a, PAUSE_Y_MAX
  ld b, a
  ld a, [ARROW_Y]
  cp a, b

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  ld a, [PAUSE_SELECTION]
  inc a
  ld [PAUSE_SELECTION], a

  ld a, [ARROW_Y]
  add a, 16
  ld [ARROW_Y], a

  ret

launchFinishScreen:
  pop hl ; TODO should just set the stack to the top of ram

  call slowdown

  call fadeOut
  call LCDControl.waitVBlank
  call LCDControl.turnOff

  call drawFinishScreen

  ld hl, $9928
  ld a, [DISPLAY_TOTAL+3]
  add $5C
  ld [hli], a
  ld a, [DISPLAY_TOTAL+2]
  add $5C
  ld [hli], a
  ld a, [DISPLAY_TOTAL+1]
  add $5C
  ld [hli], a
  ld a, [DISPLAY_TOTAL]
  add $5C
  ld [hli], a

  call LCDControl.turnOn
  ld a, [rLCDC]
  res 1, a
  ld [rLCDC], a
  call fadeIn

.lockup
  call read_pad

  ld a, [_PAD]
	cp a, 0
  call z, resetPress

  ld a, [_PAD_PRESSED]
  cp a, 1
  jr z, .lockup

  ld a, [_PAD]
  cp a, 0

  call nz, setPress
  ld a, 0
  ld [_PAD], a
	jp nz, Start
  jr .lockup

include "lib/helpers.inc"

section "Tiles", ROM0
Tiles:
include "assets/tiles.inc"
Tiles.end

include "assets/title_screen_tiles.inc"

section "Maps", ROM0
include "assets/maps.inc"
include "assets/finish_screen_map.inc"
include "assets/title_screen_map.inc"
