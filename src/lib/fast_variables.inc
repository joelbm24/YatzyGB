; vim: ft=gbasm

_PAD:
  ds 1

_PAD_PRESSED:
  ds 1

Seed:
  ds 3

dstruct DisplayNumbers, DISPLAY

dstruct DiceSlots, diceSlots

RN:
  ds 5

fadeout_enabled:
  ds 1

fadein_enabled:
  ds 1

fade_state:
  ds 1

game_state:
  ds 1

frame_counter:
  ds 1
