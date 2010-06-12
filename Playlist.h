#import <Foundation/Foundation.h>
#import "constants.h"

@interface Playlist : NSObject
{
	NSMutableArray * songs;
	NSMutableArray * lines;
	int mode;
}

- (id) initWithFile:(NSString *) fileName;
- (id) songs;
- (void) dealloc;

@end

