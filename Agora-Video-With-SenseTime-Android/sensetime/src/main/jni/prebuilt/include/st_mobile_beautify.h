#ifndef INCLUDE_STMOBILE_ST_MOBILE_BEAUTIFY_H_
#define INCLUDE_STMOBILE_ST_MOBILE_BEAUTIFY_H_

#include "st_mobile_common.h"
#include "st_mobile_human_action.h"

/// 该文件中的API不保证线程安全.多线程调用时,需要确保安全调用.例如在 create handle 没有执行完就执行 process 可能造成crash;在 process 执行过程中调用 destroy 函数可能会造成crash.

/// @defgroup st_mobile_beautify
/// @brief beautify interfaces
/// This set of interfaces processing beautify routines
///
/// @{

/// @brief 创建美化句柄
/// @param [out] handle 初始化的美化句柄
/// @return 成功返回ST_OK, 错误则返回错误码
ST_SDK_API st_result_t
st_mobile_beautify_create(
    st_handle_t *handle
);

///@brief 美化参数类型
typedef enum {
    ST_BEAUTIFY_REDDEN_STRENGTH = 1,        /// 红润强度, [0,1.0], 默认值0.36, 0.0不做红润
    ST_BEAUTIFY_SMOOTH_MODE     = 2,        /// 磨皮模式, 默认值1.0, 1.0表示对全图磨皮, 0.0表示只对人脸磨皮
    ST_BEAUTIFY_SMOOTH_STRENGTH = 3,        /// 磨皮强度, [0,1.0], 默认值0.74, 0.0不做磨皮
    ST_BEAUTIFY_WHITEN_STRENGTH = 4,        /// 美白强度, [0,1.0], 默认值0.30, 0.0不做美白
    ST_BEAUTIFY_ENLARGE_EYE_RATIO = 5,      /// 大眼比例, [0,1.0], 默认值0.13, 0.0不做大眼效果
    ST_BEAUTIFY_SHRINK_FACE_RATIO = 6,      /// 瘦脸比例, [0,1.0], 默认值0.11, 0.0不做瘦脸效果
    ST_BEAUTIFY_SHRINK_JAW_RATIO = 7,       /// 小脸比例, [0,1.0], 默认值0.10, 0.0不做小脸效果
    ST_BEAUTIFY_CONTRAST_STRENGTH = 8,      /// 对比度强度, [0,1.0], 默认值0.05, 0.0不做对比度处理
    ST_BEAUTIFY_SATURATION_STRENGTH = 9,    /// 饱和度强度, [0,1.0], 默认值0.10, 0.0不做饱和度处理
    ST_BEAUTIFY_DEHIGHLIGHT_STRENGTH = 10,  /// 去高光强度, [0,1.0], 默认值0.0, 0.0不做去高光，注意，此功能只用于图片处理，预览或视频处理均设为0.0
	ST_BEAUTIFY_NARROW_FACE_STRENGTH = 11,  /// 窄脸强度, [0,1.0], 默认值0.0, 0.0不做窄脸
    ST_BEAUTIFY_ROUND_EYE_RATIO = 12,       /// 圆眼比例, [0,1.0], 默认值0.0, 0.0不做圆眼

    ST_BEAUTIFY_3D_NARROW_NOSE_RATIO = 20,              /// 瘦鼻比例，[0, 1.0], 默认值为0.0，0.0不做瘦鼻
    ST_BEAUTIFY_3D_NOSE_LENGTH_RATIO = 21,              /// 鼻子长短比例，[-1, 1], 默认值为0.0, [-1, 0]为短鼻，[0, 1]为长鼻
    ST_BEAUTIFY_3D_CHIN_LENGTH_RATIO = 22,              /// 下巴长短比例，[-1, 1], 默认值为0.0，[-1, 0]为短下巴，[0, 1]为长下巴
    ST_BEAUTIFY_3D_MOUTH_SIZE_RATIO = 23,               /// 嘴型比例，[-1, 1]，默认值为0.0，[-1, 0]为放大嘴巴，[0, 1]为缩小嘴巴
    ST_BEAUTIFY_3D_PHILTRUM_LENGTH_RATIO = 24,          /// 人中长短比例，[-1, 1], 默认值为0.0，[-1, 0]为长人中，[0, 1]为短人中
    ST_BEAUTIFY_3D_HAIRLINE_HEIGHT_RATIO = 25,          /// 发际线高低比例，[-1, 1], 默认值为0.0，[-1, 0]为低发际线，[0, 1]为高发际线
    ST_BEAUTIFY_3D_THIN_FACE_SHAPE_RATIO = 26,          /// 瘦脸型比例， [0,1.0], 默认值0.0, 0.0不做瘦脸型效果
    ST_BEAUTIFY_3D_EYE_DISTANCE_RATIO = 27,             /// 眼距比例，[-1, 1]，默认值为0.0，[-1, 0]为减小眼距，[0, 1]为增加眼距
    ST_BEAUTIFY_3D_EYE_ANGLE_RATIO = 28,                /// 眼睛角度调整比例，[-1, 1]，默认值为0.0，[-1, 0]为左眼逆时针旋转，[0, 1]为左眼顺时针旋转，右眼与左眼相对
    ST_BEAUTIFY_3D_OPEN_CANTHUS_RATIO = 29,             /// 开眼角比例，[0, 1.0]，默认值为0.0， 0.0不做开眼角
    ST_BEAUTIFY_3D_PROFILE_RHINOPLASTY_RATIO = 30,      /// 侧脸隆鼻比例，[0, 1.0]，默认值为0.0，0.0不做侧脸隆鼻效果
    ST_BEAUTIFY_3D_BRIGHT_EYE_RATIO = 31,               /// 亮眼比例，[0, 1.0]，默认值为0.0，0.0不做亮眼
    ST_BEAUTIFY_3D_REMOVE_DARK_CIRCLES_RATIO = 32,      /// 去黑眼圈比例，[0, 1.0]，默认值为0.0，0.0不做去黑眼圈
    ST_BEAUTIFY_3D_REMOVE_NASOLABIAL_FOLDS_RATIO = 33,  /// 去法令纹比例，[0, 1.0]，默认值为0.0，0.0不做去法令纹
    ST_BEAUTIFY_3D_WHITE_TEETH_RATIO = 34,              /// 白牙比例，[0, 1.0]，默认值为0.0，0.0不做白牙
    ST_BEAUTIFY_3D_APPLE_MUSLE_RATIO = 35,              /// 苹果肌比例，[0, 1.0]，默认值为0.0，0.0不做苹果肌
} st_beautify_type;

