package com.sensetime.stmobile;


import android.content.res.AssetManager;

import com.sensetime.stmobile.model.STAnimalFace;

/**
 * Created by sensetime on 18-8-1.
 */

public class STMobileAnimalNative {
    private final static String TAG = STMobileAnimalNative.class.getSimpleName();

    public final static long ST_MOBILE_CAT_DETECT = 0x00000001;    ///<  猫脸检测

    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }

    //供JNI使用，应用不需要关注
    private long nativeAnimalHandle;

    public native int createInstance(String modelpath, int config);

    public native int createInstanceFromAssetFile(String assetModelpath, int config, AssetManager assetManager);

    public native int setParam(int type, float value);

    public native int reset();

    public native void destroyInstance();

    public native STAnimalFace[] animalDetect(byte[] imgData, int imageFormat, int orientation, int imageWidth, int imageHeight);

    public static native STAnimalFace[] animalMirror(int width, STAnimalFace[] animalFace, int faceCount);

    public static native STAnimalFace[] animalRotate(int width, int height, int orientation, STAnimalFace[] animalFace, int faceCount);

    public static native STAnimalFace[] animalResize(float scale, STAnimalFace[] animalFace, int faceCount);
}
