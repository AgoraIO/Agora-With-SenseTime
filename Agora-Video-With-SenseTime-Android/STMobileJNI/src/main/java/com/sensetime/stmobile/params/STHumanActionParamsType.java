package com.sensetime.stmobile.params;

/**
 * Created by sensetime on 17-3-14.
 */

public class STHumanActionParamsType {

    // 人脸参数
    /// 设置检测到的最大人脸数目N(默认值32, 最大值32),持续track已检测到的N个人脸直到人脸数小于N再继续做detect.值越大,检测到的人脸数目越多,但相应耗时越长. 如果当前人脸数目达到上限，检测线程将休息
    public final static int ST_HUMAN_ACTION_PARAM_FACELIMIT = 0;
    /// 设置tracker每多少帧进行一次detect(默认值有人脸时24,无人脸时24/3=8). 值越大,cpu占用率越低, 但检测出新人脸的时间越长.
    public final static int ST_HUMAN_ACTION_PARAM_FACE_DETECT_INTERVAL = 1;
    /// 设置106点平滑的阈值[0.0,1.0](默认值0.5), 值越大, 点越稳定,但相应点会有滞后.
    public final static int ST_HUMAN_ACTION_PARAM_SMOOTH_THRESHOLD = 2;
    /// 设置head_pose去抖动的阈值[0.0,1.0](默认值0.5),值越大, pose信息的值越稳定,但相应值会有滞后.
    public final static int ST_HUMAN_ACTION_PARAM_HEADPOSE_THRESHOLD = 3;
    /// 设置脸部隔帧检测（对上一帧结果做拷贝），目的是减少耗时。默认每帧检测一次. 最多每10帧检测一次. 开启隔帧检测后, 只能对拷贝出来的检测结果做后处理.
    public final static int ST_HUMAN_ACTION_PARAM_FACE_PROCESS_INTERVAL = 5;
    ///设置人脸106点检测的阈值[0.0,1.0]
    public final static int ST_HUMAN_ACTION_PARAM_FACE_THRESHOLD = 6;

    // 设置face mesh渲染模式, face mesh分为人脸，眼睛，嘴巴，后脑勺，耳朵，脖子六个部位，2106模型只包含人脸，眼睛，嘴巴三个部位
    // 用一个六位的十六进制数字表示渲染模式0xFFFFFF，将要渲染部位的对应数字位设为1，不渲染的部位设为0，例如：渲染人脸和嘴巴，0x101000，默认只渲染人脸0x100000
    public final static int ST_HUMAN_ACTION_PARAM_FACE_MESH_MODE = 20;
    // 设置face mesh额头点扩展scale范围起始值（小于终止值，默认是2）
    public final static int ST_HUMAN_ACTION_PARAM_FACE_MESH_START_SCALE = 21;
    // 设置face mesh额头点扩展scale范围终止值（大于起始值，默认是3）
    public final static int ST_HUMAN_ACTION_PARAM_FACE_MESH_END_SCALE = 22;
    // 设置face mesh结果输出坐标系,(0: 屏幕坐标系， 1：三维坐标系，默认是屏幕坐标系）
    public final static int ST_HUMAN_ACTION_PARAM_FACE_MESH_OUTPUT_FORMAT = 23;
    // 获取face mesh模型支持的关键点的数量（2106或者3060）
    public final static int ST_HUMAN_ACTION_PARAM_FACE_MESH_MODEL_VERTEX_NUM = 24;

    // 设置face mesh是否需要计算边界点(0：不需要计算边界点，1：需要计算边界点）
    public final static int ST_HUMAN_ACTION_PARAM_FACE_MESH_CONTOUR = 26;

    // 手部参数
    /// 设置检测到的最大手数目N(默认值2, 最大值32),持续track已检测到的N个hand直到人脸数小于N再继续做detect.值越大,检测到的hand数目越多,但相应耗时越长. 如果当前手数目达到上限，检测线程将休息
    public final static int ST_HUMAN_ACTION_PARAM_HAND_LIMIT = 101;
    /// 设置手势检测每多少帧进行一次 detect (默认有手时30帧detect一次, 无手时10(30/3)帧detect一次). 值越大,cpu占用率越低, 但检测出新人脸的时间越长.
    public final static int ST_HUMAN_ACTION_PARAM_HAND_DETECT_INTERVAL = 102;
    /// 设置手势隔帧检测（对上一帧结果做拷贝），目的是减少耗时。默认每帧检测一次. 最多每10帧检测一次. 开启隔帧检测后, 只能对拷贝出来的检测结果做后处理.
    public final static int ST_HUMAN_ACTION_PARAM_HAND_PROCESS_INTERVAL = 103;
    //设置手检测的阈值[0.0,1.0]
    public final static int ST_HUMAN_ACTION_PARAM_HAND_THRESHOLD = 104;

