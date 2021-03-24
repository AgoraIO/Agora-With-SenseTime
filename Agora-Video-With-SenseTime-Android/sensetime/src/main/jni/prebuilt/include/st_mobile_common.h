﻿#ifndef INCLUDE_STMOBILE_ST_MOBILE_COMMON_H_
#define INCLUDE_STMOBILE_ST_MOBILE_COMMON_H_

/// @defgroup st_common st common
/// @brief common definitions for st libs
/// @{

#ifdef _MSC_VER
#	ifdef SDK_EXPORTS
#		define ST_SDK_API_ __declspec(dllexport)
#	else
#		define ST_SDK_API_
#	endif
#else /* _MSC_VER */
#	ifdef SDK_EXPORTS
#		define ST_SDK_API_ __attribute__((visibility ("default")))
#	else
#		define ST_SDK_API_
#	endif
#endif

#ifdef __cplusplus
#	define ST_SDK_API extern "C" ST_SDK_API_
#else
#	define ST_SDK_API ST_SDK_API_
#endif

/// st handle declearation
typedef void *st_handle_t;

/// st result declearation
typedef int   st_result_t;

#define ST_OK                               0   ///< 正常运行

#define ST_E_INVALIDARG                     -1  ///< 无效参数
#define ST_E_HANDLE                         -2  ///< 句柄错误
#define ST_E_OUTOFMEMORY                    -3  ///< 内存不足
#define ST_E_FAIL                           -4  ///< 内部错误
#define ST_E_DELNOTFOUND                    -5  ///< 定义缺失
#define ST_E_INVALID_PIXEL_FORMAT           -6  ///< 不支持的图像格式
#define ST_E_FILE_NOT_FOUND                 -7  ///< 文件不存在
#define ST_E_INVALID_FILE_FORMAT            -8  ///< 文件格式不正确导致加载失败
#define ST_E_FILE_EXPIRE                    -9  ///< 文件过期

#define ST_E_INVALID_AUTH                   -13 ///< license不合法
#define ST_E_INVALID_APPID                  -14 ///< 包名错误
#define ST_E_AUTH_EXPIRE                    -15 ///< license过期
#define ST_E_UUID_MISMATCH                  -16 ///< UUID不匹配
#define ST_E_ONLINE_AUTH_CONNECT_FAIL       -17 ///< 在线验证连接失败
#define ST_E_ONLINE_AUTH_TIMEOUT            -18 ///< 在线验证超时
#define ST_E_ONLINE_AUTH_INVALID            -19 ///< 在线签发服务器端返回错误
#define ST_E_LICENSE_IS_NOT_ACTIVABLE       -20 ///< license不可激活
#define ST_E_ACTIVE_FAIL                    -21 ///< license激活失败
#define ST_E_ACTIVE_CODE_INVALID            -22 ///< 激活码无效

#define ST_E_NO_CAPABILITY                  -23 ///< license文件没有提供这个能力
#define ST_E_PLATFORM_NOTSUPPORTED          -24 ///< license不支持这个平台
#define ST_E_SUBMODEL_NOT_EXIST             -26 ///< 子模型不存在
#define ST_E_ONLINE_ACTIVATE_NO_NEED        -27 ///< 不需要在线激活
#define ST_E_ONLINE_ACTIVATE_FAIL           -28 ///< 在线激活失败
#define ST_E_ONLINE_ACTIVATE_CODE_INVALID   -29 ///< 在线激活码无效
#define ST_E_ONLINE_ACTIVATE_CONNECT_FAIL   -30 ///< 在线激活连接失败

#define ST_E_MODEL_NOT_IN_MEMORY            -31 ///< 模型不在内存中
#define ST_E_UNSUPPORTED_ZIP                -32 ///< 当前sdk不支持的素材包
#define ST_E_PACKAGE_EXIST_IN_MEMORY        -33 ///< 素材包已存在在内存中，不重复加载，或相同动画正在播放，不重复播放

#define ST_E_NOT_CONNECT_TO_NETWORK         -34 ///< 设备没有联网
#define ST_E_OTHER_LINK_ERRORS_IN_HTTPS     -35 ///< https中的其他链接错误
#define ST_E_CERTIFICAT_NOT_BE_TRUSTED      -36 ///< windows系统有病毒或被黑导致证书不被信任

#define ST_E_LICENSE_LIMIT_EXCEEDED         -37 ///< license激活次数已用完

#define ST_E_NOFACE                     	-38 ///< 没有检测到人脸

