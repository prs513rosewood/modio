#import "AudioQueueUtils.h"

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
