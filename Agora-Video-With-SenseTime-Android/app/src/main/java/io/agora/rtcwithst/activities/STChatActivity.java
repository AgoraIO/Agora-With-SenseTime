package io.agora.rtcwithst.activities;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.SurfaceView;
import android.view.TextureView;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.io.File;

import io.agora.capture.video.camera.CameraVideoManager;
import io.agora.capture.video.camera.VideoCapture;
import io.agora.rtc.RtcEngine;
import io.agora.rtc.video.VideoCanvas;
import io.agora.rtc.video.VideoEncoderConfiguration;
import io.agora.rtcwithst.framework.PreprocessorSenseTime;
import io.agora.rtcwithst.framework.RtcVideoConsumer;
import io.agora.rtcwithst.R;
import io.agora.rtcwithst.utils.Constant;

import static com.sensetime.effects.utils.Constants.ST_MAKEUP_BLUSH_NAME;
import static com.sensetime.effects.utils.Constants.ST_MAKEUP_BROW_NAME;
import static com.sensetime.effects.utils.Constants.ST_MAKEUP_EYELINER;
import static com.sensetime.effects.utils.Constants.ST_MAKEUP_EYELINER_NAME;
import static com.sensetime.stmobile.STBeautyParamsType.ST_BEAUTIFY_ENLARGE_EYE_RATIO;
import static com.sensetime.stmobile.STBeautyParamsType.ST_BEAUTIFY_REDDEN_STRENGTH;
import static com.sensetime.stmobile.STBeautyParamsType.ST_BEAUTIFY_WHITEN_STRENGTH;
import static com.sensetime.stmobile.model.STMobileType.ST_MAKEUP_TYPE_BLUSH;
import static com.sensetime.stmobile.model.STMobileType.ST_MAKEUP_TYPE_BROW;

public class STChatActivity extends RtcBasedActivity {
    private static final String TAG = STChatActivity.class.getSimpleName();
    private static final int REQUEST = 1;
    private static final String[] PERMISSIONS = {
            Manifest.permission.CAMERA
    };
    private CameraVideoManager mCameraVideoManager;
    private EffectOptionContainer mEffectContainer;
    private TextureView mVideoSurface;
    private boolean mPermissionGranted;
    private boolean mIsMirrored = true;
    private int mRemoteUid = -1;
    private FrameLayout mRemoteViewContainer;

