#import "PlaybackManager.h"

void HandleOutputBuffer (
		void                *aqData,
		AudioQueueRef       inAQ,
		AudioQueueBufferRef inBuffer
)
{
	struct AQPlayerState *pAqData = (struct AQPlayerState *) aqData;        // 1
	static end = 0;
	if (pAqData->mIsRunning == NO) {
		return;
	}
	UInt32 numBytesReadFromFile;                              // 3
	UInt32 numPackets = pAqData->mNumPacketsToRead;           // 4
	AudioFileReadPackets (
			pAqData->mAudioFile,
			NO,
			&numBytesReadFromFile,
			pAqData->mPacketDescs, 
			pAqData->mCurrentPacket,
			&numPackets,
			inBuffer->mAudioData 
			);

	if (numPackets > 0) {                                     // 5
		inBuffer->mAudioDataByteSize = numBytesReadFromFile;  // 6
		AudioQueueEnqueueBuffer ( 
				pAqData->mQueue,
				inBuffer,
				(pAqData->mPacketDescs ? numPackets : 0),
				pAqData->mPacketDescs
				);
		pAqData->mCurrentPacket += numPackets;                // 7 
	} else {
		end++;
		AudioQueueStop (
				pAqData->mQueue,
				NO
				);
		if (end == kNumberBuffers)
			pAqData->mIsRunning = NO; 
	}
}

void DeriveBufferSize (
		AudioStreamBasicDescription ASBDesc,
		UInt32						maxPacketSize,
		Float64						seconds,
		UInt32						*outBufferSize,
		UInt32						*outNumPacketsToRead
)
{
	static const int maxBufferSize = 0x50000;
	static const int minBufferSize = 0x4000;

	if (ASBDesc.mFramesPerPacket != 0) {
		Float64 numPacketsForTime = ASBDesc.mSampleRate / ASBDesc.mFramesPerPacket * seconds;
		*outBufferSize = numPacketsForTime * maxPacketSize;
	}

	else {
		*outBufferSize = (maxBufferSize > maxPacketSize) ? maxBufferSize : maxPacketSize;
	}

	if (*outBufferSize > maxBufferSize && *outBufferSize > maxPacketSize) {
		*outBufferSize = maxBufferSize;
	}

	else {
		if (*outBufferSize < minBufferSize) {
			*outBufferSize = minBufferSize;
		}
	}

	*outNumPacketsToRead = *outBufferSize / maxPacketSize;
}

@implementation PlaybackManager

- (id) initWithFile:(NSString *) filePath
{
	if (( self = [super init] )) {
		int i;
		NSURL * fileURL = [NSURL fileURLWithPath:filePath];
		OSStatus result = AudioFileOpenURL((CFURLRef) fileURL, fsRdPerm, 0, &aqData.mAudioFile);
		UInt32 dataFormatSize = sizeof (aqData.mDataFormat);

		AudioFileGetProperty(
				aqData.mAudioFile,
				kAudioFilePropertyDataFormat,
				&dataFormatSize,
				&aqData.mDataFormat
		);

		AudioQueueNewOutput(
				&aqData.mDataFormat,
				HandleOutputBuffer,
				&aqData,
				CFRunLoopGetCurrent(),
				kCFRunLoopCommonModes,
				0,
				&aqData.mQueue
		);

		UInt32 maxPacketSize;
		UInt32 propertySize = sizeof (maxPacketSize);
		AudioFileGetProperty(
				aqData.mAudioFile,
				kAudioFilePropertyPacketSizeUpperBound,
				&propertySize,
				&maxPacketSize
		);

		DeriveBufferSize(
				aqData.mDataFormat,
				maxPacketSize,
				0.5,
				&aqData.bufferByteSize,
				&aqData.mNumPacketsToRead
		);


		BOOL isFormatVBR = (
				aqData.mDataFormat.mBytesPerPacket == 0 ||
				aqData.mDataFormat.mFramesPerPacket == 0
		);

		if (isFormatVBR) {
			aqData.mPacketDescs = 
				(AudioStreamPacketDescription *) malloc(
						aqData.mNumPacketsToRead * sizeof (AudioStreamPacketDescription)
				);
		}

		else {
			aqData.mPacketDescs = NULL;
		}

		UInt32 cookieSize = sizeof (UInt32);
		BOOL couldNotGetProperty = 
			AudioFileGetPropertyInfo(
					aqData.mAudioFile,
					kAudioFilePropertyMagicCookieData,
					&cookieSize,
					NULL
			);

		if (!couldNotGetProperty && cookieSize) {
			char * magicCookie = (char *) malloc (cookieSize);

			AudioFileGetProperty(
					aqData.mAudioFile,
					kAudioFilePropertyMagicCookieData,
					&cookieSize,
					magicCookie
			);

			AudioQueueSetProperty(
					aqData.mQueue,
					kAudioQueueProperty_MagicCookie,
					magicCookie,
					cookieSize
			);

			free(magicCookie);
		}

		aqData.mCurrentPacket = 0;
		aqData.mIsRunning = YES;
		for (i = 0 ; i < kNumberBuffers ; i++) {
			AudioQueueAllocateBuffer(
					aqData.mQueue,
					aqData.bufferByteSize,
					&aqData.mBuffers[i]
			);

			HandleOutputBuffer(
					&aqData,
					aqData.mQueue,
					aqData.mBuffers[i]
			);
		}
		aqData.mIsRunning = NO;

		Float32 gain = 1.0;

		AudioQueueSetParameter(
				aqData.mQueue,
				kAudioQueueParam_Volume,
				gain
		);
	}

	return self;
}

- (void) play
{
	aqData.mIsRunning = YES;
	AudioQueueStart(aqData.mQueue, NULL);

	do {
		CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, NO);
	} while (aqData.mIsRunning);
	CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, NO);
}

- (void) dealloc
{
	AudioQueueDispose(aqData.mQueue, YES);
	AudioFileClose(aqData.mAudioFile);
	free(aqData.mPacketDescs);
	[super dealloc];
}

@end

