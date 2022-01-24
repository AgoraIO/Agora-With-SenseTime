#ifndef INCLUDE_STMOBILE_ST_MOBILE_SLAM_H_
#define INCLUDE_STMOBILE_ST_MOBILE_SLAM_H_

#include "st_mobile_common.h"

#define MAX_FEATURE_CNT (2000)
// SLAM方向
typedef enum STSLAMOrientation
{
    ST_SLAM_Portrait,
    ST_SLAM_LandscapeRight,
    ST_SLAM_UpsideDown,
    ST_SLAM_LandscapeLeft
} STSLAMOrientation;
// SLAM状态
typedef enum STSLAMState
{
    ST_SLAM_INITIALIZING,       //正在检测
    ST_SLAM_TRACKING_SUCCESS,       //跟踪成功
    ST_SLAM_TRACKING_FAIL           //跟踪失败
} STSLAMState;
// IMU信息格式
typedef struct st_slam_imu {
    double acceleration[3];         //加速计
    double gyroscope[3];            //陀螺仪
    double timeStamp;               //时间戳
} st_slam_imu;
// attitude信息格式
typedef struct st_slam_attitude {
    double quaternion[4];           //四元数
    double gravity[3];              //重力计
    double timeStamp;               //时间戳
}st_slam_attitude;
// slam结果中的camera信息
typedef struct sl_slam_camera{
    float quaternion[4];            //四元数
    float center[3];                //中心点
    float rotation[3][3];           //旋转矩阵
    float translation[3];           //相机位移
    float depth;                    //深度
    st_rotate_type rotate;          //相机图像方向
} st_slam_camera;

typedef struct st_slam_corner {
    float x, y;
} st_slam_corner;

// 平面相关信息
typedef struct st_slam_plane {
    int plane_id;               // 平面ID
    bool is_update;
    int plane_f_index[2];
    int plane_v_index[2];
    float plane_normal[3];
    float plane_origin_point[3];
    float plane_x_axis[3];
}st_slam_plane;

// 标记点.
typedef struct st_slam_landmark {
    float x, y, z, w; // x, y, z为坐标, w为权重。
} st_slam_landmark;

// slam结果
typedef struct st_slam_result
{
    STSLAMState state;
    st_slam_camera camera;                      //相机信息
    st_slam_corner* features;   //特征点坐标
    float fovx;                                 //相机横向视角
    float bodyQuaternion[4];                    //机身姿态四元数
    int num_features;                           //特征点数量
    int track_confidence;                       //跟踪的置信度，阈值是0-100
    int track_state;

    int num_landmarks;
    st_slam_landmark* landmarks;
    int num_planes;
    st_slam_plane* planes;
    float* dense_mesh_v;
    int dense_mesh_v_size;
    int* dense_mesh_f;
    int dense_mesh_f_size;
    int* plane_v_index;
    int* plane_f_index;
} st_slam_result;

/// @brief 创建slam句柄
/// @parma[out] handle 句柄,失败返回NULL
/// @parma[in] width 被检测图片宽
/// @parma[in] height 被检测图片高
/// @parma[in] fovx 相机横向视角
/// @parma[in] orientation 被检测图像朝向
/// @parma[in] camera_type 手机是双摄相机还是单摄相机
/// @parma[in] useIMU 是否使用imu信息，android输入false, iOS可以选择true或false输入
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t st_mobile_slam_create(st_handle_t *handle, int width, int height, double fovx, STSLAMOrientation orientation, bool useIMU);

/// @brief 进行slam检测和跟踪
/// @parma[in] slam handle 句柄
/// @parma[in] imgData 被检测图片的数据
/// @parma[in] img_time_stamp 被检测图片的时间戳
/// @parma[in] imus 传感器数据结果数组
/// @parma[in] imu_count 传感器数据结果数组大小
/// @parma[in] attiude attitude结果
/// @parma[in] format 被检测图像数据格式
/// @parma[in] width 被检测图片宽
/// @parma[in] height 被检测图片高
/// @parma[in] stride 被检测图片stride
/// @parma[out] slam_output 检测得到的slam数据
/// @return 成功返回ST_OK, 失败返回其他错误码,错误码定义在st_mobile_common.h中,如ST_E_FAIL等
ST_SDK_API st_result_t st_mobile_slam_run(st_handle_t handle, st_image_t input_image, st_slam_imu* imus, int imu_count, st_slam_attitude attiude, st_slam_result* slam_output);

///// @brief 估计当前场景光照强度
///// @parma[in] slam handle 句柄
///// @parma[in] image_data 被检测摄像头图片的数据(需要是nv21）
///// @parma[in] image_width 被检测图片宽
///// @parma[in] image_height 被检测图片高
///// @parma[in] stride 被检测图片stride
///// @parma[in] exposure 相机曝光时间
///// @return 返回估计结果
//ST_SDK_API float st_mobile_slam_estimate_light_intensity(st_handle_t handle, st_image_t image, float exposure);
/// @brief 根据屏幕触摸点设置slam世界坐标系初始位置
/// @parma[in] slam handle 句柄
/// @parma[in] fX view中归一化的触摸点横向坐标
/// @param[in] fY view中归一化的触摸点纵向坐标
ST_SDK_API void st_mobile_slam_set_init_pos(st_handle_t handle, const float fX, const float fY);
/// @brief reset slam状态
/// @parma[in] slam handle 句柄
ST_SDK_API void st_mobile_slam_reset(st_handle_t handle);


/// @brief 销毁slam句柄
/// @parma[in] slam handle 句柄
ST_SDK_API void st_mobile_slam_destroy(st_handle_t handle);


#endif /* st_slam_h */
