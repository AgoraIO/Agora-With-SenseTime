package io.agora.rtcwithst;

import android.app.Application;

import io.agora.capture.video.camera.CameraVideoManager;
import io.agora.capture.video.camera.VideoModule;
import io.agora.rtc.Constants;
import io.agora.rtc.RtcEngine;
import io.agora.rtcwithst.framework.PreprocessorSenseTime;
import io.agora.rtcwithst.rtc.IRtcEventHandler;
import io.agora.rtcwithst.rtc.RtcEventHandler;

public class AgoraApplication extends Application {
    private CameraVideoManager mVideoManager;
    private RtcEngine mRtcEngine;
    private RtcEventHandler mEventHandler;

    @Override
    public void onCreate() {
        super.onCreate();
        initVideoModule();
        initRtcEngine();
    }

    private void initVideoModule() {
        mVideoManager = new CameraVideoManager(this,
                new PreprocessorSenseTime(getApplicationContext()));
    }

    private void initRtcEngine() {
        try {
            mEventHandler = new RtcEventHandler();
            mRtcEngine = RtcEngine.create(getApplicationContext(),
                    getResources().getString(R.string.AGORA_APP_ID), mEventHandler);
            mRtcEngine.enableVideo();
            mRtcEngine.enableDualStreamMode(false);
            mRtcEngine.setChannelProfile(Constants.CHANNEL_PROFILE_LIVE_BROADCASTING);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public CameraVideoManager videoManager() {
        return mVideoManager;
    }

    public RtcEngine rtcEngine() {
        return mRtcEngine;
    }

    public void registerEventHandler(IRtcEventHandler handler) {
        mEventHandler.registerHandler(handler);
    }

    public void removeEventHandler(IRtcEventHandler handler) {
        mEventHandler.removeHandler(handler);
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        VideoModule.instance().stopAllChannels();
        RtcEngine.destroy();
    }
}
