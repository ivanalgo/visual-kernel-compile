CC = gcc
CFLAGS = -g -O2 -Wall

all: adapter_gcc

adater_gcc:adapter_gcc.c
	$(CC) $(CFLAGS) adapter_gcc.c -o adapter_gcc


clean:
	rm -rf adapter_gcc
