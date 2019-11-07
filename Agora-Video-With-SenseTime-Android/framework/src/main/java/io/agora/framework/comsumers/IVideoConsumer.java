package io.agora.framework.comsumers;

import io.agora.framework.VideoCaptureFrame;
import io.agora.framework.channels.VideoChannel;

public interface IVideoConsumer {
    int TYPE_ON_SCREEN = 0;
    int TYPE_OFF_SCREEN = 1;

    void onConsumeFrame(VideoCaptureFrame frame, VideoChannel.ChannelContext context);
    void connectChannel(int channelId);
    void disconnectChannel(int channelId);

    /**
     * Give a chance for subclasses to return a drawing target
     * object. This object can only be either a Surface or a
     * SurfaceTexture.
     * @return
     */
    Object onGetDrawingTarget();

    int onMeasuredWidth();
    int onMeasuredHeight();
}
