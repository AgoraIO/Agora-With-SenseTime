package io.agora.framework.comsumers;

import android.graphics.SurfaceTexture;
import android.opengl.GLES20;
import android.util.Log;
import android.view.TextureView;

import io.agora.framework.VideoCaptureFrame;
import io.agora.framework.VideoModule;
import io.agora.framework.channels.VideoChannel;

public class SurfaceTextureConsumer extends BaseWindowConsumer implements TextureView.SurfaceTextureListener {
    private static final String TAG = SurfaceTextureConsumer.class.getSimpleName();

    private SurfaceTexture mSurfaceTexture;
    private int mWidth;
    private int mHeight;

    public SurfaceTextureConsumer(VideoModule videoModule) {
        super(videoModule);
    }

    @Override
    public void onConsumeFrame(VideoCaptureFrame frame, VideoChannel.ChannelContext context) {
        if (mSurfaceTexture == null) {
            return;
        }

        super.onConsumeFrame(frame, context);
    }

    @Override
    public Object onGetDrawingTarget() {
        return mSurfaceTexture;
    }

    @Override
    public int onMeasuredWidth() {
        return mSurfaceTexture != null ? mWidth : 0;
    }

    @Override
    public int onMeasuredHeight() {
        return mSurfaceTexture != null ? mHeight : 0;
    }

    @Override
    public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
        // Log.i(TAG, "onSurfaceTextureAvailable");
        mSurfaceTexture = surface;
        destroyed = false;
        initialized = false;
        setSize(width, height);
        connectChannel(CHANNEL_ID);
    }

    @Override
    public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {
        GLES20.glViewport(0, 0, width, height);
        setSize(width, height);
    }

    private void setSize(int width, int height) {
        mWidth = width;
        mHeight = height;
        mSurfaceTexture.setDefaultBufferSize(mWidth, mHeight);
    }

    @Override
    public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
        Log.i(TAG, "onSurfaceTextureDestroyed");
        disconnectChannel(CHANNEL_ID);
        destroyed = true;
        return true;
    }

    @Override
    public void onSurfaceTextureUpdated(SurfaceTexture surface) {
        // Log.i(TAG, "onSurfaceTextureUpdated");
    }
}
