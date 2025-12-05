; vim: ft=gbasm

include "src/lib/hardware.inc"
include "src/lib/hardware_compat.inc"
include "src/lib/macros/macros.inc"
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

section "VBlank Interrupt", ROM0[$0040]
VBlankInterrupt:
	push af
	push bc
	push de
	push hl
	jp VBlankHandler

section "Game Code", ROM0
VBlankHandler:
  ldh a, [frame_counter]
  inc a
  ldh [frame_counter], a

  ldh a, [fadein_enabled]
  cp 1
  call z, fadeIn

  ldh a, [fadeout_enabled]
  cp 1
  call z, fadeOut

.drawGame:
  ldh a, [game_state]
  cp DRAW_STATE_NOTHING
  jr z, .exit

  ldh a, [game_state]
  cp DRAW_STATE_GAME
  call z, drawGame

  ldh a, [game_state]
  cp DRAW_STATE_PAUSE
  call z, drawPause

.exit:
  pop hl
	pop de
	pop bc
	pop af
	reti

Start:
  CopyConstToVar rTAC, TACF_START
  CopyVars Seed, rDIV
  CopyVars Seed+1, rDIV
  CopyVars Seed+2, rDIV

.initDisplay
  xor a
  ldh [rBGP], a
  ldh [rOBP0], a
  ldh [rOBP1], a
  EnableVBlankInterrupt
  call LCDControl.turnOff

  ldh [rSCY], a
  ldh [rSCX], a
  ldh [game_state], a
  ld [CHEAT_ENABLE], a


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

  call drawTitleScreenMap

  call LCDControl.turnOn
  call enableAndWaitFadeIn

.lockup
  call read_pad

  ldh a, [_PAD]
	cp a, 0
  call z, resetPress

  ldh a, [_PAD_PRESSED]
  cp a, 1
  jr z, .lockup

  ldh a, [_PAD]
	and %00001000
	jr nz, .copyTiles

  halt

  jr .lockup

.copyTiles
  call setPress
  xor a
  ldh [_PAD], a
  call enableAndWaitFadeOut
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
  ldh [_PAD], a
  ldh [diceSlots_Slot1], a
  ldh [diceSlots_Slot2], a
  ldh [diceSlots_Slot3], a
  ldh [diceSlots_Slot4], a
  ldh [diceSlots_Slot5], a
  ld [SELECTION], a
  ld [MENU], a
  ld [KEPT_DICE], a
  ld [CARD], a
  ld [GAME_FINISHED], a
  ld [NO_BACK], a

  call status.init
  call scorecard.init
  call sounds.init

.main
  CopyConstToVar arrowData_MinY, MENU_Y_MIN
  CopyConstToVar arrowData_MaxY, MENU_Y_MAX
  CopyConstToVar arrowData_MinX, MENU_X_MIN
  CopyConstToVar arrowData_MaxX, MENU_X_MAX
  CopyConstToVar arrowData_XChange, MENU_X_CHANGE
  CopyConstToVar arrowData_YChange, MENU_Y_CHANGE

  call drawGameScreenMap
  call drawWindowMap
  call arrow_control.initialize
  call arrow_control.init
  call arrow_control.setPosition
  call arrow_control.jump
  call scorecard.draw
  DrawSubtotal
  DrawTotal

  call LCDControl.turnOn
  call enableAndWaitFadeIn

  ld a, DRAW_STATE_GAME
  ldh [game_state], a

  jp input

include "src/lib/arrow_control.inc"
include "src/lib/lcd_control.inc"
include "src/lib/dice.inc"
include "src/lib/sounds.inc"
include "src/lib/status.inc"
include "src/lib/scorecard.inc"
include "src/lib/calc_score.inc"
include "src/lib/helpers.inc"

drawPause:
  call arrow_control.draw
  ret

drawGame:
  DrawDiceSlot diceSlots_Slot1, BEGIN_SLOT_1, 0
  DrawDiceSlot diceSlots_Slot2, BEGIN_SLOT_2, 1
  DrawDiceSlot diceSlots_Slot3, BEGIN_SLOT_3, 2
  DrawDiceSlot diceSlots_Slot4, BEGIN_SLOT_4, 3
  DrawDiceSlot diceSlots_Slot5, BEGIN_SLOT_5, 4
  call scorecard.draw
  call arrow_control.draw
  DrawRollCount
  DrawTotal
  DrawSubtotal
  ret

read_pad:
    HighVariableSet rP1, %00100000
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]

    and $0F
    swap a
    ld b, a

    HighVariableSet rP1, %00010000
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]

    and $0F
    or b

    cpl
    ldh [_PAD], a
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

  ld a, [CHEAT_ENABLE]
  cp a, 1
  jr z, .cheat

  call RandomNumber
  call changeDice.changeSlot1

  call RandomNumber
  call changeDice.changeSlot2

  call RandomNumber
  call changeDice.changeSlot3

  call RandomNumber
  call changeDice.changeSlot4

  call RandomNumber
  call changeDice.changeSlot5
  jr .continue

