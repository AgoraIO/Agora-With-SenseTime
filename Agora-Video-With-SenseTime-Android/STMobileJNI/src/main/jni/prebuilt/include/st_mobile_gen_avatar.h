#ifndef INCLUDE_STMOBILE_ST_MOBILE_GEN_AVATAR_H_
#define INCLUDE_STMOBILE_ST_MOBILE_GEN_AVATAR_H_

#include "st_mobile_common.h"
#include "st_mobile_human_action.h"

// API specific error.
#define ST_E_NO_AVATAR_FOUND				-1042  ///< 指定avatar不存在
#define ST_E_NO_FEATURE_FOUND               -1043  ///< 指定feature不存在
#define ST_E_NO_CLIP_FOUND                  -1044  ///< 指定clip不存在

typedef enum
{
    ST_MOBILE_GENAVATAR_RIGHT_HAND_COORD = 1,
    ST_MOBILE_GENAVATAR_LEFT_HAND_COORD = 2,
} st_mobile_genavatar_hand_coord_t;

typedef enum
{
    ST_MOBILE_GENAVATAR_NONE = 0x0,
    ST_MOBILE_GENAVATAR_ENABLE_RENDER = 0x1,
} st_mobile_genavatar_config_t;

typedef enum
{
    AVATAR_FEATURE_IDX_BROW = 4,
    AVATAR_FEATURE_IDX_COUNT = 6,
} st_avatar_feature_idx_t;

typedef enum
{
    ST_RESET_FACE_POSE_FRONT,
    ST_RESET_FACE_POSE_CURRENT
} st_face_pose_type_t;

typedef enum
{
    ST_BACKGROUND_IMG_JPEG,
    ST_BACKGROUND_IMG_PNG,
    ST_BACKGROUND_IMG_TGA,
    ST_BACKGROUND_SEQUENCE
} st_render_background_type_t;

#ifndef GENAVATAR_NEW_CONTROLLER
#define GENAVATAR_NEW_CONTROLLER
#endif

