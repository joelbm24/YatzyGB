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

.setDieToInvert1
  ld de, InvertDice1Map
  ret

.setDieTo2:
  ld de, Dice2Map
  ret

.setDieToInvert2
  ld de, InvertDice2Map
  ret

.setDieTo3:
  ld de, Dice3Map
  ret

.setDieToInvert3
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

.setDieToInvert5
  ld de, InvertDice5Map
  ret

.setDieTo6:
  ld de, Dice6Map
  ret

.setDieToInvert6
  ld de, InvertDice6Map
  ret

.copyDiceSlot
  ld a, [de]
  ld [hli], a
  inc de

  ld a, [de]
  ld [hli], a
  inc de

  ld a, [de]
  ld [hli], a
  inc de

  ld bc, 29
  add hl, bc

  ld a, [de]
  ld [hli], a
  inc de

  ld a, [de]
  ld [hli], a
  inc de

  ld a, [de]
  ld [hli], a
  inc de

  ld bc, 29
  add hl, bc

  ld a, [de]
  ld [hli], a
  inc de

  ld a, [de]
  ld [hli], a
  inc de

  ld a, [de]
  ld [hli], a
  inc de
  ret

changeDice:
.changeSlot1
  call LCDControl.setUpdate
  ld b, a
  ld a, [KEPT_DICE]
  bit 0, a
  ret nz

  ld a, b
  ld [slot1Value], a
  ret

.changeSlot2
  call LCDControl.setUpdate
  ld b, a
  ld a, [KEPT_DICE]
  bit 1, a
  ret nz

  ld a, b
  ld [slot2Value], a
  ret

.changeSlot3
  call LCDControl.setUpdate
  ld b, a
  ld a, [KEPT_DICE]
  bit 2, a
  ret nz

  ld a, b
  ld [slot3Value], a
  ret

.changeSlot4
  call LCDControl.setUpdate
  ld b, a
  ld a, [KEPT_DICE]
  bit 3, a
  ret nz

  ld a, b
  ld [slot4Value], a
  ret

.changeSlot5
  call LCDControl.setUpdate
  ld b, a
  ld a, [KEPT_DICE]
  bit 4, a
  ret nz

  ld a, b
  ld [slot5Value], a
  ret

.selectSlot1
  call LCDControl.setUpdate
  ld b, 0
  set 0, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.selectSlot2
  call LCDControl.setUpdate
  ld b, 0
  set 1, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.selectSlot3
  call LCDControl.setUpdate
  ld b, 0
  set 2, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.selectSlot4
  call LCDControl.setUpdate
  ld b, 0
  set 3, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.selectSlot5
  call LCDControl.setUpdate
  ld b, 0
  set 4, b

  ld a, [KEPT_DICE]
  xor b
  ld [KEPT_DICE], a
  ret

.resetDice:
  call LCDControl.setUpdate
  ld a, 3
  ld [ROLL_COUNT], a

  ;call updateRollCount

  xor a

  ld [slot1Value], a
  ld [slot2Value], a
  ld [slot3Value], a
  ld [slot4Value], a
  ld [slot5Value], a
  ld [KEPT_DICE], a

  ret
