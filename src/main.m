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
 * main.m
 *
 * Reads arguments and initializes playlist and player instances
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include <time.h>
#include <stdlib.h>
#import "constants.h"
#import "Player.h"
#import "Playlist.h"

#define USAGE() fprintf (stderr, "usage: modio file ...\n       modio -p playlist\n")

int main (int argc, char * argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSArray * args = [[NSProcessInfo processInfo] arguments];
	BOOL playlist_mode = NO;

	srand(time(NULL));

	if (argc < 2) {
		USAGE();
		return EXIT_FAILURE;
	}

	playlist_mode = [[args objectAtIndex:1] isEqualToString:@"-p"];
	Playlist * list = nil;

	if (playlist_mode  && !(argc < 3)) {
		list = [[Playlist alloc] initWithFile:[args objectAtIndex:2]];
	}
	
	else if (playlist_mode && argc < 3) {
		USAGE();
		return EXIT_FAILURE;
	}

	else {
		list = [[Playlist alloc] initWithArray:[args subarrayWithRange:NSMakeRange(1, argc - 1)]];
	}

	Player * player = [[Player alloc] initWithPlaylist:list];
	[player play];
	[list release];
	[player release];

	[pool drain];
	return EXIT_SUCCESS;
}