    //设置手骨架检测的阈值[0.0,1.0]
    public final static int ST_HUMAN_ACTION_PARAM_HAND_SKELETON_THRESHOLD = 110;

    // 肢体参数
    /// 设置检测到的最大肢体数目N(默认值1),持续track已检测到的N个肢体直到肢体数小于N再继续做detect.值越大,检测到的body数目越多,但相应耗时越长. 如果当前肢体数目达到上限，检测线程将休息
    public final static int ST_HUMAN_ACTION_PARAM_BODY_LIMIT = 200;
    /// 设置肢体关键点检测每多少帧进行一次 detect (默认有肢体时30帧detect一次, 无body时10(30/3)帧detect一次). 值越大,cpu占用率越低, 但检测出新body的时间越长.
    public final static int ST_HUMAN_ACTION_PARAM_BODY_DETECT_INTERVAL = 201;
    /// 设置肢体隔帧检测（对上一帧结果做拷贝），目的是减少耗时。默认每帧检测一次. 最多每10帧检测一次. 开启隔帧检测后, 只能对拷贝出来的检测结果做后处理.
    public final static int ST_HUMAN_ACTION_PARAM_BODY_PROCESS_INTERVAL = 202;
    //设置身体检测的阈值[0.0，1.0]
    public final static int ST_HUMAN_ACTION_PARAM_BODY_THRESHOLD = 203;
    /// 已废弃 设置是否根据肢体信息检测摄像头运动状态 (0: 不检测; 1: 检测. 默认检测肢体轮廓点时检测摄像头运动状态)
    //ST_HUMAN_ACTION_PARAM_DETECT_CAMERA_MOTION_WITH_BODY = 203,
    public final static int ST_HUMAN_ACTION_PARAM_BODY_STATURE = 210;   // 身高，单位为米，3D骨架乘以身高（整体缩放），得到真实的物理尺度

    // 人头分割参数
    /// 设置头部分割检测结果灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致. 默认不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_HEAD_SEGMENT_RESULT_ROTATE = 300;
    /// 设置人头分割边界区域上限阈值.
    public final static int ST_HUMAN_ACTION_PARAM_HEAD_SEGMENT_MAX_THRESHOLD = 301;
    /// 设置人头分割边界区域下限阈值
    public final static int ST_HUMAN_ACTION_PARAM_HEAD_SEGMENT_MIN_THRESHOLD = 302;
    // 头部分割后处理长边的长度[10,长边长度](默认长边240,短边=长边/原始图像长边*原始图像短边).值越大,头部分割后处理耗时越长,边缘部分效果越好.
    public final static int ST_HUMAN_ACTION_PARAM_HEAD_SEGMENT_MAX_SIZE = 303;
    // 不支持设置输出图像长边长度

    // 背景分割/人像分割参数
    /// 输出的background结果中长边的长度[10,长边长度](默认长边为模型内部处理的长边，若设置会做resize处理输出).值越大,背景分割的耗时越长,边缘部分效果越好.值为0还原为默认值.
    public final static int ST_HUMAN_ACTION_PARAM_BACKGROUND_MAX_SIZE = 400;
    /// 背景分割羽化程度[0,1](默认值0.35),0 完全不羽化,1羽化程度最高,在strenth较小时,羽化程度基本不变.值越大,前景与背景之间的过度边缘部分越宽.
    /// 备注：如果设置背景分割为新版本，即ST_HUMAN_ACTION_PARAM_SEGMENT_KERNAL_TYPE为1，此选项无效。
    public final static int ST_HUMAN_ACTION_PARAM_BACKGROUND_BLUR_STRENGTH = 401;// 只对1.5.0 模型有效
    /// 设置前后背景检测结果灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致. 默认不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_BACKGROUND_RESULT_ROTATE = 402;
    /// 设置背景分割边界区域上限阈值.
    public final static int ST_HUMAN_ACTION_PARAM_SEGMENT_MAX_THRESHOLD = 403;
    /// 设置背景分割边界区域下限阈值
    public final static int ST_HUMAN_ACTION_PARAM_SEGMENT_MIN_THRESHOLD = 404;
    // 设置背景分割检测间隔
    public final static int ST_HUMAN_ACTION_PARAM_BACKGROUND_PROCESS_INTERVAL = 405;
//	ST_HUMAN_ACTION_PARAM_SEGMENT_KERNAL_TYPE = 406, 已废弃

