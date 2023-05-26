CFLAGS = -Wall

all: xor.so

xor.so: xor.c
	gac -o $@ -d xor.c -p $(CFLAGS)

clean:
	rm $(wildcard *.la *.so)
