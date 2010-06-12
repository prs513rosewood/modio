FRAMEWORKS=-framework Foundation -framework AppKit
CC=gcc
EXEC=modio

all:main.o Playlist.o Player.o
	$(CC) $(FRAMEWORKS) $^ -o $(EXEC)

main.o:main.m Player.o Playlist.o
	$(CC) -c $< -o $@

Player.o:Player.m Player.h Playlist.o constants.h
	$(CC) -c $< -o $@

Playlist.o:Playlist.m Playlist.h constants.h
	$(CC) -c $< -o $@
