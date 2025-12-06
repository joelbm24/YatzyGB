; vim: ft=gbasm

LCDControl:

.waitVBlank
  ldh a, [rLY]
  cp 144
  jr c, .waitVBlank
  ret

.turnOff:
  call .waitVBlank
  xor a
  ldh [rLCDC], a
  ret

.turnOn:
  ld a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON|LCDCF_WIN9C00
  ldh [rLCDC], a
  ret
