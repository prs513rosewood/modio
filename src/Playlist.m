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
		NSArray * lines = [self contentsOfPlaylist:fileName];
		songs = [[NSMutableArray alloc] init];

		if (lines == nil)
			return nil;

		NSString * prefix = nil, * songPath = nil;

		for (id aLine in lines) {
			if ( [aLine length]  && ([aLine length] - 1)) {
				switch ([aLine characterAtIndex:0]) {
					case ':':
						prefix = [self makePrefix:[aLine substringFromIndex:1]];
						break;
					case '!':
						if (([aLine rangeOfString:@"rand"]).location != NSNotFound)
							mode |= RAND;
						if (([aLine rangeOfString:@"loop"]).location != NSNotFound)
							mode |= LOOP;
						break;
					case '>':
						if ( [aLine characterAtIndex:1] == '>') {
							if (prefix == nil)
								break;

							[songs addObjectsFromArray:[self enumerateDirectory:prefix]];
						}

						else {
							songPath = [aLine substringFromIndex:1];
							if ( [songPath isAbsolutePath] || !prefix)
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

- (NSArray *) contentsOfPlaylist:(NSString *) fileName
{
	NSError * error = nil;
	NSString * contents = [NSString stringWithContentsOfFile:fileName encoding:4 error:&error];

	if (!contents && error) {
		NSString * errorDescription = [[error localizedDescription] stringByReplacingOccurrencesOfString:@"file" withString:@"playlist" options:0 range:NSMakeRange(4, 7)];
		fprintf(stderr, "error: %s\n", [errorDescription UTF8String]);
		return nil;
	}

	return [contents componentsSeparatedByString:@"\n"];

}

- (NSString *) makePrefix:(NSString*) str
{
	BOOL exists, isDir;
	NSFileManager * helper = [[[NSFileManager alloc] init] autorelease];
	NSString * newPrefix = [[str stringByStandardizingPath] stringByAppendingString:@"/"];
	exists = [helper fileExistsAtPath:newPrefix isDirectory:&isDir];

	if (!exists || !isDir) {
		NSString * errorString = [NSString stringWithFormat:@"The directory \“%@\” doesn't exist.", newPrefix];
		fprintf(stderr, "error: %s\n", [errorString UTF8String]);
		return nil;
	}
	return newPrefix;
}

- (NSMutableArray *) enumerateDirectory:(NSString *) dir
{
	NSFileManager * helper = [[[NSFileManager alloc] init] autorelease];
	NSDirectoryEnumerator * e = [helper enumeratorAtPath:dir];
	NSMutableArray * array = [NSMutableArray array];
	NSString * file = nil;
	BOOL isDir;

	while (( file = [e nextObject] )) {
		[helper fileExistsAtPath:[dir stringByAppendingString:file] isDirectory:&isDir];

		if (!isDir)
			[array addObject:[dir stringByAppendingString:file]];
	}
	return array;
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