#define ST_E_API_UNSUPPORTED                -39 ///< 该API暂不支持
#define ST_E_API_DEPRECATED                 -40 ///< 该API已标记为废弃，应替换其他API或停止使用
#define ST_E_ARG_UNSUPPORTED                -41 ///< 该参数不支持
#define ST_E_PRECONDITION                   -42 ///< 前置条件不满足

// rendering related errors.
#define ST_E_INVALID_GL_CONTEXT             -100 ///< OpenGL Context错误，当前为空，或不一致
#define ST_E_RENDER_DISABLED                -101 ///< 创建句柄时候没有开启渲染

#ifndef CHECK_FLAG
#define CHECK_FLAG(action,flag) (((action)&(flag)) == flag)
#endif

/// st rectangle definition
typedef struct st_rect_t {
    int left;   ///< 矩形最左边的坐标
    int top;    ///< 矩形最上边的坐标
    int right;  ///< 矩形最右边的坐标
    int bottom; ///< 矩形最下边的坐标
} st_rect_t;

/// st float type point definition
typedef struct st_pointf_t {
    float x;    ///< 点的水平方向坐标,为浮点数
    float y;    ///< 点的竖直方向坐标,为浮点数
} st_pointf_t;

typedef struct st_point3f_t {
	float x;    ///< 点的水平方向坐标
	float y;    ///< 点的竖直方向坐标
	float z;    ///< 点的深度坐标
} st_point3f_t;

/// st integer type point definition
typedef struct st_pointi_t {
    int x;      ///< 点的水平方向坐标,为整数
    int y;      ///< 点的竖直方向坐标,为整数
} st_pointi_t;

/// st hand dynamic gesture type definition
typedef enum st_hand_dynamic_gesture_type_t {
    ST_DYNAMIC_GESTURE_TYPE_INVALID = -1,
    ST_DYNAMIC_GESTURE_TYPE_HOLD_ON,                           ///< 静止
    ST_DYNAMIC_GESTURE_TYPE_FOREFINGER_CLICK,                  ///< 食指点击
    ST_DYNAMIC_GESTURE_TYPE_FOREFINGER_ROTATION_CLOCKWISE,     ///< 食指顺时针旋转
    ST_DYNAMIC_GESTURE_TYPE_FOREFINGER_ROTATION_ANTICLOCKWISE, ///< 食指逆时针旋转
    ST_DYNAMIC_GESTURE_TYPE_PALM_FAN,                          ///< 手掌扇风（废弃）
    ST_DYNAMIC_GESTURE_TYPE_PALM_MOVING_LEFT_AND_RIGHT,        ///< 手掌左右平移
    ST_DYNAMIC_GESTURE_TYPE_PALM_MOVING_UP_AND_DOWN,           ///< 手掌上下平移
    ST_DYNAMIC_GESTURE_TYPE_MAX_NUM
} st_hand_dynamic_gesture_type_t;

/// st hand dynamic gesture definition
typedef struct st_hand_dynamic_gesture_t {
    int has_dynamic_gesture;                        ///< 是否有动态手势：0表示没有，1表示有
    st_hand_dynamic_gesture_type_t dynamic_gesture; ///< 动态手势类别
    float score;                                    ///< 动态手势得分
} st_hand_dynamic_gesture_t;

// st color definition
typedef struct st_color_t {
    float r;
    float g;
    float b;
    float a;
} st_color_t;

/// st pixel format definition
typedef enum {
    ST_PIX_FMT_GRAY8,   ///< Y    1        8bpp ( 单通道8bit灰度像素 )
    ST_PIX_FMT_YUV420P, ///< YUV  4:2:0   12bpp ( 3通道, 一个亮度通道, 另两个为U分量和V分量通道, 所有通道都是连续的. 只支持I420)
    ST_PIX_FMT_NV12,    ///< YUV  4:2:0   12bpp ( 2通道, 一个通道是连续的亮度通道, 另一通道为UV分量交错 )
    ST_PIX_FMT_NV21,    ///< YUV  4:2:0   12bpp ( 2通道, 一个通道是连续的亮度通道, 另一通道为VU分量交错 )
    ST_PIX_FMT_BGRA8888,///< BGRA 8:8:8:8 32bpp ( 4通道32bit BGRA 像素 )
    ST_PIX_FMT_BGR888,  ///< BGR  8:8:8   24bpp ( 3通道24bit BGR 像素 )
    ST_PIX_FMT_RGBA8888,///< RGBA 8:8:8:8 32bpp ( 4通道32bit RGBA 像素 )
    ST_PIX_FMT_RGB888   ///< RGB  8:8:8   24bpp ( 3通道24bit RGB 像素 )
} st_pixel_format;

