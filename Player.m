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

}

- (void) dealloc
{
	[playlist release];
	[super dealloc];
}

@end

