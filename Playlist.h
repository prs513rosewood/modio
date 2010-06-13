#import <Foundation/Foundation.h>
#import "constants.h"

@interface Playlist : NSObject
{
	NSMutableArray * songs;
	NSMutableArray * lines;
	int mode;
}

- (id) initWithFile:(NSString *) fileName;
- (int) mode;
- (id) songs;
- (void) dealloc;

@end

