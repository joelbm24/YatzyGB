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

  xor a
  cp a, b
  jr nz, .loop

  inc c
  ret

.resetC
  ld c, 0
  ret

; Input: HL = 16-bit number to divide
; Output: HL = quotient, A = remainder
; Modifies: A, BC, HL

div10:
    ld bc, 0         ; BC = quotient


.sub1000:
    ld a, h
    cp 0x03          ; Check if HL >= 1000 (0x3E8)
    jr c, .sub100
    jr nz, .do_sub1000
    ld a, l
    cp 0xE8
    jr c, .sub100

.do_sub1000:
    ld a, l
    sub 0xE8
    ld l, a
    ld a, h
    sbc 0x03
    ld h, a

    ld a, c
    add a, 100
    ld c, a
    ld a, b
    adc 0
    ld b, a

    jr .sub1000

.sub100:
    ld a, h
    or a
    jr nz, .do_sub100
    ld a, l
    cp 100
    jr c, .sub10

.do_sub100:
    ld a, l
    sub 100
    ld l, a
    ld a, h
    sbc 0
    ld h, a

    ld a, c
    add a, 10
    ld c, a
    ld a, b
    adc 0
    ld b, a

    jr .sub100

.sub10:
    ld a, h
    or a
    jr nz, .do_sub10
    ld a, l
    cp 10
    jr c, .done

.do_sub10:
    ld a, l
    sub 10
    ld l, a
    ld a, h
    sbc 0
    ld h, a

    inc bc

    jr .sub10

.done:
    ld a, l
    ld h, b
    ld l, c
    ret

getDisplayNumber:
.loop
  call div10
  ld [de], a
  inc de
  ld a, h
  or l
  ret z
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
