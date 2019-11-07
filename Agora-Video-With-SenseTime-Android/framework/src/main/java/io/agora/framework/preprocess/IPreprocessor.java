package io.agora.framework.preprocess;

import io.agora.framework.VideoCaptureFrame;
import io.agora.framework.channels.VideoChannel;

public interface IPreprocessor {
    void onPreProcessFrame(VideoCaptureFrame outFrame, VideoChannel.ChannelContext context);
    void initPreprocessor();
    void releasePreprocessor(VideoChannel.ChannelContext context);
}
