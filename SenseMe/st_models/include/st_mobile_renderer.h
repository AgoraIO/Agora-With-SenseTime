#ifndef INCLUDE_STMOBILE_ST_MOBILE_RENDERER_H_
#define INCLUDE_STMOBILE_ST_MOBILE_RENDERER_H_


#include "st_mobile_common.h"
#include "st_mobile_slam.h"

typedef enum st_slam_aux_type {
    ST_SLAM_AXIS,                       //slam坐标轴
    ST_SLAM_GRIDPLANE,                  //slam平面
    ST_SLAM_HORIZONTALPLANE,              //表示手机位置的平面
    ST_SLAM_UNITCUBE,                   //单元大小的正方体
    ST_SLAM_FEATURE,                    //slam特征点
    ST_SLAM_PLANE_MESH,
    ST_SLAM_ALL                         //所有辅助信息
}st_slam_aux_type;

/// @brief 创建renderer句柄
/// @parma[out] handle 句柄,失败返回NULL
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_renderer_create(st_handle_t *handle);

/// @brief 释放renderer句柄
ST_SDK_API void
st_mobile_renderer_destroy(st_handle_t handle);

/// @brief 用于设置初始imu方向,安卓为相机方向,iOS为应用配置方向
/// @parma[in] renderer handle 句柄
/// @parma[in] orientation 朝向参数
ST_SDK_API void
st_mobile_renderer_set_app_initial_orientation(st_handle_t handle, st_rotate_type orientation);

/// @brief 用于设置需渲染的模型
/// @parma[in] handle 句柄
/// @parma[in] path 模型zip的路径
/// @return 成功返回模型ID,失败返回-1
ST_SDK_API int
st_mobile_renderer_add_object(st_handle_t handle, const char* path);

/// @brief 删除指定模型
/// @parma[in] renderer handle 句柄
/// @parma[in] 模型的ID
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_renderer_delete_object(st_handle_t handle, int object_id);

/// @brief 删除全部模型
/// @parma[in] renderer handle 句柄
ST_SDK_API void
st_mobile_renderer_delete_all_objects(st_handle_t handle);

/// @brief 重置指定模型位置, 在调用st_mobile_slam_set_init_pos后调用
/// @parma[in] renderer handle 句柄
/// @parma[in] object_id 模型的ID
ST_SDK_API void
st_mobile_renderer_reset_object(st_handle_t handle, int object_id);

/// @brief 根据触碰点改变模型在slam平面上的位置
/// @parma[in] renderer handle 句柄
/// @parma[in] object_id 模型的ID
/// @parma[in] 2.0f*x/viewWidth - 1.0f来计算
/// @parma[in] 2.0f*y/viewHeight - 1.0f来计算
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_renderer_set_object_location(st_handle_t handle, int object_id, float ratio_x, float ratio_y);

/// @brief 设置需显示的slam信息
/// @parma[in] renderer handle 句柄
/// @parma[in] type 需改变的信息种类
/// @parma[in] 信息是否可见
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_renderer_set_aux_display(st_handle_t handle, st_slam_aux_type type, bool visible);

/// @brief 渲染slam结果
/// @parma[in] renderer handle 句柄
/// @parma[in] textureid_src 输入的原始纹理
/// @parma[in] info slam的结果
/// @parma[in] width 输入纹理宽
/// @parma[in] height 输入纹理高
/// @parma[out] textureid_dst 输出纹理
/// @parma[out] image_out 输出图片数据, 可为空
/// @parma[in] format输出图片数据格式，支持ST_PIX_FMT_RGBA8888, ST_PIX_FMT_BGRA8888, ST_PIX_FMT_NV12, ST_PIX_FMT_NV21
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_renderer_render_slam(st_handle_t handle, unsigned int textureid_src, st_slam_result &info, int width, int height, unsigned int textureid_dst, unsigned char* image_out, st_pixel_format format);

/// @brief 渲染slam结果, 安卓用双纹理版
/// @parma[in] renderer handle 句柄
/// @parma[in] textureid_y_src 输入的原始纹理y通道
/// @parma[in] textureid_uv_src 输入的原始纹理uv通道
/// @parma[in] info slam的结果
/// @parma[in] width 输入纹理宽
/// @parma[in] height 输入纹理高
/// @parma[out] textureid_dst 输出纹理
/// @parma[out] image_out 输出图片数据, 可为空
/// @parma[in] format 输出图片数据格式，支持ST_PIX_FMT_RGBA8888, ST_PIX_FMT_RGBA, ST_PIX_FMT_NV12, ST_PIX_FMT_NV21
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_renderer_render_slam_yuv(st_handle_t handle, unsigned int textureid_y_src, unsigned int textureid_uv_src, st_slam_result &info, int width, int height, unsigned int textureid_dst, unsigned char* image_out, st_pixel_format format);
ST_SDK_API void
st_mobile_renderer_reset(st_handle_t handle);

#endif /* st_mobile_renderer_h */
