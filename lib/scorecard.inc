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
  ld [DISPLAY_3KIND], a
  ld [DISPLAY_3KIND+1], a
  ld [DISPLAY_4KIND], a
  ld [DISPLAY_4KIND+1], a
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
  ld a, 1
  ld [CARD], a

  ld a, [SELECTION]
  add 9
  ld [SELECTION], a

  ld a, [ARROW_MAX_Y]
  add a, 16
  ld [ARROW_MAX_Y], a

  ret

.changeToCard0
  xor a
  ld [CARD], a

  ld a, [ARROW_MAX_Y]
  sub a, 16
  ld [ARROW_MAX_Y], a

  ld a, [SELECTION]
  cp a, 16
  call z, .adjustArrow

  ld a, [SELECTION]
  sub 9
  ld [SELECTION], a

  ret

.adjustArrow
  dec a
  ld [SELECTION], a
  call arrow.up
  ret

.resetNumber
  xor a
  ld [de], a
  inc de
  ld [de], a
  ret

.drawTwoNumbers
  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.addSubtotal
  ld b, a
  ld a, [SUBTOTAL]
  add b
  ld [SUBTOTAL], a
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
  ret

.setOnes
  ld a, [UPPER_STATUS]
  set 0, a
  ld [UPPER_STATUS], a
  call .changeOnes
  ld a, [POSSIBLE_ONES]
  call .addSubtotal
  ld a, [POSSIBLE_ONES]
  call .addTotal
  call .checkAddBonus
  ret

.setTwos
  ld a, [UPPER_STATUS]
  set 1, a
  ld [UPPER_STATUS], a
  call .changeTwos
  ld a, [POSSIBLE_TWOS]
  call .addSubtotal
  ld a, [POSSIBLE_TWOS]
  call .addTotal
  call .checkAddBonus
  ret

.setThrees
  ld a, [UPPER_STATUS]
  set 2, a
  ld [UPPER_STATUS], a
  call .changeThrees
  ld a, [POSSIBLE_THREES]
  call .addSubtotal
  ld a, [POSSIBLE_THREES]
  call .addTotal
  call .checkAddBonus
  ret

.setFours
  ld a, [UPPER_STATUS]
  set 3, a
  ld [UPPER_STATUS], a
  call .changeFours
  ld a, [POSSIBLE_FOURS]
  call .addSubtotal
  ld a, [POSSIBLE_FOURS]
  call .addTotal
  call .checkAddBonus
  ret

.setFives
  ld a, [UPPER_STATUS]
  set 4, a
  ld [UPPER_STATUS], a
  call .changeFives
  ld a, [POSSIBLE_FIVES]
  call .addSubtotal
  ld a, [POSSIBLE_FIVES]
  call .addTotal
  call .checkAddBonus
  ret

.setSixes
  ld a, [UPPER_STATUS]
  set 5, a
  ld [UPPER_STATUS], a
  call .changeSixes
  ld a, [POSSIBLE_SIXES]
  call .addSubtotal
  ld a, [POSSIBLE_SIXES]
  call .addTotal
  call .checkAddBonus
  ret

.setBonus
  ld a, [UPPER_STATUS]
  set 6, a
  ld [UPPER_STATUS], a
  call .changeBonus
  ld a, [POSSIBLE_BONUS]
  call .addSubtotal
  ld a, [POSSIBLE_BONUS]
  call .addTotal
  ret

.set3Kind
  ld a, [LOWER_STATUS]
  set 0, a
  ld [LOWER_STATUS], a
  call .change3Kind
  ld a, [POSSIBLE_3KIND]
  call .addTotal
  ret

.set4Kind
  ld a, [LOWER_STATUS]
  set 1, a
  ld [LOWER_STATUS], a
  call .change4Kind
  ld a, [POSSIBLE_4KIND]
  call .addTotal
  ret

.setFull
  ld a, [LOWER_STATUS]
  set 2, a
  ld [LOWER_STATUS], a
  call .changeFull
  ld a, [POSSIBLE_FULL]
  call .addTotal
  ret

.setSmall
  ld a, [LOWER_STATUS]
  set 3, a
  ld [LOWER_STATUS], a
  call .changeSmall
  ld a, [POSSIBLE_SMALL]
  call .addTotal
  ret