typedef enum
{
#ifdef GENAVATAR_NEW_CONTROLLER
    ST_AVATAR_CTRL_BROW_HORIZONTAL = 0,             //"眉毛整体左右",
    ST_AVATAR_CTRL_BROW_VERTICAL,                   //"眉毛整体上下",
    ST_AVATAR_CTRL_BROW_HEADER_HORIZONTAL,          //"眉头左右",
    ST_AVATAR_CTRL_BROW_HEADER_VERTICAL,            //"眉头上下",
    ST_AVATAR_CTRL_BROW_ARCH_HORIZONTAL,            //"眉弓左右",
    ST_AVATAR_CTRL_BROW_ARCH_VERTICAL,              //"眉弓上下",
    ST_AVATAR_CTRL_BROW_TAIL_HORIZONTAL,            //"眉尾左右",
    ST_AVATAR_CTRL_BROW_TAIL_VERTICAL,              //"眉尾上下",
    ST_AVATAR_CTRL_EYE_VERTICAL,                    //"调整双眼上下位置",
    ST_AVATAR_CTRL_EYE_DISTANCE,                    //"调节双眼左右位置",
    ST_AVATAR_CTRL_EYE_OPEN,                        //"调节双眼睁大程度",
    ST_AVATAR_CTRL_EYE_SIZE,                        //"调节双眼整体大小",
    ST_AVATAR_CTRL_EYE_IN_CORNER_VERTICAL,          //"内眼角上下调节",
    ST_AVATAR_CTRL_EYE_IN_CORNER_HORIZONTAL,        //"内眼角左右调节",
    ST_AVATAR_CTRL_UPPER_EYELID_HORIZONTAL,         //"上眼皮左右调节",
    ST_AVATAR_CTRL_UPPER_EYELID_VERTICAL,           //"上眼皮上下调节",
    ST_AVATAR_CTRL_LOWER_EYELID_HORIZONTAL,         //"下眼皮左右调节",
    ST_AVATAR_CTRL_LOWER_EYELID_VERTICAL,           //"下眼皮上下调节",
    ST_AVATAR_CTRL_EYE_OUT_CORNER_VERTICAL,         //"外眼角上下调节",
    ST_AVATAR_CTRL_EYE_OUT_CORNER_HORIZONTAL,       //"外眼角左右调节",
    ST_AVATAR_CTRL_NOSE_LENGTH,                     //"鼻子长短",
    ST_AVATAR_CTRL_NOSE_SIZE,                       //"鼻子大小",
    ST_AVATAR_CTRL_NOSE_ANGLE,                      //"鼻子挺拔",
    ST_AVATAR_CTRL_NOSTRIL_SIZE,                    //"鼻翼大小",
    ST_AVATAR_CTRL_NOSTRIL_VERTICAL,                //"鼻翼上下",
    ST_AVATAR_CTRL_NOSE_BRIDGE_HEIGHT,              //"鼻梁高低",
    ST_AVATAR_CTRL_NOSE_HEAD_SIZE,                  //"鼻头大小",
    ST_AVATAR_CTRL_NOSE_HEAD_ANGLE,                 //"鼻头朝向",
    ST_AVATAR_CTRL_MOUTH_SIZE,                      //"嘴巴变大变小",
    ST_AVATAR_CTRL_MOUTH_VERTICAL,                  //"嘴巴变宽变窄",
    ST_AVATAR_CTRL_MOUTH_CORNER_LENGTH,             //"嘴巴上移下移",
    ST_AVATAR_CTRL_MOUTH_CORNER_VERTICAL,           //"嘴巴向前或后突出",
    ST_AVATAR_CTRL_UPPER_LIP_THICK,                 //"嘴角上扬下撇",
    ST_AVATAR_CTRL_UPPER_LIP_PEAK,                  //"人中上移下移",
    ST_AVATAR_CTRL_LOWER_LIP_THICK,                 //"嘴峰变宽变窄",
    ST_AVATAR_CTRL_LOWER_LIP_SQURENESS,             //"上嘴变厚变薄",
    ST_AVATAR_CTRL_LIP_MARK_VERTICAL,               //"上嘴峰变高变低",
    ST_AVATAR_CTRL_LIP_ARC,                         //"上嘴唇突出向下",
    ST_AVATAR_CTRL_LIP_MARK_UP_DOWN,                // "唇珠向上向下",
    ST_AVATAR_CTRL_LIP_ARC_UP_DOWN,                 // "唇线向上向下",
    ST_AVATAR_CTRL_LOWER_LIP,                       // "下唇变厚变薄",
    ST_AVATAR_CTRL_LOWER_LIP_PEAK,                  // "下唇峰上移下移",
    ST_AVATAR_CTRL_LOWER_LIP_SIDE,                  // "下唇两侧上移下移",
    ST_AVATAR_CTRL_MOUTH_CORNER,                    // "嘴角变宽变细",
    ST_AVATAR_CTRL_HEAD_HORIZONTAL_SIZE,            //"整头胖瘦",
    ST_AVATAR_CTRL_HEAD_VERTICAL_SIZE,              //"整头长短",
    ST_AVATAR_CTRL_FOREHEAD_HEIGHT,                 //"额头高低",
    ST_AVATAR_CTRL_FOREHEAD_WIDTH,                  //"额头宽窄",
    ST_AVATAR_CTRL_JAW_POINT_LENGTH,                //"下巴尖长短",
    ST_AVATAR_CTRL_JAW_LENGTH,                      //"下巴长短",
    ST_AVATAR_CTRL_JAW_SQUARENESS,                  //"下巴尖方",
    ST_AVATAR_CTRL_JAW_HEIGHT,                      //"下颚高低",
    ST_AVATAR_CTRL_JAW_WIDTH,                       //"下颚宽窄",
    ST_AVATAR_CTRL_CHEEK_WIDTH,                     //"颧骨宽窄",
    ST_AVATAR_CTRL_CHEEK_THICK,                      //"腮部凹凸",
    ST_AVATAR_CTRL_CHEST_HEIGHT,                    //"胸高低"
    ST_AVATAR_CTRL_CHEST_SIZE,                      //"胸大小"
    ST_AVATAR_CTRL_WAIST_SIZE,                      //"腰大小"
    ST_AVATAR_CTRL_HIPS_SIZE,                       //"臀大小"
    ST_AVATAR_CTRL_HIPS_HEIGHT,                     //"臀翘程度"
    ST_AVATAR_CTRL_EYE_VERTICAL_SIZE,               //"调节双眼宽窄程度",
    ST_AVATAR_CTRL_BODY_SIZE,                       //"调节身体整体大小",
#else
    ST_AVATAR_CTRL_BROW_HORIZONTAL = 0,             //"眉毛整体左右",
    ST_AVATAR_CTRL_BROW_VERTICAL,                   //"眉毛整体上下",
    ST_AVATAR_CTRL_BROW_HEADER_HORIZONTAL,          //"眉头左右",
    ST_AVATAR_CTRL_BROW_HEADER_VERTICAL,            //"眉头上下",
    ST_AVATAR_CTRL_BROW_ARCH_HORIZONTAL,            //"眉弓左右",
    ST_AVATAR_CTRL_BROW_ARCH_VERTICAL,              //"眉弓上下",
    ST_AVATAR_CTRL_BROW_TAIL_HORIZONTAL,            //"眉尾左右",
    ST_AVATAR_CTRL_BROW_TAIL_VERTICAL,              //"眉尾上下",
    ST_AVATAR_CTRL_EYE_VERTICAL,                    //"调整双眼上下位置",
    ST_AVATAR_CTRL_EYE_DISTANCE,                    //"调节双眼左右位置",
    ST_AVATAR_CTRL_EYE_OPEN,                        //"调节双眼睁大程度",
    ST_AVATAR_CTRL_EYE_SIZE,                        //"调节双眼整体大小",
    ST_AVATAR_CTRL_EYE_IN_CORNER_VERTICAL,          //"内眼角上下调节",
    ST_AVATAR_CTRL_EYE_IN_CORNER_HORIZONTAL,        //"内眼角左右调节",
    ST_AVATAR_CTRL_UPPER_EYELID_HORIZONTAL,         //"上眼皮左右调节",
    ST_AVATAR_CTRL_UPPER_EYELID_VERTICAL,           //"上眼皮上下调节",
    ST_AVATAR_CTRL_LOWER_EYELID_HORIZONTAL,         //"下眼皮左右调节",
    ST_AVATAR_CTRL_LOWER_EYELID_VERTICAL,           //"下眼皮上下调节",
    ST_AVATAR_CTRL_EYE_OUT_CORNER_VERTICAL,         //"外眼角上下调节",
    ST_AVATAR_CTRL_EYE_OUT_CORNER_HORIZONTAL,       //"外眼角左右调节",
    ST_AVATAR_CTRL_NOSE_LENGTH,                     //"鼻子长短",
    ST_AVATAR_CTRL_NOSE_SIZE,                       //"鼻子大小",
    ST_AVATAR_CTRL_NOSE_ANGLE,                      //"鼻子挺拔",
    ST_AVATAR_CTRL_NOSTRIL_SIZE,                    //"鼻翼大小",
    ST_AVATAR_CTRL_NOSTRIL_VERTICAL,                //"鼻翼上下",
    ST_AVATAR_CTRL_NOSE_BRIDGE_HEIGHT,              //"鼻梁高低",
    ST_AVATAR_CTRL_NOSE_HEAD_SIZE,                  //"鼻头大小",
    ST_AVATAR_CTRL_NOSE_HEAD_ANGLE,                 //"鼻头朝向",
    ST_AVATAR_CTRL_MOUTH_SIZE,                      //"嘴大小",
    ST_AVATAR_CTRL_MOUTH_VERTICAL,                  //"嘴上下",
    ST_AVATAR_CTRL_MOUTH_CORNER_LENGTH,             //"嘴角长短",
    ST_AVATAR_CTRL_MOUTH_CORNER_VERTICAL,           //"嘴角上下",
    ST_AVATAR_CTRL_UPPER_LIP_THICK,                 //"上唇厚薄",
    ST_AVATAR_CTRL_UPPER_LIP_PEAK,                  //"上唇唇峰",
    ST_AVATAR_CTRL_LOWER_LIP_THICK,                 //"下唇厚薄",
    ST_AVATAR_CTRL_LOWER_LIP_SQURENESS,             //"下唇方尖",
    ST_AVATAR_CTRL_LIP_MARK_VERTICAL,               //"唇珠上下",
    ST_AVATAR_CTRL_LIP_ARC,                         //"唇弧度",
    ST_AVATAR_CTRL_HEAD_HORIZONTAL_SIZE,            //"整头胖瘦",
    ST_AVATAR_CTRL_HEAD_VERTICAL_SIZE,              //"整头长短",
    ST_AVATAR_CTRL_FOREHEAD_HEIGHT,                 //"额头高低",
    ST_AVATAR_CTRL_FOREHEAD_WIDTH,                  //"额头宽窄",
    ST_AVATAR_CTRL_JAW_POINT_LENGTH,                //"下巴尖长短",
    ST_AVATAR_CTRL_JAW_LENGTH,                      //"下巴长短",
    ST_AVATAR_CTRL_JAW_SQUARENESS,                  //"下巴尖方",
    ST_AVATAR_CTRL_JAW_HEIGHT,                      //"下颚高低",
    ST_AVATAR_CTRL_JAW_WIDTH,                       //"下颚宽窄",
    ST_AVATAR_CTRL_CHEEK_WIDTH,                     //"颧骨宽窄",
    ST_AVATAR_CTRL_CHEEK_THICK,                     //"腮部凹凸"
    ST_AVATAR_CTRL_CHEST_HEIGHT,                    //"胸高低"
    ST_AVATAR_CTRL_CHEST_SIZE,                      //"胸大小"
    ST_AVATAR_CTRL_WAIST_SIZE,                      //"腰大小"
    ST_AVATAR_CTRL_HIPS_SIZE,                       //"臀大小"
    ST_AVATAR_CTRL_HIPS_HEIGHT,                     //"臀翘程度"
    ST_AVATAR_CTRL_EYE_VERTICAL_SIZE,               //"调节双眼宽窄程度",
    ST_AVATAR_CTRL_BODY_SIZE,                       //"调节身体整体大小",
#endif
} st_avatar_controller_id_t;