/// image rotate type definition
typedef enum {
    ST_CLOCKWISE_ROTATE_0 = 0,  ///< 图像不需要旋转,图像中的人脸为正脸
    ST_CLOCKWISE_ROTATE_90 = 1, ///< 图像需要顺时针旋转90度,使图像中的人脸为正
    ST_CLOCKWISE_ROTATE_180 = 2,///< 图像需要顺时针旋转180度,使图像中的人脸为正
    ST_CLOCKWISE_ROTATE_270 = 3 ///< 图像需要顺时针旋转270度,使图像中的人脸为正
} st_rotate_type;

/// 图像格式定义
typedef struct st_image_t {
    unsigned char *data;    ///< 图像数据指针
    st_pixel_format pixel_format;   ///< 像素格式
    int width;              ///< 宽度(以像素为单位)
    int height;             ///< 高度(以像素为单位)
    int stride;             ///< 跨度, 即每行所占的字节数
    double time_stamp;   ///< 时间戳
} st_image_t;

/// @brief 人脸106点信息
typedef struct st_mobile_106_t {
    st_rect_t rect;         ///< 代表面部的矩形区域
    float score;            ///< 置信度
    st_pointf_t points_array[106];  ///< 人脸106关键点的数组
    float visibility_array[106];    ///< 对应点的能见度,点未被遮挡1.0,被遮挡0.0
    float yaw;              ///< 水平转角,真实度量的左负右正
    float pitch;            ///< 俯仰角,真实度量的上负下正
    float roll;             ///< 旋转角,真实度量的左负右正
    float eye_dist;         ///< 两眼间距
    int ID;                 ///< faceID: 每个检测到的人脸拥有唯一的faceID.人脸跟踪丢失以后重新被检测到,会有一个新的faceID
} st_mobile_106_t, *p_st_mobile_106_t;

/// @brief 耳朵关键点信息
typedef struct st_mobile_ear_t {
	st_pointf_t *p_ear_points;          ///< 耳朵关键点. 没有检测到时为NULL.耳朵左右各有18个关键点，共36个关键点，0-4为左耳靠近内耳区域的一条线，5-17为左耳外耳廓，18-22为右耳靠近内耳区域的一条线，23-35为右耳外耳廓
	int ear_points_count;               ///< 耳朵关键点个数. 检测到时为ST_MOBILE_EAR_POINTS_COUNT, 没有检测到时为0
	float left_ear_score;               ///< 左耳检测结果置信度: [0.0, 1.0]
	float right_ear_score;              ///< 右耳检测结果置信度: [0.0, 1.0]
} st_mobile_ear_t, *p_st_mobile_ear_t;

/// @brief 额头关键点信息
typedef struct st_mobile_forehead_t {
	st_pointf_t *p_forehead_points;     ///< 额头点
	int forehead_points_count;          ///< 额头点个数
} st_mobile_forehead_t, *p_st_mobile_forehead_t;

/// @brief 3d mesh关键点信息
typedef struct st_mobile_face_mesh_t {
	st_point3f_t * p_face_mesh_points;     ///< 3DMesh关键点数组
	st_point3f_t * p_face_mesh_normal;     ///< 3DMesh法线，每个法线对应一个关键点
	int face_mesh_points_count;            ///< 3DMesh关键点的数目
	float transform_mat[4][4];             ///< 旋转变换矩阵
	float view_mat[4][4];                  ///< 视角矩阵
	float project_mat[4][4];               ///< 投影矩阵
} st_mobile_face_mesh_t, *p_st_mobile_face_mesh_t;

/// @brief 多平面image数据结构，支持单平面（RGBA、BGRA），双平面（NV21/NV12)、三平面（YUV420）
typedef struct
{
    unsigned char* planes[3];   /// Image Plane 图像平面内存地址
    int strides[3];             /// image stride 图像每行的跨距，有效跨距应该与plane对应
    int width;                  /// image width 图像宽度
    int height;                 /// image height 图像高度
    st_pixel_format format;     /// input image format 图像的格式
} st_multiplane_image_t;

/// 人脸检测内部参数
typedef struct st_mobile_face_extra_info {
	float affine_mat[3][3];				   ///< 仿射变换矩阵
	int model_input_size;                  ///< 内部模型输入大小
} st_mobile_face_extra_info;

