#ifndef INCLUDE_STMOBILE_ST_MOBILE_MAKEUP_H_
#define INCLUDE_STMOBILE_ST_MOBILE_MAKEUP_H_

#include "st_mobile_common.h"
#include "st_mobile_human_action.h"

/// 该文件中的API不保证线程安全.多线程调用时,需要确保安全调用.例如在 create handle 没有执行完就执行 process 可能造成crash;在 process 执行过程中调用 destroy 函数可能会造成crash.

/// @defgroup st_mobile_makeup
/// @brief sticker interfaces
///
/// This set of interfaces process makeup routines.
///
typedef enum
{
	ST_MAKEUP_TYPE_EYE = 1,   	    //眼部美妆
	ST_MAKEUP_TYPE_FACE = 2,	    //腮部美妆
	ST_MAKEUP_TYPE_LIP = 3,		    //唇部美妆
	ST_MAKEUP_TYPE_NOSE = 4,	    //修容美妆
	ST_MAKEUP_TYPE_BROW = 5,		//眉部美妆
    ST_MAKEUP_TYPE_EYELINER = 6,    //眼线美妆
    ST_MAKEUP_TYPE_EYELASH = 7,     //眼睫毛美妆
    ST_MAKEUP_TYPE_EYEBALL = 8,     //美瞳美妆
}st_makeup_type;

/// @brief 创建美妆句柄
/// @parma[out] handle 美妆句柄, 失败返回NULL
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_create(
    st_handle_t* handle
);

/// @brief 更换素材包 (删除已有的素材包)
/// @param[in] handle 已初始化的美妆句柄
/// @param[in] makeup_type 制定素材包所属的type, 定义如st_makeup_type.
/// @param[in] zip_path 待更换的素材包文件路径
/// @param[out] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_set_makeup_for_type(
    st_handle_t handle,
    st_makeup_type makeup_type,
    const char* zip_path,
    int* package_id
);

/// @brief 更换缓存中的素材包 (删除已有的素材包)
/// @param[in] handle 已初始化的美妆句柄
/// @param[in] makeup_type 制定素材包所属的type, 定义如st_makeup_type.
/// @param[in] zip_buffer 待更换的素材包缓存起始地址
/// @param[in] zip_buffer_size 素材包缓存大小
/// @param[out] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_set_makeup_for_type_from_buffer(
    st_handle_t handle,
    st_makeup_type makeup_type,
    const unsigned char* zip_buffer,
    int zip_buffer_size,
    int* package_id
);

/// @brief 添加素材包
/// @param[in] handle 已初始化的美妆句柄
/// @param[in] makeup_type 制定素材包所属的type, 定义如st_makeup_type.
/// @param[in] zip_path 待添加的素材包文件路径
/// @param[out] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_add_makeup_for_type(
    st_handle_t handle,
	st_makeup_type makeup_type,
    const char* zip_path,
    int* package_id
);

/// @brief 添加缓存中的素材包
/// @param[in] handle 已初始化的美妆句柄
/// @param[in] makeup_type 制定素材包所属的type, 定义如st_makeup_type.
/// @param[in] zip_buffer 待添加的素材包缓存起始地址
/// @param[in] zip_buffer_size 素材包缓存大小
/// @param[out] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_add_makeup_for_type_from_buffer(
    st_handle_t handle,
	st_makeup_type makeup_type,
    const unsigned char* zip_buffer,
    int zip_buffer_size,
    int* package_id
);

/// @brief 删除指定素材包. 可以在非OpenGL线程中执行, 处理下一帧时释放OpenGL资源
/// @param[in] handle 已初始化的美妆句柄
/// @param[in] package_id 待删除的素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_remove_makeup(
    st_handle_t handle,
    int package_id
);

/// @brief 清空所有素材包. 可以在非OpenGL线程中调用, 处理下一帧时释放OpenGL资源
/// @parma[in] handle 已初始化的美妆句柄
ST_SDK_API void
st_mobile_makeup_clear_makeups(
    st_handle_t handle
);

/// @brief 获取触发动作类型。目前需要显示的
/// @parma[in] handle 已初始化的美妆句柄
/// @param[out] action 返回的触发动作, 每一位分别代表该位对应状态是否是触发动作, 对应状态详见st_mobile_common.h中, 如ST_MOBILE_EYE_BLINK等
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_get_trigger_action(
    st_handle_t handle,
    unsigned long long *action
);

