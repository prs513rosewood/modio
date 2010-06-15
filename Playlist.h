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

