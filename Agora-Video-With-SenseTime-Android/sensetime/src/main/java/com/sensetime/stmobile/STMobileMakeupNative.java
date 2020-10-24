package com.sensetime.stmobile;

import android.content.res.AssetManager;

import com.sensetime.stmobile.model.STHumanAction;
import com.sensetime.stmobile.model.STImage;

public class STMobileMakeupNative {
    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }

    //供JNI使用，应用不需要关注
    private long nativeMakeupHandle;

    /**
     * 创建美妆实例
     *
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstance();

    /**
     * 更换美妆素材包 (删除已有的素材包)
     *
     * @param type    制定素材包所属的type, 定义如st_makeup_type
     * @param typePath 素材包路径
     * @return 成功返回packageId，错误返回-1
     */
    public native int setMakeupForType(int type, String typePath);

    /**
     * 从Asset文件夹更换美妆素材包
     *
     * @param type    制定素材包所属的type, 定义如st_makeup_type
     * @param typePath 素材包路径
     * @param assetManager 资源文件管理器
     * @return 成功返回packageId，错误返回-1
     */
    public native int setMakeupForTypeFromAssetsFile(int type, String typePath, AssetManager assetManager);

    /**
     * 添加美妆素材包
     *
     * @param type    制定素材包所属的type, 定义如st_makeup_type
     * @param typePath 素材包路径
     * @return 成功返回packageId，错误返回-1
     */
    public native int addMakeupForType(int type, String typePath);

    /**
     * 从Asset文件夹添加美妆素材包
     *
     * @param type    制定素材包所属的type, 定义如st_makeup_type
     * @param typePath 素材包路径
     * @param assetManager 资源文件管理器
     * @return 成功返回packageId，错误返回-1
     */
    public native int addMakeupForTypeFromAssetsFile(int type, String typePath, AssetManager assetManager);

    /**
     * 删除美妆素材包
     *
     * @param packageId    素材包packageId
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int removeMakeup(int packageId);

    /**
     * 删除所有美妆素材包
     */
    public native void clearMakeups();

    /**
     * 获取素材TriggerAction
     *
     * @return 成功返回TriggerAction
     */
    public native long getTriggerAction();

    /**
     * 美妆预处理
     *
     * @param imgData      humanAction对应的buffer数据
     * @param imageFormat  imgData数据格式
     * @param imageWidth   宽度
     * @param imageHeight  高度
     * @param humanAction  检测到的人脸数据
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int prepare(byte[] imgData, int imageFormat, int imageWidth, int imageHeight, STHumanAction humanAction);

    /**
     * 美妆处理，运行在gl线程
     *
     * @param textureIn    输入纹理
     * @param humanAction  humanAction检测结果
     * @param rotate       人脸在humanAction中的方向
     * @param imageWidth   输入纹理宽度
     * @param imageHeight  输入纹理高度
     * @param textureOut   输出纹理
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int processTexture(int textureIn, STHumanAction humanAction, int rotate, int imageWidth, int imageHeight, int textureOut);

    /**
     * 美妆处理并输出buffer，运行在gl线程
     *
     * @param textureIn    输入纹理
     * @param humanAction  humanAction检测结果
     * @param rotate       人脸在humanAction中的方向
     * @param imageWidth   输入纹理宽度
     * @param imageHeight  输入纹理高度
     * @param textureOut   输出纹理
     * @param outFmt       输出buffer格式
     * @param imageOut     输出buffer数据
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int processTextureAndOutputBuffer(int textureIn, STHumanAction humanAction, int rotate, int imageWidth, int imageHeight, int textureOut, int outFmt, byte[] imageOut);

    /**
     * 设置美妆强度
     *
     * @param type    制定素材包所属的type, 定义如st_makeup_type
     * @param value   强度值
     */
    public native void setStrengthForType(int type, float value);

    /**
     * 设置磨皮强度
     *
     * @param type    制定素材包所属的type, 定义如st_makeup_type
     * @param value   强度值
     */
    public native void setSmoothStrengthForType(int type, float value);

    /**
     * 修改制定类型美妆的图片素材, 仅当该类型美妆目前只有一张素材图片时起效
     *
     * @param type      制定素材包所属的type, 定义如st_makeup_type
     * @param packageId 素材包id
     * @param imageData 设置image图像数据
     */
    public native void setResourceForType(int type, int packageId, STImage imageData);

    /**
     * 销毁美妆实例
     *
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int destroyInstance();

    /**
     * 设置性能/效果优先级倾向，引擎内部会根据设置调整渲染策略
     * @param hint 性能/效果优先级，参看STPerformanceHintType
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int setPerformanceHint(int hint);

    /**
     * 美妆处理，运行在gl线程
     *
     * @param textureIn    输入纹理
     * @param humanActionPtr  humanAction检测结果对应指针
     * @param rotate       人脸在humanAction中的方向
     * @param imageWidth   输入纹理宽度
     * @param imageHeight  输入纹理高度
     * @param textureOut   输出纹理
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int processTextureWithNativePtr(int textureIn, long humanActionPtr, int rotate, int imageWidth, int imageHeight, int textureOut);

    /**
     * 美妆处理并输出buffer，运行在gl线程
     *
     * @param textureIn    输入纹理
     * @param humanActionPtr  humanAction检测结果
     * @param rotate       人脸在humanAction中的方向
     * @param imageWidth   输入纹理宽度
     * @param imageHeight  输入纹理高度
     * @param textureOut   输出纹理
     * @param outFmt       输出buffer格式
     * @param imageOut     输出buffer数据
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int processTextureAndOutputBufferWithNativePtr(int textureIn, long humanActionPtr, int rotate, int imageWidth, int imageHeight, int textureOut, int outFmt, byte[] imageOut);

}
