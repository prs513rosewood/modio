#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreFoundation/CoreFoundation.h>

#import "constants.h"
#import "AudioQueueUtils.h"

@interface PlaybackManager : NSObject
{
	struct AQPlayerState aqData;
}

- (id) initWithFile:(NSString *) filePath;
- (void) play;
- (void) dealloc;

@end
