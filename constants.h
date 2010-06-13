#ifndef CONSTS_H
#define CONSTS_H

#define PLAY(x) [x play];\
		sleep ( [x duration] );\
		[x stop]

enum {
	RAND = 1 << 0,
	LOOP = 1 << 1
};

#endif

