#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include <time.h>
#include <stdlib.h>
#import "constants.h"
#import "Player.h"
#import "Playlist.h"

#define USAGE() printf ("usage: modio [-p] file ...\n")

int main (int argc, char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSArray * args = [[NSProcessInfo processInfo] arguments];
	NSEnumerator * e = nil;
	NSString * arg = nil;

	srand(time(NULL));

	if (argc < 2) {
		USAGE();
		return EXIT_FAILURE;
	}

	if ( [[args objectAtIndex:1] isEqualToString:@"-p"] ) {
		if (!(argc < 3)) {
			e = [[args subarrayWithRange:NSMakeRange(2, argc - 2)] objectEnumerator];

			while (( arg = [e nextObject] )) {
				Playlist * list = [[Playlist alloc] initWithFile:arg];
				Player * player = [[Player alloc] initWithPlaylist:list];
				[player play];
				[list release];
				[player release];
			}
		}
		else {
			USAGE();
			return EXIT_FAILURE;
		}
	}

	else {
		Playlist * list = [[Playlist alloc] initWithArray:[args subarrayWithRange:NSMakeRange(1, argc - 1)]];
		Player * player = [[Player alloc] initWithPlaylist:list];
		[player play];
		[list release];
		[player release];
	}

	[pool drain];
	return EXIT_SUCCESS;
}