.cheat:
  ldh a, [RN]
  call changeDice.changeSlot1
  ldh a, [diceSlots_Slot1]
  call changeDice.changeSlot2
  ldh a, [diceSlots_Slot1]
  call changeDice.changeSlot3
  ldh a, [diceSlots_Slot1]
  call changeDice.changeSlot4
  ldh a, [diceSlots_Slot1]
  call changeDice.changeSlot5

.continue
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
  ldh [_PAD_PRESSED], a
  ret

moveArrow:
  ld a, [arrowData_Update]
  bit 0, a
  ret z

  call arrow_control.move

  xor a
  ld [arrowData_Update], a

  ret

held_down:
  halt
input:
	call read_pad

  ldh a, [_PAD]
	cp a, 0
  call z, resetPress

  ; wait til button is released
  ldh a, [_PAD_PRESSED]
  cp a, 1
  jp z, held_down

  ldh a, [_PAD]
	and PADF_UP
	call nz, moveArrowUp

  ; down
	ldh a, [_PAD]
	and PADF_DOWN
	call nz, moveArrowDown

  ; left
 	ldh a, [_PAD]
	and PADF_LEFT
	call nz, moveArrowLeft

  ; right
  ldh a, [_PAD]
	and PADF_RIGHT
	call nz, moveArrowRight

  ; B
  ldh a, [_PAD]
	and PADF_B
	call nz, goBack

  ; A
  ldh a, [_PAD]
	and PADF_A
	call nz, select

  ; Start
  ldh a, [_PAD]
	and PADF_START
	jp nz, selectPause

  call moveArrow
  call Reseed

  halt

  jp input

pauseHeldDown:
  halt
pauseInput:
  call read_pad

  ldh a, [_PAD]
	cp a, 0
  call z, resetPress

  ; wait til button is released
  ldh a, [_PAD_PRESSED]
  cp a, 1
  jp z, pauseHeldDown

  ; Start
  ldh a, [_PAD]
	and PADF_START
	jp nz, closeWindow

  ; up
  ldh a, [_PAD]
	and PADF_UP
	call nz, pauseMoveUp

  ; down
	ldh a, [_PAD]
	and PADF_DOWN
	call nz, pauseMoveDown

  ; B
  ldh a, [_PAD]
	and PADF_B
	jr nz, closeWindow

  ; A
  ldh a, [_PAD]
	and PADF_A
	jr nz, selectYesNo

  halt

  jr pauseInput


openWindow:
  SetVariableBit rLCDC, 5
  ret

selectPause:
  call setPress

  ld a, DRAW_STATE_PAUSE
  ldh [game_state], a

  call saveArrowPosition
  call openWindow

  VariableSet PAUSE_SELECTION, 1
  CopyConstToVar arrowData_YPos, PAUSE_Y_MAX
  CopyConstToVar arrowData_XPos, PAUSE_X_MIN

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
  call enableAndWaitFadeOut
  call LCDControl.turnOff
  jp setupGame

selectYesNo:
  call setPress
  call sounds.SelectBeep

  ld a, [PAUSE_SELECTION]
  cp a, 0
  jr z, restartGame

closeWindow:
  call setPress
  xor a
  ldh [_PAD], a

	ldh a, [rLCDC]
	res 5, a
	ldh [rLCDC], a

closeWindowDraw:
  call setOldArrowPosition
  call LCDControl.waitVBlank
  call arrow_control.draw
.end
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

  xor a
  ldh [game_state], a

  call enableAndWaitFadeOut
  call LCDControl.turnOff

drawFinish:
  call drawFinishScreenMap
  DrawNumber BEGIN_FINISH_TOTAL, DISPLAY_TOTAL, 4
.end

  call LCDControl.turnOn
  ldh a, [rLCDC]
  res 1, a
  ldh [rLCDC], a
  call enableAndWaitFadeIn
  jr .lockup

.held_down
  halt
.lockup
  call read_pad

  ldh a, [_PAD]
	cp a, 0
  call z, resetPress

  ldh a, [_PAD_PRESSED]
  cp a, 1
  jr z, .held_down

  ldh a, [_PAD]
  cp a, 0
  call nz, setPress

  ld a, 0
  ldh [_PAD], a
	jp nz, Start

  halt

  jr .lockup


section "Tiles", ROM0
Tiles:
include "assets/tiles.inc"
Tiles.end

include "assets/title_screen_tiles.inc"

section "Maps", ROM0
include "assets/maps.inc"
include "assets/finish_screen_map.inc"
include "assets/title_screen_map.inc"
