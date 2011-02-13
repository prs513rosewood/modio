#import <AudioToolbox/AudioToolbox.h>
#import "constants.h"

#ifndef AUDIOQUEUEUTILS_H
#define AUDIOQUEUEUTILS_H

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

void DeriveBufferSize (
		AudioStreamBasicDescription ASBDesc,
		UInt32						maxPacketSize,
		Float64						seconds,
		UInt32						*outBufferSize,
		UInt32						*outNumPacketsToRead
);

#endif

