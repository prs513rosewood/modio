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
		playlist = (_playlist == nil) ? nil : [_playlist retain];
	}

	return self;
}

- (void) shuffleArray:(NSMutableArray *) array
{
	unsigned int randIndex = 0, i;
	const unsigned int count = [array count];

	for (i = 0 ; i < count ; i++) {
		randIndex = rand() % (count - i) + i;
		[array insertObject:[array objectAtIndex:randIndex] atIndex:i];
		[array removeObjectAtIndex:randIndex + 1];
	}
}

- (NSData *) getData:(NSString *) file
{
	NSError * error = nil;
	NSData * data = [NSData dataWithContentsOfFile:file options:0 error:&error];

	if (!data && error) {
		NSString * errorDescription = [error localizedDescription];
		fprintf (stderr, "error: %s\n", [errorDescription UTF8String]);
	}

	return data;

}

- (void) play
{
	if (playlist == nil)
		return;

	NSMutableArray * songs = [playlist songs];
	NSString * songName = nil;
	unsigned int i;
	BOOL done = NO;

	do {
		if ( [playlist mode] & RAND)
			[self shuffleArray:songs];

		if ( [playlist mode] & LOOP)
			done = YES;

		for (i = 0 ; i < [songs count] ; i++) {
			songName = [songs objectAtIndex:i];
			PlaybackManager * manager = [[PlaybackManager alloc] initWithFile:songName];

			if (!manager) {
				[songs removeObject:songName];
				i--;
			}

			else {
				[manager play];
				[manager release];
			}
		}

		if ([songs count] == 0)
			done = NO;
	} while (done);
}

- (void) dealloc
{
	[playlist release];
	[super dealloc];
}

@end

