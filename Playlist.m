#import "Playlist.h"

@implementation Playlist

- (id) initWithFile:(NSString *) fileName
{
	if (( self = [super init] )) {
		songs = [[NSMutableArray alloc] init];
		NSMutableArray * lines = [NSMutableArray array];
		NSString * contents = [NSString stringWithContentsOfFile:fileName];
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

