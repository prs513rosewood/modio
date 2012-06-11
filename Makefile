FRAMEWORKS	=	-framework Foundation -framework CoreFoundation -framework CoreAudio -framework AudioToolbox
CC			=	gcc

I386_PREFIX	=	objects/i386
X86_64_PREFIX = objects/x86_64
EXEC_PPC	=	$(PPC_PREFIX)/modio
EXEC_I386	=	$(I386_PREFIX)/modio
EXEC_X86_64 =	$(X86_64_PREFIX)/modio
EXEC		=	modio
I386		=	-arch i386
X86_64		=	-arch x86_64
PREFIX		=	/usr/local
SRC			=	src

.PHONY:objects-i386, objects-x86_64, install, clean

all:universal

universal:i386 x86_64
	lipo -create $(EXEC_I386) $(EXEC_X86_64) -output $(EXEC)


#
# i386 architecture
#

i386:$(EXEC_I386)

$(EXEC_I386):objects-i386
	$(CC) $(I386) $(FRAMEWORKS) $(I386_PREFIX)/*.o -o $(EXEC_I386)
objects-i386:
	make -C $(SRC) i386

#
# x86_64 architecture
#

x86_64:$(EXEC_X86_64)

$(EXEC_X86_64):objects-x86_64
	$(CC) $(X86_64) $(FRAMEWORKS) $(X86_64_PREFIX)/*.o -o $(EXEC_X86_64)
objects-x86_64:
	make -C $(SRC) x86_64

# Other targets

install:
	mkdir -p $(PREFIX)/bin
	install $(EXEC) $(PREFIX)/bin
distclean:clean
	rm -rf $(EXEC) objects/ 
clean:
	make -C $(SRC) clean
