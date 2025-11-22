; vim: ft=gbasm

scorecard:
.init
  xor a
  ld [DISPLAY_ONES], a
  ld [DISPLAY_ONES+1], a
  ld [DISPLAY_TWOS], a
  ld [DISPLAY_TWOS+1], a
  ld [DISPLAY_THREES], a
  ld [DISPLAY_THREES+1], a
  ld [DISPLAY_FOURS], a
  ld [DISPLAY_FOURS+1], a
  ld [DISPLAY_FIVES], a
  ld [DISPLAY_FIVES+1], a
  ld [DISPLAY_SIXES], a
  ld [DISPLAY_SIXES+1], a
  ld [DISPLAY_BONUS], a
  ld [DISPLAY_BONUS+1], a
  ld [DISPLAY_v3KIND], a
  ld [DISPLAY_v3KIND+1], a
  ld [DISPLAY_v4KIND], a
  ld [DISPLAY_v4KIND+1], a
  ld [DISPLAY_FULL], a
  ld [DISPLAY_FULL+1], a
  ld [DISPLAY_SMALL], a
  ld [DISPLAY_SMALL+1], a
  ld [DISPLAY_LARGE], a
  ld [DISPLAY_LARGE+1], a
  ld [DISPLAY_YATZY], a
  ld [DISPLAY_YATZY+1], a
  ld [DISPLAY_CHANCE], a
  ld [DISPLAY_CHANCE+1], a
  ld [UPPER_STATUS], a
  ld [LOWER_STATUS], a
  ret

.changeToCard1
  VariableSet CARD, 1
  VariableAdd SELECTION, 9
  VariableAdd arrowData_MaxY, 16
  ret

.changeToCard0
  xor a
  ld [CARD], a

  VariableSub arrowData_MaxY, 16

  ld a, [SELECTION]
  cp a, 16
  call z, .adjustArrow

  VariableSub SELECTION, 9

  ret

.adjustArrow
  dec a
  ld [SELECTION], a
  call arrow_control.up
  ret

.resetNumber
  xor a
  ld [de], a
  inc de
  ld [de], a
  ret

.addSubtotal
  ld b, a
  ld a, [SUBTOTAL]
  add b
  ld [SUBTOTAL], a
  ret

.addTotalNoCheck
  ld c, a
  xor a
  ld b, a
  ld a, [TOTAL+1]
  ld l, a
  ld a, [TOTAL]
  ld h, a
  add hl, bc

  ld a, h
  ld [TOTAL], a
  ld a, l
  ld [TOTAL+1], a
  ret


.addTotal
  ld c, a
  xor a
  ld b, a
  ld a, [TOTAL+1]
  ld l, a
  ld a, [TOTAL]
  ld h, a
  add hl, bc

  ; This will double add the yatzy bonus when upper card bonus is applied
  call calcScore.calcRepeatYatzy
  ld b, 0
  ld c, a
  add hl, bc

  ld a, h
  ld [TOTAL], a
  ld a, l
  ld [TOTAL+1], a
  ret

.checkAddBonus
  ld a, [UPPER_STATUS]
  bit 6, a
  ret nz

  ld a, [SUBTOTAL]
  cp a, 62
  call nc, .setBonus
  call c, .checkCardFilled
  ret

.setOnes
  SetVariableBit UPPER_STATUS, 0

  call .changeOnes
  ld a, [POSSIBLE_ONES]
  call .addSubtotal
  ld a, [POSSIBLE_ONES]
  call .addTotal
  call .checkAddBonus
  ret

.setTwos
  SetVariableBit UPPER_STATUS, 1

  call .changeTwos
  ld a, [POSSIBLE_TWOS]
  call .addSubtotal
  ld a, [POSSIBLE_TWOS]
  call .addTotal
  call .checkAddBonus
  ret

