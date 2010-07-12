FRAMEWORKS=-framework Foundation -framework AppKit
CC=gcc
EXEC=modio
PREFIX=/usr/local
SRC=src

all:
	make -C $(SRC)
	$(CC) $(FRAMEWORKS) $(SRC)/*.o -o $(EXEC)

install:
	mkdir -p $(PREFIX)/bin
	install $(EXEC) $(PREFIX)/bin

distclean:clean
	rm -f $(EXEC)

clean:
	make -C $(SRC) clean