.setLarge
  ld a, [LOWER_STATUS]
  set 4, a
  ld [LOWER_STATUS], a
  call .changeLarge
  ld a, [POSSIBLE_LARGE]
  call .addTotal
  ret

.setYatzy
  ld a, [LOWER_STATUS]
  set 5, a
  ld [LOWER_STATUS], a
  call .changeYatzy
  ld a, [POSSIBLE_YATZY]
  call .addTotal
  ret

.setChance
  ld a, [LOWER_STATUS]
  set 6, a
  ld [LOWER_STATUS], a
  call .changeChance
  ld a, [POSSIBLE_CHANCE]
  call .addTotal
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
  ld de, DISPLAY_3KIND
  call .resetNumber
  ret

.clear4Kind
  ld de, DISPLAY_4KIND
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
  xor a
  ld h, 0 
  ld a, [POSSIBLE_ONES]
  ld l, a
  ld de, DISPLAY_ONES
  call getDisplayNumber
  ret

.updateTwos
  xor a
  ld h, 0 
  ld a, [POSSIBLE_TWOS]
  ld l, a
  ld de, DISPLAY_TWOS
  call getDisplayNumber
  ret

.updateThrees
  xor a
  ld h, 0 
  ld a, [POSSIBLE_THREES]
  ld l, a
  ld de, DISPLAY_THREES
  call getDisplayNumber
  ret

.updateFours
  xor a
  ld h, 0 
  ld a, [POSSIBLE_FOURS]
  ld l, a
  ld de, DISPLAY_FOURS
  call getDisplayNumber
  ret

.updateFives
  xor a
  ld h, 0 
  ld a, [POSSIBLE_FIVES]
  ld l, a
  ld de, DISPLAY_FIVES
  call getDisplayNumber
  ret

.updateSixes
  xor a
  ld h, 0 
  ld a, [POSSIBLE_SIXES]
  ld l, a
  ld de, DISPLAY_SIXES
  call getDisplayNumber
  ret

.updateBonus
  xor a
  ld h, 0 
  ld a, [POSSIBLE_BONUS]
  ld l, a
  ld de, DISPLAY_BONUS
  call getDisplayNumber
  ret

.update3Kind
  xor a
  ld h, 0 
  ld a, [POSSIBLE_3KIND]
  ld l, a
  ld de, DISPLAY_3KIND
  call getDisplayNumber
  ret

.update4Kind
  xor a
  ld h, 0 
  ld a, [POSSIBLE_4KIND]
  ld l, a
  ld de, DISPLAY_4KIND
  call getDisplayNumber
  ret

.updateFull
  xor a
  ld h, 0 
  ld a, [POSSIBLE_FULL]
  ld l, a
  ld de, DISPLAY_FULL
  call getDisplayNumber
  ret

.updateSmall
  xor a
  ld h, 0 
  ld a, [POSSIBLE_SMALL]
  ld l, a
  ld de, DISPLAY_SMALL
  call getDisplayNumber
  ret

.updateLarge
  xor a
  ld h, 0 
  ld a, [POSSIBLE_LARGE]
  ld l, a
  ld de, DISPLAY_LARGE
  call getDisplayNumber
  ret

.updateYatzy
  xor a
  ld h, 0 
  ld a, [POSSIBLE_YATZY]
  ld l, a
  ld de, DISPLAY_YATZY
  call getDisplayNumber
  ret

.updateChance
  xor a
  ld h, 0 
  ld a, [POSSIBLE_CHANCE]
  ld l, a
  ld de, DISPLAY_CHANCE
  call getDisplayNumber
  ret

