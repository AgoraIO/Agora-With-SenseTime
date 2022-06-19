package com.sensetime.stmobile;

import android.content.res.AssetManager;

import com.sensetime.stmobile.model.STImage;
import com.sensetime.stmobile.model.STMobile106;


/**
 * 人脸比对JNI定义
 */
public class STMobileFaceVerifyNative {
    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }

    //供底层使用，不需要关注
    private long STMobileFaceVerifyNativeHandle;

    /**
     * 创建实例
     *
     * @param modelpath 模型路径
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstance(String modelpath);

    /**
     * 从assets资源文件创建实例
     *
     * @param assetModelpath 模型路径
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstanceFromAssetFile(String assetModelpath, AssetManager assetManager);

    /**
     * 获取人脸特征
     *
     * @param image      用于检测的图像数据
     * @param face106  输入待处理的人脸信息，需要包括关键点信息
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native byte[] getFeature(STImage image, STMobile106 face106);

    /**
     * 获取人脸比对分数
     *
     * @param feature_01  输入人脸特征1
     * @param feature_02  输入人脸特征2
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native float getFeaturesCompareScore(byte[] feature_01, byte[] feature_02);

    /**
     * 释放实例
     */
    public native void destroyInstance();
}
