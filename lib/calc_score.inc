calcScore:
.calcOnes
  ld a, 5
  ret

.calcTwos
  ld a, 10
  ret

.calcThrees
  ld a, 15
  ret

.calcFours
  ld a, 20
  ret

.calcFives
  ld a, 25
  ret

.calcSixes
  ld a, 30
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