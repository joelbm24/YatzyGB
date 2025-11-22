yatzy : link
	rgbfix -v -p 0xFF bin/yatzy.gb

link : asm
	rgblink -o bin/yatzy.gb bin/yatzy.o

asm :
	mkdir -p bin
	rgbasm -Weverything -o bin/yatzy.o src/main.asm

clean :
	rm -r bin

run : yatzy
	mgba bin/yatzy.gb

debug : yatzy
	java -jar ~/Emulicious/Emulicious.jar bin/yatzy.gb
