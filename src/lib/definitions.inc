; vim: ft=gbasm

INCLUDE "src/lib/structs.inc"
	rgbds_structs_version 4.1.0

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