/// @brief track106配置选项,对应st_mobile_tracker_106_create和st_mobile_human_action_create中的config参数,具体配置如下：
// 使用单线程或双线程track：处理图片必须使用单线程,处理视频建议使用多线程 (创建human_action handle建议使用ST_MOBILE_DETECT_MODE_VIDEO/ST_MOBILE_DETECT_MODE_IMAGE)
#define ST_MOBILE_TRACKING_MULTI_THREAD         0x00000000  ///< 多线程,功耗较多,卡顿较少
#define ST_MOBILE_TRACKING_SINGLE_THREAD        0x00010000  ///< 单线程,功耗较少,对于性能弱的手机,会偶尔有卡顿现象
/// 检测模式
#define ST_MOBILE_DETECT_MODE_VIDEO             0x00020000  ///< 视频检测
#define ST_MOBILE_DETECT_MODE_IMAGE             0x00040000  ///< 图片检测 与视频检测互斥，只能同时使用一个



#define ST_MOBILE_TRACKING_ENABLE_DEBOUNCE      0x00000010  ///< 打开人脸106点和三维旋转角度去抖动
#define ST_MOBILE_TRACKING_ENABLE_FACE_ACTION   0x00000020  ///< 检测脸部动作：张嘴、眨眼、抬眉、点头、摇头

/// @brief 人脸检测结果
typedef struct st_mobile_face_t {
    st_mobile_106_t face106;               ///< 人脸信息，包含矩形框、106点、head pose信息等
    st_pointf_t *p_extra_face_points;      ///< 眼睛、眉毛、嘴唇关键点. 没有检测到时为NULL
    int extra_face_points_count;           ///< 眼睛、眉毛、嘴唇关键点个数. 检测到时为ST_MOBILE_EXTRA_FACE_POINTS_COUNT, 没有检测到时为0
    st_pointf_t * p_tongue_points;         ///< 舌头关键点数组
    float * p_tongue_points_score;         ///< 舌头关键点对应的置信度
    int tongue_points_count;               ///< 舌头关键点的数目
    st_mobile_face_mesh_t * p_face_mesh;   ///< 3d mesh信息，包括3d mesh关键点及个数
    st_pointf_t *p_eyeball_center;         ///< 眼球中心关键点. 没有检测到时为NULL
    int eyeball_center_points_count;       ///< 眼球中心关键点个数. 检测到时为ST_MOBILE_EYEBALL_CENTER_POINTS_COUNT, 没有检测到时为0
    st_pointf_t *p_eyeball_contour;        ///< 眼球轮廓关键点. 没有检测到时为NULL
    int eyeball_contour_points_count;      ///< 眼球轮廓关键点个数. 检测到时为ST_MOBILE_EYEBALL_CONTOUR_POINTS_COUNT, 没有检测到时为0
    float left_eyeball_score;              ///< 左眼球检测结果（中心点和轮廓点）置信度: [0.0, 1.0]
    float right_eyeball_score;             ///< 右眼球检测结果（中心点和轮廓点）置信度: [0.0, 1.0]
    st_mobile_ear_t* p_face_ear;           ///< 耳朵信息，包括耳朵关键点及个数，左右耳置信度
    st_point3f_t *p_gaze_direction;        ///< 左眼和右眼视线方向，没有检测到是为NULL
    float *p_gaze_score;                   ///< 视线置信度: [0.0, 1.0], 建议阈值为0.5
    unsigned long long face_action;        ///< 脸部动作
    unsigned char *p_avatar_help_info;     ///< avatar辅助信息,仅限内部使用，严禁修改
    int avatar_help_info_length;           ///< avatar辅助信息字节长度
    int skin_type;                         ///< 肤色类型
    float *p_face_action_score;            ///< 脸部动作置信度, eye, mouth, pitch, yaw, brow
    int face_action_score_count;           ///< 脸部动作数目
    st_mobile_forehead_t* p_face_forehead; ///< 额头点信息，包括额头点坐标和个数
    st_color_t hair_color;                 ///< avatar发色, rgb取值范围[0.0, 1.0]; 其中a(alpha)值不必要，设置默认值为1.0
    st_mobile_face_extra_info face_extra_info;///< 人脸检测模型内部参数
} st_mobile_face_t, *p_st_mobile_face_t;

/// @brief 设置眨眼动作的阈值,置信度为[0,1], 默认阈值为0.5
ST_SDK_API void
st_mobile_set_eyeblink_threshold(
    float threshold
);
/// @brief 设置张嘴动作的阈值,置信度为[0,1], 默认阈值为0.5
ST_SDK_API void
st_mobile_set_mouthah_threshold(
    float threshold
);
/// @brief 设置摇头动作的阈值,置信度为[0,1], 默认阈值为0.5
ST_SDK_API void
st_mobile_set_headyaw_threshold(
    float threshold
);
/// @brief 设置点头动作的阈值,置信度为[0,1], 默认阈值为0.5
ST_SDK_API void
st_mobile_set_headpitch_threshold(
    float threshold
);
/// @brief 设置挑眉毛动作的阈值,置信度为[0,1], 默认阈值为0.5
ST_SDK_API void
st_mobile_set_browjump_threshold(
    float threshold
);

