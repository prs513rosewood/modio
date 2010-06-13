#import "Player.h"

@implementation Player

- (id) initWithPlaylist:(Playlist *) _playlist
{
	if (self = [super init]) {
		playlist = [_playlist retain];
	}

	return self;
}

- (void) play
{
	NSString * songName = nil;
	NSData * source = nil;
	NSSound * music = nil;

	for (songName in [playlist songs]) {
		source = [NSData dataWithContentsOfFile:songName];

		if (!source) {
			printf("file not found: %s\n", [songName UTF8String]);
			exit (EXIT_FAILURE);
		}

		music = [[NSSound alloc] initWithData:source];

		if (!music) {
			printf ("could not read file : %s\n", [songName UTF8String]);
			exit(EXIT_FAILURE);
		}

		PLAY(music);
		[music release];
		music = nil;
		source = nil;
	}
}

- (void) dealloc
{
	[playlist release];
	[super dealloc];
}

@end

