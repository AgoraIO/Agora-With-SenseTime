package com.sensetime.stmobile;

import android.content.Context;
import android.content.res.AssetManager;
import android.util.Log;

import com.sensetime.stmobile.model.STEffect3DBeautyPartInfo;
import com.sensetime.stmobile.model.STEffectBeautyInfo;
import com.sensetime.stmobile.model.STEffectModuleInfo;
import com.sensetime.stmobile.model.STEffectPackageInfo;
import com.sensetime.stmobile.model.STEffectRenderInParam;
import com.sensetime.stmobile.model.STEffectRenderOutParam;
import com.sensetime.stmobile.model.STEffectTryonInfo;
import com.sensetime.stmobile.model.STFaceMeshList;
import com.sensetime.stmobile.model.STImage;
import com.sensetime.stmobile.model.STQuaternion;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class STMobileEffectNative {

    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }

    //供JNI使用，应用不需要关注
    private long nativeEffectHandle;

    private STSoundPlay mSoundPlay;

    //创建handle使用
    public static final int EFFECT_CONFIG_NONE = 0x0;  // 默认模式，输入连续序列帧时使用，比如视频或预览模式
    public static final int EFFECT_CONFIG_IMAGE_MODE = 0x2;  // 图像模式，输入为静态图像或单帧图像

    public static String getFilePath(String filename) {
        if ((filename != null) && (filename.length() > 0)) {
            int dot = filename.lastIndexOf('/');
            if ((dot > -1) && (dot < (filename.length()))) {
                return filename.substring(0, dot + 1);
            }
        }
        return filename;
    }

    /**
     * 创建美颜句柄
     *
     * @param context 上下文
     * @param config  素材生效模式
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public int createInstance(Context context, int config) {
        if (context != null) {
            mSoundPlay = STSoundPlay.getInstance(context);
        }

        String path = "";
//        path = findLibrary(context, "ppl3Hexagon_skel");
//        path = getFilePath(path);
//        if (null!=path) {
//        Log.d("lugqpath8", "createInstance: " + path);
//
//        } else {
//        Log.d("lugqpath8", "createInstance: nulllll" );
//        path = "";
//
//        }
        int ret = createInstanceNative(config, path);

        if (0 == ret && mSoundPlay != null) {
            mSoundPlay.setEffectHandle(this);
        }

        return ret;
    }

    public static String findLibrary(Context context, String libName) {
        String result = null;
        ClassLoader classLoader = (context.getClassLoader());
        if (classLoader != null) {
            try {
                Method findLibraryMethod = classLoader.getClass().getMethod("findLibrary", new Class<?>[] { String.class });
                if (findLibraryMethod != null) {
                    Object objPath = findLibraryMethod.invoke(classLoader, new Object[] { libName });
                    if (objPath != null && objPath instanceof String) {
                        result = (String) objPath;
                    }
                }
            } catch (NoSuchMethodException e) {
                Log.e("findLibrary1", e.toString());
            } catch (IllegalAccessException e) {
                Log.e("findLibrary1", e.toString());
            } catch (IllegalArgumentException e) {
                Log.e("findLibrary1", e.toString());
            } catch (InvocationTargetException e) {
                Log.e("findLibrary1", e.toString());
            } catch (Exception e) {
                Log.e("findLibrary1", e.toString());
            }
        }

        return result;
    }

    /**
     * 创建实例
     *
     * @param config 素材生效模式
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    private native int createInstanceNative(int config, String path);

    /**
     * 释放实例
     */
    public void destroyInstance() {
        destroyInstanceNative();
        if (mSoundPlay != null) {
            mSoundPlay.release();
            mSoundPlay = null;
        }
    }

    public void destroyInstance(boolean needReleaseSoundPlay) {
        destroyInstanceNative();
        if (needReleaseSoundPlay && mSoundPlay != null) {
            mSoundPlay.release();
            mSoundPlay = null;
        }
    }

    /**
     * 通知声音停止函数
     *
     * @param name 结束播放的声音文件名（MB）,默认150MB,素材过大时,循环加载,降低内存； 贴纸较小时,全部加载,降低cpu
     * @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
     */
    public native int setSoundPlayDone(String name);

    /**
     * 释放实例
     *
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    private native int destroyInstanceNative();

    /**
     * 设置特效的参数
     *
     * @param param 参数类型
     * @param value 参数数值，具体范围参考参数类型说明
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int setParam(int param, float value);

    /**
     * 设置美颜相关参数
     * @param param 配置项类型
     * @param value 配置项参数值
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int setBeautyParam(int param, float value);

    /**
     * 获取特效的参数
     *
     * @param param 参数类型
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native float getParam(int param);

    /**
     * 设置试妆相关参数
     * @param info TryOn接口输入参数
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int setTryOnParam(STEffectTryonInfo info, int type);

    /**
     * 获取试妆相关参数
     */
    public native STEffectTryonInfo getTryOnParam(int tryonType);

    /**
     * 设置美颜的模式, 目前仅对磨皮和美白有效
     *
     * @param param 美颜类型
     * @param value 模式
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int setBeautyMode(int param, int value);

    /**
     * 获取美颜的模式, 目前仅对磨皮和美白有效
     *
     * @param param 美颜类型
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int getBeautyMode(int param);

    /**
     * 添加素材包
     *
     * @param path 待添加的素材包文件路径
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int addPackage(String path);

    /**
     * 从assets资源文件添加素材包
     *
     * @param file_path 待添加的素材包文件路径
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int addPackageFromAssetsFile(String file_path, AssetManager assetManager);

    /**
     * 更换缓存中的素材包 (删除已有的素材包)
     *
     * @param path 待添加的素材包文件路径
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int changePackage(String path);

    /**
     * 从assets资源文件更换缓存中的素材包 (删除已有的素材包)
     *
     * @param file_path 待添加的素材包文件路径
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int changePackageFromAssetsFile(String file_path, AssetManager assetManager);

    /**
     * 删除指定素材包
     *
     * @param id 待删除的素材包ID
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int removeEffect(int id);

    /**
     * 清空所有素材包
     */
    public native void clear();

    /**
     * 获取素材信息
     *
     * @param packageId 素材包ID
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native STEffectPackageInfo getPackageInfo(int packageId);

    /**
     * 获取素材的贴纸信息
     *
     * @param packageId   素材包ID
     * @param moduleCount 贴纸信息地址能容纳的贴纸的数量
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native STEffectModuleInfo[] getModulesInPackage(int packageId, int moduleCount);

    /**
     * 获取贴纸信息
     *
     * @param moduleId 贴纸ID
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native STEffectModuleInfo getModuleInfo(int moduleId);

    /**
     * 获取覆盖生效的美颜的数量, 仅在添加，更改，移除素材之后调用
     *
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int getOverlappedBeautyCount();

    /**
     * 获取覆盖生效的美颜的信息, 仅在添加，更改，移除素材之后调用
     *
     * @param beautyCount 起始地址可以容纳美颜信息的数量
     */
    public native STEffectBeautyInfo[] getOverlappedBeauty(int beautyCount);

    /**
     * 设置美颜的强度
     *
     * @param type  美颜类型
     * @param value 强度
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int setBeautyStrength(int type, float value);

    /**
     * 获取美颜的强度
     *
     * @param type 美颜类型
     * @return 强度
     */
    public native float getBeautyStrength(int type);

    /**
     * 加载美颜素材
     *
     * @param param 美颜类型
     * @param path  待添加的素材文件路径
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int setBeauty(int param, String path);

    /**
     * 加载美颜素材
     *
     * @param param     美颜类型
     * @param file_path 待添加的素材文件路径
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int setBeautyFromAssetsFile(int param, String file_path, AssetManager assetManager);

    /**
     * 获取需要的检测配置选项
     */
    public native long getHumanActionDetectConfig();

    /**
     * 获取目前需要的动物检测类型
     */
    public native long getAnimalDetectConfig();

    /**
     * 获取自定义配置
     */
    public native long getCustomParamConfig();

    /**
     * 特效渲染, 必须在OpenGL渲染线程中执行
     *
     * @param inputParams  输入的渲染信息
     * @param outputParams 输出的渲染信息
     * @param needOutputHumanAction 是否输出特效处理之后的检测结果
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int render(STEffectRenderInParam inputParams, STEffectRenderOutParam outputParams, boolean needOutputHumanAction);

    /**
     * 重新播放素材
     *
     * @param packageId 贴纸id
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int replayPackage(int packageId);

    /**
     * 设置贴纸素材包内部美颜组合的强度，强度范围[0.0, 1.0]
     *
     * @param packageId  素材包id
     * @param beautyGroup 美颜组合类型，目前只支持设置美妆、滤镜组合的强度
     * @param strength 强度值
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int setPackageBeautyGroupStrength(int packageId, int beautyGroup, float strength);

    /**
     * 释放内部缓存的资源，目前主要是GL相关的渲染资源，需要在GL context中调用
     *
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int releaseCachedResource();

    /**
     * 在调用st_mobile_effect_set_beauty函数加载了3D微整形素材包之后调用。获取到素材包中所有的blendshape名称、index和当前强度[0, 1]
     *
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native STEffect3DBeautyPartInfo[] get3DBeautyParts();

    /**
     * 在调用st_mobile_effect_set_beauty函数加载了3D微整形素材包之后调用。在获取blendshape数组之后，可以依据起信息修改权重[0, 1]，设置给渲染引擎产生效果。
     *
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int set3dBeautyPartsStrength(STEffect3DBeautyPartInfo[] effect3DBeautyPartInfo, int length);

    /**
     * 用于输入human action的face mesh list信息。
     *
     * @param faceMeshList 从human action中获取的face_mesh_list信息
     * @return 成功返回0，错误返回其它，参考STResultCode
     */
    public native int setFaceMeshList(STFaceMeshList faceMeshList);

    /**
     * 获取需要的自定义事件选项
     */
    public native int getCustomEventNeeded();

    /**
     * 获取前摄/后摄对应的默认手机姿态四元数，在处理图片、视频或者没有相应的手机姿态的情况下，需要传入默认的camera_quat
     * @return 四元数
     */
    public native STQuaternion getDefaultCameraQuaternion(boolean frontCamera);

    public native int changeBg(int stickerId, STImage image);

    /**
     * 用于 JNI 中调用
     */
    public void packageStateChangeCalledByJni(int packageState, int packageId) {
        if (null != mListener) {
            mListener.packageStateChange(packageState, packageId);
        }
    }

    private Listener mListener;

    public void setListener(Listener listener) {
        this.mListener = listener;
    }

    public interface Listener {
        /**
         * 素材包的播放状态
         * @param packageState 对应 STEffectPackageState 中状态
         * @param packageId 素材包ID
         */
        void packageStateChange(int packageState, int packageId);
    }

}
