FRAMEWORKS	=	-framework Cocoa
CC		=	gcc

PPC_PREFIX	=	objects/ppc
I386_PREFIX	=	objects/i386
EXEC_PPC	=	$(PPC_PREFIX)/modio
EXEC_I386	=	$(I386_PREFIX)/modio
EXEC		=	modio
PPC		=	-arch ppc
I386		=	-arch i386
PREFIX		=	/usr/local
SRC		=	src

.PHONY:objects-ppc, objects-i386, install, clean

all:universal

universal:ppc i386
	lipo -create $(EXEC_PPC) $(EXEC_I386) -output $(EXEC)


#
# ppc architecture
#

ppc:$(EXEC_PPC)

$(EXEC_PPC):objects-ppc
	$(CC) $(PPC) $(FRAMEWORKS) $(PPC_PREFIX)/*.o -o $(EXEC_PPC)
objects-ppc:
	make -C $(SRC) ppc

#
# i386 architecture
#

i386:$(EXEC_I386)

$(EXEC_I386):objects-i386
	$(CC) $(I386) $(FRAMEWORKS) $(I386_PREFIX)/*.o -o $(EXEC_I386)
objects-i386:
	make -C $(SRC) i386

# Other targets

install:
	mkdir -p $(PREFIX)/bin
	install $(EXEC) $(PREFIX)/bin
distclean:clean
	rm -rf $(EXEC) objects/ 
clean:
	make -C $(SRC) clean