.changeOnes
  ld de, DISPLAY_ONES+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeTwos
  ld de, DISPLAY_TWOS+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeThrees
  ld de, DISPLAY_THREES+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeFours
  ld de, DISPLAY_FOURS+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeFives
  ld de, DISPLAY_FIVES+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeSixes
  ld de, DISPLAY_SIXES+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeBonus
  ld de, DISPLAY_BONUS+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.change3Kind
  ld de, DISPLAY_3KIND+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.change4Kind
  ld de, DISPLAY_4KIND+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeFull
  ld de, DISPLAY_FULL+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeSmall
  ld de, DISPLAY_SMALL+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeLarge
  ld de, DISPLAY_LARGE+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeYatzy
  ld de, DISPLAY_YATZY+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.changeChance
  ld de, DISPLAY_CHANCE+1
  ld a, [de]
  add 10
  ld [de], a
  dec de

  ld a, [de]
  add 10
  ld [de], a
  ret

.drawOnes
  ld hl, BEGIN_ONES+4
  ld de, DISPLAY_ONES+1
  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawTwos
  ld hl, BEGIN_TWOS+4
  ld de, DISPLAY_TWOS+1
  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawThrees
  ld hl, BEGIN_THREES+4
  ld de, DISPLAY_THREES+1
  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawFours
  ld hl, BEGIN_FOURS+4
  ld de, DISPLAY_FOURS+1
  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawFives
  ld hl, BEGIN_FIVES+4
  ld de, DISPLAY_FIVES+1
  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawSixes
  ld hl, BEGIN_SIXES+4
  ld de, DISPLAY_SIXES+1
  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawBonus
  ld hl, BEGIN_BONUS+4
  ld de, DISPLAY_BONUS+1

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.draw3Kind
  ld hl, BEGIN_3KIND+4
  ld de, DISPLAY_3KIND+1

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.draw4Kind
  ld hl, BEGIN_4KIND+4
  ld de, DISPLAY_4KIND+1

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawFull
  ld hl, BEGIN_FULL+4
  ld de, DISPLAY_FULL+1

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawSmall
  ld hl, BEGIN_SMALL+4
  ld de, DISPLAY_SMALL+1

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawLarge
  ld hl, BEGIN_LARGE+4
  ld de, DISPLAY_LARGE+1

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawYatzy
  ld hl, BEGIN_YATZY+4
  ld de, DISPLAY_YATZY+1

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
  ret

.drawChance
  ld hl, BEGIN_CHANCE+4
  ld de, DISPLAY_CHANCE+1

  ld a, [de]
  dec de
  add $BF
  ld [hli], a

  ld a, [de]
  add $BF
  ld [hl], a
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

.drawPossibleUpper
  call .drawOnes
  call .drawTwos
  call .drawThrees
  call .drawFours
  call .drawFives
  call .drawSixes
  call .drawBonus
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

.drawPossibleLower
  call .draw3Kind
  call .draw4Kind
  call .drawFull
  call .drawSmall
  call .drawLarge
  call .drawYatzy
  call .drawChance
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
  call .drawPossibleUpper
  call .drawPossibleLower
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
  ld a, [UPPER_STATUS]
  bit 0, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkTwos
  ld a, [UPPER_STATUS]
  bit 1, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkThrees
  ld a, [UPPER_STATUS]
  bit 2, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkFours
  ld a, [UPPER_STATUS]
  bit 3, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkFives
  ld a, [UPPER_STATUS]
  bit 4, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkSixes
  ld a, [UPPER_STATUS]
  bit 5, a
  call nz, .loadA
  call z, .unloadA
  ret

.check3Kind
  ld a, [LOWER_STATUS]
  bit 0, a
  call nz, .loadA
  call z, .unloadA
  ret

.check4Kind
  ld a, [LOWER_STATUS]
  bit 1, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkFull
  ld a, [LOWER_STATUS]
  bit 2, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkSmall
  ld a, [LOWER_STATUS]
  bit 3, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkLarge
  ld a, [LOWER_STATUS]
  bit 4, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkYatzy
  ld a, [LOWER_STATUS]
  bit 5, a
  call nz, .loadA
  call z, .unloadA
  ret

.checkChance
  ld a, [LOWER_STATUS]
  bit 6, a
  call nz, .loadA
  call z, .unloadA
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
  ld a, [GAME_FINISHED]
  cp a, 1
  ld [GAME_FINISHED], a
  ret

.checkFinished
  ld a, [UPPER_STATUS]
  ld b, a
  ld a, [LOWER_STATUS]
  add b
  cp a, 254
  call z, .setGameFinished
  ret
