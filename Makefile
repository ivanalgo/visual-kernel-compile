CC = gcc
CFLAGS = -g -O2 -Wall

all: adapter_gcc libhookcmd.so

adater_gcc:adapter_gcc.c
	$(CC) $(CFLAGS) adapter_gcc.c -o adapter_gcc

libhookcmd.so: hookcmd.c
	$(CC) $(CFLAGS) -fPIC -shared hookcmd.c -o libhookcmd.so
clean:
	rm -rf adapter_gcc libhookcmd.so
