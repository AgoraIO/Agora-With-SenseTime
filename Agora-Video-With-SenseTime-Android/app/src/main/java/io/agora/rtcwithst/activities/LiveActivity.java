package io.agora.rtcwithst.activities;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.SurfaceView;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.Nullable;

import io.agora.framework.channels.ChannelManager;
import io.agora.kit.media.camera.capture.VideoCapture;
import io.agora.kit.media.camera.capture.VideoCaptureFactory;
import io.agora.rtc.Constants;
import io.agora.rtc.RtcEngine;
import io.agora.rtc.video.VideoCanvas;
import io.agora.rtc.video.VideoEncoderConfiguration;
import io.agora.rtcwithst.Constant;
import io.agora.rtcwithst.R;
import io.agora.rtcwithst.rtc.IRtcEventHandler;
import io.agora.rtcwithst.framework.RtcVideoConsumer;
import io.agora.rtcwithst.views.sensetime.EffectOptionsLayout;

public class LiveActivity extends BaseActivity implements IRtcEventHandler {
    private static final String TAG = LiveActivity.class.getSimpleName();

    private VideoCapture mVideoCapture;

    private FrameLayout mRemotePreviewLayout;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initUI();
        checkPermission();
    }

    private void initUI() {
        setContentView(R.layout.live_activity);
        EffectOptionsLayout effectLayout = findViewById(R.id.effect_option_layout);
        effectLayout.setSTEffectListener(getSenseTimeRender());
        mRemotePreviewLayout = findViewById(R.id.remote_view_layout);
    }

    @Override
    protected void onPermissionsGranted() {
        registerHandler(this);
        startVideoCapture();
        joinChannel();
    }

    @Override
    protected void onPermissionsFailed() {

    }

    private void startVideoCapture() {
        mVideoCapture = VideoCaptureFactory.createVideoCapture(this);
        mVideoCapture.allocate(640, 480, 24, mFacing);
        mVideoCapture.startCaptureMaybeAsync(false);
        mVideoCapture.connectChannel(ChannelManager.ChannelID.CAMERA);
    }

    private void joinChannel() {
        String channelName = getIntent().getStringExtra(Constant.ACTION_KEY_ROOM_NAME);
        rtcEngine().setClientRole(Constants.CLIENT_ROLE_BROADCASTER);
        rtcEngine().setVideoSource(new RtcVideoConsumer(videoModule(),
                ChannelManager.ChannelID.CAMERA));
        rtcEngine().setVideoEncoderConfiguration(new VideoEncoderConfiguration(
                VideoEncoderConfiguration.VD_640x480,
                VideoEncoderConfiguration.FRAME_RATE.FRAME_RATE_FPS_24,
                VideoEncoderConfiguration.STANDARD_BITRATE,
                VideoEncoderConfiguration.ORIENTATION_MODE.ORIENTATION_MODE_FIXED_PORTRAIT));
        rtcEngine().joinChannel(null, channelName, null, 0);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        removeHandler(this);
        rtcEngine().leaveChannel();
        stopVideoCapture();
    }

    private void stopVideoCapture() {
        mVideoCapture.disconnect();
        mVideoCapture.stopCaptureAndBlockUntilStopped();
        mVideoCapture.deallocate();
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
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                SurfaceView remoteView = RtcEngine.CreateRendererView(context);
                mRemotePreviewLayout.addView(remoteView);
                mRemotePreviewLayout.setVisibility(View.VISIBLE);
                rtcEngine().setupRemoteVideo(new VideoCanvas(remoteView,
                        VideoCanvas.RENDER_MODE_HIDDEN, uid));
            }
        });
    }

    @Override
    public void onUserOffline(int uid, int reason) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mRemotePreviewLayout.removeAllViews();
                mRemotePreviewLayout.setVisibility(View.GONE);
            }
        });
    }

    private int mFacing = Constant.CAMERA_FACING_FRONT;

    public void onCameraChange(View view) {
        switch (mFacing) {
            case Constant.CAMERA_FACING_BACK:
                mVideoCapture.setPaused(true);
                mVideoCapture.stopCaptureAndBlockUntilStopped();
                mVideoCapture.allocate(640, 480, 24, Constant.CAMERA_FACING_FRONT);
                mFacing = Constant.CAMERA_FACING_FRONT;
                mVideoCapture.startCaptureMaybeAsync(false);
                break;
            case Constant.CAMERA_FACING_FRONT:
                mVideoCapture.stopCaptureAndBlockUntilStopped();
                mVideoCapture.allocate(640, 480, 24, Constant.CAMERA_FACING_BACK);
                mFacing = Constant.CAMERA_FACING_BACK;
                mVideoCapture.startCaptureMaybeAsync(false);
                mVideoCapture.setPaused(false);
                break;
            default:
                Log.e(TAG, "no facing matched");
        }
    }
}
