#ifndef INCLUDE_STMOBILE_ST_MOBILE_ATTR_FACEFEATURE_H_
#define INCLUDE_STMOBILE_ST_MOBILE_ATTR_FACEFEATURE_H_

#include "st_mobile_common.h"


#define ST_ATTR_FF_DETECT_HAIRSTYLE				0x20000001  ///< 人脸属性发型开关
#define ST_ATTR_FF_DETECT_GLASS                 0x20000002  ///< 人脸属性眼镜开关
#define ST_ATTR_FF_DETECT_EYELID                0x20000004  ///< 人脸属性眼皮开关
#define ST_ATTR_FF_DETECT_MUSTACHE              0x20000008  ///< 人脸属性胡子开关

/// @brief 眼镜属性
typedef struct st_mobile_attr_face_glass_info{
	enum glass_type_t{
		GLASS_TYPE_NONE = 0,				///< 无眼镜
		GLASS_TYPE_TRANSPARENT,				///< 透明眼镜
		GLASS_TYPE_SUNGLASS					///< 太阳镜
	} glass_type;									///< 眼镜类型
	enum glass_frame_t{
		GLASS_FRAME_NONE = 0,				///< 无镜框
		GLASS_FRAME_FULL,					///< 全镜框
		GLASS_FRAME_HALF					///< 半镜框
	} glass_frame;									///< 镜框类型
	enum glass_shape_t{
		GLASS_SHAPE_NONE = 0,				///< 无形状眼镜
		GLASS_SHAPE_RECTANGLE,				///< 长方形眼镜
		GLASS_SHAPE_CIRCULAR,				///< 圆形眼镜
		GLASS_SHAPE_SQUARE					///< 正方形眼镜
	} glass_shape;									///< 眼镜形状
	enum glass_thickness_t{
		GLASS_THICKNESS_NONE = 0,			///< 无镜框
		GLASS_THICKNESS_THIN,				///< 细镜框
		GLASS_THICKNESS_THICK,				///< 粗镜框
	} glass_thickness;								///< 框粗细
} st_mobile_attr_face_glass_info_t;						///< 眼镜属性

/// @brief 女生头发属性
typedef struct st_mobile_attr_face_hair_girl_info{
	enum hair_girl_fringe_t{
		HAIR_FRINGE_NONE = 0,				///< 无刘海
		HAIR_FRINGE_FULL,					///< 齐刘海
		HAIR_FRINGE_MIDDLE,					///< 中分
		HAIR_FRINGE_LEFT,					///< 左斜
		HAIR_FRINGE_RIGHT,					///< 右斜
		HAIR_FRINGE_AIR						///< 空气刘海
	} fringe;									///< 刘海类型
	enum hair_girl_buckle_t{
		HAIR_BUCKLE_STAIGHT = 0,			///< 直发
		HAIR_BUCKLE_CIRLY,					///< 卷发
	} buckle;									///< 头发类型
	enum hair_girl_length_t{
		HAIR_LENGTH_NONE = 0,				///< 无头发
		HAIR_LENGTH_SHORT,					///< 短头发
		HAIR_LENGTH_MEDIUM_SHORT,			///< 中短发
		HAIR_LENGTH_MEDIUM_LONG,			///< 中长发
		HAIR_LENGTH_LONG,					///< 长头发
	} length;									///< 头发长度
	enum hair_girl_shape_t {
		HAIR_SHAPE_WEAR_DOWN = 0,			///< 披发
		HAIR_SHAPE_SINGLE_HORSETAIL,		///< 单马尾
		HAIR_SHAPE_DOUBLE_HORSETAIL,		///< 双马尾
		HAIR_SHAPE_SINGLE_BALL,				///< 单丸子
		HAIR_SHAPE_DOUBLE_BALL,				///< 双丸子
		HAIR_SHAPE_SINGLE_TWIST_BRAID,		///< 单麻花辫
		HAIR_SHAPE_DOUBLE_TWIST_BRAID,		///< 双麻花辫
		HAIR_SHAPE_UP_DO                    ///< 盘发
	} shape;									///< 头发形状
} st_mobile_attr_face_hair_girl_info_t;							///< 女生发型属性

