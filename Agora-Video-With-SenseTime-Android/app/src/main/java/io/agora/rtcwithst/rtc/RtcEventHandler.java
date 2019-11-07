package io.agora.rtcwithst.rtc;

import java.util.ArrayList;
import java.util.List;

import io.agora.rtc.IRtcEngineEventHandler;

public class RtcEventHandler extends IRtcEngineEventHandler {
    private List<IRtcEventHandler> mHandlers = new ArrayList<>();

    public void registerHandler(IRtcEventHandler handler) {
        if (!mHandlers.contains(handler)) {
            mHandlers.add(handler);
        }
    }

    public void removeHandler(IRtcEventHandler handler) {
        mHandlers.remove(handler);
    }

    @Override
    public void onJoinChannelSuccess(String channel, int uid, int elapsed) {
        for (IRtcEventHandler handler : mHandlers) {
            handler.onJoinChannelSuccess(channel, uid, elapsed);
        }
    }

    @Override
    public void onUserJoined(int uid, int elapsed) {
        for (IRtcEventHandler handler : mHandlers) {
            handler.onUserJoined(uid, elapsed);
        }
    }

    @Override
    public void onUserOffline(int uid, int reason) {
        for (IRtcEventHandler handler : mHandlers) {
            handler.onUserOffline(uid, reason);
        }
    }
}
