; vim: ft=gbasm

dice:

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
  ld de, Dice0Map
  ret

.setDieTo1:
  ld de, Dice1Map
  ret

.setDieToInvert1:
  ld de, InvertDice1Map
  ret

.setDieTo2:
  ld de, Dice2Map
  ret

.setDieToInvert2:
  ld de, InvertDice2Map
  ret

.setDieTo3:
  ld de, Dice3Map
  ret

.setDieToInvert3:
  ld de, InvertDice3Map
  ret

.setDieTo4:
  ld de, Dice4Map
  ret

.setDieToInvert4
  ld de, InvertDice4Map
  ret

.setDieTo5:
  ld de, Dice5Map
  ret

.setDieToInvert5:
  ld de, InvertDice5Map
  ret

.setDieTo6:
  ld de, Dice6Map
  ret

.setDieToInvert6:
  ld de, InvertDice6Map
  ret

.copyDiceSlot:
  REPT 3
    ld a, [de]
    ld [hli], a
    inc de
  ENDR

  ld bc, 29
  add hl, bc

  REPT 3
    ld a, [de]
    ld [hli], a
    inc de
  ENDR

  ld bc, 29
  add hl, bc

  REPT 3
    ld a, [de]
    ld [hli], a
    inc de
  ENDR

  ret

changeDice:
.changeSlot1:
  ld b, a
  ld a, [KEPT_DICE]
  bit 0, a
  ret nz

  ld a, b
  ldh [diceSlots_Slot1], a
  ret

.changeSlot2:
  ld b, a
  ld a, [KEPT_DICE]
  bit 1, a
  ret nz

  ld a, b
  ldh [diceSlots_Slot2], a
  ret

.changeSlot3:
  ld b, a
  ld a, [KEPT_DICE]
  bit 2, a
  ret nz

  ld a, b
  ldh [diceSlots_Slot3], a
  ret

.changeSlot4:
  ld b, a
  ld a, [KEPT_DICE]
  bit 3, a
  ret nz

  ld a, b
  ldh [diceSlots_Slot4], a
  ret

.changeSlot5:
  ld b, a
  ld a, [KEPT_DICE]
  bit 4, a
  ret nz

  ld a, b
  ldh [diceSlots_Slot5], a
  ret

.selectSlot1:
  ld b, 0
  set 0, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.selectSlot2:
  ld b, 0
  set 1, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.selectSlot3:
  ld b, 0
  set 2, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.selectSlot4:
  ld b, 0
  set 3, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.selectSlot5:
  ld b, 0
  set 4, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.resetDice:
  VariableSet ROLL_COUNT, 3

  xor a
  ldh [diceSlots_Slot1], a
  ldh [diceSlots_Slot2], a
  ldh [diceSlots_Slot3], a
  ldh [diceSlots_Slot4], a
  ldh [diceSlots_Slot5], a
  ld [KEPT_DICE], a

  ret
