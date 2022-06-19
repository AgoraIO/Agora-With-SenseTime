package com.sensetime.stmobile;

/**
 * 定义美颜支持的图片格式
 */
public class STCommonNative {

    static {
        System.loadLibrary("st_mobile");
        System.loadLibrary("stmobile_jni");
    }

    //支持的图片格式
    public final static int ST_PIX_FMT_GRAY8 = 0;   // Y    1        8bpp ( 单通道8bit灰度像素 )
    public final static int ST_PIX_FMT_YUV420P = 1; // YUV  4:2:0   12bpp ( 3通道, 一个亮度通道, 另两个为U分量和V分量通道, 所有通道都是连续的 )
    public final static int ST_PIX_FMT_NV12 = 2;    // YUV  4:2:0   12bpp ( 2通道, 一个通道是连续的亮度通道, 另一通道为UV分量交错 )
    public final static int ST_PIX_FMT_NV21 = 3;    // YUV  4:2:0   12bpp ( 2通道, 一个通道是连续的亮度通道, 另一通道为VU分量交错 )
    public final static int ST_PIX_FMT_BGRA8888 = 4;// BGRA 8:8:8:8 32bpp ( 4通道32bit BGRA 像素 )
    public final static int ST_PIX_FMT_BGR888 = 5;  // BGR  8:8:8   24bpp ( 3通道24bit BGR 像素 )
    public final static int ST_PIX_FMT_RGBA8888 = 6; // RGRA 8:8:8:8 32bpp ( 4通道32bit RGBA 像素 )

    //支持的最大人脸数量
    public final static int ST_MOBILE_HUMAN_ACTION_MAX_FACE_COUNT = 10;

    //人脸跟踪的配置选项，对应STMobileHumanActionNative 初始化时的config参数，具体配置如下：
    //  使用单线程或双线程track：处理图片必须使用单线程，处理视频建议使用多线程
    public final static int ST_MOBILE_TRACKING_MULTI_THREAD = 0x00000000;  // 多线程，功耗较多，卡顿较少
    public final static int ST_MOBILE_TRACKING_SINGLE_THREAD = 0x00010000;  // 单线程，功耗较少，对于性能弱的手机，会偶尔有卡顿现象

    //检测配置选项
    public final static int ST_MOBILE_TRACKING_ENABLE_DEBOUNCE = 0x00000010;  // 打开去抖动
    public final static int ST_MOBILE_TRACKING_ENABLE_FACE_ACTION = 0x00000020; // 检测脸部动作：张嘴、眨眼、抬眉、点头、摇头

    // 动态手势类型
    public final static int ST_DYNAMIC_GESTURE_TYPE_INVALID = -1;
    public final static int ST_DYNAMIC_GESTURE_TYPE_HOLD_ON = 0;                           ///< 静止
    public final static int ST_DYNAMIC_GESTURE_TYPE_FOREFINGER_CLICK = 1;                  ///< 食指点击
    public final static int ST_DYNAMIC_GESTURE_TYPE_FOREFINGER_ROTATION_CLOCKWISE = 2;     ///< 食指顺时针旋转
    public final static int ST_DYNAMIC_GESTURE_TYPE_FOREFINGER_ROTATION_ANTICLOCKWISE = 3; ///< 食指逆时针旋转
    public final static int ST_DYNAMIC_GESTURE_TYPE_PALM_FAN = 4;                          ///< 手掌扇风（废弃）
    public final static int ST_DYNAMIC_GESTURE_TYPE_PALM_MOVING_LEFT_AND_RIGHT = 5;        ///< 手掌左右平移
    public final static int ST_DYNAMIC_GESTURE_TYPE_PALM_MOVING_UP_AND_DOWN = 6;           ///< 手掌上下平移
    public final static int ST_DYNAMIC_GESTURE_TYPE_MAX_NUM = 7;

    /**
     * 进行颜色格式转换, 不建议使用关于YUV420P的转换,速度较慢
     *
     * @param inputImage   用于待转换的图像数据
     * @param outputImage  转换后的图像数据
     * @param width        用于转换的图像的宽度(以像素为单位)
     * @param height       用于转换的图像的高度(以像素为单位)
     * @param type         需要转换的颜色格式,参考st_mobile_common.h中的st_color_convert_type
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public static native int stColorConvert(byte[] inputImage, byte[] outputImage, int width, int height, int type);

    /**
     * 进行图片旋转
     *
     * @param inputImage   待旋转的图像数据
     * @param outputImage  旋转后的图像数据
     * @param width        用于旋转的图像的宽度(以像素为单位)
     * @param height       用于旋转的图像的高度(以像素为单位)
     * @param format       用于旋转的图像的类型
     * @param rotation     需要旋转的角度，当旋转角度为90度或270度时，交换width和height后，按照新的宽高读取outputImage数据
     * @return 成功返回0，错误返回其他，参考STUtils.ResultCode
     */
    public static native int stImageRotate(byte[] inputImage, byte[] outputImage, int width, int height, int format, int rotation);

    /**
     * 设置眨眼动作的阈值,置信度为[0,1], 默认阈值为0.5
     * @param threshold     阈值
     */
    public native void setEyeblinkThreshold(float threshold);

    /**
     * 设置张嘴动作的阈值,置信度为[0,1], 默认阈值为0.5
     * @param threshold     阈值
     */
    public native void setMouthahThreshold(float threshold);

    /**
     * 设置张嘴动作的阈值,置信度为[0,1], 默认阈值为0.5
     * @param threshold     阈值
     */
    public native void setHeadyawThreshold(float threshold);

    /**
     * 设置张嘴动作的阈值,置信度为[0,1], 默认阈值为0.5
     * @param threshold     阈值
     */
    public native void setHeadpitchThreshold(float threshold);

    /**
     * 设置张嘴动作的阈值,置信度为[0,1], 默认阈值为0.5
     * @param threshold     阈值
     */
    public native void setBrowjumpThreshold(float threshold);

    /**
     * 设置人脸106点平滑的阈值. 若不设置, 使用默认值. 默认值0.8, 建议取值范围：[0.0, 1.0]. 阈值越大, 去抖动效果越好, 跟踪延时越大
     * @param threshold     阈值
     */
    public native void setSmoothThreshold(float threshold);

    /**
     * 设置人脸三维旋转角度去抖动的阈值. 若不设置, 使用默认值. 默认值0.5, 建议取值范围：[0.0, 1.0]. 阈值越大, 去抖动效果越好, 跟踪延时越大
     * @param threshold     阈值
     */
    public native void setHeadposeThreshold(float threshold);
}
