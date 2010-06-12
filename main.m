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
	NSData * soundSource = nil;
	NSString * fileName;
	NSSound * music = nil;
	NSEnumerator * enumerator = nil;

	if (argc < 2) {
		printf ("usage: modio filename ...\n");
		return -1;
	}

	enumerator = [[args subarrayWithRange:NSMakeRange(1, argc - 1)] objectEnumerator];

	while (fileName = [enumerator nextObject]) {
		if (!(soundSource = [NSData dataWithContentsOfFile:fileName])) {
			printf ("file not found: %s\n", [fileName UTF8String]);
		}

		else {
			music = [[NSSound alloc] initWithData:soundSource];
			if (!music) {
				printf ("could not read file: %s\n", [fileName UTF8String]);
			}

			else {
				PLAY(music);
				[music release];
				music = nil;
			}
		}
	}
	[pool drain];
	return 0;
}