/// @brief 设置人脸106点平滑的阈值. 若不设置, 使用默认值. 默认值0.8, 建议取值范围：[0.0, 1.0]. 阈值越大, 去抖动效果越好, 跟踪延时越大
ST_SDK_API void
st_mobile_set_smooth_threshold(
    float threshold
);

/// @brief 设置人脸三维旋转角度去抖动的阈值. 若不设置, 使用默认值. 默认值0.5, 建议取值范围：[0.0, 1.0]. 阈值越大, 去抖动效果越好, 跟踪延时越大
ST_SDK_API void
st_mobile_set_headpose_threshold(
    float threshold
);

/// @brief 设置只使用SSE指令集
ST_SDK_API void
st_mobile_set_sse_only(
bool sse_only
);

/// 支持的颜色转换格式
typedef enum {
    ST_BGRA_YUV420P = 0,    ///< ST_PIX_FMT_BGRA8888到ST_PIX_FMT_YUV420P转换
    ST_BGR_YUV420P = 1,     ///< ST_PIX_FMT_BGR888到ST_PIX_FMT_YUV420P转换
    ST_BGRA_NV12 = 2,       ///< ST_PIX_FMT_BGRA8888到ST_PIX_FMT_NV12转换
    ST_BGR_NV12 = 3,        ///< ST_PIX_FMT_BGR888到ST_PIX_FMT_NV12转换
    ST_BGRA_NV21 = 4,       ///< ST_PIX_FMT_BGRA8888到ST_PIX_FMT_NV21转换
    ST_BGR_NV21 = 5,        ///< ST_PIX_FMT_BGR888到ST_PIX_FMT_NV21转换
    ST_YUV420P_BGRA = 6,    ///< ST_PIX_FMT_YUV420P到ST_PIX_FMT_BGRA8888转换
    ST_YUV420P_BGR = 7,     ///< ST_PIX_FMT_YUV420P到ST_PIX_FMT_BGR888转换
    ST_NV12_BGRA = 8,       ///< ST_PIX_FMT_NV12到ST_PIX_FMT_BGRA8888转换
    ST_NV12_BGR = 9,        ///< ST_PIX_FMT_NV12到ST_PIX_FMT_BGR888转换
    ST_NV21_BGRA = 10,      ///< ST_PIX_FMT_NV21到ST_PIX_FMT_BGRA8888转换
    ST_NV21_BGR = 11,       ///< ST_PIX_FMT_NV21到ST_PIX_FMT_BGR888转换
    ST_BGRA_GRAY = 12,      ///< ST_PIX_FMT_BGRA8888到ST_PIX_FMT_GRAY8转换
    ST_BGR_BGRA = 13,       ///< ST_PIX_FMT_BGR888到ST_PIX_FMT_BGRA8888转换
    ST_BGRA_BGR = 14,       ///< ST_PIX_FMT_BGRA8888到ST_PIX_FMT_BGR888转换
    ST_YUV420P_GRAY = 15,   ///< ST_PIX_FMT_YUV420P到ST_PIX_FMT_GRAY8转换
    ST_NV12_GRAY = 16,      ///< ST_PIX_FMT_NV12到ST_PIX_FMT_GRAY8转换
    ST_NV21_GRAY = 17,      ///< ST_PIX_FMT_NV21到ST_PIX_FMT_GRAY8转换
    ST_BGR_GRAY = 18,       ///< ST_PIX_FMT_BGR888到ST_PIX_FMT_GRAY8转换
    ST_GRAY_YUV420P = 19,   ///< ST_PIX_FMT_GRAY8到ST_PIX_FMT_YUV420P转换
    ST_GRAY_NV12 = 20,      ///< ST_PIX_FMT_GRAY8到ST_PIX_FMT_NV12转换
    ST_GRAY_NV21 = 21,      ///< ST_PIX_FMT_GRAY8到ST_PIX_FMT_NV21转换
    ST_NV12_YUV420P = 22,   ///< ST_PIX_FMT_NV12到ST_PIX_FMT_YUV420P转换
    ST_NV21_YUV420P = 23,   ///< ST_PIX_FMT_NV21到ST_PIX_FMT_YUV420P转换
    ST_NV21_RGBA = 24,      ///< ST_PIX_FMT_NV21到ST_PIX_FMT_RGBA8888转换
    ST_BGR_RGBA = 25,       ///< ST_PIX_FMT_BGR888到ST_PIX_FMT_RGBA8888转换
    ST_BGRA_RGBA = 26,      ///< ST_PIX_FMT_BGRA8888到ST_PIX_FMT_RGBA8888转换
    ST_RGBA_BGRA = 27,      ///< ST_PIX_FMT_RGBA8888到ST_PIX_FMT_BGRA8888转换
    ST_GRAY_BGR = 28,       ///< ST_PIX_FMT_GRAY8到ST_PIX_FMT_BGR888转换
    ST_GRAY_BGRA = 29,      ///< ST_PIX_FMT_GRAY8到ST_PIX_FMT_BGRA8888转换
    ST_NV12_RGBA = 30,      ///< ST_PIX_FMT_NV12到ST_PIX_FMT_RGBA8888转换
    ST_NV12_RGB = 31,       ///< ST_PIX_FMT_NV12到ST_PIX_FMT_RGB888转换
    ST_RGBA_NV12 = 32,      ///< ST_PIX_FMT_RGBA8888到ST_PIX_FMT_NV12转换
    ST_RGB_NV12 = 33,       ///< ST_PIX_FMT_RGB888到ST_PIX_FMT_NV12转换
    ST_RGBA_BGR = 34,       ///< ST_PIX_FMT_RGBA888到ST_PIX_FMT_BGR888转换
    ST_BGRA_RGB = 35,       ///< ST_PIX_FMT_BGRA888到ST_PIX_FMT_RGB888转换
    ST_RGBA_GRAY = 36,      ///< ST_PIX_FMT_RGBA8888到ST_PIX_FMT_GRAY8转换
    ST_RGB_GRAY = 37,       ///< ST_PIX_FMT_RGB888到ST_PIX_FMT_GRAY8转换
    ST_RGB_BGR = 38,        ///< ST_PIX_FMT_RGB888到ST_PIX_FMT_BGR888转换
    ST_BGR_RGB = 39,        ///< ST_PIX_FMT_BGR888到ST_PIX_FMT_RGB888转换
    ST_YUV420P_RGBA = 40,   ///< ST_PIX_FMT_YUV420P到ST_PIX_FMT_RGBA8888转换
    ST_RGBA_YUV420P = 41,   ///< ST_PIX_FMT_RGBA8888到ST_PIX_FMT_YUV420P转换
    ST_RGBA_NV21 = 42       ///< ST_PIX_FMT_RGBA8888到ST_PIX_FMT_NV21转换
} st_color_convert_type;