typedef enum {
    ST_AVATAR_PINCH_BONE_COUNT = 61,
} st_avatar_pinch_bone_t;

typedef enum
{
    ST_MOBILE_COLOR_BLEND_NORMAL = 0,
    ST_MOBILE_COLOR_BLEND_MULTIPLY = 1,
    ST_MOBILE_COLOR_BLEND_COLOR = 2
} st_mobile_color_blend_mode_t;

/// @brief 创建avatar handle
/// @param[in] config 设置创建句柄的方式，可使用'或'方式组合各种不同的需求，参见ST_MOBILE_GENAVATAR_ENABLE_RENDER相关宏，不使用任何flag可传入ST_MOBILE_GENAVATAR_NONE;
/// @param[in] p_handle avatar handle指针
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_create(unsigned int config, st_handle_t* p_handle);

/// @brief 销毁avatar handle
/// @param[in] handle 已初始化的avatar handle
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_destroy(
    st_handle_t handle
);

/// @brief 加载avatar素材包，该接口会删除此前添加的所有avatar，包括附加在其上的makeups和fectures，然后创建一个全新的由p_package_path指定的avatar；
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_package_path avatar素材包路径
/// @param[out] p_avatar_id avatar模型的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_reset_avatar(
    st_handle_t handle,
    const char* p_package_path,
    int* p_avatar_id
);

/// @brief 从buffer加载avatar素材包，其逻辑与st_mobile_gen_avatar_reset_avatar一致
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_package_buffer avatar素材包对应的内存buffer
/// @param[in] buff_len 内存buffer的字节数
/// @param[out] p_avatar_id avatar模型的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_reset_avatar_from_buffer(
    st_handle_t handle,
    const char* p_package_buffer,
    int buffer_len,
    int* p_avatar_id
);

/// @brief 设置avatar模型是否可见（渲染）
/// @param[in] handle 已初始化的avatar handle
/// @param[in] b_visible true - 显示avatar模型（base与当前可见feature）， false - 隐藏avatar模型（base与所有feature），只显示设置的背景
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_avatar_visible(
    st_handle_t handle,
    bool b_visible
);

/// @brief 传入人脸检测数据及检测图像宽、高、旋转，对Avatar脸部骨骼自动变形，捏出接近的人脸
/// @param[in] handle 已初始化的avatar handle
/// @param[in] image_width 检测图像宽
/// @param[in] image_height 检测图像高
/// @param[in] rotate 图像中人脸的方向
/// @param[in] p_human 人脸检测数据
/// @param[in] b_is_male 检测出的性别，true - 男性，false - 女性
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_auto_pinch_face(
    st_handle_t handle,
    int image_width,
    int image_height,
    st_rotate_type rotate,
    const st_mobile_human_action_t* p_human,
    bool b_is_male
);

#define ST_GENAVATAR_BONE_NAME_LEN 128

/// @brief 骨骼空间变换数据结构，包含名字（最长128字节），3D空间变换两组数据结构
typedef struct
{
    char bone_name[ST_GENAVATAR_BONE_NAME_LEN];
    st_mobile_transform_t transform;
} st_mobile_bone_transform_t;

/// @brief 【不需要在GL context中调用】获取当前激活avatar的，用于捏脸的blendshape的数量
/// @param[in] handle 已初始化的avatar handle
/// @param[out] count 填充变量;
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_pinch_face_blendshape_count(
    st_handle_t handle,
    int *count
);

/// @brief 【不需要在GL context中调用】获取当前激活avatar的，用于捏脸的骨骼的数量
/// @param[in] handle 已初始化的avatar handle
/// @param[out] count 填充变量;
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_pinch_face_bone_count(
    st_handle_t handle,
    int *count
);

/// @brief 【不需要在GL context中调用】传入人脸检测结果（人脸240点等），获取对应的捏脸骨骼参数，目前只支持一张人脸
/// @param[in] handle 已初始化的avatar handle
/// @param[in] image_width 检测图像宽
/// @param[in] image_height 检测图像高
/// @param[in] rotate 图像中人脸的方向
/// @param[in] p_human 人脸检测数据
/// @param[in] b_is_male 第一张人脸对应的性别
/// @param[out] p_bone_array 骨骼transform结果数组，输出结果为右手系，全局坐标系的TRS分量，可以调用st_mobile_convert_trs_to_matrix转换为4X4矩阵
/// @param[in] bone_array_size 骨骼transform数组的大小，可通过接口st_mobile_gen_avatar_get_pinch_face_bone_count获取
/// @param[out] p_blendshape_array 捏脸BS系数
/// @param[in] blendshape_array_size 捏脸BS系数组数大小，可通过接口st_mobile_gen_avatar_get_pinch_face_blendshape_count获取
/// @param[out] p_feature_id_array 脸部特征id数组
/// @param[in] feature_id_array_size 脸部特征id数组的大小，应该不小于AVATAR_FEATURE_IDX_COUNT
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_autopinch_result(
    st_handle_t handle,
    int image_width,
    int image_height,
    st_rotate_type rotate,
    const st_mobile_human_action_t *p_human,
    bool b_is_male,
    st_mobile_bone_transform_t *p_bone_array,
    int bone_array_size,
    float* p_blendshape_array,
    int blendshape_array_size,
    int *p_feature_id_array,
    int feature_id_array_size,
    st_mobile_genavatar_hand_coord_t output_coord
);

/// @brief 【不需要在GL context中调用】传入人脸检测结果（人脸240点等），获取对应的表情系数，目前只支持一张人脸，表情系数的索引对应的表情在ST_AVATAR_EXPRESSION_INDEX中定义
/// @param[in] handle 已初始化的avatar handle
/// @param[in] image_width 检测图像宽
/// @param[in] image_height 检测图像高
/// @param[in] rotate 图像中人脸的方向
/// @param[in] p_human 人脸检测数据
/// @param[out] p_expression_array 输出的表情系数数组
/// @param[in] array_size 传入表情系数数组的大小，应该不小于ST_AVATAR_EXPRESSION_NUM
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_face_expression(
    st_handle_t handle,
    int image_width,
    int image_height,
    st_rotate_type rotate,
    const st_mobile_human_action_t *p_human,
    float *p_expression_array,
    int array_size
);

