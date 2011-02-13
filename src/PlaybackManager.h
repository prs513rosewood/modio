#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreFoundation/CoreFoundation.h>

#define kNumberBuffers 3

struct AQPlayerState
{
	AudioStreamBasicDescription		mDataFormat;
	AudioQueueRef					mQueue;
	AudioQueueBufferRef				mBuffers[kNumberBuffers];
	AudioFileID						mAudioFile;
	UInt32							bufferByteSize;
	SInt64							mCurrentPacket;
	UInt32							mNumPacketsToRead;
	AudioStreamPacketDescription	*mPacketDescs;
	BOOL							mIsRunning;
};

void HandleOutputBuffer (
		void				*aqData,
		AudioQueueRef		inAQ,
		AudioQueueBufferRef	inBuffer
);

@interface PlaybackManager : NSObject
{
	struct AQPlayerState aqData;
}

- (id) initWithFile:(NSString *) filePath;
- (void) play;
- (void) dealloc;

@end
