#import "PlaybackManager.h"


@implementation PlaybackManager

- (id) initWithFile:(NSString *) filePath
{
	if (( self = [super init] )) {
		int i;
		NSURL * fileURL = [NSURL fileURLWithPath:filePath];
		OSStatus doesntExists = AudioFileOpenURL((CFURLRef) fileURL, fsRdPerm, 0, &aqData.mAudioFile);
		UInt32 dataFormatSize = sizeof (aqData.mDataFormat);

		if (doesntExists) {
			fprintf(stderr, "error: The file \"%s\" doesn't exist.\n", [filePath UTF8String]);
			return nil;
		}

		OSStatus isNotReadable = AudioFileGetProperty(
				aqData.mAudioFile,
				kAudioFilePropertyDataFormat,
				&dataFormatSize,
				&aqData.mDataFormat
		);

		if (isNotReadable) {
			fprintf(stderr, "error: The file \"%s\" isn't readable.\n", [filePath UTF8String]);
			return nil;
		}

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