/// @brief 【不需要在GL context中调用】传入2D/3D点对，计算对应的相机外参
/// @param[in] handle 已初始化的avatar handle
/// @param[in] width 检测图像宽
/// @param[in] height 检测图像高
/// @param[in] fov 相机垂直张角，单位为角度（0-180）
/// @param[in] point_num 2D/3D点对的个数，2D、3D点数组的大小应该完全一样
/// @param[in] p_2d_points 2D点数组，注意，如果检测结果有旋转，需要提前将检测出的2D点转正
/// @param[in] p_3d_points 3D点数组
/// @param[out] p_transform 输出的将3D点与2D点对齐需要的相机transform
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_calc_pose(
    st_handle_t handle,
    int width, int height, float fov,
    int point_num,
    const st_pointf_t *p_2d_points,
    const st_point3f_t *p_3d_points,
    st_mobile_transform_t *p_transform
);

/// @brief 目前检测输出的眉毛类型，其中男性4类，女性5类。
typedef enum {
    AVATAR_UNKNOWN_EYEBROW = 0,
    AVATAR_MALE_THIN_FLAT_EYEBROW,          // 男性细平眉
    AVATAR_MALE_THICK_FLAT_EYEBROW,         // 男性粗平眉
    AVATAR_MALE_DASHING_EYEBROW,            // 男性剑眉
    AVATAR_MALE_SLANTED_EYEBROW,            // 男性八字眉
    AVATAR_FEMALE_THIN_FLAT_EYEBROW,        // 女性细平眉
    AVATAR_FEMALE_THICK_FLAT_EYEBROW,       // 女性粗平眉
    AVATAR_FEMALE_THIN_RAISED_EYEBROW,      // 女性细调眉
    AVATAR_FEMALE_THICK_RAISED_EYEBROW,     // 女性粗挑眉
    AVATAR_FEMALE_BENT_EYEBROW,             // 女性弯弯眉
} st_avatar_eyebrow_t;

/// @brief 获取自动捏脸检测到的眉毛类型。注意，需要在调用完成生成接口（auto_pinch_face / genface）之后再调用该接口。
/// @param[in] handle 已初始化的avatar handle
/// @param[out] p_eyebrow 眉毛类型枚举值
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_eyebrow_type(
    st_handle_t handle,
    st_avatar_eyebrow_t* p_eyebrow
);

/// @brief 【不需要在GL context中调用】传入人脸标准点（支持多人脸），计算商汤标准3D人头模型对应的相机外参
/// @param[in] handle 已初始化的avatar handle
/// @param[in] width 检测图像宽
/// @param[in] height 检测图像高
/// @param[in] rotate 将检测图像上的人脸转正，需要顺时针旋转的角度
/// @param[in] fov 相机垂直张角，单位为角度（0-180）
/// @param[in] p_faces 检测得到的人脸关键点数组
/// @param[in] face_count 人脸个数
/// @param[out] p_transforms 输出的将3D人头变换到图像人脸位置对应的transform数组，数组的长度应该不小于face_count
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_calc_standard_pose(
    st_handle_t handle,
    int width, int height, st_rotate_type rotate, float fov,
    const st_mobile_face_t* p_faces, int face_count,
    st_mobile_transform_t *p_transforms
);

/// @brief 获取自动捏脸检测到的feature ids，如眉毛款式等，应该在调用了st_mobile_gen_avatar_genface之后再调用该接口获取feature type。
/// @param[in] handle 已初始化的avatar handle
/// @param[in] type_index feature类型索引
/// @param[out] type_value feature id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_face_features(
    st_handle_t handle,
    st_avatar_feature_idx_t type_index,
    int* type_value
);

/// 捏脸controller数据结构
typedef struct
{
    st_avatar_controller_id_t id;
    float value;
} st_bone_controller_info_t;

/// @brief 更新手动捏脸controller信息，当前需要在渲染版本中调用，且加载了有效的avatar。后续将修改为可以在非渲染版本中调用
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] p_bone_ctrl_infos 捏脸控制点数据数组，控制参数的范围为[0, 1]，无任何影响的默认控制参数为0.5。
/// @parma[in] info_num 控制点数据数组的长度
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_update_bone_controller_info(
    st_handle_t handle,
    const st_bone_controller_info_t* p_bone_ctrl_infos,
    int info_num
);

// 已经废弃，请调用st_mobile_gen_avatar_load_pinch_config
// /// @brief 加载预先捏好的avatar骨骼配置文件
// /// @parma[in] handle 已初始化的avatar handle
// /// @parma[in] p_config_path 骨骼配置文件路径
// /// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
// ST_SDK_API st_result_t
// st_mobile_gen_avatar_load_bone_transform_config(
//     st_handle_t handle,
//     const char* p_config_path
// );

// 已经废弃，请调用st_mobile_gen_avatar_load_pinch_config_from_buffer
// /// @brief 加载预先捏好的avatar骨骼配置buffer
// /// @parma[in] handle 已初始化的avatar handle
// /// @parma[in] p_config_buffer 骨骼配置对应的内存buffer
// /// @param[in] buff_len 内存buffer的字节数
// /// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
// ST_SDK_API st_result_t
// st_mobile_gen_avatar_load_bone_transform_config_from_buffer(
//     st_handle_t handle,
//     const char* p_config_buffer,
//     int buff_len
// );

/// @brief 设置avatar皮肤颜色
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_color 要设置的颜色值，数值范围为[0, 1]，且注意一般alpha（a）值应为1，否则会有不正确的混合效果。
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_change_skin_color(
    st_handle_t handle,
    const st_color_t* p_color
);

/// @brief 从文件加载一个avatar附属模型，如头发、眼镜、衣服、鞋子等
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_feature_path 附属模型的路径
/// @param[out] p_feature_id 返回的用于标识附属模型的id，后续修改颜色、设置可见性、删除使用。
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_add_feature(
    st_handle_t handle,
    const char* p_feature_path,
    int* p_feature_id
);

/// @brief 从buffer加载一个附属模型，如头发、眼镜等
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_feature_buffer 附属模型对应的内存buffer
/// @param[in] buff_len 内存buffer的字节数
/// @param[out] p_feature_id 返回的用于标识附属模型的id，后续修改颜色、设置可见性、删除使用。
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_add_feature_from_buffer(
    st_handle_t handle,
    const char* p_feature_buffer,
    int buff_len,
    int* p_feature_id
);

