package io.agora.framework.producers;

import io.agora.framework.VideoCaptureFrame;

public interface IVideoProducer {
    void connectChannel(int channelId);
    void pushVideoFrame(VideoCaptureFrame frame);
    void disconnect();
}
