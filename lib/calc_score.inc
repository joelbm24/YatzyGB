calcScore:
.init
.reset
  xor a
  ld [DICE_STATUS], a
  ld [ONE_TOTAL], a
  ld [TWO_TOTAL], a
  ld [THREE_TOTAL], a
  ld [FOUR_TOTAL], a
  ld [FIVE_TOTAL], a
  ld [SIX_TOTAL], a
  ld [STRAIGHT], a
  ld [DICE_SUM], a
  ret

.addOne
  ld a, [ONE_TOTAL]
  add a, 1
  ld [ONE_TOTAL], a
  ld a, [DICE_SUM]
  add a, 1
  ld [DICE_SUM], a
  ld a, [STRAIGHT]
  set 0, a
  ld [STRAIGHT], a
  ret

.addTwo
  ld a, [TWO_TOTAL]
  add a, 2
  ld [TWO_TOTAL], a
  ld a, [DICE_SUM]
  add a, 2
  ld [DICE_SUM], a
  ld a, [STRAIGHT]
  set 1, a
  ld [STRAIGHT], a
  ret

.addThree
  ld a, [THREE_TOTAL]
  add a, 3
  ld [THREE_TOTAL], a
  ld a, [DICE_SUM]
  add a, 3
  ld [DICE_SUM], a
  ld a, [STRAIGHT]
  set 2, a
  ld [STRAIGHT], a
  ret

.addFour
  ld a, [FOUR_TOTAL]
  add a, 4
  ld [FOUR_TOTAL], a
  ld a, [DICE_SUM]
  add a, 4
  ld [DICE_SUM], a
  ld a, [STRAIGHT]
  set 3, a
  ld [STRAIGHT], a
  ret

.addFive
  ld a, [FIVE_TOTAL]
  add a, 5
  ld [FIVE_TOTAL], a
  ld a, [DICE_SUM]
  add a, 5
  ld [DICE_SUM], a
  ld a, [STRAIGHT]
  set 4, a
  ld [STRAIGHT], a
  ret

.addSix
  ld a, [SIX_TOTAL]
  add a, 6
  ld [SIX_TOTAL], a
  ld a, [DICE_SUM]
  add a, 6
  ld [DICE_SUM], a
  ld a, [STRAIGHT]
  set 5, a
  ld [STRAIGHT], a
  ret

.calcDice
.calcOnes
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

.calcTwos
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

.calcThrees
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

.calcFours
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

.calcFives
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

.calcSixes
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

  ret

.calcBonus
  ld a, 35
  ret

.calc3Kind
  ld a, [DICE_STATUS]
  bit 0, a
  ld a, 0
  ret z

  ld a, [DICE_SUM]
  ld b, a
  ret

.calc4Kind
  ld a, [DICE_STATUS]
  bit 1, a
  ld a, 0
  ret z

  ld a, [DICE_SUM]
  ret

.calcFull
  ld a, [DICE_STATUS]
  bit 2, a
  ld a, 0
  ret z
  ld a, 25
  ret

.calcSmall
  ld a, [DICE_STATUS]
  bit 3, a
  ld a, 0
  ret z

  ld a, 30
  ret

.calcLarge
  ld a, [DICE_STATUS]
  bit 4, a
  ld a, 0
  ret z

  ld a, 40
  ret

.calcYatzy
  ld a, [DICE_STATUS]
  bit 5, a
  ld a, 0
  ret z

  ld a, 50
  ret

.calcChance
  ld a, [DICE_SUM]
  ret

.calcRepeatYatzy
  ld a, [DICE_STATUS]
  bit 5, a
  ld a, 0
  ret z

  ld a, [LOWER_STATUS]
  bit 5, a
  ld a, 0
  ret z

  ld a, [LOWER_STATUS]
  bit 7, a
  ld a, 0
  ret z

  ld a, 100
  ret

.set3Kind
  ld a, [DICE_STATUS]
  set 0, a
  ld [DICE_STATUS], a
  ret

.set4Kind
  ld a, [DICE_STATUS]
  set 0, a
  set 1, a
  ld [DICE_STATUS], a
  ret

.setFull
  ld a, [DICE_STATUS]
  set 2, a
  ld [DICE_STATUS], a
  ret

.setSmall
  ld a, [DICE_STATUS]
  set 3, a
  ld [DICE_STATUS], a
  ret

