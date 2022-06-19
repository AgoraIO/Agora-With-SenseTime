package com.sensetime.stmobile;

import com.sensetime.stmobile.model.STImage;

public class STMobileGreenScreenSegmentNative {

    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }
    private long GreenScreenSegmentNativeHandle;

    /**
     * 创建实例
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstance();

    /**
     * 处理绿幕分割（需在gl线程使用）
     * @param imageObj  输入图像
     * @param outputTexture 输出绿幕分割结果
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public native int process(STImage imageObj, int outputTexture);

    /**
     * 释放handle
     */
    public native int destroyInstance();

    /**
     * @param type  要设置参数的类型
     * @param value 设置的值
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public native int setParam(int type, float value);

    /**
     * @param type  参数关键字,和setparam对应
     * @param type 参数取值
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public native float getParam(int type);
}