/// @brief 美妆预处理，用于检测脸部区域暗光和逆光
/// @parma[in] handle 已初始化的美妆句柄
/// @param[in] image 用于检测的图像数据
/// @param[in] image_width 用于检测的图像的宽度(以像素为单位)
/// @param[in] image_height 用于检测的图像的高度(以像素为单位)
/// @param[in] image_stride 用于检测的图像的跨度(以像素为单位),即每行的字节数
/// @param[in] human_action 动作, 包含106点、face动作
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_prepare(
    st_handle_t handle,
    const unsigned char* image,
    st_pixel_format pixel_format,
    int image_width,
    int image_height,
    int image_stride,
    st_mobile_human_action_t* human_action
);

/// @brief 对OpenGLES中的纹理进行美妆处理, 必须在opengl环境中运行, 仅支持RGBA图像格式.
/// @parma[in] handle 已初始化的美妆句柄
/// @param[in]texture_src 输入texture id
/// @param[in] image_width 图像宽度
/// @param[in] image_height 图像高度
/// @param[in] human_action 动作, 包含106点、face动作
/// @param[in]texture_dst 输出texture id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_process_texture(
    st_handle_t handle,
    unsigned int texture_src, int image_width, int image_height,
    st_rotate_type rotate,
    st_mobile_human_action_t* human_action,
    unsigned int texture_dst
);

/// @brief 对OpenGLES中的纹理进行美妆处理并转成buffer输出, 必须在opengl环境中运行, 仅支持RGBA图像格式的texture
/// @parma[in] handle 已初始化的美妆句柄
/// @param[in] textureid_src 输入texture id
/// @param[in] image_width 图像宽度
/// @param[in] image_height 图像高度
/// @param[in] rotate 人脸朝向
/// @param[in] human_action 动作, 包含106点、face动作
/// @param[in] textureid_dst 输出texture id
/// @param[out] img_out 输出图像数据数组, 需要用户分配内存, 如果是null, 不输出buffer
/// @param[in] fmt_out 输出图片的类型, 支持NV21, BGR, BGRA, NV12, RGBA, YUV420P格式.
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_makeup_process_and_output_texture(
    st_handle_t handle,
    unsigned int textureid_src, int image_width, int image_height,
    st_rotate_type rotate,
    st_mobile_human_action_t* human_action,
    unsigned int textureid_dst,
    unsigned char* img_out, st_pixel_format fmt_out
);

/// @brief 调整指定类型美妆的强度
/// @param[in] handle 已初始化的美妆句柄
/// @param[in] makeup_type 制定素材包所属的type, 定义如st_makeup_type.
/// @param[in] value 指定美妆的强度，范围在[0, 1]
ST_SDK_API void
st_mobile_makeup_set_strength_for_type(
	st_handle_t handle,
    st_makeup_type makeup_type,
    float value
);

/// @brief 调整指定类型的磨皮强度，目前支持唇部
/// @param handle 已初始化的美妆句柄
/// @param[in] makeup_type 制定素材包所属的type, 定义如st_makeup_type.
/// @param[in] value 指定磨皮强度，范围在[0, 1]
ST_SDK_API void
st_mobile_makeup_set_smooth_strength(
    st_handle_t handle,
    st_makeup_type makeup_type,
    float value
);

/// @brief 修改制定类型美妆的图片素材, 仅当该类型美妆目前只有一张素材图片时起效。
/// @param[in] handle 已初始化的美妆句柄
/// @param[in] makeup_type 制定素材包所属的type, 定义如st_makeup_type.
/// @param[in] package_id 指定素材所属的package
/// @param[in] resource_data 素材图片的数据, 支持格式包括:ST_PIX_FMT_RGBA8888, ST_PIX_FMT_BGRA8888, ST_PIX_FMT_NV12, ST_PIX_FMT_NV21
ST_SDK_API void
st_mobile_makeup_set_resource_for_type(
	st_handle_t handle,
    st_makeup_type makeup_type,
    int package_id,
    st_image_t resource_data
);

/// @brief 释放美妆句柄, 必须在OpenGL线程中调用
/// @parma[in] handle 已初始化的美妆句柄
ST_SDK_API void
st_mobile_makeup_destroy(
    st_handle_t handle
);
#endif  // INCLUDE_STMOBILE_ST_MOBILE_MAKEUP_H_
