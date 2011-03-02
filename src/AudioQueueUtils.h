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
 * AudioQueueUtils.h
 *
 * Defines useful functions for handleing audio queues (set up and run).
 */

#import <Foundation/Foundation.h>
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

