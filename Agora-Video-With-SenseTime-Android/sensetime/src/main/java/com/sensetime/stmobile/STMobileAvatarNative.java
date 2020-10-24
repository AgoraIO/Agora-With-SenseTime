package com.sensetime.stmobile;

import android.content.res.AssetManager;

import com.sensetime.stmobile.model.STHumanAction;
import com.sensetime.stmobile.model.STMobileFaceInfo;

public class STMobileAvatarNative {

    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }

    //供JNI使用，应用不需要关注
    private long nativeAvatarHandle;

    public native int createInstance(String modelpath);

    public native int createInstanceFromAssetFile(String assetModelpath, AssetManager assetManager);

    public native void destroyInstance();

    public native long getAvatarDetectConfig();

    public native int avatarExpressionDetect(int rotate, int imageWidth, int imageHeight, STMobileFaceInfo humanActionInput, float[] outputArray);
}

