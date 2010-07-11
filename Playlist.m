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
 * Playlist.m
 *
 * Implments the Playlist class.
 */

#import "Playlist.h"

@implementation Playlist

- (id) initWithFile:(NSString *) fileName
{
	if (( self = [super init] )) {
		NSString * contents = [NSString stringWithContentsOfFile:fileName];

		if (!contents) {
			printf ("file not found: %s\n", [fileName UTF8String]);
			exit (EXIT_FAILURE);
		}

		songs = [[NSMutableArray alloc] init];
		NSMutableArray * lines = [NSMutableArray array];
		NSString * aLine = nil, * prefix = nil;
		NSRange range = NSMakeRange(0, 0);
		unsigned int i;

		for (i = 0 ; i < [contents length] ; i++) {
			if ([contents characterAtIndex:i] == '\n') {
				range.length = i - range.location;
				[lines addObject:[contents substringWithRange:range]];
				range.location = i + 1;
			}
		}

		for (aLine in lines) {
			if ( [aLine isEqualToString:@""] != YES) {
				switch ([aLine characterAtIndex:0]) {
					case ':':
						if ( [aLine characterAtIndex:[aLine length] - 1] == '/')
							prefix = [aLine substringFromIndex:1];
						else
							prefix = [[aLine substringFromIndex:1] stringByAppendingString:@"/"];
						break;
					case '!':
						if (([aLine rangeOfString:@"rand"]).location != NSNotFound)
							mode |= RAND;
						if (([aLine rangeOfString:@"loop"]).location != NSNotFound)
							mode |= LOOP;
						break;
					case '>':
						[songs addObject:[prefix stringByAppendingString:[aLine substringFromIndex:1]]];
						break;
					default:
						break;
				}
			}
		}

	}
	return self;
}

- (id) initWithArray:(NSArray *) array
{
	if (( self = [super init] )) {
		songs = [array retain];
	}
	return self;
}

- (int) mode
{
	return mode;
}

- (id) songs
{
	return [[songs retain] autorelease];
}

- (void) dealloc
{
	[songs release];
	[super dealloc];
}

@end

