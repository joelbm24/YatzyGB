yatzy : link
	rgbfix -v -p 0xFF bin/yatzy.gb

link : asm
	rgblink -o bin/yatzy.gb bin/yatzy.o

asm :
	mkdir -p bin
	rgbasm -o bin/yatzy.o main.asm

clean :
	rm -r bin
