package io.agora.rtcwithst.framework;

import android.opengl.GLES20;
import android.util.Log;

import io.agora.capture.framework.modules.channels.ChannelManager;
import io.agora.capture.framework.modules.channels.VideoChannel;
import io.agora.capture.framework.modules.consumers.IVideoConsumer;
import io.agora.capture.video.camera.VideoCaptureFrame;
import io.agora.capture.video.camera.VideoModule;
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
    private static final String TAG = RtcVideoConsumer.class.getSimpleName();

    private volatile IVideoFrameConsumer mRtcConsumer;
    private volatile boolean mValidInRtc;

    private VideoModule mVideoModule;
    private VideoChannel mVideoChannel;
    private int mChannelId;


    public RtcVideoConsumer() {
        this(ChannelManager.ChannelID.CAMERA);
    }

    private RtcVideoConsumer(int channelId) {
        mVideoModule = VideoModule.instance();
        mChannelId = channelId;
    }

    @Override
    public void onConsumeFrame(VideoCaptureFrame frame, VideoChannel.ChannelContext context) {
        if (mValidInRtc) {
            int format = frame.format.getTexFormat() == GLES20.GL_TEXTURE_2D
                    ? AgoraVideoFrame.FORMAT_TEXTURE_2D
                    : AgoraVideoFrame.FORMAT_TEXTURE_OES;
            if (mRtcConsumer != null) {
                mRtcConsumer.consumeTextureFrame(frame.textureId, format,
                        frame.format.getWidth(), frame.format.getHeight(),
                        frame.rotation + 180, frame.timestamp, frame.textureTransform);
            }
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
    public void setMirrorMode(int i) {

    }

    @Override
    public Object getDrawingTarget() {
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
    public void recycle() {

    }

    @Override
    public String getId() {
        return null;
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

    @Override
    public int getCaptureType() {
        return MediaIO.CaptureType.CAMERA.intValue();
    }

    @Override
    public int getContentHint() {
        return MediaIO.ContentHint.NONE.intValue();
    }
}