/// @brief 设置美化参数,默认包含所有功能参数和强度参数
/// @param [in] handle 已初始化的美化句柄
/// @param [in] type 美化参数关键字, 例如ST_BEAUTIFY_CONTRAST_STRENGTH、ST_BEAUTIFY_SMOOTH_STRENGTH
/// @param [in] value 参数取值
/// @return 成功返回ST_OK, 错误则返回错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_beautify_setparam(
    st_handle_t handle,
    st_beautify_type type,
    float value
);

/// @brief 对图像buffer做美化处理, 需要在OpenGL环境中调用
/// @param[in] handle 已初始化的美化句柄
/// @param[in] img_in 输入图片的数据数组
/// @param[in] fmt_in 输入图片的类型,支持NV21,BGR,BGRA,NV12,RGBA,YUV420P格式
/// @param[in] image_width 输入图片的宽度(以像素为单位)
/// @param[in] image_height 输入图片的高度(以像素为单位)
/// @param[in] image_stride 用于检测的图像的跨度(以像素为单位),即每行的字节数；目前仅支持字节对齐的padding,不支持roi
/// @param[in] rotate 将图像中的人转正，图像需要顺时针旋转的角度. 不需要执行美体时, 设置为0
/// @param[in] p_human 人脸检测结果humanAction；如果为NULL,不执行大眼瘦脸
/// @param[out] img_out 输出图像数据数组
/// @param[in] fmt_out 输出图片的类型,支持NV21,BGR,BGRA,NV12,RGBA,YUV420P格式
/// @param[out] p_human_out 输出美化后的人脸humanAction,需要由用户分配内存,必须与输入的人脸数据大小相同；如果为NULL,不输出美化后的人脸数据
/// @return 成功返回ST_OK, 错误则返回错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_beautify_process_buffer(
    st_handle_t handle,
    const unsigned char *img_in, st_pixel_format fmt_in,
    int image_width, int image_height, int image_stride,
    st_rotate_type rotate,
    const st_mobile_human_action_t* p_human,
    unsigned char *img_out, st_pixel_format fmt_out,
    st_mobile_human_action_t* p_human_out
);

