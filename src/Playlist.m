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
		NSError * error = nil;
		NSString * contents = [NSString stringWithContentsOfFile:fileName encoding:4 error:&error];

		if (!contents && error) {
			NSString * errorDescription = [[error localizedDescription] stringByReplacingOccurrencesOfString:@"file" withString:@"playlist" options:0 range:NSMakeRange(4, 7)];
			fprintf(stderr, "error: %s\n", [errorDescription UTF8String]);
			exit ( [error code] );
		}

		NSArray * lines = [contents componentsSeparatedByString:@"\n"];
		NSFileManager * helper = [[[NSFileManager alloc] init] autorelease];
		NSString * prefix = nil, * songPath = nil;
		BOOL exists, isDir;

		songs = [[NSMutableArray alloc] init];

		for (id aLine in lines) {
			if ( [aLine length]  && ([aLine length] - 1)) {
				switch ([aLine characterAtIndex:0]) {
					case ':':
						prefix = [[[aLine substringFromIndex:1] stringByStandardizingPath] stringByAppendingString:@"/"];
						exists = [helper fileExistsAtPath:prefix isDirectory:&isDir];

						if (!exists || !isDir) {
							NSString * errorString = [NSString stringWithFormat:@"The directory \“%@\” doesn't exist.", prefix];
							fprintf(stderr, "error: %s\n", [errorString UTF8String]);
							exit(EXIT_FAILURE);
						}

						break;
					case '!':
						if (([aLine rangeOfString:@"rand"]).location != NSNotFound)
							mode |= RAND;
						if (([aLine rangeOfString:@"loop"]).location != NSNotFound)
							mode |= LOOP;
						break;
					case '>':
						if ( [aLine characterAtIndex:1] == '>') {
							NSDirectoryEnumerator * e = [helper enumeratorAtPath:prefix];
							NSString * file = nil;

							while (( file = [e nextObject] )) {
								[helper fileExistsAtPath:[prefix stringByAppendingString:file] isDirectory:&isDir];

								if (!isDir)
									[songs addObject:[prefix stringByAppendingString:file]];
							}
						}

						else {
							songPath = [aLine substringFromIndex:1];
							if ( [songPath isAbsolutePath] )
								[songs addObject:songPath];
							else
								[songs addObject:[prefix stringByAppendingString:songPath]];
						}
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

