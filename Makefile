yatzy : link
	rgbfix -v yatzy.gb

link : asm
	rgblink -o yatzy.gb yatzy.o

asm :
	rgbasm -o yatzy.o main.asm

clean :
	rm yatzy.gb yatzy.o
