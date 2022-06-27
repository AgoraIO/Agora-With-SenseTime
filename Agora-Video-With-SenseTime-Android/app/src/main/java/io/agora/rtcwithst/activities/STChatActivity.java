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

import com.sensetime.stmobile.model.STMobileMakeupType;
import com.sensetime.stmobile.params.STEffectBeautyType;

import java.io.File;
import java.util.List;

import io.agora.capture.video.camera.CameraVideoManager;
import io.agora.capture.video.camera.VideoCapture;
import io.agora.rtc.RtcEngine;
import io.agora.rtc.video.VideoCanvas;
import io.agora.rtc.video.VideoEncoderConfiguration;
import io.agora.rtcwithst.R;
import io.agora.rtcwithst.framework.PreprocessorSenseTime;
import io.agora.rtcwithst.framework.RtcVideoConsumer;
import io.agora.rtcwithst.utils.Constant;

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
        preprocessor.onStickerSelected("sticker_face_shape" + File.separator + "lianxingface.zip", selected);
    }

    private void setFilter(boolean selected) {
        if(selected){
            preprocessor.onFilterSelected("filter_portrait" + File.separator + "filter_style_babypink.model", 1);
        }
        else{
            preprocessor.onFilterSelected("filter_portrait" + File.separator + "filter_style_babypink.model", 0);
        }
    }

    private void setMakeupItemParam(boolean selected) {
        if(selected){
            preprocessor.onMakeupSelected(STMobileMakeupType.ST_MAKEUP_TYPE_LIP,  "makeup_lip" + File.separator + "12自然.zip", 1);
        }
        else{
            preprocessor.onMakeupSelected(STMobileMakeupType.ST_MAKEUP_TYPE_LIP, null, 0);
        }
    }

    private void setBeautificationOn(boolean selected) {
        if(selected){
            preprocessor.onBeautyModeSelected(STEffectBeautyType.EFFECT_BEAUTY_BASE_WHITTEN, STEffectBeautyType.WHITENING1_MODE);
            preprocessor.onBeautyStrengthSelected(STEffectBeautyType.EFFECT_BEAUTY_BASE_WHITTEN, 100f);
            preprocessor.onBeautyStrengthSelected(STEffectBeautyType.EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE, 1.0f);
        }
        else{
            preprocessor.onBeautyModeSelected(STEffectBeautyType.EFFECT_BEAUTY_BASE_WHITTEN, STEffectBeautyType.WHITENING1_MODE);
            preprocessor.onBeautyStrengthSelected(STEffectBeautyType.EFFECT_BEAUTY_BASE_WHITTEN, 0f);
            preprocessor.onBeautyStrengthSelected(STEffectBeautyType.EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE, 0.0f);
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

            @Override
            public void onCameraClosed() {
                Log.i(TAG, "onCameraClosed!");
            }

            @Override
            public VideoCapture.FrameRateRange onSelectCameraFpsRange(List<VideoCapture.FrameRateRange> list, VideoCapture.FrameRateRange frameRateRange) {
                return null;
            }
        });

        // Set camera capture configuration
        mCameraVideoManager.setPictureSize(640, 480);
        mCameraVideoManager.setFrameRate(24);
        mCameraVideoManager.setFacing(io.agora.capture.video.camera.Constant.CAMERA_FACING_FRONT);

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