/// @brief 进行颜色格式转换, 不建议使用关于YUV420P的转换,速度较慢
/// @param[in] image_src 用于待转换的图像数据
/// @param[out] image_dst 转换后的图像数据
/// @param[in] image_width 用于转换的图像的宽度(以像素为单位)
/// @param[in] image_height 用于转换的图像的高度(以像素为单位)
/// @param[in] type 需要转换的颜色格式
/// @return 正常返回ST_OK,否则返回错误类型
ST_SDK_API st_result_t
st_mobile_color_convert(
    const unsigned char *image_src,
    unsigned char *image_dst,
    int image_width,
    int image_height,
    st_color_convert_type type
);

/// @brief 旋转图像
/// @param[in] image_src 待旋转的图像数据
/// @param[out] image_dst 旋转后的图像数据, 由客户分配内存.旋转后，图像会变成紧凑的（没有padding）
/// @param[in] image_width 待旋转的图像的宽度, 旋转后图像的宽度可能会发生变化，由用户处理
/// @param[in] image_height 待旋转的图像的高度, 旋转后图像的高度可能会发生变化，由用户处理
/// @param[in] image_stride 待旋转的图像的跨度, 旋转后图像的跨度可能会发生变化，由用户处理
/// @param[in] pixel_format 待旋转的图像的格式
/// @param[in] rotate_type 顺时针旋转角度
ST_SDK_API st_result_t
st_mobile_image_rotate(
    const unsigned char *image_src,
    unsigned char *image_dst,
    int image_width,
    int image_height,
    int image_stride,
    st_pixel_format pixel_format,
    st_rotate_type rotate_type
);

/// @brief 图像resize类型
typedef enum {
	ST_MOBILE_RESIZE_TYPE_NEAREST_POINT = 0,   // 最近邻插值
	ST_MOBILE_RESIZE_TYPE_LINEAR = 1,    // 线性插值
} st_mobile_resize_type;


/// @brief 缩放图像
/// @param[in] src 原始图像
/// @param[out] dst 目标图像, 用户分配内存
/// @param[in] type 缩放方法
ST_SDK_API st_result_t
st_mobile_image_resize(
	const st_image_t * src,
	st_image_t* dst,
	st_mobile_resize_type type
);

