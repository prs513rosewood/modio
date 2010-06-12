#import "Playlist.h"

@implementation Playlist

- (id) initWithFile:(NSString *) fileName
{
	if (self = [super init]) {
		lines = [[NSMutableArray alloc] init];
		songs = [[NSMutableArray alloc] init];
		NSString * contents = [NSString stringWithContentsOfFile:fileName];
		NSString * aLine = nil, prefix = nil;
		NSRange range = NSMakeRange(0, 0);
		int i;

		for (i = 0 ; i < [contents length] ; i++) {
			if ([contents caracterAtIndex:i] == '\n') {
				range.length = i - range.location;
				[lines addObject:[contents substringWithRange:range]];
				range.location = i + 1;
			}
		}

		for (aLine in lines) {
			switch ([aLine characterAtIndex:0]) {
				case ':':
					prefix = [NSString stringWithstring:[aLine substringFromIndex:1]];
					break;
				case '!':
					if (([aLine rangeOfString:@"rand"]).location != NSNotFound)
						mode |= RAND;
					if (([aLine rangeOfString:@"loop"]).location != NSNotFound)
						mode |= LOOP;
					break;
				case '>':
					[songs addObject:[prefix stringByAppndingString:[aLine substringFromIndex:1]];
					break;
				default:
					break;
			}
		}

	}

	return self;
}

- (id) songs
{
	return [[songs retain] autorelease];
}

- (void) dealloc
{
	[lines release];
	[songs release];
	[super dealloc];
}

@end

