#ifndef INCLUDE_STMOBILE_ST_MOBILE_AVATAR_H_
#define INCLUDE_STMOBILE_ST_MOBILE_AVATAR_H_

#include "st_mobile_common.h"


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

/// @brief 创建Avatar句柄，非线程安全
/// @param[out] p_handle 待创建的Avatar句柄
/// @param[in] p_model_file_path Avatar Core Model的文件路径
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_avatar_create(
    st_handle_t *p_handle,
    const char* p_model_file_path
);

/// @brief 创建Avatar句柄，非线程安全
/// @param[out] p_handle 待创建的Avatar句柄
/// @param[in] p_buffer 已加载到内存中的Avatar Core Model buffer
/// @param[in] buffer_len p_buffer的字节个数
/// @return 成功返回ST_OK, 失败返回其他错误码, 错误码定义在st_mobile_common.h中, 如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_avatar_create_from_buffer(
    st_handle_t *p_handle,
    const char* p_buffer,
    int buffer_len
);

/// @brief 销毁Avatar句柄，非线程安全
/// @param[in] handle 待销毁的Avatar句柄
ST_SDK_API void
st_mobile_avatar_destroy(
	st_handle_t handle
);

/// @brief 获取Avatar需要的检测配置，非线程安全
/// @param[in] handle Avatar句柄
/// @return 当前Avatar需要的检测参数，需要传给检测模块获取检测结果
ST_SDK_API unsigned long long
st_mobile_avatar_get_detect_config(
    st_handle_t handle
);

/// @brief 获取根据传入关键点拟合的Avatar表情系数结果，非线程安全
/// @param[in] handle 已初始化的Avatar句柄
/// @param[in] width  预览图像宽度
/// @param[in] height 预览图像高度
/// @param[in] rotate 预览图像中将人脸转正需要的旋转角度
/// @param[in] p_face 当前帧人脸关键点检测结果。目前SDK只支持对一个人脸获取表情系数
/// @param[out] p_expression_array 待写入的参数数组指针，数组应由调用方预先分配，数组大小应该大于或等于ST_AVATAR_EXPRESSION_NUM，否则将产生越界异常
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_avatar_get_expression(
    st_handle_t handle,
    int width, int height,
    st_rotate_type rotate,
    const st_mobile_face_t* p_face,
    float* p_expression_array
);


#endif // INCLUDE_STMOBILE_ST_MOBILE_AVATAR_H_
