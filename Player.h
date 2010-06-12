#import <Foundation/Foundation.h>
#import "Playlist.h"

@interface Player : NSObject
{
	Playlist * playlist;
}

- (id) initWithPlaylist:(Playlist *) _playlist;
- (void) play;
- (void) dealloc;

@end
