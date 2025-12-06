; vim: ft=gbasm

drawTitleScreenMap:
  CopyMemory _SCRN0, TitleScreenMap
  ret

drawFinishScreenMap:
  CopyMemory _SCRN0, FinishScreenMap
  ret

drawGameScreenMap:
  CopyMemory _SCRN0, GameScreenMap
  ret

drawWindowMap:
  CopyMemory _SCRN1, WindowMap
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
  ldh [RN], a

  call RandomNumber
  ldh [RN+1], a

  call RandomNumber
  ldh [RN+2], a

  call RandomNumber
  ldh [RN+3], a

  call RandomNumber
  ldh [RN+4], a

Reseed:
  ldh a, [Seed]
  ldh [Seed], a
  ldh a, [Seed+1]
  ldh [Seed+1], a
  ldh a, [Seed]
  ld b, a
  ldh a, [Seed+1]
  xor b
  ldh [Seed+2], a
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
  jr z, .resetCounter
.continue
  xor a
  cp a, b
  jr nz, .loop

  inc c
  ret
.resetCounter
  ld c, 0
  jr .continue

; Input: HL = 16-bit number to divide
; Output: HL = quotient, A = remainder
; Modifies: A, BC, HL
div10:
    ld bc, 0

.sub1000:
    ld a, h
    cp 0x03
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
  ldh a, [frame_counter]
  bit 2, a
  jr z, .exit

  xor a
  ldh [frame_counter], a

  ldh a, [fade_state]
  cp 0
  jr z, .stage1
  cp 1
  jr z, .stage2
  cp 2
  jr z, .stage3
  cp 3
  jr z, .stage4

  jr .exit

.stage1:
  inc a
  ldh [fade_state], a
  SetAllPalletes %00000000
  ret

.stage2:
  inc a
  ldh [fade_state], a
  SetAllPalletes %01010100
  ret

.stage3:
  inc a
  ldh [fade_state], a
  SetAllPalletes %10100100
  ret

.stage4:
  xor a
  ldh [fade_state], a
  ldh [fadein_enabled], a
  SetAllPalletes %11100100
.exit:
  ret

fadeOut:
  ldh a, [frame_counter]
  bit 2, a
  jr z, .exit

  ldh a, [fade_state]
  cp 0
  jr z, .stage1
  cp 1
  jr z, .stage2
  cp 2
  jr z, .stage3
  cp 3
  jr z, .stage4

.stage1:
  inc a
  ldh [fade_state], a
  SetAllPalletes %11100100
  ret
.stage2:
  inc a
  ldh [fade_state], a
  SetAllPalletes %10100100
  ret
.stage3:
  inc a
  ldh [fade_state], a
  SetAllPalletes %01010100
  ret
.stage4:
  xor a
  ldh [fade_state], a
  ldh [fadeout_enabled], a
  SetAllPalletes %00000000
.exit:
  ret

enableAndWaitFadeIn:
  ld a, 1
  ldh [fadein_enabled], a
.loop:
  ldh a, [fadein_enabled]
  cp 0
  halt
  jr nz, .loop
  ret

enableAndWaitFadeOut:
  ld a, 1
  ldh [fadeout_enabled], a
.loop:
  ldh a, [fadeout_enabled]
  cp 0
  halt
  jr nz, .loop
  ret
