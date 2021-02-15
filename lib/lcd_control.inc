LCDControl:

.waitVBlank
  ld a, [rLY]
  cp 144
  jr c, .waitVBlank
  ret

.turnOff:
  call .waitVBlank
  xor a
  ld [rLCDC], a
  ret

.turnOn
  ld a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON|LCDCF_WIN9C00
  ld [rLCDC], a
  ret

.setUpdate
  ld b, a
  ld a, 1
  ld [SCREEN_UPDATE], a
  ld a, b
  ret

.resetUpdate
  ld b, a
  ld a, 0
  ld [SCREEN_UPDATE], a
  ld a, b
  ret