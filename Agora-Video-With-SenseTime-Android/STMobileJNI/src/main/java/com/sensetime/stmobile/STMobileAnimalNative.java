package com.sensetime.stmobile;


import android.content.res.AssetManager;

import com.sensetime.stmobile.model.STAnimalFace;

/**
 * Created by sensetime on 18-8-1.
 */

public class STMobileAnimalNative {
    private final static String TAG = STMobileAnimalNative.class.getSimpleName();

    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }

    //供JNI使用，应用不需要关注
    private long nativeAnimalHandle;

    public final static int ST_MOBILE_CAT_DETECT = 0x00000001;  ///< 猫脸检测
    public final static int ST_MOBILE_DOG_DETECT = 0x00000010;  ///< 狗脸检测

    /// 检测模式
    public final static int ST_MOBILE_DETECT_MODE_VIDEO = 0x00020000;  ///< 视频检测
    public final static int ST_MOBILE_DETECT_MODE_IMAGE = 0x00040000;  ///< 图片检测

    /**
     * 创建实例
     *
     * @param modelpath 模型文件的,例如models/face_track_2.x.x.model
     * @param config 配置选项 例如ST_MOBILE_TRACKING_MULTI_THREAD,默认使用双线程跟踪,实时视频预览建议使用该配置.
         使用单线程算法建议选择（ST_MOBILE_TRACKING_SINGLE_THREAD)
         图片版建议选择ST_MOBILE_DETECT_MODE_IMAGE
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstance(String modelpath, int config);

    /**
     * 创建实例
     *
     * @param assetModelpath 模型文件的,例如models/face_track_2.x.x.model
     * @param config 配置选项 例如ST_MOBILE_TRACKING_MULTI_THREAD,默认使用双线程跟踪,实时视频预览建议使用该配置.
    使用单线程算法建议选择（ST_MOBILE_TRACKING_SINGLE_THREAD)
    图片版建议选择ST_MOBILE_DETECT_MODE_IMAGE
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstanceFromAssetFile(String assetModelpath, int config, AssetManager assetManager);


    /**
     * @param type  要设置Animal参数的类型
     * @param value 设置的值
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public native int setParam(int type, float value);

    /**
     * 重置，清除所有缓存信息
     *
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public native int reset();

    /**
     * 释放instance
     */
    public native void destroyInstance();

    /**
     * 检测猫脸
     *
     * @param imgData       用于检测的图像数据
     * @param imageFormat   用于检测的图像数据的像素格式,比如STCommon.ST_PIX_FMT_NV12。能够独立提取灰度通道的图像格式处理速度较快，
     *                      比如ST_PIX_FMT_GRAY8，ST_PIX_FMT_YUV420P，ST_PIX_FMT_NV12，ST_PIX_FMT_NV21
     * @param orientation   图像中猫脸的方向,例如STRotateType.ST_CLOCKWISE_ROTATE_0
     * @param imageWidth    用于检测的图像的宽度(以像素为单位)
     * @param imageHeight   用于检测的图像的高度(以像素为单位)
     * @return 猫脸信息
     */
    public native STAnimalFace[] animalDetect(byte[] imgData, int imageFormat, int orientation, int detectConfig, int imageWidth, int imageHeight);

    /**
     * 镜像猫脸检测结果
     *
     * @param width        用于转换的图像的宽度(以像素为单位)
     * @param animalFace  需要镜像的STAnimalFace的数组
     * @param faceCount 猫脸的数量
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public static native STAnimalFace[] animalMirror(int width, STAnimalFace[] animalFace, int faceCount);

    /**
     * 旋转human_action检测结果
     *
     * @param width        用于转换的图像的宽度(以像素为单位)
     * @param height       用于转换的图像的高度(以像素为单位)
     * @param orientation  顺时针旋转的角度,例如STRotateType.ST_CLOCKWISE_ROTATE_90（旋转90度）
     * @param animalFace  需要镜像的STAnimalFace的数组
     * @param faceCount 猫脸的数量
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public static native STAnimalFace[] animalRotate(int width, int height, int orientation, STAnimalFace[] animalFace, int faceCount);

    /**
     * resize human_action检测结果
     *
     * @param scale        缩放的尺度
     * @param animalFace  需要镜像的STAnimalFace的数组
     * @param faceCount 猫脸的数量
     * @return 成功返回新humanActon，错误返回null
     */
    public static native STAnimalFace[] animalResize(float scale, STAnimalFace[] animalFace, int faceCount);

    /**
     * 添加子模型.
     *
     * @param modelPath 模型文件的路径. 后添加的会覆盖之前添加的同类子模型。加载模型耗时较长, 建议在初始化创建句柄时就加载模型
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public native int addSubModel(String modelPath);

    /**
     * 从资源文件夹添加子模型.
     *
     * @param assetModelpath 模型文件的路径. 后添加的会覆盖之前添加的同类子模型。加载模型耗时较长, 建议在初始化创建句柄时就加载模型
     * @param assetManager 资源文件管理器
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int addSubModelFromAssetFile(String assetModelpath, AssetManager assetManager);
}
