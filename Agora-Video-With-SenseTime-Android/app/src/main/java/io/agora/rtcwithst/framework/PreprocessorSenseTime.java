package io.agora.rtcwithst.framework;

import android.content.Context;
import android.opengl.GLES20;
import android.opengl.Matrix;
import android.util.Log;

import com.sensetime.effects.STEffectListener;
import com.sensetime.effects.STRenderer;

import io.agora.capture.framework.modules.channels.VideoChannel;
import io.agora.capture.framework.modules.processors.IPreprocessor;
import io.agora.capture.video.camera.VideoCaptureFormat;
import io.agora.capture.video.camera.VideoCaptureFrame;

public class PreprocessorSenseTime implements IPreprocessor, STEffectListener {
    private static final String TAG = PreprocessorSenseTime.class.getSimpleName();

    private STRenderer mSTRenderer;
    private Context mContext;
    private float[] mIdentityMatrix = new float[16];

    private boolean mEnabled = true;

    public PreprocessorSenseTime(Context context) {
        mContext = context;
    }

    @Override
    public void initPreprocessor() {
        Log.i(TAG, "initPreprocessor");
        STRenderer.Builder builder = new STRenderer.Builder();
        builder.setContext(mContext)
                .enableSticker(true)
                .enableBeauty(true)
                .enableFilter(true)
                .enableMakeup(true)
                .enableDebug(false);
        mSTRenderer = builder.build();
        Matrix.setIdentityM(mIdentityMatrix, 0);
    }

    @Override
    public void enablePreProcess(boolean enabled) {
        mEnabled = enabled;
    }

    @Override
    public void releasePreprocessor(VideoChannel.ChannelContext context) {
        Log.i(TAG, "releasePreprocessor");
        if (mSTRenderer != null) {
            mSTRenderer.release();
            mSTRenderer = null;
        }
    }

    @Override
    public VideoCaptureFrame onPreProcessFrame(VideoCaptureFrame outFrame, VideoChannel.ChannelContext context) {
        if (mSTRenderer == null || !mEnabled) {
            return outFrame;
        }

        // SenseTime library will rotate the target
        // image automatically to upright.
        outFrame.textureId = mSTRenderer.preProcess(
                outFrame.textureId,
                outFrame.surfaceTexture,
                outFrame.format.getWidth(),
                outFrame.format.getHeight(),
                outFrame.format.getWidth(),
                outFrame.format.getHeight(),
                outFrame.rotation,
                outFrame.textureTransform);

        if (outFrame.rotation == 90 || outFrame.rotation == 270) {
            int width = outFrame.format.getWidth();
            int height = outFrame.format.getHeight();
            outFrame.format.setWidth(height);
            outFrame.format.setHeight(width);
        }

        outFrame.rotation = 0;
        outFrame.textureTransform = mIdentityMatrix;
        outFrame.format.setTexFormat(GLES20.GL_TEXTURE_2D);

        return outFrame;
    }

    @Override
    public void onBeautyParamSelected(int param, float value) {
        if (mSTRenderer != null) {
            mSTRenderer.setBeautyParam(param, value);
        }
    }

    @Override
    public void onFilterSelected(String filterPath, float strength) {
        if (mSTRenderer != null) {
            mSTRenderer.setFilterStyle(filterPath, strength);
        }
    }

    @Override
    public void onMakeupSelected(int type, String index, String path) {
        if (mSTRenderer != null) {
            if (path != null) {
                mSTRenderer.setMakeupType(type, index, path);
                mSTRenderer.setMakeupStrength(type, 1.0f);
            } else {
                mSTRenderer.removeMakeupByType(index);
            }
        }
    }

    @Override
    public void onStickerSelected(String path) {
        if (mSTRenderer != null) {
            mSTRenderer.changeSticker(path);
        }
    }

    @Override
    public float onGetBeautyParamValue(int param) {
        return mSTRenderer == null ? 0 :
                mSTRenderer.getSTEffectParameters().getBeautyParam(param);
    }

    @Override
    public String onGetCurrentFilterPath() {
        return mSTRenderer == null ? null :
                mSTRenderer.getSTEffectParameters().getFilter();
    }

    @Override
    public String onGetCurrentGroupMakeup(String index) {
        return mSTRenderer == null ? null :
                mSTRenderer.getSTEffectParameters().getMakeupPath(index);
    }
}
