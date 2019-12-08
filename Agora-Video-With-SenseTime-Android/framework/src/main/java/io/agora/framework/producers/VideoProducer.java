package io.agora.framework.producers;

import android.opengl.GLES11Ext;
import android.os.Handler;
import android.util.Log;

import io.agora.framework.VideoCaptureFrame;
import io.agora.framework.VideoModule;
import io.agora.framework.channels.VideoChannel;

public abstract class VideoProducer implements IVideoProducer {
    private static final String TAG = VideoProducer.class.getSimpleName();

    protected VideoChannel videoChannel;
    private volatile Handler handler;
    private volatile boolean mPaused;

    @Override
    public void connectChannel(int channelId) {
        videoChannel = VideoModule.instance().connectProducer(this, channelId);
        handler = videoChannel.getHandler();
    }

    @Override
    public void pushVideoFrame(final VideoCaptureFrame frame) {
        if (handler == null) {
            return;
        }

        handler.post(new Runnable() {
            @Override
            public void run() {
                if (mPaused) {
                    return;
                }

                // TODO workaround for setting the texture type
                frame.mFormat.setPixelFormat(GLES11Ext.GL_TEXTURE_EXTERNAL_OES);

                final VideoCaptureFrame out = new VideoCaptureFrame(frame);
                try {
                    frame.mSurfaceTexture.updateTexImage();
                    frame.mSurfaceTexture.getTransformMatrix(out.mTexMatrix);
                } catch (Exception e) {
                    e.printStackTrace();
                    return;
                }

                if (videoChannel != null) {
                    videoChannel.pushVideoFrame(out);
                }
            }
        });
    }

    @Override
    public void disconnect() {
        Log.i(TAG, "disconnect");
        handler = null;

        if (videoChannel != null) {
            videoChannel.disconnectProducer();
            videoChannel = null;
        }
    }

    public void setPaused(boolean paused) {
        mPaused = paused;
    }
}