/// @}

/// 3D rigid transform structure.
typedef struct st_mobile_transform_t {
    float position[3];
    float eulerAngle[3];    // euler in angle.
    float scale[3];
} st_mobile_transform_t;

/// @brief 将Translation，Rotation，Scale分量合成为一个4X4矩阵（列优先），右手坐标系。
/// @param[in] p_trs st_mobile_transform_t结构体表示的TRS分量
/// @param[out] mat4x4 转换之后的列优先存储的4X4齐次变换矩阵
/// @return true - 转换成功，false - 转换失败
ST_SDK_API bool st_mobile_convert_trs_to_matrix(const st_mobile_transform_t *p_trs, float mat4x4[16]);

/// @brief 将4X4矩阵（列优先）分解为Translation，Rotation，Scale分量，右手坐标系。
/// @param[in] mat4x4 列优先存储的4X4齐次变换矩阵
/// @param[out] p_trs st_mobile_transform_t结构体表示的分解之后的TRS分量
/// @return true - 分解成功，false - 分解失败
ST_SDK_API bool st_mobile_convert_matrix_to_trs(const float mat4x4[16], st_mobile_transform_t *p_trs);

/// @brief 性能/效果优先级
typedef enum {
    ST_PREFER_EFFECT,
    ST_PREFER_PERFORMANCE,
    ST_PREFER_AUTO_TUNE,
    ST_PREFER_NOTHING,
} st_performance_hint_t;

/// @brief log层级定义
typedef enum {
    ST_LOG_DEBUG,
    ST_LOG_TRACE,
    ST_LOG_WARNING,
    ST_LOG_ERROR,
    ST_LOG_DISABLE,
} st_log_level_t;

// this is the singleton API (thread safe), and would affect whole st_mobile APIs.
/// @brief 设置st_mobile当前的log层级，层级关系为自底向上的包含关系，如ST_LOG_ERROR包含所有其他可log的level。
///        将当前的log层级设置为ST_LOG_DISABLE将禁用所有log。
///        该接口保证线程安全。
/// @param[in] level 将设置的log层级
/// @return 正常返回ST_OK，否则返回错误类型
ST_SDK_API st_result_t
st_mobile_set_log_level(st_log_level_t level);

/// @brief 获取当前的log层级
/// @param[out] p_level 应该非空，用于获取当前的log层级
/// @return 正常返回ST_OK，否则返回错误类型
ST_SDK_API st_result_t
st_mobile_get_log_level(st_log_level_t* p_level);

/// @brief 将log重定向到文件中，如果传入的文件路径为空，则重置为输出到标准设备流
/// @param[in] p_file_path 重定向log文件的全路径
/// @param[in] b_tranc_file 是否清除文件内容，true - 清除文件内容，false - 不清除文件内容
/// @return 正常返回ST_OK，否则返回错误类型
ST_SDK_API st_result_t
st_mobile_redirect_log_to_file(const char* p_file_path, bool b_tranc_file);

