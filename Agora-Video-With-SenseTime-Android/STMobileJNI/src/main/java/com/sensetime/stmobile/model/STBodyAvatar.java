package com.sensetime.stmobile.model;

public class STBodyAvatar {

    STQuaternion[] quaternions;
    int bodyQuatCount;
    boolean isIdle;

    public STQuaternion[] getQuaternions() {
        return quaternions;
    }

    public boolean isIdle() {
        return isIdle;
    }

    public int getBodyQuatCount() {
        return bodyQuatCount;
    }
}
