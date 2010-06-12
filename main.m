#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include <stdlib.h>

#define PLAY(sound) [sound play];\
		sleep ( [sound duration] );\
		[sound stop];

int main (int argc, char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSArray * args = [[NSProcessInfo processInfo] arguments];

	if ( [args count] == 1) {
		exit (-1);
	}

	NSData * soundSource = [NSData dataWithContentsOfFile:[args objectAtIndex:1]];

	if (!soundSource)
		exit(-1);

	NSSound * music = [[NSSound alloc] initWithData:soundSource];
	PLAY(music);
	[music release];
	[pool drain];
	return 0;
}
