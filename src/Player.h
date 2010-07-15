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
 * Player.h
 *
 * The class Player takes care of sounds. It reads them from the playlist
 * and genrates an array of songs according to mode (randomly if specified).
 */

#import <Cocoa/Cocoa.h>

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

