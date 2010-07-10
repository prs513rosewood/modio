#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include <time.h>
#include <stdlib.h>
#import "constants.h"
#import "Player.h"
#import "Playlist.h"

#define USAGE() printf ("usage: modio file ...\n       modio -p playlist\n")

int main (int argc, char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSArray * args = [[NSProcessInfo processInfo] arguments];
	BOOL playlist_mode = NO;

	srand(time(NULL));

	if (argc < 2) {
		USAGE();
		return EXIT_FAILURE;
	}

	playlist_mode = [[args objectAtIndex:1] isEqualToString:@"-p"];
	Playlist * list = nil;

	if (playlist_mode  && !(argc < 3)) {
		list = [[Playlist alloc] initWithFile:[args objectAtIndex:2]];
	}
	
	else if (playlist_mode && argc < 3) {
		USAGE();
		return EXIT_FAILURE;
	}

	else {
		list = [[Playlist alloc] initWithArray:[args subarrayWithRange:NSMakeRange(1, argc - 1)]];
	}

	Player * player = [[Player alloc] initWithPlaylist:list];
	[player play];
	[list release];
	[player release];

	[pool drain];
	return EXIT_SUCCESS;
}
