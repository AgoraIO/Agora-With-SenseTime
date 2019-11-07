package io.agora.rtcwithst.rtc;

public interface IRtcEventHandler {
    void onJoinChannelSuccess(String channel, int uid, int elapsed);
    void onUserJoined(int uid, int elapsed);
    void onUserOffline(int uid, int reason);
}
