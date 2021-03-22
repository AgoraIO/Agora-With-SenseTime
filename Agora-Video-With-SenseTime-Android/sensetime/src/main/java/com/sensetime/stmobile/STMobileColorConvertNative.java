package com.sensetime.stmobile;


public class STMobileColorConvertNative {
    private long colorConvertNativeHandle;

    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }

    /**
     * 创建实例
     *
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int createInstance();

    /**
     * 设置color convert输入buffer的尺寸，提前调用该接口可以提升后续color convert接口的时间，需要在OpenGL Context中调用
     *
     * @param width 待转换图像的宽度
     * @param height 待转换图像的高度
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int setTextureSize(int width, int height);

    /**
     * 对输入的nv21格式的buffer转换成RGBA格式，并输出到texId对应的OpenGL纹理中，需要在OpenGL Context中调用
     *
     * @param width 待转换图像的宽度
     * @param height 待转换图像的高度
     * @param orientation 图像朝向，根据传入图像旋转角度，将图像转正。如果旋转角度为90或270，tex_out的宽高需要与buffer的宽高对调
     * @param needMirror 是否需要将输出纹理镜像
     * @param imageData NV21格式的图像buffer
     * @param textureId RGBA格式输出纹理，需要在调用层预先创建
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int nv21BufferToRgbaTexture(int width, int height, int orientation, boolean needMirror, byte[] imageData, int textureId);

    /**
     * 对输入的纹理转换为nv21格式，并输出到buffer，需要在OpenGL Context中调用
     *
     * @param textureId RGBA格式输入纹理，需要在调用层预先创建
     * @param width 纹理的宽度
     * @param height 纹理的高度
     * @param nv21ImageData 输出NV21格式的图像buffer，需要在应用层分配内存

     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int rgbaTextureToNv21Buffer(int textureId, int width, int height, byte[] nv21ImageData);

    /**
     * 对输入的nv12格式的buffer转换成RGBA格式，并输出到texId对应的OpenGL纹理中，需要在OpenGL Context中调用
     *
     * @param width 待转换图像的宽度
     * @param height 待转换图像的高度
     * @param orientation 图像朝向，根据传入图像旋转角度，将图像转正。如果旋转角度为90或270，tex_out的宽高需要与buffer的宽高对调
     * @param needMirror 是否需要将输出纹理镜像
     * @param imageData NV21格式的图像buffer
     * @param textureId RGBA格式输出纹理，需要在调用层预先创建
     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int nv12BufferToRgbaTexture(int width, int height, int orientation, boolean needMirror, byte[] imageData, int textureId);

    /**
     * 对输入的纹理转换为nv12格式，并输出到buffer，需要在OpenGL Context中调用
     *
     * @param textureId RGBA格式输入纹理，需要在调用层预先创建
     * @param width 纹理的宽度
     * @param height 纹理的高度
     * @param nv21ImageData 输出NV12格式的图像buffer，需要在应用层分配内存

     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int rgbaTextureToNv12Buffer(int textureId, int width, int height, byte[] nv21ImageData);

    /**
     * 对输入的纹理转换为灰度格式，并输出到buffer，需要在OpenGL Context中调用
     *
     * @param textureId RGBA格式输入纹理，需要在调用层预先创建
     * @param width 纹理的宽度
     * @param height 纹理的高度
     * @param gray8ImageData 输出gray8格式的图像buffer，需要在应用层分配内存

     * @return 成功返回0，错误返回其他，参考STCommon.ResultCode
     */
    public native int rgbaTextureToGray8Buffer(int textureId, int width, int height, byte[] gray8ImageData);

    /**
     * 销毁实例
     */
    public native void destroyInstance();
}
