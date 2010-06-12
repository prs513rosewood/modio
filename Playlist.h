#import <Foundation/Foundation.h>

@interface Playlist : NSObject
{
	NSArray * songs;
	int mode;
}

- (id) initWithFile:(NSString *) fileName;

@end

