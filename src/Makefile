PPC_PREFIX	=	../objects/ppc
I386_PREFIX	=	../objects/i386

CC		=	gcc
FLAGS		=	-W -Wall
PPC		=	-arch ppc
I386		=	-arch i386

.PHONY:prefix-ppc, prefix-i386, clean

#
# ppc architecture
#

ppc:prefix-ppc $(PPC_PREFIX)/main.o $(PPC_PREFIX)/Player.o $(PPC_PREFIX)/Playlist.o

$(PPC_PREFIX)/main.o:main.m $(PPC_PREFIX)/Player.o $(PPC_PREFIX)/Playlist.o
	$(CC) $(PPC) $(FLAGS) -c $< -o $@

$(PPC_PREFIX)/Player.o:Player.m Player.h constants.h
	$(CC) $(PPC) $(FLAGS) -c $< -o $@

$(PPC_PREFIX)/Playlist.o:Playlist.m Playlist.h constants.h
	$(CC) $(PPC) $(FLAGS) -c $< -o $@

#
# i386 architecture
#

i386:prefix-i386 $(I386_PREFIX)/main.o $(I386_PREFIX)/Player.o $(I386_PREFIX)/Playlist.o

$(I386_PREFIX)/main.o:main.m $(I386_PREFIX)/Player.o $(I386_PREFIX)/Playlist.o
	$(CC) $(I386) $(FLAGS) -c $< -o $@

$(I386_PREFIX)/Player.o:Player.m Player.h constants.h
	$(CC) $(I386) $(FLAGS) -c $< -o $@

$(I386_PREFIX)/Playlist.o:Playlist.m Playlist.h constants.h
	$(CC) $(I386) $(FLAGS) -c $< -o $@

# Other targets

prefix-ppc:
	mkdir -p $(PPC_PREFIX)
prefix-i386:
	mkdir -p $(I386_PREFIX)
clean:
	rm -f $(PPC_PREFIX)/*.o
	rm -f $(I386_PREFIX)/*.o