/// @brief 设置指定附属模型的显示与否，一般在隐藏衣服、身体等，单独显示头部时使用。
/// @param[in] handle 已初始化的avatar handle
/// @param[in] feature_id 附属模型的id
/// @param[in] visible 是否显示
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_feature_visible(
    st_handle_t handle,
    int feature_id,
    bool visible
);

/// @brief 设置附属模型的颜色
/// @param[in] handle 已初始化的avatar handle
/// @param[in] feature_id 附属模型的id
/// @param[in] p_color 要设置的颜色值，数值范围为[0, 1]，且注意一般alpha（a）值应为1，否则会有不正确的混合效果。
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_change_feature_color(
    st_handle_t handle,
    int feature_id,
    const st_color_t* p_color
);

/// @brief 删除一个附属模型，如头发、眼镜等
/// @param[in] handle 已初始化的avatar handle
/// @param[in] feature_id 附属模型的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_remove_feature(
    st_handle_t hanle,
    int feature_id
);

/// @brief 删除所有附属模型，如头发、眼镜等
/// @param[in] handle 已初始化的avatar handle
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_clear_features(
    st_handle_t handle
);

/// @brief 添加一个美妆贴图，如眉毛、口红、胡子等
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_makeup_path 美妆素材包的路径
/// @param[out] p_makeup_id 返回的美妆id，用于后续修改颜色、删除美妆使用。
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_add_makeup(
    st_handle_t handle,
    const char* p_makeup_path,
    int* p_makeup_id
);

/// @brief 从buffer添加一个美妆贴图，如眉毛、口红等
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_makeup_buffer 美妆素材对应的内存buffer
/// @param[in] buff_len 内存buffer的字节数
/// @param[out] p_makeup_id 返回的美妆id，用于后续修改颜色、删除美妆使用。
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_add_makeup_from_buffer(
    st_handle_t handle,
    const char* p_makeup_buffer,
    int buff_len,
    int* p_makeup_id
);

/// @brief 设置对应美妆的颜色
/// @param[in] handle 已初始化的avatar handle
/// @param[in] makeup_id 美妆id
/// @param[in] p_color 要设置的颜色值，数值范围为[0, 1]，且注意一般alpha（a）值应为1，否则会有不正确的混合效果。
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_change_makeup_color(
    st_handle_t handle,
    int makeup_id,
    const st_color_t* p_color
);

/// @brief 删除一个美妆贴图，如眉毛、口红等
/// @param[in] handle 已初始化的avatar handle
/// @param[in] makeup_id 美妆id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_remove_makeup(
    st_handle_t handle,
    int makeup_id
);

/// @brief 删除所有美妆贴图，如眉毛、口红等
/// @param[in] handle 已初始化的avatar handle
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_clear_makeups(
    st_handle_t handle
);

typedef enum
{
    AVATAR_FACING_BODY_FRONT = 0,
    AVATAR_FACING_BODY_LEFT_45,
    AVATAR_FACING_BODY_RIGHT_45,
    AVATAR_FACING_HEAD_FRONT,
    AVATAR_FACING_HEAD_LEFT_45,
    AVATAR_FACING_HEAD_RIGHT_45,
} st_avatar_facing_mode_t;

/// @brief 设置Avatar模型当前朝向视点，在切换初始视点、手动捏脸视点、侧身视点等时使用。目前该接口暂不支持。
/// @param[in] handle 已初始化的avatar handle
/// @param[in] facing_mode Avatar模型目标朝向视点
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_facing_mode(
    st_handle_t handle,
    st_avatar_facing_mode_t facing_mode
);

/// @brief 获取Avatar模型当前朝向视点
/// @param[in] handle 已初始化的avatar handle
/// @param[out] p_facing_mode Avatar模型当前的朝向视点
/// @return Avatar模型当前朝向视点
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_facing_mode(
    st_handle_t handle, st_avatar_facing_mode_t *p_facing_mode
);

/// @brief 竖直方向上旋转Avatar模型
/// @param[in] handle 已初始化的avatar handle
/// @param[in] rotateAngle 旋转角度（单位为角度）
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_rotate(
    st_handle_t handle,
    float rotateAngle
);

typedef enum {
    AVATAR_PINCH_DATA_ZIP,
    AVATAR_PINCH_DATA_JSON,
    AVATAR_PINCH_DATA_UNKNOWN,
} st_avatar_pinch_data_format;

/// @brief 导出当前avatar捏脸配置（骨骼参数，属性信息等）到文件，导出到文件不需要捏脸相关模型已经被加载。
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_export_path 导出配置文件路径，目前支持导出json、zip两种文件格式，文件后缀名应该是这两种中的一种
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_export_pinch_config(
    st_handle_t handle,
    const char *p_export_path,
    st_mobile_genavatar_hand_coord_t output_coord
);

/// @brief 获取当前avatar捏脸配置（骨骼参数，属性信息等）导出到buffer需要的字节数
/// @param[in] handle 已初始化的avatar handle
/// @param[in] config_name 导出的捏脸数据的文件名（用于内部的json文件命名），可以传入空指针或者空字符串，这样内部将使用默认文件名（影响buffer需要的长度），注意与
///                        export_pinch_config_to_buffer传入的名字保持一致
/// @param[in] format 导出配置文件的格式，目前支持导出json、zip两种文件格式
/// @param[out] p_length 导出到buffer需要的字节数
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_pinch_config_buffer_length(
    st_handle_t handle,
    const char* config_name,
    st_avatar_pinch_data_format format,
    int* p_length, st_mobile_genavatar_hand_coord_t output_coord
);

/// @brief 导出当前avatar捏脸配置（骨骼参数，属性信息等）到buffer
/// @param[in] handle 已初始化的avatar handle
/// @param[in] config_name 导出的捏脸文件的文件名（用于内部的json文件命名），可以传入空指针或者空字符串，这样内部将使用默认文件名。
/// @param[in] format 导出配置文件的格式，目前支持导出json、zip两种文件格式
/// @param[out] p_buffer 待写入捏脸数据的内存buffer，如果为nullptr，则仅仅返回需要的大小;
/// @param[in][out] buffer_len buffer输入的字节数，及最终写入的字节数
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_export_pinch_config_to_buffer(
    st_handle_t handle,
    const char *config_name,
    st_avatar_pinch_data_format format,
    char *p_buffer, int *buffer_len,
    st_mobile_genavatar_hand_coord_t output_coord
);

/// @brief 从文件加载avatar预先手动捏脸的骨骼信息
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] p_pinch_file_path 捏脸数据文件的输入路径，目前支持json、zip两种文件格式
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_load_pinch_config(
    st_handle_t handle,
    const char* p_pinch_file_path
);

