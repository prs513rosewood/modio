FRAMEWORKS=-framework Foundation -framework AppKit
CC=gcc
EXEC=modio

all:main.m
	$(CC) $(FRAMEWORKS) $^ -o $(EXEC)

