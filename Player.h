#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <time.h>
#import <stdlib.h>
#import <stdio.h>
#import "Playlist.h"
#import "constants.h"

@interface Player : NSObject
{
	Playlist * playlist;
}

- (id) initWithPlaylist:(Playlist *) _playlist;
- (void) play;
- (void) dealloc;

@end

