﻿#ifndef INCLUDE_STMOBILE_ST_MOBILE_STICKER_H_
#define INCLUDE_STMOBILE_ST_MOBILE_STICKER_H_

#include "st_mobile_common.h"
#include "st_mobile_human_action.h"
#include "st_mobile_animal.h"
#include "st_mobile_sticker_module.h"

/// 该文件中的API不保证线程安全.多线程调用时,需要确保安全调用.例如在 create handle 没有执行完就执行 process 可能造成crash;在 process 执行过程中调用 destroy 函数可能会造成crash.

#define ST_STICKER_MODULE_NAME_MAX_LENGTH   127
/// @defgroup st_mobile_sticker
/// @brief sticker interfaces
///
/// This set of interfaces process sticker routines.
///

/// @brief 输入参数
typedef struct st_mobile_input_params {
    float camera_quaternion[4];     ///< 相机四元数
    bool is_front_camera;           ///< 是否是前置摄像头
    int custom_event;               ///< 用户自定义事件
} st_mobile_input_params_t, *p_st_mobile_input_params_t;

/// @brief 手机传感器列表，后续会根据需要的传感器数据扩展，最多支持32个传感器
typedef enum
{
    ST_INPUT_PARAM_NONE                 = 0x0,      ///< 无需传感器
    ST_INPUT_PARAM_CAMERA_QUATERNION    = 0x1,      ///< 手机朝向传感器
} st_mobile_input_param_type;

///@brief 贴纸参数
typedef enum {
	ST_STICKER_PARAM_MAX_IMAGE_MEMORY_INT = 0,          ///< 设置贴纸素材图像所占用的最大内存
	ST_STICKER_PARAM_WAIT_MATERIAL_LOADED_BOOL = 1,     ///< 等待素材加载完毕后再渲染，用于希望等待模型加载完毕再渲染的场景，比如单帧或较短视频的3D绘制等

	ST_STICKER_PARAM_SOUND_LOAD_FUNC_PTR = 2,           ///< 设置音乐加载回调函数
	ST_STICKER_PARAM_SOUND_PLAY_FUNC_PTR = 3,           ///< 设置音乐播放回调函数
	ST_STICKER_PARAM_SOUND_PAUSE_FUNC_PTR = 4,          ///< 设置音乐暂停回调函数
	ST_STICKER_PARAM_SOUND_STOP_FUNC_PTR = 5,           ///< 设置音乐停止回调函数
	ST_STICKER_PARAM_SOUND_COMPLETED_STR = 6,           ///< 设置已经播放完成的音乐
	ST_STICKER_PARAM_SOUND_UNLOAD_FUNC_PTR = 7,         ///< 设置音乐数据删除回调函数
	ST_STICKER_PARAM_MODULES_COUNT_INT = 8,             ///< 获取贴纸模块个数

	ST_STICKER_PARAM_PACKAGE_STATE_FUNC_PTR = 9,    ///< 设置package状态回调函数
    ST_STICKER_PARAM_SOUND_RESUME_FUNC_PTR = 10,          ///< 设置音乐继续回调函数

    ST_STICKER_PARAM_PREFER_MEMORY_CACHE = 11,    ///< 如果清除所有3D贴纸, 是否保留3D共用资源
} st_sticker_param_type;


/// @brief 贴纸模块类型
typedef enum {
    ST_MODULE_STICKER_2D = 0,       ///< 2D贴纸模块
    ST_MODULE_SOUND = 1,            ///< 音乐模块
    ST_MODULE_BEAUTIFY = 2,         ///< 美颜模块
    ST_MODULE_FILTER = 3,           ///< 滤镜模块
    ST_MODULE_DEFORMAITON = 4,      ///< 脸部变形模块
    ST_MODULE_MAKEUP = 5,           ///< 美妆模块
    ST_MODULE_BACKGROUND_EDGE = 6,  ///< 背景描边模块
    ST_MODULE_STICKER_3D = 7,       ///< 3D贴纸模块
    ST_MODULE_PARTICLE = 8,         ///< 粒子模块
    ST_MODULE_AVATAR = 9,           ///< Avatar模块
    ST_MODULE_FACE_EXCHANGE = 10,   ///< 多人换脸模块
    ST_MODULE_FACE_MATTING = 11,
    ST_MODULE_SKYBOX = 12,          ///< 天空盒模块
    ST_MODULE_CATCH_BUTTERFLY = 13, ///< 捕蝴蝶模块
    ST_MODULE_FACE_STRETCH = 14,    ///< 人脸拖拽模块
    ST_MODULE_DOUBLEGANGER = 15,
    ST_MODULE_MASK_FILL = 16,
    ST_MODULE_HEAD_ANIMATION = 17
} st_module_type;

