package io.agora.rtcwithst;


import android.app.Application;
import android.text.TextUtils;
import android.util.Log;

import io.agora.rtc2.RtcEngine;
import io.agora.rtcwithst.framework.PreprocessorSenseTime;

public class MyApplication extends Application {
    private RtcEngine mRtcEngine;
    private RtcEngineEventHandlerProxy mRtcEventHandler;
    private PreprocessorSenseTime preprocessorSenseTime;

    @Override
    public void onCreate() {
        super.onCreate();
        initRtcEngine();
    }

    private void initRtcEngine() {
        String appId = getString(R.string.AGORA_APP_ID);
        if (TextUtils.isEmpty(appId)) {
            throw new RuntimeException("NEED TO use your App ID, get your own ID at https://dashboard.agora.io/");
        }

        mRtcEventHandler = new RtcEngineEventHandlerProxy();
        try {
            mRtcEngine = RtcEngine.create(this, appId, mRtcEventHandler);
            mRtcEngine.enableVideo();
            preprocessorSenseTime = new PreprocessorSenseTime(this);
            mRtcEngine.registerVideoFrameObserver(preprocessorSenseTime);
            mRtcEngine.setChannelProfile(io.agora.rtc2.Constants.CHANNEL_PROFILE_LIVE_BROADCASTING);
        } catch (Exception e) {
            throw new RuntimeException("NEED TO check rtc sdk init fatal error\n" + Log.getStackTraceString(e));
        }
    }

    public RtcEngine rtcEngine() {
        return mRtcEngine;
    }

    public PreprocessorSenseTime preProcessor() {
        return preprocessorSenseTime;
    }

    public void addRtcHandler(RtcEngineEventHandler handler) {
        mRtcEventHandler.addEventHandler(handler);
    }

    public void removeRtcHandler(RtcEngineEventHandler handler) {
        mRtcEventHandler.removeEventHandler(handler);
    }

}
