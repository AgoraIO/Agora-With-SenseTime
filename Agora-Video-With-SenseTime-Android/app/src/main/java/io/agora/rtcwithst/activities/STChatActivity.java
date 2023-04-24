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

import io.agora.rtc2.Constants;
import io.agora.rtc2.video.VideoCanvas;
import io.agora.rtc2.video.VideoEncoderConfiguration;
import io.agora.rtcwithst.R;
import io.agora.rtcwithst.utils.Constant;

public class STChatActivity extends RtcBasedActivity {
    private static final String TAG = STChatActivity.class.getSimpleName();
    private static final int REQUEST = 1;
    private static final String[] PERMISSIONS = {
            Manifest.permission.CAMERA
    };
    private EffectOptionContainer mEffectContainer;
    private TextureView mVideoSurface;
    private boolean mPermissionGranted;
    private int mRemoteUid = -1;
    private FrameLayout mRemoteViewContainer;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initUI();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        rtcEngine().leaveChannel();
        rtcEngine().stopPreview();
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

        @Override
        public void onEffectNotSupported(int index, int textResource) {
            Toast.makeText(STChatActivity.this, R.string.sorry_no_permission, Toast.LENGTH_SHORT).show();
        }
    }

    private void setStickerItem(boolean selected) {
        preProcessor().onStickerSelected("style_lightly" + File.separator + "wanneng.zip", selected);
    }

    private void setFilter(boolean selected) {
        if (selected) {
            preProcessor().onFilterSelected("filter_portrait" + File.separator + "filter_style_babypink.model", 1);
        } else {
            preProcessor().onFilterSelected("filter_portrait" + File.separator + "filter_style_babypink.model", 0);
        }
    }

    private void setMakeupItemParam(boolean selected) {
        if (selected) {
            preProcessor().onMakeupSelected(STMobileMakeupType.ST_MAKEUP_TYPE_LIP, "makeup_lip" + File.separator + "12自然.zip", 1);
        } else {
            preProcessor().onMakeupSelected(STMobileMakeupType.ST_MAKEUP_TYPE_LIP, null, 0);
        }
    }

    private void setBeautificationOn(boolean selected) {
        if (selected) {
            preProcessor().onBeautyModeSelected(STEffectBeautyType.EFFECT_BEAUTY_BASE_WHITTEN, STEffectBeautyType.WHITENING1_MODE);
            preProcessor().onBeautyStrengthSelected(STEffectBeautyType.EFFECT_BEAUTY_BASE_WHITTEN, 100f);
            preProcessor().onBeautyStrengthSelected(STEffectBeautyType.EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE, 1.0f);
        } else {
            preProcessor().onBeautyModeSelected(STEffectBeautyType.EFFECT_BEAUTY_BASE_WHITTEN, STEffectBeautyType.WHITENING1_MODE);
            preProcessor().onBeautyStrengthSelected(STEffectBeautyType.EFFECT_BEAUTY_BASE_WHITTEN, 0f);
            preProcessor().onBeautyStrengthSelected(STEffectBeautyType.EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE, 0.0f);
        }
    }

    private void initRoom() {
        joinChannel();
    }

    private void joinChannel() {
        rtcEngine().setVideoEncoderConfiguration(new VideoEncoderConfiguration(
                VideoEncoderConfiguration.VD_640x360,
                VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_24,
                VideoEncoderConfiguration.STANDARD_BITRATE,
                VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT));
        rtcEngine().setClientRole(io.agora.rtc2.Constants.CLIENT_ROLE_BROADCASTER);
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
        // Can attach other consumers here,
        // For example, rtc consumer or rtmp module
        rtcEngine().setupLocalVideo(new VideoCanvas(mVideoSurface, Constants.RENDER_MODE_HIDDEN, Constants.VIDEO_MIRROR_MODE_DISABLED, 0));
        rtcEngine().startPreview();
        updateEffectOptionPanel();
    }

    private void updateEffectOptionPanel() {
        // Beautification
        mEffectContainer.setItemViewStyles(0, false, true);
        // Sticker
        mEffectContainer.setItemViewStyles(2, false, true);
    }


    public void onCameraChange(View view) {
        rtcEngine().switchCamera();
        preProcessor().switchCamera();
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
        if (mRemoteUid == -1 && state == Constants.REMOTE_VIDEO_STATE_PLAYING) {
            runOnUiThread(() -> {
                mRemoteUid = uid;
                setRemoteVideoView(uid);
            });
        }else{
            runOnUiThread(() -> {
                mRemoteUid = -1;
                mRemoteViewContainer.removeAllViews();
            });
        }
    }

    private void setRemoteVideoView(int uid) {
        SurfaceView surfaceView = new SurfaceView(this);
        rtcEngine().setupRemoteVideo(new VideoCanvas(
                surfaceView, VideoCanvas.RENDER_MODE_HIDDEN, uid));
        mRemoteViewContainer.addView(surfaceView);
    }
}