/// @brief 创建贴纸句柄
/// @parma[out] handle 贴纸句柄, 失败返回NULL
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_create(
    st_handle_t* handle
);

/// @brief 更换素材包 (删除已有的素材包)
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] zip_path 待更换的素材包文件路径
/// @param[out] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_change_package(
    st_handle_t handle,
    const char* zip_path,
    int* package_id
);

/// @brief 重新播放素材
/// @param[in] handle 已初始化的贴纸句柄
/// @param[in] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_replay_package(
    st_handle_t handle,
    int package_id
);

/// @brief 更换缓存中的素材包 (删除已有的素材包)
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] zip_buffer 待更换的素材包缓存起始地址
/// @param[in] zip_buffer_size 素材包缓存大小
/// @param[out] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_change_package_from_buffer(
    st_handle_t handle,
    const unsigned char* zip_buffer,
    int zip_buffer_size,
    int* package_id
);

/// @brief 添加素材包
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] zip_path 待添加的素材包文件路径
/// @param[out] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_add_package(
    st_handle_t handle,
    const char* zip_path,
    int* package_id
);

/// @brief 添加缓存中的素材包
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] zip_buffer 待添加的素材包缓存起始地址
/// @param[in] zip_buffer_size 素材包缓存大小
/// @param[out] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_add_package_from_buffer(
    st_handle_t handle,
    const unsigned char* zip_buffer,
    int zip_buffer_size,
    int* package_id
);

/// @brief 创建一个空的素材包
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[out] package_id 创建的素材包的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_create_package(
    st_handle_t handle,
    int* package_id
);

/// @brief 删除指定素材包. 可以在非OpenGL线程中执行, 处理下一帧时释放OpenGL资源
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] package_id 待删除的素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_remove_package(
    st_handle_t handle,
    int package_id
);

/// @brief 清空所有素材包. 可以在非OpenGL线程中调用, 处理下一帧时释放OpenGL资源
/// @parma[in] handle 已初始化的贴纸句柄
ST_SDK_API void
st_mobile_sticker_clear_packages(
    st_handle_t handle
);

/// @brief 创建贴纸模块
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] type 模块类型
/// @param[in] package_id 素材包id
/// @param[out] module_id 贴纸模块id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_create_module(
    st_handle_t handle,
    st_module_type type,
    int package_id,
    int* module_id
);

/// @brief 将贴纸模块移动到指定的素材包
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 贴纸模块id
/// @param[in] package_id 素材包id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_move_module_to_package(
    st_handle_t handle,
    int module_id,
    int package_id
);

/// @brief 删除贴纸模块. 可以在非 OpenGL 线程中调用, OpenGL资源在处理下一帧时释放
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_remove_module(
    st_handle_t handle,
    int module_id
);

/// @brief 获取触发动作类型。目前需要显示的
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[out] action 返回的触发动作, 每一位分别代表该位对应状态是否是触发动作, 对应状态详见st_mobile_common.h中, 如ST_MOBILE_EYE_BLINK等
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_trigger_action(
    st_handle_t handle,
    unsigned long long *action
);

/// @brief 获取目前需要的动物检测类型
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[out] action 返回的需要检测的类别，对应状态详见st_mobile_common.h中, 如ST_MOBILE_CAT_DETECT等
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_animal_detect_config(
									 st_handle_t handle,
									 unsigned long long *config
									 );


/// @brief 获取当前需要的自定义输入参数列表，应该在每次切换/添加素材包之后调用。该函数保证线程安全
/// @param[in] handle 已初始化的sticker句柄
/// @param[out] p_param_types 需要的自定义输入参数列表，打包为位图，通过st_mobile_input_param_type枚举值获取列表
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_needed_input_params(
    st_handle_t handle,
    int* p_param_types
);

/// @brief 对OpenGLES中的纹理进行贴纸处理, 必须在opengl环境中运行, 仅支持RGBA图像格式.
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in]texture_src 输入texture id
/// @param[in] image_width 图像宽度
/// @param[in] image_height 图像高度
/// @param[in] rotate 人脸朝向
/// @param[in] frontRotate 前景渲染朝向
/// @param[in] human_action 动作, 包含106点、face动作
/// @param[in] input_params 一些硬件参数和自定义事件
/// @param[in] animal_face 检测到的猫脸结果数组
/// @param[in] animal_face_count 检测到的猫脸数量
/// @param[in]texture_dst 输出texture id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_process_texture_both(
								  st_handle_t handle,
								  unsigned int texture_src, int image_width, int image_height,
								  st_rotate_type rotate, st_rotate_type frontRotate, bool need_mirror,
								  st_mobile_human_action_t* human_action,
								  st_mobile_input_params_t* input_params,
								  st_mobile_animal_face_t* animal_face,
								  int animal_face_count,
								  unsigned int texture_dst
								  );




