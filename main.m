#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include <stdlib.h>
#import "constants.h"
#import "Player.h"
#import "Playlist.h"

int main (int argc, char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSArray * args = [[NSProcessInfo processInfo] arguments];
	Playlist * list = [[Playlist alloc] initWithFile:[args objectAtIndex:1]];
	Player * player = [[Player alloc] initWithPlaylist:list];

	[player play];
	[list release];
	[player release];
	[pool drain];
	return EXIT_SUCCESS;
}
