; vim: ft=gbasm

include "src/lib/hardware.inc"
include "src/lib/hardware_compat.inc"
include "src/lib/macros.inc"
include "src/lib/definitions.inc"
include "src/lib/constants.inc"

section "Header", ROM0[$100]
EntryPoint:
  di
  jp Start

rept $150 - $104
  db 0
endr

section "Sprites", oam
dstruct ArrowSprite, arrowSprite

Section "Fast Data", hram
include "src/lib/fast_variables.inc"

section "Data", wram0
include "src/lib/variables.inc"

section "Game Code", ROM0
Start:
  CopyConstToVar rTAC, TACF_START
  CopyVars Seed, rDIV
  CopyVars Seed+1, rDIV
  CopyVars Seed+2, rDIV

.initDisplay
  xor a
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a
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

  ld a, [_PAD]
	and %00001000
	jr nz, .copyTiles
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
  ld sp, $DFFF
  VariableSet ROLL_COUNT, 3
  VariableSet DISABLE_KEEP_SCORE, 1

  xor a
  ld [diceSlots_Slot1], a
  ld [diceSlots_Slot2], a
  ld [diceSlots_Slot3], a
  ld [diceSlots_Slot4], a
  ld [diceSlots_Slot5], a
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
  CopyConstToVar arrowData_MinY, MENU_Y_MIN
  CopyConstToVar arrowData_MaxY, MENU_Y_MAX
  CopyConstToVar arrowData_MinX, MENU_X_MIN
  CopyConstToVar arrowData_MaxX, MENU_X_MAX
  CopyConstToVar arrowData_XChange, MENU_X_CHANGE
  CopyConstToVar arrowData_YChange, MENU_Y_CHANGE
  call arrow_control.initialize
  call arrow_control.setPosition
  call arrow_control.jump
  call scorecard.draw
  DrawSubtotal
  DrawTotal

  call LCDControl.turnOn
  call fadeIn

  jp input

include "src/lib/arrow_control.inc"
include "src/lib/lcd_control.inc"
include "src/lib/dice.inc"
include "src/lib/sounds.inc"
include "src/lib/status.inc"
include "src/lib/scorecard.inc"
include "src/lib/calc_score.inc"

read_pad:
    VariableSet rP1, %00100000
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]

    and $0F
    swap a
    ld b, a

    VariableSet rP1, %00010000
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
  VariableDec ROLL_COUNT
  call scorecard.update
  xor a
  ld [DISABLE_KEEP_SCORE], a

  ld a, [ROLL_COUNT]
  cp a, 0
  call z, selectCard

  ret

selectCard:
  VariableSet MENU, 2

  xor a
  ld [SELECTION], a

  VariableSet NO_BACK, 1
  CopyConstToVar arrowData_MinY, CARD_Y_MIN
  CopyConstToVar arrowData_MaxY, CARD_Y_MAX
  CopyConstToVar arrowData_MinX, CARD_X_MIN
  CopyConstToVar arrowData_MaxX, CARD_X_MAX
  CopyConstToVar arrowData_XChange, CARD_X_CHANGE
  CopyConstToVar arrowData_YChange, CARD_Y_CHANGE
  call arrow_control.jump
  ret

selectCategory:
  call scorecard.check
  ld a, b
  cp a, 1
  call z, sounds.ErrorBeep
  ret z

  call sounds.SelectBeep
  call scorecard.setScore
  xor a
  ld [NO_BACK], a
  call scorecard.clear
  VariableSet DISABLE_KEEP_SCORE, 1
  call changeDice.resetDice
  VariableSet ROLL_COUNT, 3
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
  VariableSet MENU, 1
  VariableSet SELECTION, 0
  CopyConstToVar arrowData_MinY, DICE_Y_MIN
  CopyConstToVar arrowData_MaxY, DICE_Y_MAX
  CopyConstToVar arrowData_MinX, DICE_X_MIN
  CopyConstToVar arrowData_MaxX, DICE_X_MAX
  CopyConstToVar arrowData_XChange, DICE_X_CHANGE
  CopyConstToVar arrowData_YChange, DICE_Y_CHANGE
  call arrow_control.jump

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
  jr z, .keepscore
  ret

  .keepscore
  xor a
  ld [DISABLE_KEEP_SCORE], a
  ret