/// @brief 更新贴纸需要的Mask纹理, 必须在opengl环境中运行. 典型地, old_human_action为美颜之前的检测结果, new_hunman_action为美颜之后的检测结果
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] old_hunman_action 检测结果
/// @param[in] new_hunman_action 变形之后的检测结果
/// @param[in] width 原始图像的宽
/// @param[in] height 原始图像的高
/// @param[in] rotate 人脸朝向
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_update_internal_mask(
    st_handle_t handle,
    const st_mobile_human_action_t* old_human_action,
    const st_mobile_human_action_t* new_human_action,
    int width, int height,
    st_rotate_type rotate
);

/// @brief 对OpenGLES中的纹理进行贴纸处理, 必须在opengl环境中运行, 仅支持RGBA图像格式.
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in]texture_src 输入texture id
/// @param[in] image_width 图像宽度
/// @param[in] image_height 图像高度
/// @param[in] rotate 人脸朝向
/// @param[in] frontRotate 前景渲染朝向
/// @param[in] human_action 动作, 包含106点、face动作
/// @param[in] input_params 一些硬件参数和自定义事件
/// @param[in]texture_dst 输出texture id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_process_texture(
    st_handle_t handle,
    unsigned int texture_src, int image_width, int image_height,
    st_rotate_type rotate, st_rotate_type frontRotate, bool need_mirror,
    st_mobile_human_action_t* human_action,
    st_mobile_input_params_t* input_params,
    unsigned int texture_dst
);

/// @brief 对OpenGLES中的纹理进行贴纸处理并转成buffer输出, 必须在opengl环境中运行, 仅支持RGBA图像格式的texture
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] textureid_src 输入texture id
/// @param[in] image_width 图像宽度
/// @param[in] image_height 图像高度
/// @param[in] rotate 人脸朝向
/// @param[in] frontRotate 前景渲染朝向
/// @param[in] need_mirror 是否需要镜像
/// @param[in] human_action 动作, 包含106点、face动作
/// @param[in] input_params 一些硬件参数和自定义事件
/// @param[in] textureid_dst 输出texture id
/// @param[out] img_out 输出图像数据数组, 需要用户分配内存, 如果是null, 不输出buffer
/// @param[in] fmt_out 输出图片的类型, 支持NV21, BGR, BGRA, NV12, RGBA, YUV420P格式.
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_process_and_output_texture(
    st_handle_t handle,
    unsigned int textureid_src, int image_width, int image_height,
    st_rotate_type rotate, st_rotate_type frontRotate, bool need_mirror,
    st_mobile_human_action_t* human_action,
    st_mobile_input_params_t* input_params,
    unsigned int textureid_dst,
    unsigned char* img_out, st_pixel_format fmt_out
);
/// @brief sticker module part定义
typedef struct {
	int id;                                             ///< ID
	int package_id;                                     ///< 所属package的对应ID
	st_module_type type;                                ///< module种类
	bool enabled;                                       ///< 目前是否被激活
	char name[ST_STICKER_MODULE_NAME_MAX_LENGTH + 1];   ///< 名称
} st_module_info;

/// @brief 获取贴纸模块信息
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] p_infos 贴纸模块信息数组. 由用户分配内存 (使用ST_STICKER_PARAM_MODULES_COUNT_INT参数获取贴纸模块个数)
/// @param[in,out] p_count 输入分配的内存能够存储的模块信息个数, 返回实际获取到的模块信息个数. 当分配的内存不足时, 只返回内存能够存储的模块信息
/// @return 成功返回ST_OK. 当用户分配的内存不足时, 返回ST_E_OUTOFMEMORY
ST_SDK_API st_result_t
st_mobile_sticker_get_modules(
    st_handle_t handle,
    st_module_info* p_infos,
    int* p_count
);

/// @brief 获取素材包id数组
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[out] package_ids 素材包id数组指针
/// @param[out] package_count 素材包个数
/// @return 素材包id数组指针
ST_SDK_API st_result_t
st_mobile_sticker_get_packages(
    st_handle_t handle,
    int* package_ids,
    int* package_count
);

/// @brief 等待素材加载完毕后再渲染，因为会导致切换素材包时画面卡顿，仅建议用于希望等待模型加载完毕再渲染的场景，比如单帧或较短视频的3D绘制等
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] wait 是否等待素材加载完毕后再渲染
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_waiting_material_loaded(
                                              st_handle_t handle,
                                              bool wait
                                              );

/// @brief 释放贴纸句柄, 必须在OpenGL线程中调用
/// @parma[in] handle 已初始化的贴纸句柄
ST_SDK_API void
st_mobile_sticker_destroy(
    st_handle_t handle
);

