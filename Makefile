FRAMEWORKS=-framework Foundation -framework AppKit
CC=gcc
FLAGS=-W -Wall
EXEC=modio
PREFIX=/usr/local

all:main.o Playlist.o Player.o
	$(CC) $(FRAMEWORKS) $^ -o $(EXEC)

main.o:main.m Player.o Playlist.o
	$(CC) $(FLAGS) -c $< -o $@

Player.o:Player.m Player.h constants.h
	$(CC) $(FLAGS) -c $< -o $@

Playlist.o:Playlist.m Playlist.h constants.h
	$(CC) $(FLAGS) -c $< -o $@

install:
	mkdir -p $(PREFIX)/bin
	install $(EXEC) $(PREFIX)/bin

distclean:clean
	rm -f $(EXEC)
clean:
	rm -f *.o