/// @brief 从buffer加载avatar捏脸配置的骨骼信息
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_pinch_buffer 捏脸配置的内存buffer
/// @param[in] buffer_len 内存buffer的字节数
/// @param[in] format 配置文件的格式，目前支持json、zip两种文件格式
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_load_pinch_config_from_buffer(
    st_handle_t handle,
    const char* p_pinch_buffer, int buffer_len,
    st_avatar_pinch_data_format format
);

/// @brief 从文件加载avatar骨骼动画
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_clip_file_path 骨骼动画的路径
/// @param[out] p_clip_id 内部返回的骨骼动画的id，用于后续切换动画、删除动画clip等
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_load_animation_clip(
    st_handle_t handle,
    const char* p_clip_file_path,
    int* p_clip_id
);

/// @brief 从内存加载avatar骨骼动画
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_clip_buffer 骨骼动画内存buffer
/// @param[in] buffer_len 内存buffer的字节数
/// @param[out] p_clip_id 骨骼动画的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_load_animation_clip_from_buffer(
    st_handle_t handle,
    const char* p_clip_buffer,
    int buffer_len,
    int* p_clip_id
);

/// @brief 从内存卸载avatar骨骼动画
/// @param[in] handle 已初始化的avatar handle
/// @param[in] clip_id 要卸载的骨骼动画id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_unload_animation_clip(
    st_handle_t handle,
    int clip_id
);

/// @brief 获取当前avatar已经加载的骨骼动画数量
/// @param[in] handle 已初始化的avatar handle
/// @param[out] p_clip_count 已经加载的骨骼动画数量
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_animation_clip_count(
    st_handle_t handle,
    int* p_clip_count
);

/// @brief 切换到目标avatar骨骼动画
/// @param[in] handle 已初始化的avatar handle
/// @param[in] clip_id 骨骼动画的id
/// @param[in] transit_sec 过渡时长
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_change_animation(
    st_handle_t handle,
    int clip_id,
    float transit_sec
);

/// @brief 骨骼动画序列单元
typedef struct {
    int anim_clip_id;   /// load_animation_clip返回的clip id
    int loop_num;       /// 循环次数，目前只支持0, 1两个值，其中0指一直循环，1指播放单次
    float smooth_sec;   /// 从前面一个动画过渡到当前动画的过渡时间
} st_animation_target;

/// @brief 切换到目标avatar骨骼动画
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_targets 需要播放的动画序列
/// @param[in] anim_num 动画序列的长度
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_play_animation_stack(st_handle_t handle, const st_animation_target *p_targets, int anim_num);

/// @brief 停止当前正在播放的Avatar骨骼动画，如果当前没有播放骨骼动画，则不做任何事情
/// @param[in] handle 已初始化的avatar handle
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_stop_animation(
    st_handle_t handle
);

typedef enum
{
    /// 捏脸编辑
    AVATAR_DISPLAY_PINCHING = 0,
    /// 只显示头部的实时跟踪
    AVATAR_DISPLAY_FACE_TRACKING,
    /// 显示完整肢体的实时跟踪
    AVATAR_DISPLAY_BODY_TRACKING,
} st_avatar_display_mode_t;

/// @brief 设置avatar当前的显示模式，显示模式会影响后续获取的detect config，另外，内部更新逻辑会有一些区别
/// @param[in] handle 已初始化的avatar handle
/// @param[in] display_mode avatar显示模式
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_display_mode(
    st_handle_t handle,
    st_avatar_display_mode_t display_mode
);

/// @brief 获取avatar当前的显示模式，目前支持捏脸编辑和实时跟踪两个模式，其中捏脸编辑显示全身，实时跟踪只显示头部
/// @param[in] handle 已初始化的avatar handle
/// @param[out] p_display_mode 返回Avatar当前显示模式
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_display_mode(
    st_handle_t handle, st_avatar_display_mode_t* p_display_mode
);

ST_SDK_API st_result_t
st_mobile_gen_avatar_get_blendshape_weights(
    st_handle_t handle, float* p_weights, int num
);

/// @brief 将Avatar渲染到输入的目标纹理上，用于上层显示
/// @param[in] handle 已初始化的avatar handle
/// @param[in] texture_src 输入texture id
/// @param[in] image_width 图像宽度
/// @param[in] image_height 图像高度
/// @param[in] rotate 人脸转正需要顺时针旋转的角度
/// @param[in] p_human_action 人特征检测数据（人脸、肢体等）
/// @param[in] p_body_avatar_array 肢体骨骼旋转数据，用于驱动avatar肢体动作
/// @param[in] body_avatar_count 肢体骨骼数组的长度
/// @param[in]texture_dst 输出texture id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_process_texture(
    st_handle_t handle,
    unsigned int texture_src,
    int image_width,
    int image_height,
    st_rotate_type rotate,
    const st_mobile_human_action_t* p_human_action,
    st_mobile_body_avatar_t* p_body_avatar_array,
    int body_avatar_count,
    unsigned int texture_dst
);

/// @brief 在肢体驱动时没有人体的情况下用来重置Avatar模型，调用之后avatar将停止播放动画，肢体将初始化为无动画的初始姿态
/// @param[in] handle 已初始化的avatar handle
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_reset_body_pose(
    st_handle_t handle
);

/// @brief 获取avatar捏脸需要的检测配置
/// @param[in] handle 已初始化的avatar handle
/// @param[out] p_detect_config 捏脸需要的检测配置
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_detect_config(
    st_handle_t handle,
    unsigned long long* p_detect_config
);

/// @brief 通过内存buffer设置avatar背景
/// @param[in] handle 已初始化的avatar handle
/// @param[in] background_file_buff 背景的图像buffer数据, 可以是单张图,也可以是序列帧素材包, 若该参数为NULL，则显示相机原图
/// @param[in] background_buff_len 背景图像buffer的字节数
/// @param[in] background_type 输入的素材类型，参考st_render_background_type_t的定义
/// @param[out] package_id 返回的输入素材ID
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_background_from_buffer(
    st_handle_t handle,
    const char* background_file_buff,
    int background_buff_len,
    st_render_background_type_t background_type,
    int* package_ID
);

/// @brief 通过文件路径设置avatar背景，若要移除背景，使用`st_mobile_gen_avatar_remove_background`
/// @param[in] handle 已初始化的avatar handle
/// @param[in] background_path 用于背景的文件路径，不能传空
/// @param[out] package_id 返回的输入素材ID
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_background_from_path(
    st_handle_t handle,
    const char* background_path,
    int* package_ID
);

/// @brief 设置avatar背景颜色，若要移除背景，使用`st_mobile_gen_avatar_remove_background`
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_color 要设置的背景颜色，不能为空指针
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_background_color(
    st_handle_t handle,
    const st_color_t* p_color
);

/// @brief 删除指定avatar背景
/// @param[in] handle 已初始化的avatar handle
/// @param[in] package_id 欲删除的素材ID，传入一个负数，如-1，将清除当前所有背景
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_remove_background(
    st_handle_t handle,
    int package_id
);