/// @brief 调整最小帧处理间隔
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] minFrameInterval 贴纸前后两个序列帧切换的最小时间间隔，单位为毫秒。当两个相机帧处理的间隔小于这个值的时候，当前显示的贴纸序列帧会继续显示，直到显示的时间大于该设定值贴纸才会切换到下一阵，相机帧不受影响。
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_min_interval(
								   st_handle_t handle,
								   float minFrameInterval
								   );

/// @brief 设置int类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 贴纸模块id. 设置贴纸句柄参数时, 不用指定module_id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_param_int(
    st_handle_t handle,
    int module_id,
    int param_type,
    int value
);

/// @brief 设置unsigned int类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 贴纸模块id. 设置贴纸句柄参数时, 不用指定module_id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_param_uint(
    st_handle_t handle,
    int module_id,
    int param_type,
    int value
);

/// @brief 设置unsigned long long类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 贴纸模块id. 设置贴纸句柄参数时, 不用指定module_id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_param_ull(
    st_handle_t handle,
    int module_id,
    int param_type,
    int value
);

/// @brief 设置float类型参数
/// @parma[in] handle 贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_param_float(
    st_handle_t handle,
    int module_id,
    int param_type,
    float value
);

/// @brief 设置bool类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_param_bool(
    st_handle_t handle,
    int module_id,
    int param_type,
    bool value
);

/// @brief 设置字符串类型参数 (以'\0'结尾)
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] str 字符串起始地址
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_param_str(
    st_handle_t handle,
    int module_id,
    int param_type,
    const char* str
);

/// @brief 设置指针类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] ptr 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_param_ptr(
    st_handle_t handle,
    int module_id,
    int param_type,
    void* ptr
);

/// @brief 设置数组类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] array_data 数组地址
/// @param[in] array_size 数组元素个数
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_set_param_array(
    st_handle_t handle,
    int module_id,
    int param_type,
    void* array_data,
    int array_size
);

/// @brief 获取贴纸模块的int类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_param_int(
    st_handle_t handle,
    int module_id,
    int param_type,
    int* value
);

/// @brief 获取unsigned int类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_param_uint(
    st_handle_t handle,
    int module_id,
    int param_type,
    int* value
);

/// @brief 获取unsigned long long类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_param_ull(
    st_handle_t handle,
    int module_id,
    int param_type,
    int* value
);

/// @brief 获取float类型参数
/// @parma[in] handle 贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_param_float(
    st_handle_t handle,
    int module_id,
    int param_type,
    float* value
);

/// @brief 获取bool类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] value 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_param_bool(
    st_handle_t handle,
    int module_id,
    int param_type,
    bool* value
);

/// @brief 获取字符串类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] str 保存字符串的内存地址. 由用户创建
/// @param[in, out] len 用户创建的内存空间大小 (建议至少创建1024字节). 返回字符串的实际长度 (不包含结束符'\0')
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_param_str(
st_handle_t handle,
int module_id,
int param_type,
char* str,
int* len
);

/// @brief 获取指针类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[in] ptr 参数值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_param_ptr(
    st_handle_t handle,
    int module_id,
    int param_type,
    void** ptr
);

/// @brief 获取数组类型参数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[out] array_data 数组地址
/// @param[out] array_size 数组元素个数
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_param_array(
    st_handle_t handle,
    int module_id,
    int param_type,
    int array_size,
    void* array_data
);


/// @brief 释放空闲的gl渲染资源,需要在gl上下文中调用
/// @param[in] handle 已初始化的贴纸句柄
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_release_gl_resource(
    st_handle_t handle
);

/// @brief 获取数组类型参数的元素个数
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] module_id 模块id
/// @param[in] param_type 参数类型
/// @param[out] array_size 数组元素个数
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_sticker_get_param_array_size(
    st_handle_t handle,
    int module_id,
    int param_type,
    int* array_size
);

/// @brief 设置性能/效果优先级倾向，引擎内部会根据设置调整渲染策略。
/// @parma[in] handle 已初始化的贴纸句柄
/// @param[in] hint 性能/效果优先级
ST_SDK_API st_result_t
st_mobile_sticker_set_performance_hint(
    st_handle_t handle,
    st_performance_hint_t hint
);

/// @brief 重置内部process texture接口output buffer时的双缓冲（PC平台），避免在传入texture时域上不连续时的闪一阵旧结果问题
/// @param[in] handle 已初始化的贴纸句柄
ST_SDK_API st_result_t
st_mobile_sticker_reset_output_buffer_cache(
    st_handle_t handle
);

#endif  // INCLUDE_STMOBILE_ST_MOBILE_STICKER_H_
