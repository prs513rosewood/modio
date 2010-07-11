/*
Copyright (C) 2010  Lucas Frérot

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/* 
 * Player.m
 *
 * Implements the Player class.
 */

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