/// @brief 对图像做美化处理,此接口针对不在OpenGL环境中执行函数的用户,内部会初始化环境,较慢,只适合单张图片
/// @param[in] handle 已初始化的美化句柄
/// @param[in] img_in 输入图片的数据数组
/// @param[in] fmt_in 输入图片的类型,支持NV21,BGR,BGRA,NV12,RGBA,YUV420P格式
/// @param[in] image_width 输入图片的宽度(以像素为单位)
/// @param[in] image_height 输入图片的高度(以像素为单位)
/// @param[in] image_stride 用于检测的图像的跨度(以像素为单位),即每行的字节数；目前仅支持字节对齐的padding,不支持roi
/// @param[in] rotate 将图像中的人转正，图像需要顺时针旋转的角度. 不需要执行美体时, 设置为0
/// @param[in] p_human 人脸检测结果humanAction；如果为NULL,不执行大眼瘦脸
/// @param[out] img_out 输出图像数据数组
/// @param[in] fmt_out 输出图片的类型,支持NV21,BGR,BGRA,NV12,RGBA,YUV420P格式
/// @param[out] p_human_out 输出美化后的人脸humanAction,需要由用户分配内存,必须与输入的人脸数据大小相同；如果为NULL,不输出美化后的人脸数据
/// @return 成功返回ST_OK, 错误则返回错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_beautify_process_picture(
    st_handle_t handle,
    const unsigned char *img_in, st_pixel_format fmt_in,
    int image_width, int image_height, int image_stride,
    st_rotate_type rotate,
    const st_mobile_human_action_t* p_human,
    unsigned char *img_out, st_pixel_format fmt_out,
    st_mobile_human_action_t* p_human_out
);

/// @brief 对OpenGL中的纹理进行美化处理
/// @param[in] handle 已初始化的美化句柄
/// @param[in] textureid_src 待处理的纹理id, 仅支持RGBA纹理
/// @param[in] image_width 输入纹理的宽度(以像素为单位)
/// @param[in] image_height 输入纹理的高度(以像素为单位)
/// @param[in] rotate 将图像中的人转正，图像需要顺时针旋转的角度. 不需要执行美体时, 设置为0
/// @param[in] p_human 人脸检测结果humanAction；如果为NULL,不执行大眼瘦脸
/// @param[in] textureid_dst 处理后的纹理id, 仅支持RGBA纹理
/// @param[out] p_human_out 输出美化后的人脸humanAction,需要由用户分配内存,必须与输入的人脸数据大小相同；如果为NULL,不输出美化后的人脸数据
/// @return 成功返回ST_OK, 错误则返回错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_beautify_process_texture(
    st_handle_t handle,
    unsigned int textureid_src,
    int image_width, int image_height,
    st_rotate_type rotate,
    const st_mobile_human_action_t* p_human,
    unsigned int textureid_dst,
    st_mobile_human_action_t* p_human_out
);

/// @brief 对OpenGL中的纹理进行美化处理, 并将输出texture转换为buffer输出
/// @param[in] handle 已初始化的美化句柄
/// @param[in] textureid_src 待处理的纹理id, 仅支持RGBA纹理
/// @param[in] image_width 输入纹理的宽度(以像素为单位)
/// @param[in] image_height 输入纹理的高度(以像素为单位)
/// @param[in] rotate 将图像中的人转正，图像需要顺时针旋转的角度. 不需要执行美体时, 设置为0
/// @param[in] p_human 人脸检测结果humanAction；如果为NULL,不执行大眼瘦脸
/// @param[in] textureid_dst 处理后的纹理id, 仅支持RGBA纹理
/// @param[out] img_out 输出图像数据数组,需要用户分配内存,如果是null, 不输出buffer
/// @param[in] fmt_out 输出图片的类型,支持NV21,BGR,BGRA,NV12,RGBA,YUV420P格式
/// @param[out] p_human_out 输出美化后的人脸humanAction,需要由用户分配内存,必须与输入的人脸数据大小相同；如果为NULL,不输出美化后的人脸数据
/// @return 成功返回ST_OK, 错误则返回错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_beautify_process_and_output_texture(
    st_handle_t handle,
    unsigned int textureid_src,
    int image_width, int image_height,
    st_rotate_type rotate,
    const st_mobile_human_action_t* p_human,
    unsigned int textureid_dst,
    unsigned char *img_out, st_pixel_format fmt_out,
    st_mobile_human_action_t* p_human_out
);

/// @brief 释放美化句柄. 必须在OpenGL线程中调用
/// @param[in] handle 已初始化的美化句柄
ST_SDK_API void
st_mobile_beautify_destroy(
    st_handle_t handle
);

#endif // INCLUDE_STMOBILE_ST_MOBILE_BEAUTIFY_H_