changeToMainMenu:
  xor a
  ld [SELECTION], a
  ld [MENU], a

  CopyConstToVar arrowData_MinY, MENU_Y_MIN
  CopyConstToVar arrowData_MaxY, MENU_Y_MAX
  CopyConstToVar arrowData_MinX, MENU_X_MIN
  CopyConstToVar arrowData_MaxX, MENU_X_MAX
  CopyConstToVar arrowData_XChange, MENU_X_CHANGE
  CopyConstToVar arrowData_YChange, MENU_Y_CHANGE
  call arrow_control.jump
  ret

moveArrowUp:
  call setPress

  CompareVars arrowData_YPos, arrowData_MinY

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  VariableDec SELECTION

  call arrow_control.up
  ret

moveArrowDown:
  call setPress

  CompareVars arrowData_YPos, arrowData_MaxY

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  VariableInc SELECTION

  call arrow_control.down
  ret

moveArrowLeft:
  call setPress

  CompareVars arrowData_XPos, arrowData_MinX

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  ld a, [MENU]
  cp a, 2
  call z, scorecard.changeToCard0
  call arrow_control.left
  ret z

  VariableDec SELECTION

  ret

moveArrowRight:
  call setPress

  CompareVars arrowData_XPos, arrowData_MaxX

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  ld a, [MENU]
  cp a, 2
  call z, scorecard.changeToCard1
  call arrow_control.right
  ret z
  VariableInc SELECTION

  call arrow_control.right
  ret

setPress:
  VariableSet _PAD_PRESSED, 1
  ret

resetPress:
  xor a
  ld [_PAD_PRESSED], a
  ret

moveArrow:
  ld a, [arrowData_Update]
  bit 0, a
  ret z

  call arrow_control.move

  xor a
  ld [arrowData_Update], a

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
  ; TODO: Maybe skip to drawing, we only need to confirm one input at a time.

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

  ; TODO: Probably don't have to draw all of this after each input...
  call LCDControl.waitVBlank
  DrawDiceSlot diceSlots_Slot1, BEGIN_SLOT_1, 0
  DrawDiceSlot diceSlots_Slot2, BEGIN_SLOT_2, 1
  DrawDiceSlot diceSlots_Slot3, BEGIN_SLOT_3, 2
  DrawDiceSlot diceSlots_Slot4, BEGIN_SLOT_4, 3
  DrawDiceSlot diceSlots_Slot5, BEGIN_SLOT_5, 4
  call moveArrow
  call scorecard.draw
  DrawRollCount
  DrawTotal
  DrawSubtotal
  xor a
  ld [SCREEN_UPDATE], a

  call Reseed
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

  jp input

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
  call arrow_control.draw

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
  SetVariableBit rLCDC, 5
  ret

selectPause:
  call setPress

  call saveArrowPosition
  call openWindow

  VariableSet PAUSE_SELECTION, 1
  CopyConstToVar arrowData_YPos, PAUSE_Y_MAX
  CopyConstToVar arrowData_XPos, PAUSE_X_MIN

  call LCDControl.waitVBlank
  call arrow_control.draw

  jr pauseInput

setOldArrowPosition:
  CopyVars arrowData_XPos, arrowData_OldX
  CopyVars arrowData_YPos, arrowData_OldY
  ret

saveArrowPosition:
  CopyVars arrowData_OldX, arrowData_XPos
  CopyVars arrowData_OldY, arrowData_YPos
  ret

restartGame:
  call LCDControl.waitVBlank
  call fadeOut
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
  call arrow_control.draw
  jp input

pauseMoveUp:
  call setPress

  ld a, PAUSE_Y_MIN
  ld b, a
  ld a, [arrowData_YPos]
  cp a, b

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep
  VariableDec PAUSE_SELECTION
  VariableSub arrowData_YPos, 16
  ret

pauseMoveDown:
  call setPress

  ld a, PAUSE_Y_MAX
  ld b, a
  ld a, [arrowData_YPos]
  cp a, b

  call z, sounds.ErrorBeep
  ret z

  call sounds.MoveBeep

  VariableInc PAUSE_SELECTION
  VariableAdd arrowData_YPos, 16

  ret

launchFinishScreen:
  pop hl

  call slowdown

  call fadeOut
  call LCDControl.waitVBlank
  call LCDControl.turnOff

  call drawFinishScreen

  DrawNumber BEGIN_FINISH_TOTAL, DISPLAY_TOTAL, 4

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

include "src/lib/helpers.inc"

section "Tiles", ROM0
Tiles:
include "assets/tiles.inc"
Tiles.end

include "assets/title_screen_tiles.inc"

section "Maps", ROM0
include "assets/maps.inc"
include "assets/finish_screen_map.inc"
include "assets/title_screen_map.inc"
