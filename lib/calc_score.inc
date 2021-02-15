calcScore:

.addOne
  ld a, b
  add a, 1
  ld b, a
  ret

.addTwo
  ld a, b
  add a, 2
  ld b, a
  ret

.addThree
  ld a, b
  add a, 3
  ld b, a
  ret

.addFour
  ld a, b
  add a, 4
  ld b, a
  ret

.addFive
  ld a, b
  add a, 5
  ld b, a
  ret

.addSix
  ld a, b
  add a, 6
  ld b, a
  ret

.calcOnes
  ld b, 0
  ld a, [slot1Value]
  cp a, 1
  call z, .addOne
  ld a, [slot2Value]
  cp a, 1
  call z, .addOne
  ld a, [slot3Value]
  cp a, 1
  call z, .addOne
  ld a, [slot4Value]
  cp a, 1
  call z, .addOne
  ld a, [slot5Value]
  cp a, 1
  call z, .addOne
  ld a, b
  ret

.calcTwos
  ld b, 0
  ld a, [slot1Value]
  cp a, 2
  call z, .addTwo
  ld a, [slot2Value]
  cp a, 2
  call z, .addTwo
  ld a, [slot3Value]
  cp a, 2
  call z, .addTwo
  ld a, [slot4Value]
  cp a, 2
  call z, .addTwo
  ld a, [slot5Value]
  cp a, 2
  call z, .addTwo
  ld a, b
  ret

.calcThrees
  ld b, 0
  ld a, [slot1Value]
  cp a, 3
  call z, .addThree
  ld a, [slot2Value]
  cp a, 3
  call z, .addThree
  ld a, [slot3Value]
  cp a, 3
  call z, .addThree
  ld a, [slot4Value]
  cp a, 3
  call z, .addThree
  ld a, [slot5Value]
  cp a, 3
  call z, .addThree
  ld a, b
  ret

.calcFours
  ld b, 0
  ld a, [slot1Value]
  cp a, 4
  call z, .addFour
  ld a, [slot2Value]
  cp a, 4
  call z, .addFour
  ld a, [slot3Value]
  cp a, 4
  call z, .addFour
  ld a, [slot4Value]
  cp a, 4
  call z, .addFour
  ld a, [slot5Value]
  cp a, 4
  call z, .addFour
  ld a, b
  ret

.calcFives
  ld b, 0
  ld a, [slot1Value]
  cp a, 5
  call z, .addFive
  ld a, [slot2Value]
  cp a, 5
  call z, .addFive
  ld a, [slot3Value]
  cp a, 5
  call z, .addFive
  ld a, [slot4Value]
  cp a, 5
  call z, .addFive
  ld a, [slot5Value]
  cp a, 5
  call z, .addFive
  ld a, b
  ret

.calcSixes
  ld b, 0
  ld a, [slot1Value]
  cp a, 6
  call z, .addSix
  ld a, [slot2Value]
  cp a, 6
  call z, .addSix
  ld a, [slot3Value]
  cp a, 6
  call z, .addSix
  ld a, [slot4Value]
  cp a, 6
  call z, .addSix
  ld a, [slot5Value]
  cp a, 6
  call z, .addSix
  ld a, b
  ret

.calcBonus
  ld a, 35
  ret

.calc3Kind
  ld a, 30
  ret

.calc4Kind
  ld a, 30
  ret

.calcFull
  ld a, 25
  ret

.calcSmall
  ld a, 30
  ret

.calcLarge
  ld a, 40
  ret

.calcYatzy
  ld a, 50
  ret

.calcChance
  ld a, 30
  ret

.calcRepeatYatzy
  ld a, 100
  ret

.is3Kind
  ret

.is4Kind
  ret

.isFull
  ret

.isSmall
  ret

.isLarge
  ret

.isYatzy
  ret

.calcPossibleUpperScore:
  call .calcOnes
  ld [POSSIBLE_ONES], a

  call .calcTwos
  ld [POSSIBLE_TWOS], a

  call .calcThrees
  ld [POSSIBLE_THREES], a

  call .calcFours
  ld [POSSIBLE_FOURS], a

  call .calcFives
  ld [POSSIBLE_FIVES], a

  call .calcSixes
  ld [POSSIBLE_SIXES], a

  call .calcBonus
  ld [POSSIBLE_BONUS], a
  ret

.calcPossibleLowerScore:
  call .calc3Kind
  ld [POSSIBLE_3KIND], a

  call .calc4Kind
  ld [POSSIBLE_4KIND], a

  call .calcFull
  ld [POSSIBLE_FULL], a

  call .calcSmall
  ld [POSSIBLE_SMALL], a

  call .calcLarge
  ld [POSSIBLE_LARGE], a

  call .calcYatzy
  ld [POSSIBLE_YATZY], a

  call .calcChance
  ld [POSSIBLE_CHANCE], a
  ret

.calcPossibleScore
  call .calcPossibleUpperScore
  call .calcPossibleLowerScore
  ret