.setThrees
  SetVariableBit UPPER_STATUS, 2

  call .changeThrees
  ld a, [POSSIBLE_THREES]
  call .addSubtotal
  ld a, [POSSIBLE_THREES]
  call .addTotal
  call .checkAddBonus
  ret

.setFours
  SetVariableBit UPPER_STATUS, 3
  call .changeFours
  ld a, [POSSIBLE_FOURS]
  call .addSubtotal
  ld a, [POSSIBLE_FOURS]
  call .addTotal
  call .checkAddBonus
  ret

.setFives
  SetVariableBit UPPER_STATUS, 4
  call .changeFives
  ld a, [POSSIBLE_FIVES]
  call .addSubtotal
  ld a, [POSSIBLE_FIVES]
  call .addTotal
  call .checkAddBonus
  ret

.setSixes
  SetVariableBit UPPER_STATUS, 5
  call .changeSixes
  ld a, [POSSIBLE_SIXES]
  call .addSubtotal
  ld a, [POSSIBLE_SIXES]
  call .addTotal
  call .checkAddBonus
  ret

.setBonus
  SetVariableBit UPPER_STATUS, 6
  call .changeBonus
  ld a, [POSSIBLE_BONUS]
  call .addSubtotal
  ld a, [POSSIBLE_BONUS]
  call .addTotalNoCheck
  ret

.setNoBonus
  SetVariableBit UPPER_STATUS, 6
  xor a
  ld [POSSIBLE_BONUS], a
  call .clearBonus
  call .updateBonus
  call .changeBonus
  ret

.checkCardFilled
  ld a, [UPPER_STATUS]
  cp a, 63
  call z, .setNoBonus
  ret

.set3Kind
  SetVariableBit LOWER_STATUS, 0
  call .change3Kind
  ld a, [POSSIBLE_3KIND]
  call .addTotal
  ret

.set4Kind
  SetVariableBit LOWER_STATUS, 1
  call .change4Kind
  ld a, [POSSIBLE_4KIND]
  call .addTotal
  ret

.setFull
  SetVariableBit LOWER_STATUS, 2
  call .changeFull
  ld a, [POSSIBLE_FULL]
  call .addTotal
  ret

.setSmall
  SetVariableBit LOWER_STATUS, 3
  call .changeSmall
  ld a, [POSSIBLE_SMALL]
  call .addTotal
  ret

.setLarge
  SetVariableBit LOWER_STATUS, 4
  call .changeLarge
  ld a, [POSSIBLE_LARGE]
  call .addTotal
  ret

.setChance
  SetVariableBit LOWER_STATUS, 6
  call .changeChance
  ld a, [POSSIBLE_CHANCE]
  call .addTotal
  ret

.setYatzy
  SetVariableBit LOWER_STATUS, 5
  call .changeYatzy
  ld a, [POSSIBLE_YATZY]
  call .addTotal
  SetVariableBit LOWER_STATUS, 7
  ret


.clearOnes
  ld de, DISPLAY_ONES
  call .resetNumber
  ret

.clearTwos
  ld de, DISPLAY_TWOS
  call .resetNumber
  ret

.clearThrees
  ld de, DISPLAY_THREES
  call .resetNumber
  ret

.clearFours
  ld de, DISPLAY_FOURS
  call .resetNumber
  ret

.clearFives
  ld de, DISPLAY_FIVES
  call .resetNumber
  ret

.clearSixes
  ld de, DISPLAY_SIXES
  call .resetNumber
  ret

.clearBonus
  ld de, DISPLAY_BONUS
  call .resetNumber
  ret

.clear3Kind
  ld de, DISPLAY_v3KIND
  call .resetNumber
  ret

.clear4Kind
  ld de, DISPLAY_v4KIND
  call .resetNumber
  ret

.clearFull
  ld de, DISPLAY_FULL
  call .resetNumber
  ret

.clearSmall
  ld de, DISPLAY_SMALL
  call .resetNumber
  ret

