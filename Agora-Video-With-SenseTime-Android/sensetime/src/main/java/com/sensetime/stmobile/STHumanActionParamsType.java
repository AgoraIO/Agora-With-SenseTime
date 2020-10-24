package com.sensetime.stmobile;

/**
 * Created by sensetime on 17-3-14.
 */

public class STHumanActionParamsType {

    /// background结果中长边的长度[10,长边长度](默认长边240,短边=长边/原始图像长边*原始图像短边).值越大,背景分割的耗时越长,边缘部分效果越好.
    public final static int ST_HUMAN_ACTION_PARAM_BACKGROUND_MAX_SIZE = 1;
    /// 背景分割羽化程度[0,1](默认值0.35),0 完全不羽化,1羽化程度最高,在strenth较小时,羽化程度基本不变.值越大,前景与背景之间的过度边缘部分越宽.
    public final static int ST_HUMAN_ACTION_PARAM_BACKGROUND_BLUR_STRENGTH = 2;
    /// 设置检测到的最大人脸数目N(默认值10),持续track已检测到的N个人脸直到人脸数小于N再继续做detect.值越大,检测到的人脸数目越多,但相应耗时越长.
    public final static int ST_HUMAN_ACTION_PARAM_FACELIMIT = 3;
    /// 设置tracker每多少帧进行一次detect(默认值有人脸时24,无人脸时24/3=8). 值越大,cpu占用率越低, 但检测出新人脸的时间越长.
    public final static int ST_HUMAN_ACTION_PARAM_FACE_DETECT_INTERVAL = 4;
    /// 设置106点平滑的阈值[0.0,1.0](默认值0.5), 值越大, 点越稳定,但相应点会有滞后.
    public final static int ST_HUMAN_ACTION_PARAM_SMOOTH_THRESHOLD = 5;
    /// 设置head_pose去抖动的阈值[0.0,1.0](默认值0.5),值越大, pose信息的值越稳定,但相应值会有滞后.
    public final static int ST_HUMAN_ACTION_PARAM_HEADPOSE_THRESHOLD = 6;
    /// 设置手势检测每多少帧进行一次 detect (默认有手时30帧detect一次, 无手时10(30/3)帧detect一次). 值越大,cpu占用率越低, 但检测出新人脸的时间越长.
    public final static int ST_HUMAN_ACTION_PARAM_HAND_DETECT_INTERVAL = 7;
    /// 设置前后背景检测结果灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致。默认不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_BACKGROUND_RESULT_ROTATE = 8;
    /// 设置检测到的最大人体数目N(默认值1),持续track已检测到的N个人体直到人体数小于N再继续做detect.值越大,检测到的body数目越多,但相应耗时越长.
    public final static int ST_HUMAN_ACTION_PARAM_BODY_LIMIT = 9;
    /// 设置人体关键点检测每多少帧进行一次 detect (默认有人体时30帧detect一次, 无body时10(30/3)帧detect一次). 值越大,cpu占用率越低, 但检测出新body的时间越长.
    public final static int ST_HUMAN_ACTION_PARAM_BODY_DETECT_INTERVAL = 10;
    /// 设置每多少帧检测一次人脸. 默认每帧检测一次. 最多每10帧检测一次
    public final static int ST_HUMAN_ACTION_PARAM_FACE_PROCESS_INTERVAL = 11;
    /// 设置每多少帧检测一次手势. 默认每帧检测一次. 最多每10帧检测一次
    public final static int ST_HUMAN_ACTION_PARAM_HAND_PROCESS_INTERVAL = 12;
    /// 设置每多少帧检测一次背景. 默认每帧检测一次. 最多每10帧检测一次
    public final static int ST_HUMAN_ACTION_PARAM_BACKGROUND_PROCESS_INTERVAL = 13;
    /// 设置每多少帧检测一次人体关键点. 默认每帧检测一次. 最多每10帧检测一次
    public final static int ST_HUMAN_ACTION_PARAM_BODY_PROCESS_INTERVAL = 14;
    /// 设置检测到的最大手数目N(默认值2, 最大值32),持续track已检测到的N个hand直到人脸数小于N再继续做detect.值越大,检测到的hand数目越多,但相应耗时越长. 如果当前手数目达到上限，检测线程将休息
    public final static int ST_HUMAN_ACTION_PARAM_HAND_LIMIT = 15;
    /// 头发结果中长边的长度[10,长边长度](默认长边240,短边=长边/原始图像长边*原始图像短边).值越大,头发分割的耗时越长,边缘部分效果越好.
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_MAX_SIZE = 16;
    /// 头发分割羽化程度[0,1](默认值0.35),0 完全不羽化,1羽化程度最高,在strenth较小时,羽化程度基本不变.值越大,过度边缘部分越宽.
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_BLUR_STRENGTH = 17;
    /// 设置头发灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致. 默认0不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_RESULT_ROTATE = 18;
    /// 设置头发分割隔帧检测（对上一帧结果做拷贝），目的是减少耗时。默认每帧检测一次. 最多每10帧检测一次. 开启隔帧检测后, 只能对拷贝出来的检测结果做后处理.
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_PROCESS_INTERVAL = 19;
    public final static int ST_HUMAN_ACTION_PARAM_CAM_FOVX = 20;  // 摄像头x方向上的视场角，单位为度，3d点会需要
    /// 设置是否根据肢体信息检测摄像头运动状态 (0: 不检测; 1: 检测. 默认检测肢体轮廓点时检测摄像头运动状态)
    public final static int ST_HUMAN_ACTION_PARAM_DETECT_CAMERA_MOTION_WITH_BODY = 21;
    /// 输出的multisegment结果中长边的长度.
    public final static int ST_HUMAN_ACTION_PARAM_MULTI_SEGMENT_MAX_SIZE = 22;
    /// 设置多类分割检测结果灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致. 默认不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_MULTI_SEGMENT_RESULT_ROTATE = 23;
    /// 设置预处理后图像的最长边，最小320， 视频默认值320，图像默认值1000。 值越大，耗时越长，检测到的目标数目会多一些
    public final static int ST_HUMAN_ACTION_PARAM_PREPROCESS_MAX_SIZE = 24;
    /// 设置背景分割使用的内核种类，默认0为新版本,1为旧版本
    public final static int ST_HUMAN_ACTION_PARAM_SEGMENT_KERNAL_TYPE = 25;
    /// 设置背景分割边界区域上限阈值，默认值是0.85.
    public final static int ST_HUMAN_ACTION_PARAM_SEGMENT_MAX_THRESHOLD = 26;
    /// 设置背景分割边界区域下限阈值，默认值是0
    public final static int ST_HUMAN_ACTION_PARAM_SEGMENT_MIN_THRESHOLD = 27;
    public final static int ST_HUMAN_ACTION_PARAM_STATURE = 28;   // 身高，单位为米，3D骨架乘以身高（整体缩放），得到真实的物理尺度
}
