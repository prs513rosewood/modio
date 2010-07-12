CC=gcc
FLAGS=-W -Wall
EXEC=modio
PREFIX=/usr/local

main.o:main.m Player.o Playlist.o
	$(CC) $(FLAGS) -c $< -o $@

Player.o:Player.m Player.h constants.h
	$(CC) $(FLAGS) -c $< -o $@

Playlist.o:Playlist.m Playlist.h constants.h
	$(CC) $(FLAGS) -c $< -o $@

clean:
	rm -f *.o
