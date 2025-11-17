; vim: ft=gbasm

INCLUDE "src/lib/structs.inc"
	rgbds_structs_version 4.1.0

struct DiceSlots
  bytes 1, Slot5
  bytes 1, Slot4
  bytes 1, Slot3
  bytes 1, Slot2
  bytes 1, Slot1
end_struct

struct DisplayNumbers
  bytes 2, BONUS
  bytes 4, TOTAL
  bytes 3, SUBTOTAL
  bytes 2, ONES
  bytes 2, TWOS
  bytes 2, THREES
  bytes 2, FOURS
  bytes 2, FIVES
  bytes 2, SIXES
  bytes 2, v3KIND
  bytes 2, v4KIND
  bytes 2, FULL
  bytes 2, SMALL
  bytes 2, LARGE
  bytes 2, YATZY
  bytes 2, CHANCE
end_struct

struct ArrowSprite
  bytes 1, YPos
  bytes 1, XPos
	bytes 1, Tile
	bytes 1, Attr
end_struct

struct ArrowData
  bytes 1, YPos
  bytes 1, XPos
  bytes 1, OldX
  bytes 1, OldY
  bytes 1, MinX
  bytes 1, MinY
  bytes 1, MaxX
  bytes 1, MaxY
  bytes 1, XChange
  bytes 1, YChange
  bytes 1, Update
  bytes 1, Direction
end_struct