typedef enum {
    ST_AVATAR_EYE_RIGHT_CLOSE,                          // 00右眼闭合
    ST_AVATAR_EYE_RIGHT_DOWN,                           // 01右眼下看
    ST_AVATAR_EYE_RIGHT_INWARD,                         // 02右眼向内看(向左看)
    ST_AVATAR_EYE_RIGHT_OUTWARD,                        // 03右眼向外看(向右看)
    ST_AVATAR_EYE_RIGHT_UP,                             // 04右眼向上看
    ST_AVATAR_EYE_RIGHT_NARROW,                         // 05右眼眯眼
    ST_AVATAR_EYE_RIGHT_WIDE,                           // 06右眼圆睁
    ST_AVATAR_EYE_LEFT_CLOSE,                           // 07左眼闭合
    ST_AVATAR_EYE_LEFT_DOWN,                            // 08左眼下看
    ST_AVATAR_EYE_LEFT_INWARD,                          // 09左眼向内看(向右看)
    ST_AVATAR_EYE_LEFT_OUTWARD,                         // 10左眼向外看(向左看)
    ST_AVATAR_EYE_LEFT_UP,                              // 11左眼上看
    ST_AVATAR_EYE_LEFT_NARROW,                          // 12左眼眯眼
    ST_AVATAR_EYE_LEFT_WIDE,                            // 13左眼圆睁
    ST_AVATAR_JAW_FORWARD,                              // 14下颚前突(嘴闭合)
    ST_AVATAR_JAW_RIGHT,                                // 15下颚右移(嘴闭合)
    ST_AVATAR_JAW_LEFT,                                 // 16下颚左移(嘴闭合)
    ST_AVATAR_JAW_OPEN,                                 // 17下颚向下张开(嘴自然张开)
    ST_AVATAR_MOUTH_CLOSE,                              // 18嘴形自然闭合(下颚向下张开)
    ST_AVATAR_MOUTH_ROUND,                              // 19嘟嘴，嘴唇往前突
    ST_AVATAR_MOUTH_PUCKER,                             // 20撅嘴，嘴唇往外翘
    ST_AVATAR_MOUTH_BOTH_LIP_RIGHT,                     // 21上下嘴唇右移
    ST_AVATAR_MOUTH_BOTH_LIP_LEFT,                      // 22上下嘴唇左移
    ST_AVATAR_MOUTH_RIGHT_CORNER_UP,                    // 23右嘴角向上扬
    ST_AVATAR_MOUTH_LEFT_CORNER_UP,                     // 24左嘴角向上扬
    ST_AVATAR_MOUTH_RIGHT_CORNER_DOWN,                  // 25右嘴角向下撇
    ST_AVATAR_MOUTH_LEFT_CORNER_DOWN,                   // 26左嘴角向下撇
    ST_AVATAR_MOUTH_RIGHT_CORNER_BACKWARD,              // 27右嘴角向后撇
    ST_AVATAR_MOUTH_LEFT_CORNER_BACKWARD,               // 28左嘴角向后撇
    ST_AVATAR_MOUTH_RIGHT_CORNER_OUTWARD,               // 29右嘴角水平向外移(右移)
    ST_AVATAR_MOUTH_LEFT_CORNER_OUTWARD,                // 30左嘴角水平向外移(左移)
    ST_AVATAR_MOUTH_LOWER_LIP_INWARD,                   // 31下嘴唇内卷
    ST_AVATAR_MOUTH_UPPER_LIP_INWARD,                   // 32上嘴唇内卷
    ST_AVATAR_MOUTH_LOWER_LIP_OUTWARD,                  // 33下嘴唇外翻
    ST_AVATAR_MOUTH_UPPER_LIP_OUTWARD,                  // 34上嘴唇外翻
    ST_AVATAR_MOUTH_LOWER_LIP_RIGHT_UP,                 // 35下嘴唇右上翘
    ST_AVATAR_MOUTH_LOWER_LIP_LEFT_UP,                  // 36下嘴唇左上翘
    ST_AVATAR_MOUTH_LOWER_LIP_RIGHT_DOWN,               // 37下嘴唇右下垂
    ST_AVATAR_MOUTH_LOWER_LIP_LEFT_DOWN,                // 38下嘴唇左下垂
    ST_AVATAR_MOUTH_UPPER_LIP_RIGHT_UP,                 // 39上嘴唇右上翘
    ST_AVATAR_MOUTH_UPPER_LIP_LEFT_UP,                  // 40上嘴唇左上翘
    ST_AVATAR_MOUTH_LIP_PART,                           // 41微张嘴
    ST_AVATAR_EYEBROW_RIGHT_OUTER_DOWN,                 // 42右眉毛外垂
    ST_AVATAR_EYEBROW_LEFT_OUTER_DOWN,                  // 43左眉毛外垂
    ST_AVATAR_EYEBROW_BOTH_INNER_UP,                    // 44双眉向上内挑
    ST_AVATAR_EYEBROW_RIGHT_OUTER_UP,                   // 45右眉外挑
    ST_AVATAR_EYEBROW_LEFT_OUTER_UP,                    // 46左眉外挑
    ST_AVATAR_CHEEK_BOTH_OUTWARD,                       // 47双面颊前突
    ST_AVATAR_CHEEK_RIGHT_UP,                           // 48右面颊上提
    ST_AVATAR_CHEEK_LEFT_UP,                            // 49左面颊上提
    ST_AVATAR_NOSE_RIGHT_UP,                            // 50右鼻子上提
    ST_AVATAR_NOSE_LEFT_UP,                             // 51左鼻子上提
    ST_AVATAR_NOSE_BOTH_WIDE,                           // 52双鼻张开
    ST_AVATAR_TONGUE_OUTWARD,                           // 53舌头伸出
    ST_AVATAR_EXPRESSION_NUM,
} ST_AVATAR_EXPRESSION_INDEX;
/// @brief 设置snpe相关库在手机上的绝对路径
ST_SDK_API bool
st_mobile_set_snpe_library_path(const char* path);

/// @}

/// @brief 获取sdk版本号
ST_SDK_API
const char* st_mobile_get_version();
#endif // INCLUDE_STMOBILE_ST_MOBILE_COMMON_H_