/// @brief 男生头发属性
typedef struct st_mobile_attr_face_hair_boy_info{
	enum hair_boy_type_t{
		HAIR_TYPE_NONE = 0,					///< 秃顶
		HAIR_TYPE_1,						///< 板寸或圆寸
		HAIR_TYPE_2,						///< 毛寸
		HAIR_TYPE_3,						///< 背头
		HAIR_TYPE_4,						///< 向上头
		HAIR_TYPE_5,						///< 爆炸头
		HAIR_TYPE_6,						///< 左七分头
		HAIR_TYPE_7,						///< 右七分头
		HAIR_TYPE_8,						///< 齐刘海
		HAIR_TYPE_9,						///< 左斜刘海
		HAIR_TYPE_10,						///< 右斜刘海
		HAIR_TYPE_11,						///< 中分刘海
		HAIR_TYPE_12,						///< 中分头
	} type;									///< 头发长度
} st_mobile_attr_face_hair_boy_info_t;							///< 男生发型属性

/// @brief 属性
typedef struct st_mobile_attr_face_mustache_info{
	enum mustache_middle_t{
		MUSTACHE_MIDDLE_NONE = 0,		///< 无
		MUSTACHE_MIDDLE_DISCONTINUE,	///< 有，不连续
		MUSTACHE_MIDDLE_THIN,			///< 有，不浓密
		MUSTACHE_MIDDLE_THICK,			///< 有，浓密
	} mustache_middle;							///< 人中处胡子
	enum mustache_bottom_t{
		MUSTACHE_BOTTOM_NONE = 0,		///< 无
		MUSTACHE_BOTTOM_MOUTH,			///< 有，嘴下边也有
		MUSTACHE_BOTTOM_BOTTOM,			///< 有，都在底下
		MUSTACHE_BOTTOM_MOUNTAIN		///< 有，山字形
	} mustache_bottom;							///< 下巴中心
	enum mustache_bottom_side_t{
		MUSTACHE_SIDE_NONE = 0,			///< 无
		MUSTACHE_SIDE_THIN,				///< 有，比较稀疏
		MUSTACHE_SIDE_THICK,			///< 有，比较浓密
	} mustache_bottom_side;						///< 下巴两侧
} st_mobile_attr_face_mustache_info_t;						///< 胡子属性

/// @brief 眼皮属性
typedef struct st_mobile_attr_face_eyelid_info{
	enum eyelid_type_t{
		EYELID_TYPE_SINGLE = 0,				///< 单眼皮
		EYELID_TYPE_FANSHAPED_DOUBLE,		///< 扇形双眼皮
		EYELID_TYPE_PARALLEL_DOUBLE,		///< 平行双眼皮
		EYELID_TYPE_EURO_DOUBLE,			///< 欧式双眼皮
	} eyelid_type;										///< 双眼皮属性
} st_mobile_attr_face_eyelid_info_t;						///< 眼皮属性

/// @brief 性别属性
typedef enum st_mobile_attr_gender{
	GENDER_NONE = 0,				///< 无
	GENDER_MALE,						///< 男
	GENDER_FEMALE					///< 女
} st_mobile_attr_gender_t;						///< 眼皮属性

/// @brief attribute face feature检测结果
typedef struct st_mobile_attr_face{
	union st_mobile_attr_face_hair_info_t
	{
		st_mobile_attr_face_hair_girl_info_t girl;			///< 人脸属性之女生发型
		st_mobile_attr_face_hair_boy_info_t boy;			///< 人脸属性之男生发型
	}hair;

	st_mobile_attr_face_glass_info_t glass;				///< 人脸属性之眼镜
	st_mobile_attr_face_eyelid_info_t eyelid;				///< 人脸属性之眉毛
	st_mobile_attr_face_mustache_info_t mustache;			///< 人脸属性之胡子
} st_mobile_attr_face_t;