.clearLarge
  ld de, DISPLAY_LARGE
  call .resetNumber
  ret

.clearYatzy
  ld de, DISPLAY_YATZY
  call .resetNumber
  ret

.clearChance
  ld de, DISPLAY_CHANCE
  call .resetNumber
  ret

.updateOnes
  UpdateCardNumber POSSIBLE_ONES, DISPLAY_ONES
  ret

.updateTwos
  UpdateCardNumber POSSIBLE_TWOS, DISPLAY_TWOS
  ret

.updateThrees
  UpdateCardNumber POSSIBLE_THREES, DISPLAY_THREES
  ret

.updateFours
  UpdateCardNumber POSSIBLE_FOURS, DISPLAY_FOURS
  ret

.updateFives
  UpdateCardNumber POSSIBLE_FIVES, DISPLAY_FIVES
  ret

.updateSixes
  UpdateCardNumber POSSIBLE_SIXES, DISPLAY_SIXES
  ret

.updateBonus
  UpdateCardNumber POSSIBLE_BONUS, DISPLAY_BONUS
  ret

.update3Kind
  UpdateCardNumber POSSIBLE_3KIND, DISPLAY_v3KIND
  ret

.update4Kind
  UpdateCardNumber POSSIBLE_4KIND, DISPLAY_v4KIND
  ret

.updateFull
  UpdateCardNumber POSSIBLE_FULL, DISPLAY_FULL
  ret

.updateSmall
  UpdateCardNumber POSSIBLE_SMALL, DISPLAY_SMALL
  ret

.updateLarge
  UpdateCardNumber POSSIBLE_LARGE, DISPLAY_LARGE
  ret

.updateYatzy
  UpdateCardNumber POSSIBLE_YATZY, DISPLAY_YATZY
  ret

.updateChance
  UpdateCardNumber POSSIBLE_CHANCE, DISPLAY_CHANCE
  ret

.changeOnes
  ChangeCardNumber DISPLAY_ONES
  ret

.changeTwos
  ChangeCardNumber DISPLAY_TWOS
  ret

.changeThrees
  ChangeCardNumber DISPLAY_THREES
  ret

.changeFours
  ChangeCardNumber DISPLAY_FOURS
  ret

.changeFives
  ChangeCardNumber DISPLAY_FIVES
  ret

.changeSixes
  ChangeCardNumber DISPLAY_SIXES
  ret

.changeBonus
  ChangeCardNumber DISPLAY_BONUS
  ret

.change3Kind
  ChangeCardNumber DISPLAY_v3KIND
  ret

.change4Kind
  ChangeCardNumber DISPLAY_v4KIND
  ret

.changeFull
  ChangeCardNumber DISPLAY_FULL
  ret

.changeSmall
  ChangeCardNumber DISPLAY_SMALL
  ret

.changeLarge
  ChangeCardNumber DISPLAY_LARGE
  ret

.changeYatzy
  ChangeCardNumber DISPLAY_YATZY
  ret

.changeChance
  ChangeCardNumber DISPLAY_CHANCE
  ret

.drawBonus
  DrawNumber BEGIN_BONUS+4, DISPLAY_BONUS, 2
  ret

.updatePossibleUpper:
  ld a, [UPPER_STATUS]
  bit 0, a
  call z, .updateOnes

  ld a, [UPPER_STATUS]
  bit 1, a
  call z, .updateTwos

  ld a, [UPPER_STATUS]
  bit 2, a
  call z, .updateThrees

  ld a, [UPPER_STATUS]
  bit 3, a
  call z, .updateFours

  ld a, [UPPER_STATUS]
  bit 4, a
  call z, .updateFives

  ld a, [UPPER_STATUS]
  bit 5, a
  call z, .updateSixes

  ld a, [UPPER_STATUS]
  bit 6, a
  call z, .updateBonus

  ret

