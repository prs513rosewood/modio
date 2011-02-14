PPC_PREFIX	=	../objects/ppc
I386_PREFIX	=	../objects/i386
X86_64_PREFIX =	../objects/x86_64

CC		=	gcc
FLAGS		=	-W -Wall
PPC		=	-arch ppc
I386		=	-arch i386
X86_64	=	-arch x86_64

.PHONY:prefix-ppc, prefix-i386, prefix-x86_64, clean

#
# ppc architecture
#

ppc:prefix-ppc\
	$(PPC_PREFIX)/main.o\
	$(PPC_PREFIX)/Player.o\
	$(PPC_PREFIX)/Playlist.o\
	$(PPC_PREFIX)/AudioQueueUtils.o\
	$(PPC_PREFIX)/PlaybackManager.o


$(PPC_PREFIX)/main.o:main.m $(PPC_PREFIX)/Player.o $(PPC_PREFIX)/Playlist.o
	$(CC) $(PPC) $(FLAGS) -c $< -o $@

$(PPC_PREFIX)/Player.o:Player.m Player.h constants.h
	$(CC) $(PPC) $(FLAGS) -c $< -o $@

$(PPC_PREFIX)/Playlist.o:Playlist.m Playlist.h constants.h
	$(CC) $(PPC) $(FLAGS) -c $< -o $@

$(PPC_PREFIX)/AudioQueueUtils.o:AudioQueueUtils.m AudioQueueUtils.h constants.h
	$(CC) $(PPC) $(FLAGS) -c $< -o $@

$(PPC_PREFIX)/PlaybackManager.o:PlaybackManager.m PlaybackManager.h constants.h
	$(CC) $(PPC) $(FLAGS) -c $< -o $@

#
# i386 architecture
#

i386:prefix-i386\
	$(I386_PREFIX)/main.o\
	$(I386_PREFIX)/Player.o\
	$(I386_PREFIX)/Playlist.o\
	$(I386_PREFIX)/AudioQueueUtils.o\
	$(I386_PREFIX)/PlaybackManager.o

$(I386_PREFIX)/main.o:main.m $(I386_PREFIX)/Player.o $(I386_PREFIX)/Playlist.o
	$(CC) $(I386) $(FLAGS) -c $< -o $@

$(I386_PREFIX)/Player.o:Player.m Player.h constants.h
	$(CC) $(I386) $(FLAGS) -c $< -o $@

$(I386_PREFIX)/Playlist.o:Playlist.m Playlist.h constants.h
	$(CC) $(I386) $(FLAGS) -c $< -o $@

$(I386_PREFIX)/AudioQueueUtils.o:AudioQueueUtils.m AudioQueueUtils.h constants.h
	$(CC) $(I386) $(FLAGS) -c $< -o $@

$(I386_PREFIX)/PlaybackManager.o:PlaybackManager.m PlaybackManager.h constants.h
	$(CC) $(I386) $(FLAGS) -c $< -o $@

#
# x86_64 architecture
#

x86_64:prefix-x86_64\
	$(X86_64_PREFIX)/main.o\
	$(X86_64_PREFIX)/Player.o\
	$(X86_64_PREFIX)/Playlist.o\
	$(X86_64_PREFIX)/AudioQueueUtils.o\
	$(X86_64_PREFIX)/PlaybackManager.o

$(X86_64_PREFIX)/main.o:main.m $(X86_64_PREFIX)/Player.o $(X86_64_PREFIX)/Playlist.o 
	$(CC) $(X86_64) $(FLAGS) -c $< -o $@

$(X86_64_PREFIX)/Player.o:Player.m Player.h constants.h
	$(CC) $(X86_64) $(FLAGS) -c $< -o $@

$(X86_64_PREFIX)/Playlist.o:Playlist.m Playlist.h constants.h
	$(CC) $(X86_64) $(FLAGS) -c $< -o $@

$(X86_64_PREFIX)/AudioQueueUtils.o:AudioQueueUtils.m AudioQueueUtils.h constants.h
	$(CC) $(X86_64) $(FLAGS) -c $< -o $@

$(X86_64_PREFIX)/PlaybackManager.o:PlaybackManager.m PlaybackManager.h constants.h
	$(CC) $(X86_64) $(FLAGS) -c $< -o $@

# Other targets

prefix-ppc:
	mkdir -p $(PPC_PREFIX)
prefix-i386:
	mkdir -p $(I386_PREFIX)
prefix-x86_64:
	mkdir -p $(X86_64_PREFIX)
clean:
	rm -f $(PPC_PREFIX)/*.o
	rm -f $(I386_PREFIX)/*.o
	rm -f $(X86_64_PREFIX)/*.o
