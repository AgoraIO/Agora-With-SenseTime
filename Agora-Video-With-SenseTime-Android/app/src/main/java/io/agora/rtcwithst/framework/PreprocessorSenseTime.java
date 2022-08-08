package io.agora.rtcwithst.framework;

import android.content.Context;
import android.graphics.ImageFormat;
import android.hardware.Camera;
import android.opengl.GLES20;
import android.opengl.Matrix;
import android.util.Log;
import android.view.WindowManager;

import com.sensetime.effects.STEffectListener;
import com.sensetime.effects.STRenderer;
import com.sensetime.effects.utils.FileUtils;
import com.sensetime.stmobile.STCommonNative;

import java.io.File;

import io.agora.capture.framework.modules.channels.VideoChannel;
import io.agora.capture.framework.modules.processors.IPreprocessor;
import io.agora.capture.video.camera.Constant;
import io.agora.capture.video.camera.VideoCaptureFrame;

public class PreprocessorSenseTime implements IPreprocessor, STEffectListener {
    private static final String TAG = PreprocessorSenseTime.class.getSimpleName();

    private STRenderer mSTRenderer;
    private Context mContext;
    private float[] mIdentityMatrix = new float[16];

    private boolean mEnabled = true;

    private WindowManager mWindowManager;

    public PreprocessorSenseTime(Context context) {
        mContext = context;
        mWindowManager = (WindowManager) mContext
                .getSystemService(Context.WINDOW_SERVICE);
    }

    @Override
    public void initPreprocessor() {
        Log.i(TAG, "initPreprocessor");
        mSTRenderer = new STRenderer(mContext);
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
        int textureId = mSTRenderer.preProcess(
                outFrame.format.getCameraFacing() == Constant.CAMERA_FACING_FRONT ? Camera.CameraInfo.CAMERA_FACING_FRONT : Camera.CameraInfo.CAMERA_FACING_BACK,
                outFrame.format.getWidth(),
                outFrame.format.getHeight(),
                outFrame.rotation,
                outFrame.mirrored,
                outFrame.image,
                outFrame.format.getPixelFormat() == ImageFormat.NV21 ? STCommonNative.ST_PIX_FMT_NV21 : STCommonNative.ST_PIX_FMT_BGRA8888
                //outFrame.textureId,
                //outFrame.format.getTexFormat(),
                //outFrame.textureTransform
        );
        if (textureId < 0) {
            return outFrame;
        }


        if (outFrame.rotation == 90 || outFrame.rotation == 270) {
            int width = outFrame.format.getWidth();
            int height = outFrame.format.getHeight();
            outFrame.format.setWidth(height);
            outFrame.format.setHeight(width);
        }
        outFrame.textureId = textureId;
        outFrame.rotation = 0;
        outFrame.textureTransform = mIdentityMatrix;
        outFrame.mirrored = false;
        outFrame.image = null;
        outFrame.format.setPixelFormat(ImageFormat.UNKNOWN);
        outFrame.format.setTexFormat(GLES20.GL_TEXTURE_2D);

        return outFrame;
    }

    @Override
    public void onBeautyModeSelected(int mode, int value) {
        if (mSTRenderer != null) {
            mSTRenderer.setBeautyMode(mode, value);
        }
    }

    @Override
    public void onBeautyStrengthSelected(int mode, float strength) {
        if (mSTRenderer != null) {
            mSTRenderer.setBeautyStrength(mode, strength);
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
            String[] split = filterPath.split(File.separator);
            String className = split[0];
            String fileName = split[1];
            String filterName = split[1].split("_")[2].split("\\.")[0];
            String path = FileUtils.getFilePath(mContext, className + File.separator + fileName);
            FileUtils.copyFileIfNeed(mContext, fileName, className);
            mSTRenderer.setFilterStyle(className, filterName, path);
            mSTRenderer.setFilterStrength(strength);
        }
    }

    @Override
    public void onMakeupSelected(int type, String path, float strength) {
        if (mSTRenderer != null) {
            if (path != null) {
                String[] split = path.split(File.separator);
                String className = split[0];
                String fileName = split[1];
                String _path = FileUtils.getFilePath(mContext, className + File.separator + fileName);
                FileUtils.copyFileIfNeed(mContext, fileName, className);
                mSTRenderer.setMakeupForType(type, _path);
                mSTRenderer.setMakeupStrength(type, strength);
            } else {
                mSTRenderer.removeMakeupByType(type);
            }
        }
    }

    @Override
    public void onStickerSelected(String path, boolean attach) {
        String[] split = path.split(File.separator);
        String className = split[0];
        String fileName = split[1];
        String _path = FileUtils.getFilePath(mContext, className + File.separator + fileName);
        FileUtils.copyFileIfNeed(mContext, fileName, className);
        if (mSTRenderer != null) {
            if(!attach){
                mSTRenderer.removeSticker(_path);
            }else{
                mSTRenderer.changeSticker(_path);
            }
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
