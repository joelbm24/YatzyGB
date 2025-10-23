; vim: ft=gbasm

drawTitleScreen:
  ld hl, _SCRN0
  ld de, TitleScreenMap
  ld bc, TitleScreenMap.end - TitleScreenMap

.drawTitleTilesLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .drawTitleTilesLoop
  ret

drawFinishScreen:
  ld hl, _SCRN0
  ld de, FinishScreenMap
  ld bc, FinishScreenMap.end - FinishScreenMap

.drawFinishTilesLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .drawFinishTilesLoop
  ret

drawGameScreen:
  ld hl, _SCRN0
  ld de, GameScreenMap
  ld bc, GameScreenMap.end- GameScreenMap

.drawTilesLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .drawTilesLoop
  ret

drawWindow:
  ld hl, _SCRN1
  ld de, WindowMap
  ld bc, WindowMap.end - WindowMap

.drawWindowLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .drawWindowLoop
  ret

drawTextTiles:
  ld a, [de]
  ld [hli], a
  inc de
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

setRandomNumbers:
  call RandomNumber
  ld [RN], a

  call RandomNumber
  ld [RN+1], a

  call RandomNumber
  ld [RN+2], a

  call RandomNumber
  ld [RN+3], a

  call RandomNumber
  ld [RN+4], a

Reseed:
  ld a, [Seed]
  ld [Seed], a
  ld a, [Seed+1]
  ld [Seed+1], a
  ld a, [Seed]
  ld b, a
  ld a, [Seed+1]
  xor b
  ld [Seed+2], a
  ret

RandomNumber:
  ld      hl,Seed
  ld      a,[hl+]
  sra     a
  sra     a
  sra     a
  xor     [hl]
  inc     hl
  rra
  rl      [hl]
  dec     hl
  rl      [hl]
  dec     hl
  rl      [hl]
  ld      a,[rDIV]

.randomness:
  add [hl]
  call mod6
  ld a, c
  ret

mod6:
  ld b, a
  ld c, 0

.loop
  dec b
  inc c
  ld a, 6
  cp a, c
  call z, .resetC

  ld a, 0
  cp a, b
  jr nz, .loop

  inc c
  ret

.resetC
  ld c, 0
  ret

div10:
  ld a, l
  ld b, 0

.loop
  ld c, a
  ld a, h
  cp a, 0
  call z, .checkCanExit

  ld a, c

  cp a, 10
  call c, .resetA

  sub 10
  inc b
  cp a, 0
  jr nz, .loop
  ret

.checkCanExit
  ld a, c
  cp a, 10
  jr c, .exit
  ret

.resetA
  sub 10
  inc b
  dec h
  ret

.exit
  pop hl
  ret

getDisplayNumber:
.loop
  call div10
  ld c, a
  ld a, b
  cp a, 0
  ld a, c
  ld [de], a
  inc de
  ret z
  ld a, b
  ld h, 0
  ld l, a
  jr .loop

fadeIn:
  call LCDControl.waitVBlank
  ld a, %00000000
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  call slowdown
  call LCDControl.waitVBlank
  ld a, %01010100
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  call slowdown
  call LCDControl.waitVBlank
  ld a, %10100100
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  call slowdown
  call LCDControl.waitVBlank
  ld a, %11100100
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  ret

fadeOut:
  call LCDControl.waitVBlank
  ld a, %11100100
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  call slowdown
  call LCDControl.waitVBlank
  ld a, %10100100
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  call slowdown
  call LCDControl.waitVBlank
  ld a, %01010100
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  call slowdown
  call LCDControl.waitVBlank
  ld a, %00000000
  ld [rBGP], a
  ld [rOBP0], a
  ld [rOBP1], a

  ret