    // 头发分割参数
    /// 头发结果中长边的长度[10,长边长度](默认长边240,短边=长边/原始图像长边*原始图像短边).值越大,头发分割的耗时越长,边缘部分效果越好.
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_MAX_SIZE = 410;
    /// 头发分割羽化程度[0,1](默认值0.35),0 完全不羽化,1羽化程度最高,在strenth较小时,羽化程度基本不变.值越大,过度边缘部分越宽.
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_BLUR_STRENGTH = 411;  // 无效,可删除
    /// 设置头发灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致. 默认0不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_RESULT_ROTATE = 412;
    /// 设置头发分割隔帧检测（对上一帧结果做拷贝），目的是减少耗时。默认每帧检测一次. 最多每10帧检测一次. 开启隔帧检测后, 只能对拷贝出来的检测结果做后处理.
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_PROCESS_INTERVAL = 413;  // 建议删除
    /// 设置头发分割边界区域上限阈值.
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_SEGMENT_MAX_THRESHOLD = 414;
    /// 设置头发分割边界区域下限阈值
    public final static int ST_HUMAN_ACTION_PARAM_HAIR_SEGMENT_MIN_THRESHOLD = 415;

    // 多类分割参数
    /// 输出的multisegment结果中长边的长度.
    public final static int ST_HUMAN_ACTION_PARAM_MULTI_SEGMENT_MAX_SIZE = 420;
    /// 设置多类分割检测结果灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致. 默认不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_MULTI_SEGMENT_RESULT_ROTATE = 421;


    // 皮肤分割参数
    /// 输出的皮肤分割结果中长边的长度.
    public final static int ST_HUMAN_ACTION_PARAM_SKIN_SEGMENT_MAX_SIZE = 430;
    /// 设置皮肤分割边界区域上限阈值.
    public final static int ST_HUMAN_ACTION_PARAM_SKIN_SEGMENT_MAX_THRESHOLD = 431;
    /// 设置皮肤分割边界区域下限阈值
    public final static int ST_HUMAN_ACTION_PARAM_SKIN_SEGMENT_MIN_THRESHOLD = 432;
    /// 设置皮肤分割检测结果灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致. 默认不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_SKIN_SEGMENT_RESULT_ROTATE = 433;


    // 嘴唇分割
    /// 设置嘴唇分割检测结果灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致. 默认不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_MOUTH_PARSE_RESULT_ROTATE = 450;
    // 不支持设置输出图像长边长度, 不支持调节阈值(默认是0和1)

    // 面部遮挡分割参数
    /// 设置面部遮挡检测结果灰度图的方向是否需要旋转（0: 不旋转, 保持竖直; 1: 旋转, 方向和输入图片一致. 默认不旋转)
    public final static int ST_HUMAN_ACTION_PARAM_FACE_OCCLUSION_SEGMENT_RESULT_ROTATE = 460;
    /// 设置面部遮挡分割边界区域上限阈值.
    public final static int ST_HUMAN_ACTION_PARAM_FACE_OCCLUSION_SEGMENT_MAX_THRESHOLD = 461;
    /// 设置面部遮挡分割边界区域下限阈值
    public final static int ST_HUMAN_ACTION_PARAM_FACE_OCCLUSION_SEGMENT_MIN_THRESHOLD = 462;
    // 面部遮挡分割后处理长边的长度[10,长边长度](默认长边240,短边=长边/原始图像长边*原始图像短边).值越大,面部遮挡分割后处理耗时越长,边缘部分效果越好.
    public final static int ST_HUMAN_ACTION_PARAM_FACE_OCCLUSION_SEGMENT_MAX_SIZE = 463;
    // 不支持设置输出图像长边长度


    // 通用参数
    public final static int ST_HUMAN_ACTION_PARAM_PREPROCESS_MAX_SIZE = 500; // 输入图像大小
    public final static int ST_HUMAN_ACTION_PARAM_CAM_FOVX = 211;  // 摄像头x方向上的视场角，单位为度，3d点会需要 已废弃

    //  天空分割参数
    //输出的sky结果中长边的长度
    public final static int ST_HUMAN_ACTION_PARAM_SKY_MAX_SIZE = 510;
    //天空分割检测结果灰度图的方向是否需要旋转
    public final static int ST_HUMAN_ACTION_PARAM_SKY_RESULT_ROTATE = 511;
    //设置天空分割边界区域上限阈值
    public final static int ST_HUMAN_ACTION_PARAM_SKY_SEGMENT_MAX_THRESHOLD = 512;
    //设置天空分割边界区域下限阈值
    public final static int ST_HUMAN_ACTION_PARAM_SKY_SEGMENT_MIN_THRESHOLD = 513;

    //  深度估计参数
    //输出的深度估计结果中长边的长度
    public final static int ST_HUMAN_ACTION_PARAM_DEPTH_ESTIMATION_MAX_SIZE = 515;


    public class STMeshType{
        public static final int ST_MOBILE_FACE_MESH = 1;  ///< face mesh 类型
        public static final int ST_MOBILE_HEAD_MESH = 2;   ///< 360度mesh 类型
    }
}
