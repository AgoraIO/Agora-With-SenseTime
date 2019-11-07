package io.agora.rtcwithst.framework;

import android.opengl.GLES20;
import android.util.Log;

import io.agora.framework.VideoCaptureFrame;
import io.agora.framework.VideoModule;
import io.agora.framework.channels.VideoChannel;
import io.agora.framework.comsumers.IVideoConsumer;
import io.agora.rtc.mediaio.IVideoFrameConsumer;
import io.agora.rtc.mediaio.IVideoSource;
import io.agora.rtc.mediaio.MediaIO;
import io.agora.rtc.video.AgoraVideoFrame;

/**
 * Interfaces that are implemented may be confusing.
 * The renderer acts as the consumer of the video source
 * from current video channel, and also the video source
 * of rtc engine.
 */
public class RtcVideoConsumer implements IVideoConsumer, IVideoSource {
    private volatile IVideoFrameConsumer mRtcConsumer;
    private volatile boolean mValidInRtc;

    private VideoModule mVideoModule;
    private VideoChannel mVideoChannel;
    private int mChannelId;

    public RtcVideoConsumer(VideoModule videoModule, int channelId) {
        mVideoModule = videoModule;
        mChannelId = channelId;
    }

    @Override
    public void onConsumeFrame(VideoCaptureFrame frame, VideoChannel.ChannelContext context) {
        if (mRtcConsumer != null && mValidInRtc) {
            int format = frame.mFormat.getPixelFormat() == GLES20.GL_TEXTURE_2D
                    ? AgoraVideoFrame.FORMAT_TEXTURE_2D
                    : AgoraVideoFrame.FORMAT_TEXTURE_OES;

            mRtcConsumer.consumeTextureFrame(frame.mTextureId,
                    format, frame.mFormat.getWidth(),
                    frame.mFormat.getHeight(), frame.mRotation,
                    frame.mTimeStamp, frame.mTexMatrix);
        }
    }

    @Override
    public void connectChannel(int channelId) {
        // Rtc transmission is an off-screen rendering procedure.
        mVideoChannel = mVideoModule.connectConsumer(
                this, channelId, IVideoConsumer.TYPE_OFF_SCREEN);
    }

    @Override
    public void disconnectChannel(int channelId) {
        mVideoModule.disconnectConsumer(this, channelId);
    }

    @Override
    public Object onGetDrawingTarget() {
        // Rtc engine does not draw the frames
        // on any target window surface
        return null;
    }

    @Override
    public int onMeasuredWidth() {
        return 0;
    }

    @Override
    public int onMeasuredHeight() {
        return 0;
    }

    @Override
    public boolean onInitialize(IVideoFrameConsumer consumer) {
        Log.i("consumer", "onInitialize");
        mRtcConsumer = consumer;
        return true;
    }

    @Override
    public boolean onStart() {
        Log.i("consumer", "onStart");
        connectChannel(mChannelId);
        mValidInRtc = true;
        return true;
    }

    @Override
    public void onStop() {
        mValidInRtc = false;
        mRtcConsumer = null;
    }

    @Override
    public void onDispose() {
        Log.i("consumer", "onDispose");
        disconnectChannel(mChannelId);
    }

    @Override
    public int getBufferType() {
        return MediaIO.BufferType.TEXTURE.intValue();
    }
}
