/*
Copyright (C) 2010  Lucas Frérot

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
 * PlaybackManager.m
 *
 * Implements a class that will handle playback of an audio file.
 */

#import "PlaybackManager.h"


@implementation PlaybackManager

- (id) initWithFile:(NSString *) filePath
{
	if (( self = [super init] )) {
		int i;
		NSURL * fileURL = [NSURL fileURLWithPath:filePath];
		OSStatus result = AudioFileOpenURL((CFURLRef) fileURL, fsRdPerm, 0, &aqData.mAudioFile);
		UInt32 dataFormatSize = sizeof (aqData.mDataFormat);

		if (result == fnfErr) {
			fprintf(stderr, "error: File not found : \"%s\"\n", [filePath UTF8String]);
			return nil;
		}

		else if (result == kAudioFileUnspecifiedError) {
			fprintf(stderr, "error: Bad format for file : \"%s\"\n", [filePath UTF8String]);
			return nil;
		}

		else if (result != noErr) {
			fprintf(stderr, "error: Unknown error for file : \"%s\"\n", [filePath UTF8String]);
			return nil;
		}

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