.setLarge
  ld a, [DICE_STATUS]
  set 3, a
  set 4, a
  ld [DICE_STATUS], a
  ret

.setYatzy
  ld a, [DICE_STATUS]
  set 0, a
  set 1, a
  set 5, a
  ld [DICE_STATUS], a

.set2Kind
  ld a, [DICE_STATUS]
  set 6, a
  ld [DICE_STATUS], a
  ret

.is3Kind
  ld a, [ONE_TOTAL]
  cp a, 3
  call z, .set3Kind

  ld a, [TWO_TOTAL]
  cp a, 6
  call z, .set3Kind

  ld a, [THREE_TOTAL]
  cp a, 9
  call z, .set3Kind

  ld a, [FOUR_TOTAL]
  cp a, 12
  call z, .set3Kind

  ld a, [FIVE_TOTAL]
  cp a, 15
  call z, .set3Kind

  ld a, [SIX_TOTAL]
  cp a, 18
  call z, .set3Kind
  ret

.is4Kind
  ld a, [ONE_TOTAL]
  cp a, 4
  call z, .set4Kind
  ld a, [TWO_TOTAL]
  cp a, 8
  call z, .set4Kind
  ld a, [THREE_TOTAL]
  cp a, 12
  call z, .set4Kind
  ld a, [FOUR_TOTAL]
  cp a, 16
  call z, .set4Kind
  ld a, [FIVE_TOTAL]
  cp a, 20
  call z, .set4Kind
  ld a, [SIX_TOTAL]
  cp a, 24
  call z, .set4Kind
  ret

.is2Kind
  ld a, [ONE_TOTAL]
  cp a, 2
  call z, .set2Kind
  ld a, [TWO_TOTAL]
  cp a, 4
  call z, .set2Kind
  ld a, [THREE_TOTAL]
  cp a, 6
  call z, .set2Kind
  ld a, [FOUR_TOTAL]
  cp a, 8
  call z, .set2Kind
  ld a, [FIVE_TOTAL]
  cp a, 10
  call z, .set2Kind
  ld a, [SIX_TOTAL]
  cp a, 12
  call z, .set2Kind
  ret

.isFull
  ld a, [DICE_STATUS]
  and %01000001
  cp a, 65
  call z, .setFull
  ret

.isSmall
  ld a, [STRAIGHT]
  res 5, a
  res 4, a
  cp a, 15
  call z, .setSmall

  ld a, [STRAIGHT]
  res 5, a
  res 0, a
  cp a, 30
  call z, .setSmall

  ld a, [STRAIGHT]
  res 1, a
  res 0, a
  cp a, 60
  call z, .setSmall
  ret

.isLarge
  ld a, [STRAIGHT]
  cp a, 31
  call z, .setLarge

  ld a, [STRAIGHT]
  cp a, 62
  call z, .setLarge
  ret

.isYatzy
  ld a, [ONE_TOTAL]
  cp a, 5
  call z, .setYatzy
  ld a, [TWO_TOTAL]
  cp a, 10
  call z, .setYatzy
  ld a, [THREE_TOTAL]
  cp a, 15
  call z, .setYatzy
  ld a, [FOUR_TOTAL]
  cp a, 20
  call z, .setYatzy
  ld a, [FIVE_TOTAL]
  cp a, 25
  call z, .setYatzy
  ld a, [SIX_TOTAL]
  cp a, 30
  call z, .setYatzy
  ret
  ret

.calcPossibleUpperScore:
  ld a, [ONE_TOTAL]
  ld [POSSIBLE_ONES], a

  ld a, [TWO_TOTAL]
  ld [POSSIBLE_TWOS], a

  ld a, [THREE_TOTAL]
  ld [POSSIBLE_THREES], a

  ld a, [FOUR_TOTAL]
  ld [POSSIBLE_FOURS], a

  ld a, [FIVE_TOTAL]
  ld [POSSIBLE_FIVES], a

  ld a, [SIX_TOTAL]
  ld [POSSIBLE_SIXES], a

  call .calcBonus
  ld [POSSIBLE_BONUS], a

  ret

.calcPossibleLowerScore:
  call .is2Kind
  call .is3Kind
  call .is4Kind
  call .isFull
  call .isSmall
  call .isLarge
  call .isYatzy

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
  call .calcDice
  call .calcPossibleUpperScore
  call .calcPossibleLowerScore
  ret