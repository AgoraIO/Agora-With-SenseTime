package com.sensetime.stmobile;

import android.content.res.AssetManager;

import com.sensetime.stmobile.model.STAttributeFaceFeature;
import com.sensetime.stmobile.model.STMobileFaceInfo;

public class STMobileAttributeFaceFeatureNative {

    private final static String TAG = STMobileAttributeFaceFeatureNative.class.getSimpleName();

    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }

    //供JNI使用，应用不需要关注
    private long nativeAttributeFaceFeatureHandle;

    /**
     * 创建实例
     *
     * @param modelpath 模型文件的,例如models/face_track_2.x.x.model
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstance(String modelpath);

    /**
     * 从资源文件夹创建实例
     *
     * @param assetModelpath 模型文件的路径
     * @param assetManager 资源文件管理器
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstanceFromAssetFile(String assetModelpath, AssetManager assetManager);

    /**
     * 通过子模型创建人体行为检测句柄, st_mobile_human_action_create和st_mobile_human_action_create_with_sub_models只能调一个
     *
     * @param modelPaths 模型文件路径指针数组. 根据加载的子模型确定支持检测的类型. 如果包含相同的子模型, 后面的会覆盖前面的.
     * @param modelCount 模型文件数目
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstanceWithSubModels(String[] modelPaths, int modelCount);

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

    /**
     * 删除已添加的子模型
     *
     * @param config 要删除的子模型对应的config，config为创建人体行为检测句柄配置选项（例如：ST_MOBILE_ENABLE_BODY_KEYPOINTS）
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int removeSubModelByConfig(int config);

    /**
     * 检测人脸106点及人脸行为
     *
     * @param imgData       用于检测的图像数据
     * @param imageFormat   用于检测的图像数据的像素格式,比如STCommon.ST_PIX_FMT_NV12。能够独立提取灰度通道的图像格式处理速度较快，
     *                      比如ST_PIX_FMT_GRAY8，ST_PIX_FMT_YUV420P，ST_PIX_FMT_NV12，ST_PIX_FMT_NV21
     * @param detect_config 检测选项，代表当前需要检测哪些动作，例如ST_MOBILE_EYE_BLINK|ST_MOBILE_MOUTH_AH表示当前帧只检测眨眼和张嘴
     * @param orientation   图像中人脸的方向,例如STRotateType.ST_CLOCKWISE_ROTATE_0
     * @param imageWidth    用于检测的图像的宽度(以像素为单位)
     * @param imageHeight   用于检测的图像的高度(以像素为单位)
     * @return 人脸信息
     */
    public native STAttributeFaceFeature faceFeaturesDetect(STMobileFaceInfo faces, int gender, int faceCount, byte[] imgData, int imageFormat, long detect_config,
                                                            int orientation, int imageWidth, int imageHeight);

    /**
     * 释放instance
     */
    public native void destroyInstance();

}