/// @brief  设置摄像机参数
/// @param[in] handle 已初始化的Avatar句柄
/// @param[in] position 摄像机位置
/// @param[in] target 摄像机观察位置
/// @param[in] up 摄像机向上方向
/// @param[in] transit_sec 从相机的当前姿态过渡到目标姿态的时长（单位为秒），输入0将马上切换到目标姿态
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_camera_lookat(
    st_handle_t handle,
    const float position[3],
    const float target[3],
    const float up[3],
    float transit_sec
);

/// @brief  设置透视投影摄像机参数
/// @param[in] handle 已初始化的Avatar句柄
/// @param[in] fov 摄像机竖直张角，单位为角度
/// @param[in] aspect 摄像机投影面宽高比
/// @param[in] znear 摄像机近平面，单位为米
/// @param[in] zfar 摄像机远平面，单位为米
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_camera_perspective(
    st_handle_t handle,
    float fov,
    float aspect,
    float znear,
    float zfar
);

/// @brief  设置正交投影摄像机参数，注意：如果在移动端，相关参数的设置需要参考正常垂直手持手机时屏幕的宽高。
/// @param[in] handle 已初始化的Avatar句柄
/// ...
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_camera_orthogonal(
    st_handle_t handle,
    float left, float right,
    float bottom, float top,
    float znear, float zfar
);

/// @brief  设置是否锁定人脸对齐使用的相机（不受lookat、perspective接口调用的影响），一般在不希望模型始终朝向屏幕，而是在自己局部坐标系中跟随图像中人脸转动时启用。
/// @param[in] handle 已初始化的Avatar句柄
/// @param[in] b_lock 是否锁定人脸对齐使用的相机
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_lock_face_fitting_camera(
    st_handle_t handle,
    bool b_lock
);

/// @brief  设定头部的正向姿态为当前姿态或初始姿态
/// @param[in] handle 已初始化的Avatar句柄
/// @param[in] pose_type ST_RESET_FACE_POSE_CURRENT 则将头部的正向姿态设为当前姿态，为 ST_RESET_FACE_POSE_FRONT 则为初始姿态
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_reset_face_pose(st_handle_t handle, st_face_pose_type_t pose_type);

/// @brief 标识Avatar身体各部位的枚举值
typedef enum {
    ST_AVATAR_PART_HEAD,        // Avatar头部
    ST_AVATAR_PART_UP_BODY,     // Avatar上半身
    ST_AVATAR_PART_COUNT,
} st_avatar_part_t;

/// @brief Avatar肢体驱动时的fitting系数，将在从图像计算的pose的基础上再叠加接口传入的系数。一般在减小或者增大跟随幅度时使用
/// @param[in] handle 已初始化的Avatar句柄
/// @param[in] part 要设置缩放因子的Avatar身体部位
/// @param[in] scale 缩放因子，应该大于0
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_fitting_scale(st_handle_t handle, st_avatar_part_t part, float scale);

/// @brief 是否在肢体驱动模式下开启头部影响上半身摆动的IK效果
/// @param[in] handle 已初始化的Avatar句柄
/// @param[in] b_enable_upbody_ik true - 启用效果，false - 禁用效果
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_upbody_ik_enabled(st_handle_t handle, bool b_enable_upbody_ik);

/// @brief 加载avatar素材包，多次以相同p_avatar_path调用该接口会生产多份相同的avatar实例（共享一份资源）；如果是多avatar应用场景，需要应用层传入并保存p_avatar_id指针，以便在不同avatar之间使用st_mobile_gen_avatar_active_avatar接口切换;
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] p_avatar_path avatar素材包路径
/// @parma[out] p_avatar_id avatar模型的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_add_avatar(
    st_handle_t handle,
    const char* p_avatar_path,
    int* p_avatar_id
);

/// @brief 从buffer加载avatar素材包，除此之外与st_mobile_gen_avatar_add_avatar无异。
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] p_package_buffer avatar素材包对应的内存buffer
/// @param[in] buff_len 内存buffer的字节数
/// @parma[out] p_avatar_id avatar模型的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_add_avatar_from_buffer(
    st_handle_t handle,
    const char* p_package_buffer,
    int buffer_len,
    int* p_avatar_id
);

/// @brief 克隆指定avatar，生产新的avatar，克隆会包括feature与makeup
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] from_avatar_id 已存在的、要被克隆的avatar模型id;也可以传入小于0的数字，代表克隆当前激活的avatar;
/// @parma[out] p_avatar_id avatar模型的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_clone_avatar(
    st_handle_t handle,
    int from_avatar_id,
    int* p_avatar_id
);

/// @brief 删除一个avatar，如果该avatar素材包被其他avatar共享资源，资源包不会被卸载，如果没有被共享，资源包也会释放，如果指定移除的avatar是当前激活的avatar，在成功remove后激活avatar将为nullptr;
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] avatar_id avatar模型的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_remove_avatar(
    st_handle_t handle,
    int avatar_id
);

/// @brief 旋转avatar，注意区分与st_mobile_gen_avatar_rotate接口的不同。
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] rotateAngle 旋转角度
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_rotate_avatar(
    st_handle_t handle,
    float rotateAngle
);

/// @brief 平移avatar;
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] translate 平移的尺度
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_translate_avatar(
    st_handle_t handle,
    const float translate[3]
);
/// @brief 缩放avatar;
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] scale 缩放的尺度，分别表示3个轴的缩放，任何一轴缩放不能是0或者接近0的值；
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_scale_avatar(
    st_handle_t handle,
    const float scale[3]
);

/// @brief 激活指定的avatar模型，使其成为后续API接口直接操作的目标，如果在使用其他API之前没有调用该接口，
/// 引擎默认使用最后一次通过以下函数添加的avatar：
///   st_mobile_gen_avatar_add_avatar
///   st_mobile_gen_avatar_add_avatar_from_buffer
///   st_mobile_gen_avatar_reset_avatar
///   st_mobile_gen_avatar_reset_avatar_from_buffer
/// @parma[in] handle 已初始化的avatar handle
/// @parma[in] p_avatar_id avatar模型的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_activate_avatar(
    st_handle_t handle,
    int avatar_id
);

/// @brief 获取当前激活的avatar的ID，如果不存在，返回-1；
/// @parma[in] handle 已初始化的avatar handle
/// @parma[out] p_avatar_id avatar模型的id
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_get_active_avatar(
    st_handle_t handle,
    int* p_avatar_id
);

