; vim: ft=gbasm

macro VariableAdd ; VARIABLE, VALUE
  ld a, [\1]
  add a, \2
  ld [\1], a
endm

macro VariableSub ; VARIABLE, VALUE
  ld a, [\1]
  sub a, \2
  ld [\1], a
endm

macro VariableDec ; VARIABLE
  ld a, [\1]
  dec a
  ld [\1], a
endm

macro VariableInc ; VARIABLE
  ld a, [\1]
  inc a
  ld [\1], a
endm

macro VariableSet ; VARIABLE, VALUE
  ld a, \2
  ld [\1], a
endm

macro SetVariableBit ; VARIABLE, BIT
  ld a, [\1]
  set \2, a
  ld [\1], a
endm

macro CopyConstToVar ; TO, FROM
  ld a, \2
  ld [\1], a
endm

macro CopyVars ; TO, FROM
  ld a, [\2]
  ld [\1], a
endm

macro CompareVars ; Var1, Var2
  ld a, [\2]
  ld b, a
  ld a, [\1]
  cp a, b
endm

macro HighVariableAdd ; VARIABLE, VALUE
  ldh a, [\1]
  add a, \2
  ldh [\1], a
endm

macro HighVariableSub ; VARIABLE, VALUE
  ldh a, [\1]
  sub a, \2
  ldh [\1], a
endm

macro HighVariableDec ; VARIABLE
  ldh a, [\1]
  dec a
  ldh [\1], a
endm

macro HighVariableInc ; VARIABLE
  ldh a, [\1]
  inc a
  ldh [\1], a
endm

macro HighVariableSet ; VARIABLE, VALUE
  ld a, \2
  ldh [\1], a
endm

macro HighSetVariableBit ; VARIABLE, BIT
  ldh a, [\1]
  set \2, a
  ldh [\1], a
endm

macro HighCopyConstToVar ; TO, FROM
  ld a, \2
  ldh [\1], a
endm

macro HighCopyVars ; TO, FROM
  ldh a, [\2]
  ldh [\1], a
endm

macro HighCompareVars ; Var1, Var2
  ldh a, [\2]
  ld b, a
  ldh a, [\1]
  cp a, b
endm
