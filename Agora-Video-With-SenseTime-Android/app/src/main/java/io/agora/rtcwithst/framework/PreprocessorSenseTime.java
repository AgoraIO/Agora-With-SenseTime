package io.agora.rtcwithst.framework;

import android.content.Context;
import android.graphics.Matrix;
import android.hardware.Camera;
import android.util.Log;

import com.sensetime.effects.STEffectListener;
import com.sensetime.effects.STRenderer;
import com.sensetime.effects.utils.FileUtils;
import com.sensetime.stmobile.STCommonNative;

import java.io.File;
import java.nio.ByteBuffer;
import java.util.Locale;

import io.agora.base.TextureBufferHelper;
import io.agora.base.VideoFrame;
import io.agora.base.internal.video.YuvHelper;
import io.agora.rtc2.video.IVideoFrameObserver;

public class PreprocessorSenseTime implements IVideoFrameObserver, STEffectListener {
    private static final String TAG = PreprocessorSenseTime.class.getSimpleName();
    private static final boolean DEBUG = true;

    private STRenderer mSTRenderer;
    private final TextureBufferHelper mTextureBufferHelper;
    private Context mContext;
    private volatile int cameraId = Camera.CameraInfo.CAMERA_FACING_FRONT;

    public PreprocessorSenseTime(Context context) {
        mContext = context;
        mTextureBufferHelper = TextureBufferHelper.create("STRender", null);
        mTextureBufferHelper.invoke(() -> {
            mSTRenderer = new STRenderer(context);
            return null;
        });
    }

    private void log(String format, Object... args) {
        if (DEBUG) {
            Log.d(TAG, String.format(Locale.US, format, args));
        }
    }

    public void switchCamera() {
        if (cameraId == Camera.CameraInfo.CAMERA_FACING_FRONT) {
            cameraId = Camera.CameraInfo.CAMERA_FACING_BACK;
        } else {
            cameraId = Camera.CameraInfo.CAMERA_FACING_FRONT;
        }
    }

    private ByteBuffer videoByteBuffer;
    private byte[] videoNV21;

    @Override
    public boolean onCaptureVideoFrame(VideoFrame videoFrame) {
        log("video frame transform >> start... ");

        long startTime = System.currentTimeMillis();
        VideoFrame.Buffer buffer = videoFrame.getBuffer();

        VideoFrame.I420Buffer i420Buffer = buffer.toI420();
        int width = i420Buffer.getWidth();
        int height = i420Buffer.getHeight();

        log("video frame transform >> toI420 consume: " + (System.currentTimeMillis() - startTime) + "ms");

        ByteBuffer bufferY = i420Buffer.getDataY();
        ByteBuffer bufferU = i420Buffer.getDataU();
        ByteBuffer bufferV = i420Buffer.getDataV();

        //byte[] i420 = YUVUtils.toWrappedI420(bufferY, bufferU, bufferV, width, height);
        //log("video frame transform >> toWrappedI420 consume: " + (System.currentTimeMillis() - startTime) + "ms");
        //byte[] nv21 = YUVUtils.I420ToNV21(i420, width, height);
        //log("video frame transform >> I420ToNV21 consume: " + (System.currentTimeMillis() - startTime) + "ms");

        // byte[] nv21 = YUVUtils.toWrappedNV21(bufferY, bufferU, bufferV, width, height);

        int chromaWidth = (width + 1) / 2;
        int chromaHeight = (height + 1) / 2;
        int minSize = width * height + chromaWidth * chromaHeight * 2;
        if(videoByteBuffer == null || videoByteBuffer.capacity() != minSize ){
            videoByteBuffer = ByteBuffer.allocateDirect(minSize);
            videoNV21 = new byte[minSize];
        }
        YuvHelper.I420ToNV12(bufferY, i420Buffer.getStrideY(),
                bufferV, i420Buffer.getStrideV(),
                bufferU, i420Buffer.getStrideU(),
                videoByteBuffer,
                width, height);
        videoByteBuffer.position(0);
        videoByteBuffer.get(videoNV21);
        log("video frame transform >> toWrappedNV21 consume: " + (System.currentTimeMillis() - startTime) + "ms");

        Integer textureId = mTextureBufferHelper.invoke(
                () -> mSTRenderer.preProcess(
                        cameraId,
                        width,
                        height,
                        videoFrame.getRotation(),
                        cameraId == Camera.CameraInfo.CAMERA_FACING_FRONT,
                        videoNV21,
                        STCommonNative.ST_PIX_FMT_NV21
                ));
        log("video frame transform >> preProcess consume: " + (System.currentTimeMillis() - startTime) + "ms");

        Matrix transformMatrix = new Matrix();
        VideoFrame.TextureBuffer textureBuffer = mTextureBufferHelper.wrapTextureBuffer(videoFrame.getRotatedWidth(), videoFrame.getRotatedHeight(), VideoFrame.TextureBuffer.Type.RGB, textureId, transformMatrix);
        videoFrame.replaceBuffer(textureBuffer, 0, videoFrame.getTimestampNs());

        log("video frame transform >> total consume: " + (System.currentTimeMillis() - startTime) + "ms");

        return true;
    }

    @Override
    public int getVideoFrameProcessMode() {
        return IVideoFrameObserver.PROCESS_MODE_READ_WRITE;
    }

    @Override
    public int getVideoFormatPreference() {
        return IVideoFrameObserver.VIDEO_PIXEL_DEFAULT;
    }

    @Override
    public boolean getRotationApplied() {
        return false;
    }

    @Override
    public boolean getMirrorApplied() {
        return false;
    }

    @Override
    public int getObservedFramePosition() {
        return IVideoFrameObserver.POSITION_POST_CAPTURER;
    }


    @Override
    public boolean onPreEncodeVideoFrame(VideoFrame videoFrame) {
        return false;
    }

    @Override
    public boolean onScreenCaptureVideoFrame(VideoFrame videoFrame) {
        return false;
    }

    @Override
    public boolean onPreEncodeScreenVideoFrame(VideoFrame videoFrame) {
        return false;
    }

    @Override
    public boolean onMediaPlayerVideoFrame(VideoFrame videoFrame, int mediaPlayerId) {
        return false;
    }

    @Override
    public boolean onRenderVideoFrame(String channelId, int uid, VideoFrame videoFrame) {
        return false;
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
    public void onMakeupSelected(int type, String typePath, float strength) {
        if (mSTRenderer != null) {
            if (typePath != null) {
                String[] split = typePath.split(File.separator);
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
            if (!attach) {
                mSTRenderer.removeSticker(_path);
            } else {
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
