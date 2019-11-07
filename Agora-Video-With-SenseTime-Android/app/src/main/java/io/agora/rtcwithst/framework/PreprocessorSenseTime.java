package io.agora.rtcwithst.framework;

import android.content.Context;
import android.graphics.SurfaceTexture;
import android.opengl.GLES20;
import android.opengl.Matrix;
import android.util.Log;

import com.sensetime.effects.STEffectListener;
import com.sensetime.effects.STRenderer;

import io.agora.framework.channels.VideoChannel;
import io.agora.framework.preprocess.IPreprocessor;
import io.agora.framework.VideoCaptureFrame;

public class PreprocessorSenseTime implements IPreprocessor, STEffectListener {
    private static final String TAG = PreprocessorSenseTime.class.getSimpleName();

    private STRenderer mSTRenderer;
    private Context mContext;
    private float[] mIdentityMatrix = new float[16];
    private int mRotatedTextureId;
    private SurfaceTexture mRotatedSurfaceTexture;

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
                .enableMakeup(true);
        mSTRenderer = builder.build();
        Matrix.setIdentityM(mIdentityMatrix, 0);
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
    public void onPreProcessFrame(VideoCaptureFrame outFrame, VideoChannel.ChannelContext context) {
        if (mSTRenderer == null) {
            return;
        }

        int textureId = mSTRenderer.preProcess(outFrame.mTextureId,
                outFrame.mSurfaceTexture, outFrame.mFormat.getWidth(),
                outFrame.mFormat.getHeight(), mIdentityMatrix, mIdentityMatrix);

        if (textureId > 0) {
            outFrame.mTextureId = textureId;
            outFrame.mFormat.setPixelFormat(GLES20.GL_TEXTURE_2D);
        }
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
