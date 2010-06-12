all:main.m
	gcc -x objective-c -framework Foundation $^ -o modio

