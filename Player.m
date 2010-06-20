#import "Player.h"

@implementation Player

- (id) initWithPlaylist:(Playlist *) _playlist
{
	if (( self = [super init] )) {
		playlist = [_playlist retain];
	}

	return self;
}

- (void) play
{
	NSString * songName = nil;
	NSMutableArray * songs = [NSMutableArray array], * playSongs = [playlist songs];
	unsigned int random_index = 0, i;
	BOOL done = NO;

	do {
		if ( [playlist mode] & RAND) {
			for (i = 0 ; i < [playSongs count] ; i++) {
				random_index = rand() % [playSongs count];
				[songs addObject:[playSongs objectAtIndex:random_index]];
				[playSongs removeObjectAtIndex:random_index];
			}
		}

		else
			[songs setArray:playSongs];

		if ( [playlist mode] & LOOP) {
			done = YES;
		}
		for (songName in songs) {
			NSData * source = [NSData dataWithContentsOfFile:songName];

			if (!source) {
				printf("file not found: %s\n", [songName UTF8String]);
				exit (EXIT_FAILURE);
			}

			NSSound * music = [[NSSound alloc] initWithData:source];

			if (!music) {
				printf ("could not read file : %s\n", [songName UTF8String]);
				exit(EXIT_FAILURE);
			}

			PLAY(music);
			[music release];
		}
	} while (done);
}

- (void) dealloc
{
	[playlist release];
	[super dealloc];
}

@end

