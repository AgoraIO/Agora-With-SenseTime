package io.agora.rtcwithst;

import android.app.Application;

import io.agora.framework.VideoModule;
import io.agora.framework.channels.ChannelManager;
import io.agora.rtc.Constants;
import io.agora.rtc.RtcEngine;
import io.agora.rtcwithst.framework.PreprocessorSenseTime;
import io.agora.rtcwithst.rtc.IRtcEventHandler;
import io.agora.rtcwithst.rtc.RtcEventHandler;

public class AgoraApplication extends Application {
    private VideoModule mVideoModule;
    private RtcEngine mRtcEngine;
    private RtcEventHandler mEventHandler;

    @Override
    public void onCreate() {
        super.onCreate();
        initVideoModule();
        initRtcEngine();
    }

    private void initVideoModule() {
        mVideoModule = VideoModule.instance();
        mVideoModule.init(getApplicationContext());
        mVideoModule.setPreprocessor(ChannelManager.ChannelID.CAMERA,
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
            mRtcEngine.enableWebSdkInteroperability(true);
            // mRtcEngine.setParameters("{\"rtc.log_filter\":65535}");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public VideoModule videoModule() {
        return mVideoModule;
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

    public PreprocessorSenseTime getSenseTimeRender() {
        return (PreprocessorSenseTime) mVideoModule.
                getPreprocessor(ChannelManager.ChannelID.CAMERA);
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        mVideoModule.stopAllChannels();
        RtcEngine.destroy();
    }
}