.updatePossibleLower:
  ld a, [LOWER_STATUS]
  bit 0, a
  call z, .update3Kind

  ld a, [LOWER_STATUS]
  bit 1, a
  call z, .update4Kind

  ld a, [LOWER_STATUS]
  bit 2, a
  call z, .updateFull

  ld a, [LOWER_STATUS]
  bit 3, a
  call z, .updateSmall

  ld a, [LOWER_STATUS]
  bit 4, a
  call z, .updateLarge

  ld a, [LOWER_STATUS]
  bit 5, a
  call z, .updateYatzy

  ld a, [LOWER_STATUS]
  bit 6, a
  call z, .updateChance
  ret

.clearUpper
  ld a, [UPPER_STATUS]
  bit 0, a
  call z, .clearOnes

  ld a, [UPPER_STATUS]
  bit 1, a
  call z, .clearTwos

  ld a, [UPPER_STATUS]
  bit 2, a
  call z, .clearThrees

  ld a, [UPPER_STATUS]
  bit 3, a
  call z, .clearFours

  ld a, [UPPER_STATUS]
  bit 4, a
  call z, .clearFives

  ld a, [UPPER_STATUS]
  bit 5, a
  call z, .clearSixes

  ld a, [UPPER_STATUS]
  bit 6, a
  call z, .clearBonus

  ret

.clearLower
  ld a, [LOWER_STATUS]
  bit 0, a
  call z, .clear3Kind

  ld a, [LOWER_STATUS]
  bit 1, a
  call z, .clear4Kind

  ld a, [LOWER_STATUS]
  bit 2, a
  call z, .clearFull

  ld a, [LOWER_STATUS]
  bit 3, a
  call z, .clearSmall

  ld a, [LOWER_STATUS]
  bit 4, a
  call z, .clearLarge

  ld a, [LOWER_STATUS]
  bit 5, a
  call z, .clearYatzy

  ld a, [LOWER_STATUS]
  bit 6, a
  call z, .clearChance
  ret

.setScore
  ld a, [SELECTION]
  cp a, 0
  call z, .setOnes
  ld a, [SELECTION]
  cp a, 0

  ld a, [SELECTION]
  cp a, 1
  call z, .setTwos

  ld a, [SELECTION]
  cp a, 2
  call z, .setThrees

  ld a, [SELECTION]
  cp a, 3
  call z, .setFours

  ld a, [SELECTION]
  cp a, 4
  call z, .setFives

  ld a, [SELECTION]
  cp a, 5
  call z, .setSixes

  ld a, [SELECTION]
  cp a, 10
  call z, .set3Kind

  ld a, [SELECTION]
  cp a, 11
  call z, .set4Kind

  ld a, [SELECTION]
  cp a, 12
  call z, .setFull

  ld a, [SELECTION]
  cp a, 13
  call z, .setSmall

  ld a, [SELECTION]
  cp a, 14
  call z, .setLarge

  ld a, [SELECTION]
  cp a, 15
  call z, .setYatzy

  ld a, [SELECTION]
  cp a, 16
  call z, .setChance

  ret

.draw
  DrawNumber BEGIN_ONES+4, DISPLAY_ONES, 2
  DrawNumber BEGIN_3KIND+4, DISPLAY_v3KIND, 2
  DrawNumber BEGIN_TWOS+4, DISPLAY_TWOS, 2
  DrawNumber BEGIN_4KIND+4, DISPLAY_v4KIND, 2
  DrawNumber BEGIN_THREES+4, DISPLAY_THREES, 2
  DrawNumber BEGIN_FULL+4, DISPLAY_FULL, 2
  DrawNumber BEGIN_FOURS+4, DISPLAY_FOURS, 2
  DrawNumber BEGIN_SMALL+4, DISPLAY_SMALL, 2
  DrawNumber BEGIN_FIVES+4, DISPLAY_FIVES, 2
  DrawNumber BEGIN_LARGE+4, DISPLAY_LARGE, 2
  DrawNumber BEGIN_SIXES+4, DISPLAY_SIXES, 2
  DrawNumber BEGIN_YATZY+4, DISPLAY_YATZY, 2
  DrawNumber BEGIN_CHANCE+4, DISPLAY_CHANCE, 2
  ld a, [UPPER_STATUS]
  bit 6, a
  call nz, .drawBonus
  ret