/// @brief 人脸属性检测结果
/// @param[in] handle 已初始化的人体行为句柄
/// @param[in] p_faces 已经检测到的人脸数组指针
/// @param[in] p_genders 输入对应p_faces的性别属性数组指针，个数与face_count一致。影响发型检测结果，其他检测无影响。可以为NULL，默认为GENDER_NONE。
/// @param[in] face_count 已经检测到的人脸数目
/// @param[in] image 用于检测的图像数据
/// @param[in] pixel_format 用于检测的图像数据的像素格式. 检测人脸建议使用NV12、NV21、YUV420P(转灰度图较快),检测手势和前后背景建议使用BGR、BGRA、RGB、RGBA
/// @param[in] image_width 用于检测的图像的宽度(以像素为单位)
/// @param[in] image_height 用于检测的图像的高度(以像素为单位)
/// @param[in] image_stride 用于检测的图像的跨度(以像素为单位),即每行的字节数；目前仅支持字节对齐的padding,不支持roi
/// @param[in] orientation 图像中人脸的方向
/// @param[in] face_feature_config 需要打开的人脸属性检测选项,例如ST_ATTR_FF_DETECT_HAIRSTYLE | ST_ATTR_FF_DETECT_GLASS
/// @param[out] p_face_feature 检测到的face feature结果数组起始地址的指针，由底层分配和释放。
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_attr_face_detect(
st_handle_t handle,
st_mobile_face_t *p_faces,
st_mobile_attr_gender_t *p_genders,
int face_count,
const unsigned char *image,
st_pixel_format pixel_format,
int image_width,
int image_height,
int image_stride,
st_rotate_type orientation,
unsigned long long face_feature_config,
st_mobile_attr_face_t **p_face_features
);


/// @brief 创建人脸属性检测句柄.
/// @param[in] model_path 模型文件的路径,例如models/action.model.
/// @parma[out] handle 人脸属性检测句柄,失败返回NULL
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_attr_face_create(
const char *model_path,
st_handle_t *handle
);


/// @brief 创建人脸属性检测句柄.
/// @param[in] buffer 模型缓存起始地址,为NULL时需要调用st_mobile_attribute_face_feature_create_with_sub_models添加需要的模型
/// @param[in] buffer_size 模型缓存大小
/// @parma[out] handle 人脸属性检测句柄,失败返回NULL
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_attr_face_create_from_buffer(
const unsigned char* buffer,
unsigned int buffer_size,
st_handle_t *handle
);


/// @brief 通过子模型创建人脸属性检测句柄, st_mobile_attribute_face_feature_create和st_mobile_attribute_face_feature_create_with_sub_models只能调一个
/// @param[in] model_path_arr 模型文件路径指针数组. 根据加载的子模型确定支持检测的类型. 如果包含相同的子模型, 后面的会覆盖前面的.
/// @param[in] model_count 模型文件数目
/// @parma[out] handle 人脸属性检测,失败返回NULL
/// @return 成功返回ST_OK,失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t
st_mobile_attr_face_create_with_sub_models(
const char **model_path_arr,
int model_count,
st_handle_t *handle
);

/// @brief 添加子模型.
/// @parma[in] handle 人脸属性检测句柄
/// @param[in] buffer 模型缓存起始地址
/// @param[in] buffer_size 模型缓存大小
ST_SDK_API st_result_t
st_mobile_attr_face_add_sub_model_from_buffer(
st_handle_t handle,
const unsigned char* buffer,
unsigned int buffer_size
);

/// @brief 添加子模型.
/// @parma[in] handle 人脸属性检测句柄
/// @param[in] model_path 模型文件的路径. 后添加的会覆盖之前添加的同类子模型。加载模型耗时较长, 建议在初始化创建句柄时就加载模型
ST_SDK_API st_result_t
st_mobile_attr_face_add_sub_model(
st_handle_t handle,
const char *model_path
);

/// @brief 删除子模型.
/// @parma[in] handle 人脸属性检测句柄
/// @return 成功返回ST_OK， 失败返回其他错误码
ST_SDK_API
st_result_t st_mobile_attr_face_remove_model_by_config(
st_handle_t handle,
unsigned int config
);

/// @brief 释放人脸属性检测句柄
/// @param[in] handle 已初始化的人脸属性句柄
ST_SDK_API
void st_mobile_attr_face_destroy(
st_handle_t handle
);
#endif