/// @brief 设置指定feature的dynamicbone是否`冻结`更新几帧，用于在一些`瞬移`业务需求中，不对dynamicbone进行符合物理规律的更新。因为瞬移有距离但时间极短（基本为0s），计算出来的加速度极大，用此进行正常的物理模拟会很失真。注意：我们未提供诸如`unfreeze`这样的API，故此该接口调用后的几帧会自动恢复物理模拟。
/// @param[in] handle 已初始化的avatar handle
/// @param[in] feature_id 属性模型的id
ST_SDK_API st_result_t
st_mobile_gen_avatar_freeze_feature_dynamic_bone(
    st_handle_t handle,
    int feature_id
);

/// @brief 人脸AVATAR生成
/// @param[in] handle 已初始化的avatar handle
/// @param[in] image 用于检测的图像数据
/// @param[in] pixel_format 用于检测的图像数据的像素格式. 检测人脸建议使用NV12、NV21、YUV420P(转灰度图较快),检测手势和前后背景建议使用BGR、BGRA、RGB、RGBA
/// @param[in] image_width 用于检测的图像的宽度(以像素为单位)
/// @param[in] image_height 用于检测的图像的高度(以像素为单位)
/// @param[in] image_stride 用于检测的图像的跨度(以像素为单位),即每行的字节数；目前仅支持字节对齐的padding,不支持roi
/// @param[in] p_face 人脸106点的检测结果
/// @param[in] b_is_male 检测出的性别，true - 男性，false - 女性
/// @param[in] avatar_id 用于在多avatar场景下，指定对哪个avatar生成人脸, -1 表示当前激活的avatar
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等st_mobile_human_action_avatar_get_count获得
ST_SDK_API st_result_t
st_mobile_gen_avatar_genface(
    st_handle_t handle,
    const unsigned char* image,
    st_pixel_format pixel_format,
    int image_width,
    int image_height,
    int image_stride,
    st_rotate_type rotate,
    const st_mobile_human_action_t *p_human,
    bool b_is_male,
    int avatar_id
);

/// @brief 还原捏脸数据为素材默认的效果
/// @param[in] handle 已初始化的avatar handle
/// @param[in] avatar_id 用于在多avatar场景下，指定对哪个avatar进行还原, -1 表示当前激活的avatar；非渲染模式或者没有API支持的情况下-1即可；
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中
ST_SDK_API st_result_t
st_mobile_gen_avatar_reset_genface(
    st_handle_t handle,
    int avatar_id
);

/// @brief 加载人脸AVATAR生成模型文件和配置文件
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_model_path PPL模型文件路径
/// @param[in] p_pinch_config_path 捏脸配置文件，不随模型（fbx）的变化而变化，相对比较稳定;
/// @param[in] p_pinch_model_path 捏脸模型文件，可能会随着用户FBX的变化而改变;
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_gen_avatar_load_genface_config(
	st_handle_t handle,
	const char* p_model_path,
	const char* p_pinch_config_path,
	const char* p_pinch_model_path
);

/// @see st_mobile_gen_avatar_load_genface_config
ST_SDK_API st_result_t
st_mobile_gen_avatar_load_genface_config_from_buffer(
	st_handle_t handle,
	const unsigned char* p_model_buffer,
    int model_buffer_length,
	const unsigned char* p_pinch_config_buffer,
    int pinch_config_buffer_length,
	const unsigned char* p_pinch_model_buffer,
    int pinch_model_buffer_length
);

/// @brief 卸载此前加载的用于捏脸的配置
/// @param[in] handle 已初始化的avatar handle
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中
ST_SDK_API st_result_t
st_mobile_gen_avatar_unload_genface_config(
    st_handle_t handle
);

/// @brief 添加asset素材包，注意返回的assets id与feature id，makeup id等是不同素材id（即便他们的值可能是相同的）
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_asset_path 素材包的资源路经
/// @param[out] p_asset_id 返回的输入素材ID
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中
ST_SDK_API st_result_t
st_mobile_gen_avatar_add_asset(
    st_handle_t handle,
    const char* p_asset_path,
    int* p_asset_id
);

/// @brief 添加asset素材包，
/// @param[in] handle 已初始化的avatar handle
/// @param[in] p_asset_buffer 素材包资源在内存中的首地址
/// @param[in] buff_len 资源所占内存大小(in bytes)
/// @param[out] p_asset_id 返回的输入素材ID
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中
ST_SDK_API st_result_t
st_mobile_gen_avatar_add_asset_from_buffer(
    st_handle_t handle,
    const unsigned char* p_asset_buffer,
    int buff_len,
    int* p_asset_id
);

/// @brief 移除asset素材包，
/// @param[in] handle 已初始化的avatar handle
/// @param[in] asset_id 已加载的asset素材ID
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中
ST_SDK_API st_result_t
st_mobile_gen_avatar_remove_asset(
    st_handle_t handle,
    int asset_id
);

/// @brief 移除所有asset素材包，
/// @param[in] handle 已初始化的avatar handle
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中
ST_SDK_API st_result_t
st_mobile_gen_avatar_remove_all_assets(
    st_handle_t handle
);

/// @brief 改变asset素材包中的素材颜色。
/// @param[in] handle 已初始化的avatar handle
/// @param[in] asset_id 已加载的asset素材ID
/// @param[in] p_color 要设置的颜色值数组，数值范围为[0, 1]，且注意一般alpha（a）值应为1，否则会有不正确的混合效果。
/// @param[in] color_count 颜色值数组的长度，makeup和一般材质为1，目前卡通材质需要为2
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中
ST_SDK_API st_result_t
st_mobile_gen_avatar_change_asset_color(
    st_handle_t handle,
    int asset_id,
    const st_color_t* p_color,
    int color_count
);

/// @brief 设置blendshape系数变化的幅度，默认是1.0.
// blendshape系数默认是在0到1之间变化，通过该接口可以改变其默认的范围，比如素材建模的时候指定avatar张嘴最大的程度，这个程度表示默认最大，数值化后用1表示；如果你想让嘴张的更大（或不要建模时指定的那么大），可以通过该接口将blendshape的变化幅度调整到默认最大的x倍（也就是1的x倍）。该接口不考虑mode（face_tracking,display_pinch,body_tracking)的状态。
/// @param[in] handle 已初始化的avatar handle
/// @param[in] index 枚举的blendshape索引，从st_mobile_common.h中可查看
/// @param[in] value 表情基变化幅度，任何合法的float值都是可以的，默认1.0
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中
ST_SDK_API st_result_t
st_mobile_gen_avatar_set_blendshape_factor(
    st_handle_t handle,
    ST_AVATAR_EXPRESSION_INDEX index,
    float value
);

ST_SDK_API st_result_t
st_mobile_gen_avatar_export_active_scene(
    st_handle_t handle,
    const char *p_export_path,
    st_mobile_genavatar_hand_coord_t output_coord
);
#endif // INCLUDE_STMOBILE_ST_MOBILE_GEN_AVATAR_H_