.update
  call .updatePossibleLower
  call .updatePossibleUpper
  ret

.clear
  call .clearUpper
  call .clearLower
  ret

.loadA
  ld b, 1
  ret

.unloadA
  ld b, 0
  ret

.checkOnes
  CheckStatus UPPER_STATUS, 0
  ret

.checkTwos
  CheckStatus UPPER_STATUS, 1
  ret

.checkThrees
  CheckStatus UPPER_STATUS, 2
  ret

.checkFours
  CheckStatus UPPER_STATUS, 3
  ret

.checkFives
  CheckStatus UPPER_STATUS, 4
  ret

.checkSixes
  CheckStatus UPPER_STATUS, 5
  ret

.check3Kind
  CheckStatus LOWER_STATUS, 0
  ret

.check4Kind
  CheckStatus LOWER_STATUS, 1
  ret

.checkFull
  CheckStatus LOWER_STATUS, 2
  ret

.checkSmall
  CheckStatus LOWER_STATUS, 3
  ret

.checkLarge
  CheckStatus LOWER_STATUS, 4
  ret

.checkYatzy
  CheckStatus LOWER_STATUS, 5
  ret

.checkChance
  CheckStatus LOWER_STATUS, 6
  ret

.check
  ld a, [SELECTION]
  cp a, 0
  call z, .checkOnes
  ld a, [SELECTION]
  cp a, 0
  ret z

  ld a, [SELECTION]
  cp a, 1
  call z, .checkTwos
  ld a, [SELECTION]
  cp a, 1
  ret z

  ld a, [SELECTION]
  cp a, 2
  call z, .checkThrees
  ld a, [SELECTION]
  cp a, 2
  ret z

  ld a, [SELECTION]
  cp a, 3
  call z, .checkFours
  ld a, [SELECTION]
  cp a, 3
  ret z

  ld a, [SELECTION]
  cp a, 4
  call z, .checkFives
  ld a, [SELECTION]
  cp a, 4
  ret z

  ld a, [SELECTION]
  cp a, 5
  call z, .checkSixes
  ld a, [SELECTION]
  cp a, 5
  ret z

  ld a, [SELECTION]
  cp a, 10
  call z, .check3Kind
  ld a, [SELECTION]
  cp a, 10
  ret z

  ld a, [SELECTION]
  cp a, 11
  call z, .check4Kind
  ld a, [SELECTION]
  cp a, 11
  ret z

  ld a, [SELECTION]
  cp a, 12
  call z, .checkFull
  ld a, [SELECTION]
  cp a, 12
  ret z

  ld a, [SELECTION]
  cp a, 13
  call z, .checkSmall
  ld a, [SELECTION]
  cp a, 13
  ret z

  ld a, [SELECTION]
  cp a, 14
  call z, .checkLarge
  ld a, [SELECTION]
  cp a, 14
  ret z

  ld a, [SELECTION]
  cp a, 15
  call z, .checkYatzy
  ld a, [SELECTION]
  cp a, 15
  ret z

  ld a, [SELECTION]
  cp a, 16
  call z, .checkChance
  ld a, [SELECTION]
  cp a, 16
  ret z

.setGameFinished
  ld a, 1
  ld [GAME_FINISHED], a
  ret

.checkFinished
  ld a, [UPPER_STATUS]
  cp a, 126
  ret c

  ld a, [LOWER_STATUS]
  cp a, 255
  ret c

  call .setGameFinished
  ret