    private PreprocessorSenseTime preprocessor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initUI();
    }

    private void initUI() {
        setContentView(R.layout.activity_main);
        mVideoSurface = findViewById(R.id.local_video_surface);
        mEffectContainer = findViewById(R.id.effect_container);
        mEffectContainer.setEffectOptionItemListener(new EffectListener());
        initRemoteViewLayout();
        checkCameraPermission();
        initRoom();
    }

    private void initRemoteViewLayout() {
        mRemoteViewContainer = findViewById(R.id.remote_video_layout);
        DisplayMetrics displayMetrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        RelativeLayout.LayoutParams params =
                (RelativeLayout.LayoutParams) mRemoteViewContainer.getLayoutParams();
        params.width = displayMetrics.widthPixels / 3;
        params.height = displayMetrics.heightPixels / 3;
        mRemoteViewContainer.setLayoutParams(params);
    }

    private class EffectListener implements EffectOptionContainer.OnEffectOptionContainerItemClickListener {
        @Override
        public void onEffectOptionItemClicked(int index, int textResource, boolean selected) {
            Log.i(TAG, "onEffectOptionItemClicked " + index + " " + selected);
            if (preprocessor != null) {
                switch (index) {
                    case 0:
                        setBeautificationOn(selected);
                        break;
                    case 1:
                        setMakeupItemParam(selected);
                        break;
                    case 2:
                        setStickerItem(selected);
                        break;
                    case 3:
                        setFilter(selected);
                        break;
                }
            }
        }

        @Override
        public void onEffectNotSupported(int index, int textResource) {
            Toast.makeText(STChatActivity.this, R.string.sorry_no_permission, Toast.LENGTH_SHORT).show();
        }
    }

    private void setStickerItem(boolean selected) {
        preprocessor.onStickerSelected(selected ? "newEngine" + File.separator + "maozi_uv_01.zip" : null);
    }

    private void setFilter(boolean selected) {
        if(selected){
            preprocessor.onFilterSelected("filter_portrait" + File.separator + "filter_style_ol.model", 1);
        }
        else{
            preprocessor.onFilterSelected("filter_portrait" + File.separator + "filter_style_ol.model", 0);
        }
    }

    private void setMakeupItemParam(boolean selected) {
        if(selected){
            preprocessor.onMakeupSelected(ST_MAKEUP_TYPE_BROW, ST_MAKEUP_BROW_NAME, "makeup_brow" + File.separator + "browA.zip");
            preprocessor.onMakeupSelected(ST_MAKEUP_TYPE_BLUSH, ST_MAKEUP_BLUSH_NAME, "makeup_blush" + File.separator + "blusha.zip");
            preprocessor.onMakeupSelected(ST_MAKEUP_EYELINER, ST_MAKEUP_EYELINER_NAME, "makeup_eyeliner" + File.separator + "eyelinera.zip");
        }
        else{
            preprocessor.onMakeupSelected(ST_MAKEUP_TYPE_BROW, ST_MAKEUP_BROW_NAME, null);
            preprocessor.onMakeupSelected(ST_MAKEUP_TYPE_BLUSH, ST_MAKEUP_BLUSH_NAME, null);
            preprocessor.onMakeupSelected(ST_MAKEUP_EYELINER, ST_MAKEUP_EYELINER_NAME, null);
        }
    }

    private void setBeautificationOn(boolean selected) {
        if(selected){
            preprocessor.onBeautyParamSelected(ST_BEAUTIFY_WHITEN_STRENGTH, 1);
            preprocessor.onBeautyParamSelected(ST_BEAUTIFY_ENLARGE_EYE_RATIO, 1);
            preprocessor.onBeautyParamSelected(ST_BEAUTIFY_REDDEN_STRENGTH, 1);
        }
        else{
            preprocessor.onBeautyParamSelected(ST_BEAUTIFY_WHITEN_STRENGTH, 0);
            preprocessor.onBeautyParamSelected(ST_BEAUTIFY_ENLARGE_EYE_RATIO, 0);
            preprocessor.onBeautyParamSelected(ST_BEAUTIFY_REDDEN_STRENGTH, 0);
        }
    }

    private void initRoom() {
        rtcEngine().setVideoSource(new RtcVideoConsumer());
        joinChannel();
    }

    private void joinChannel() {
        rtcEngine().setVideoEncoderConfiguration(new VideoEncoderConfiguration(
                VideoEncoderConfiguration.VD_640x360,
                VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_24,
                VideoEncoderConfiguration.STANDARD_BITRATE,
                VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT));
        rtcEngine().setClientRole(io.agora.rtc.Constants.CLIENT_ROLE_BROADCASTER);
        String roomName = getIntent().getStringExtra(Constant.ACTION_KEY_ROOM_NAME);
        rtcEngine().joinChannel(null, roomName, null, 0);
    }

    private void checkCameraPermission() {
        if (permissionGranted(Manifest.permission.CAMERA)) {
            onPermissionGranted();
            mPermissionGranted = true;
        } else {
            ActivityCompat.requestPermissions(this, PERMISSIONS, REQUEST);
        }
    }

    private boolean permissionGranted(String permission) {
        return ContextCompat.checkSelfPermission(this, permission) ==
                PackageManager.PERMISSION_GRANTED;
    }

    private void onPermissionGranted() {
        initCamera();
    }

    private void initCamera() {
        mCameraVideoManager = videoManager();
        preprocessor = (PreprocessorSenseTime) mCameraVideoManager.getPreprocessor();
        mCameraVideoManager.setCameraStateListener(new VideoCapture.VideoCaptureStateListener() {
            @Override
            public void onFirstCapturedFrame(int width, int height) {
                Log.i(TAG, "onFirstCapturedFrame: " + width + "x" + height);
            }

            @Override
            public void onCameraCaptureError(int error, String message) {
                Log.i(TAG, "onCameraCaptureError: error:" + error + " " + message);
                if (mCameraVideoManager != null) {
                    // When there is a camera error, the capture should
                    // be stopped to reset the internal states.
                    mCameraVideoManager.stopCapture();
                }
            }
        });

        // Set camera capture configuration
        mCameraVideoManager.setPictureSize(640, 480);
        mCameraVideoManager.setFrameRate(24);
        mCameraVideoManager.setFacing(io.agora.capture.video.camera.Constant.CAMERA_FACING_FRONT);
        mCameraVideoManager.setLocalPreviewMirror(toMirrorMode(mIsMirrored));

        // The preview surface is actually considered as
        // an on-screen consumer under the hood.
        mCameraVideoManager.setLocalPreview(mVideoSurface, "Surface1");

        // Can attach other consumers here,
        // For example, rtc consumer or rtmp module
        mCameraVideoManager.startCapture();
        updateEffectOptionPanel();
    }

    private void updateEffectOptionPanel() {
        // Beautification
        mEffectContainer.setItemViewStyles(0, false, true);
        // Sticker
        mEffectContainer.setItemViewStyles(2, false, true);
    }

    private int toMirrorMode(boolean isMirrored) {
        return isMirrored ? io.agora.capture.video.camera.Constant.MIRROR_MODE_ENABLED : io.agora.capture.video.camera.Constant.MIRROR_MODE_DISABLED;
    }

    public void onCameraChange(View view) {
        if (mCameraVideoManager != null) {
            mCameraVideoManager.switchCamera();
        }
    }

    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        Log.i(TAG, "onJoinChannelSuccess " + channel + " " + (uid & 0xFFFFFFFFL));
    }

    @Override
    public void onUserOffline(int uid, int reason) {
//        Log.i(TAG, "onUserJoined " + (uid & 0xFFFFFFFFL));
    }

    @Override
    public void onUserJoined(int uid, int elapsed) {
        Log.i(TAG, "onUserJoined " + (uid & 0xFFFFFFFFL));
    }

    @Override
    public void onRemoteVideoStateChanged(int uid, int state, int reason, int elapsed) {
        Log.i(TAG, "onRemoteVideoStateChanged " + (uid & 0xFFFFFFFFL) + " " + state + " " + reason);
        if (mRemoteUid == -1 && state == io.agora.rtc.Constants.REMOTE_VIDEO_STATE_DECODING) {
            runOnUiThread(() -> {
                mRemoteUid = uid;
                setRemoteVideoView(uid);
            });
        }
    }

    private void setRemoteVideoView(int uid) {
        SurfaceView surfaceView = RtcEngine.CreateRendererView(this);
        rtcEngine().setupRemoteVideo(new VideoCanvas(
                surfaceView, VideoCanvas.RENDER_MODE_HIDDEN, uid));
        mRemoteViewContainer.addView(surfaceView);
    }
}
