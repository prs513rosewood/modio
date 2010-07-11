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
 * Playlist.h
 *
 * Playlist is a class that handles an array of songs, which can be read
 * from another array, or from a file.
 * The variable mode tells us to read the playlist randomly and/or
 * to repeat it.
 */

#import <Foundation/Foundation.h>
#import "constants.h"

@interface Playlist : NSObject
{
	NSMutableArray * songs;
	int mode;
}

- (id) initWithFile:(NSString *) fileName;
- (id) initWithArray:(NSArray *) array;
- (int) mode;
- (id) songs;
- (void) dealloc;

@end

