#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include <stdlib.h>

int main (int argc, char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSSound * sound = [[NSSound alloc] initWithContentsOfFile:@"sound.mp3" byReference:NO];
	[sound play];
	sleep ( [sound duration] );
	[sound stop];
	[sound release];

	[pool drain];
	return 0;
}
