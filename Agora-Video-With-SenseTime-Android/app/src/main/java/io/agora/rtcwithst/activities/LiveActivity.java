package io.agora.rtcwithst.activities;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.SurfaceView;
import android.view.TextureView;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import androidx.annotation.Nullable;

import io.agora.capture.framework.modules.channels.ChannelManager;
import io.agora.capture.video.camera.CameraVideoManager;
import io.agora.capture.video.camera.VideoModule;
import io.agora.rtc.Constants;
import io.agora.rtc.RtcEngine;
import io.agora.rtc.video.VideoCanvas;
import io.agora.rtc.video.VideoEncoderConfiguration;
import io.agora.rtcwithst.Constant;
import io.agora.rtcwithst.R;
import io.agora.rtcwithst.framework.PreprocessorSenseTime;
import io.agora.rtcwithst.rtc.IRtcEventHandler;
import io.agora.rtcwithst.framework.RtcVideoConsumer;
import io.agora.rtcwithst.views.sensetime.EffectOptionsLayout;

public class LiveActivity extends BaseActivity implements IRtcEventHandler {
    private static final String TAG = LiveActivity.class.getSimpleName();

    private FrameLayout mRemotePreviewLayout;

    private CameraVideoManager mVideoManager;
    private boolean mFinished;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        registerHandler(this);
        checkPermission();
    }

    @Override
    protected void onPermissionsGranted() {
        init();
        joinChannel();
    }

    private void init() {
        setContentView(R.layout.live_activity);

        mVideoManager = videoManager();
        mVideoManager.setPictureSize(640, 480);
        mVideoManager.setFrameRate(24);

        RelativeLayout localLayout = findViewById(R.id.local_preview_layout);
        TextureView textureView = new TextureView(this);
        localLayout.addView(textureView);
        mVideoManager.setLocalPreview(textureView);
        mVideoManager.startCapture();

        EffectOptionsLayout effectLayout = findViewById(R.id.effect_option_layout);
        effectLayout.setSTEffectListener((PreprocessorSenseTime)mVideoManager.getPreprocessor());
        mRemotePreviewLayout = findViewById(R.id.remote_view_layout);
    }

    @Override
    protected void onPermissionsFailed() {

    }

    private void joinChannel() {
        String channelName = getIntent().getStringExtra(Constant.ACTION_KEY_ROOM_NAME);
        rtcEngine().setClientRole(Constants.CLIENT_ROLE_BROADCASTER);

        rtcEngine().setVideoSource(new RtcVideoConsumer(VideoModule.instance(),
                ChannelManager.ChannelID.CAMERA));

        rtcEngine().setVideoEncoderConfiguration(new VideoEncoderConfiguration(
                VideoEncoderConfiguration.VD_640x480,
                VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_24,
                VideoEncoderConfiguration.STANDARD_BITRATE,
                VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT));
        rtcEngine().joinChannel(null, channelName, null, 0);
    }

    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        Log.i(TAG, "joinChannelSuccess:" + channel + "|" + (uid & 0xFFFFFFFFL));
    }

    @Override
    public void onUserJoined(int uid, int elapsed) {
        createRemoteView(getApplicationContext(), uid);
    }

    private void createRemoteView(final Context context, final int uid) {
        runOnUiThread(() -> {
            SurfaceView remoteView = RtcEngine.CreateRendererView(context);
            mRemotePreviewLayout.addView(remoteView);
            mRemotePreviewLayout.setVisibility(View.VISIBLE);
            rtcEngine().setupRemoteVideo(new VideoCanvas(remoteView,
                    VideoCanvas.RENDER_MODE_HIDDEN, uid));
        });
    }

    @Override
    public void onUserOffline(int uid, int reason) {
        runOnUiThread(() -> {
            mRemotePreviewLayout.removeAllViews();
            mRemotePreviewLayout.setVisibility(View.GONE);
        });
    }

    public void onCameraChange(View view) {
        if (mVideoManager != null) {
            mVideoManager.switchCamera();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        if (mVideoManager != null) {
            mVideoManager.startCapture();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (!mFinished && mVideoManager != null) {
            mVideoManager.stopCapture();
        }
    }

    @Override
    public void finish() {
        super.finish();
        mFinished = true;
        if (mVideoManager != null) {
            mVideoManager.stopCapture();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        removeHandler(this);
        rtcEngine().leaveChannel();
    }
}
