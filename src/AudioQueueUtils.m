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
 * AudioQueueUtils.m
 *
 * Implements callback and other useful functions for handleing queues.
 */

#import "AudioQueueUtils.h"

void HandleOutputBuffer (
		void                *aqData,
		AudioQueueRef       inAQ,
		AudioQueueBufferRef inBuffer
)
{
	struct AQPlayerState *pAqData = (struct AQPlayerState *) aqData;
	static int end = 0;
	if (pAqData->mIsRunning == NO) {
		return;
	}
	UInt32 numBytesReadFromFile;
	UInt32 numPackets = pAqData->mNumPacketsToRead;
	AudioFileReadPackets (
			pAqData->mAudioFile,
			NO,
			&numBytesReadFromFile,
			pAqData->mPacketDescs, 
			pAqData->mCurrentPacket,
			&numPackets,
			inBuffer->mAudioData 
			);

	if (numPackets > 0) {
		inBuffer->mAudioDataByteSize = numBytesReadFromFile;
		AudioQueueEnqueueBuffer ( 
				inAQ,
				inBuffer,
				(pAqData->mPacketDescs ? numPackets : 0),
				pAqData->mPacketDescs
				);
		pAqData->mCurrentPacket += numPackets;
	} else {
		end++;
		AudioQueueStop (
				inAQ,
				NO
				);
		if (end == kNumberBuffers) {
			pAqData->mIsRunning = NO; 
			end = 0;
		}
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
	static const unsigned int maxBufferSize = 0x50000;
	static const unsigned int minBufferSize = 0x4000;

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
