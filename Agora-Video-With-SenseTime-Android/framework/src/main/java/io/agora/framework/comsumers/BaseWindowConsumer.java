package io.agora.framework.comsumers;

import android.opengl.EGLSurface;
import android.opengl.GLES11Ext;
import android.opengl.GLES20;
import android.util.Log;

import io.agora.framework.VideoCaptureFrame;
import io.agora.framework.VideoModule;
import io.agora.framework.channels.ChannelManager;
import io.agora.framework.channels.VideoChannel;
import io.agora.framework.gles.core.EglCore;
import io.agora.framework.gles.core.GlUtil;

public abstract class BaseWindowConsumer implements IVideoConsumer {
    protected static final int CHANNEL_ID = ChannelManager.ChannelID.CAMERA;
    public static boolean DEBUG = false;

    protected VideoModule videoModule;
    protected VideoChannel videoChannel;

    private EGLSurface drawingEglSurface;
    protected volatile boolean initialized;
    protected volatile boolean destroyed;
    private float[] mMVPMatrix = new float[16];
    private boolean mMVPInit;

    public BaseWindowConsumer(VideoModule videoModule) {
        this.videoModule = videoModule;
    }

    @Override
    public void connectChannel(int channelId) {
        videoChannel = videoModule.connectConsumer(this, channelId, IVideoConsumer.TYPE_ON_SCREEN);
    }

    @Override
    public void disconnectChannel(int channelId) {
        videoModule.disconnectConsumer(this, channelId);
    }

    @Override
    public void onConsumeFrame(VideoCaptureFrame frame, VideoChannel.ChannelContext context) {
        drawFrame(frame, context);
    }

    private void drawFrame(VideoCaptureFrame frame, VideoChannel.ChannelContext context) {
        if (destroyed) {
            return;
        }

        EglCore eglCore = context.getEglCore();

        if (!initialized) {
            if (drawingEglSurface != null) {
                eglCore.releaseSurface(drawingEglSurface);
                eglCore.makeNothingCurrent();
                drawingEglSurface = null;
            }

            drawingEglSurface = eglCore.createWindowSurface(onGetDrawingTarget());
            initialized = true;
        }

        if (!eglCore.isCurrent(drawingEglSurface)) {
            eglCore.makeCurrent(drawingEglSurface);
        }

        int width = onMeasuredWidth();
        int height = onMeasuredHeight();
        GLES20.glViewport(0, 0, width, height);

        if (!mMVPInit) {
            mMVPMatrix = GlUtil.changeMVPMatrix(GlUtil.IDENTITY_MATRIX,
                    width, height, frame.mFormat.getHeight(),
                    frame.mFormat.getWidth());
            mMVPInit = true;
        }

        if (frame.mFormat.getPixelFormat() == GLES20.GL_TEXTURE_2D) {
            context.getProgram2D().drawFrame(
                    frame.mTextureId, frame.mTexMatrix, mMVPMatrix);
        } else if (frame.mFormat.getPixelFormat() == GLES11Ext.GL_TEXTURE_EXTERNAL_OES) {
            context.getProgramOES().drawFrame(
                    frame.mTextureId, frame.mTexMatrix, mMVPMatrix);
        }

        eglCore.swapBuffers(drawingEglSurface);
    }
}
