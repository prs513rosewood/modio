FRAMEWORKS=-framework Foundation -framework AppKit
CC=gcc
EXEC=modio
PREFIX=/usr/local
SRC=src

all:$(EXEC)

$(EXEC):objects
	$(CC) $(FRAMEWORKS) $(SRC)/*.o -o $(EXEC)

.PHONY:objects
objects:
	make -C $(SRC)

.PHONY:install
install:
	mkdir -p $(PREFIX)/bin
	install $(EXEC) $(PREFIX)/bin

distclean:clean
	rm -f $(EXEC)

.PHONY:clean
clean:
	make -C $(SRC) clean
