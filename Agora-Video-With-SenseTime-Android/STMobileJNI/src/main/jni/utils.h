#ifndef _ST_UTILS_H__
#define _ST_UTILS_H__

#include <sys/time.h>
#include <time.h>
#include <jni.h>
#include "st_mobile_face_attribute.h"

#include <stdio.h>
#include <stdlib.h>
#include <android/log.h>
#include <string.h>
#include <st_mobile_human_action.h>
//#include <st_mobile_attribute_face_feature.h>
//#include <st_mobile_gen_avatar.h>
#include <st_mobile_animal.h>

#define LOGGABLE 0

#define LOGI(...) if(LOGGABLE) __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

#ifndef MIN
#define MIN(x,y) ((x)<(y)?(x):(y))
#endif

#ifndef safe_delete
#define safe_delete(x)  { if (x) { delete (x); (x) = NULL; } }
#endif

#ifndef safe_delete_array
#define safe_delete_array(x)  { if (x) { delete[] (x); (x) = NULL; } }
#endif

#define ST_JNI_ERROR_DEFAULT                -1000  ///< JNI定义的参数默认值

#define ST_JNI_ERROR_INVALIDARG             -1001  ///< 输入参数为null或无效
#define ST_JNI_ERROR_FILE_OPEN_FIALED       -1002  ///< 打开文件失败
#define ST_JNI_ERROR_FILE_SIZE              -1003  ///< 文件大小错误
#define ST_JNI_ERROR_ACTIVE_CODE            -1004  ///< 激活码错误

static inline jfieldID getHandleField(JNIEnv *env, jobject obj)
{
    jclass c = env->GetObjectClass(obj);
    // J is the type signature for long:
    return env->GetFieldID(c, "nativeHandle", "J");
}

template <typename T>
T *getHandle(JNIEnv *env, jobject obj)
{
    jlong handle = env->GetLongField(obj, getHandleField(env, obj));
    return reinterpret_cast<T *>(handle);
}

template <typename T>
void setHandle(JNIEnv *env, jobject obj, T *t)
{
    jlong handle = reinterpret_cast<jlong>(t);
    env->SetLongField(obj, getHandleField(env, obj), handle);
}

long getCurrentTime();
int getImageStride(const st_pixel_format &pixel_format, const int &outputWidth);
// convert c object to java object
jobject convert2STRect(JNIEnv *env, const st_rect_t &object_rect);
jobject convert2HumanActionSegments(JNIEnv *env, const st_mobile_human_action_segments_t *human_action_segments);
jobject convert2HumanAction(JNIEnv *env, const st_mobile_human_action_t *human_action);
void convert2HumanAction(JNIEnv *env, const st_mobile_human_action_t *human_action, jobject humanActionObj);
jobject convert2MobileFace106(JNIEnv *env, const st_mobile_106_t &mobile_106);
jobject convert2FaceAttribute(JNIEnv *env, const st_mobile_attributes_t *faceAttribute);
jobject convert2Image(JNIEnv *env, const st_image_t *image);
jobject convert2Segment(JNIEnv *env, const st_mobile_segment_t *segment);
jobject convert2HandInfo(JNIEnv *env, const st_mobile_hand_t *hand_info);
jobject convert2FaceInfo(JNIEnv *env, const st_mobile_face_t *face_info);
jobject convert2FootInfo(JNIEnv *env, const st_mobile_hand_t *foot_info);
jobject convert2BodyInfo(JNIEnv *env, const st_mobile_body_t *body_info);
//jobject convert2ModuleInfo(JNIEnv *env, const st_module_info *module_info);
jobject convert2AnimalFace(JNIEnv *env, const st_mobile_animal_face_t *animal_face);
jobject convert2FaceExtraInfo(JNIEnv *env, const st_mobile_face_extra_info &face_extra_info);
//jobject convert2MouthParse(JNIEnv *env, const st_mobile_mouth_parse_t *mouth_parse);

// convert java object to c object
bool convert2st_rect_t(JNIEnv *env, jobject rectObject, st_rect_t &rect);
bool convert2HumanActionSegments(JNIEnv *env, jobject humanActionSegmentObject, st_mobile_human_action_segments_t *human_action_segments);
bool convert2HumanAction(JNIEnv *env, jobject humanActionObject, st_mobile_human_action_t *human_action);
bool convert2mobile_106(JNIEnv *env, jobject face106, st_mobile_106_t &mobile_106);
bool convert2Image(JNIEnv *env, jobject image, st_image_t *background);
bool convert2Segment(JNIEnv *env, jobject segmentObj, st_mobile_segment_t *segment);
bool convert2HandInfo(JNIEnv *env, jobject handInfoObject, st_mobile_hand_t *hand_info);
bool convert2FaceInfo(JNIEnv *env, jobject faceInfoObject, st_mobile_face_t *face_info);
bool convert2BodyInfo(JNIEnv *env, jobject bodyInfoObject, st_mobile_body_t *body_info);

//bool convert2Condition(JNIEnv *env, jobject conditionObject, st_condition &condition);
//bool convert2TransParam(JNIEnv *env, jobject paramObject, st_trans_param &param);
//bool convert2TriggerEvent(JNIEnv *env, jobject triggerEventObject, st_trigger_event &trigger_event);
//bool convert2StickerInputParams(JNIEnv *env, jobject eventObject, st_mobile_input_params &input_params);
bool convert2AnimalFace(JNIEnv *env, jobject animalFace, st_mobile_animal_face_t *animal_face);
bool convert2FaceExtraInfo(JNIEnv *env, jobject faceExtraInfoObject, st_mobile_face_extra_info *face_extra_info);

//for release human_action
void releaseHumanAction(st_mobile_human_action_t *human_action);
void releaseAnimal(st_mobile_animal_face_t *animal_face, int faceCount);
//void releaseEffectRenderInputParams(st_effect_render_in_param_t *param);
//void releaseEffectRenderOutputParams(st_effect_render_out_param_t *param);

void DeleteObject(st_mobile_face_t*& p_faces, int& face_count);
void DeleteObject(st_mobile_hand_t*& p_hands, int& hand_count);
void DeleteObject(st_mobile_body_t*& p_bodys, int& body_count);
void releaseSegment(st_mobile_segment_t*& p_dst, int count);
void DeleteImage(st_image_t*& image);


//jobject convert2EffectTexture(JNIEnv *env, const st_effect_texture_t *effect_texture);
//bool convert2st_effect_texture(JNIEnv *env, jobject effectTextureObject, st_effect_texture_t *effect_texture);
jobject convert2Quaternion(JNIEnv *env, const st_quaternion_t &quaternion);
bool convert2st_quaternion(JNIEnv *env, jobject quaternionObject, st_quaternion_t *quaternion);
//bool convert2st_effect_custom_param(JNIEnv *env, jobject eventObject, st_effect_custom_param_t *input_params);
//bool convert2st_effect_render_in_param(JNIEnv *env, jobject inputObject, st_effect_render_in_param_t *render_in_param);
//bool convert2st_effect_render_out_param(JNIEnv *env, jobject outputObject, st_effect_render_out_param_t *render_out_param);
//jobject convert2STEffectRenderOutParam(JNIEnv *env, const st_effect_render_out_param_t *render_out_param);
//jobject convert2EffectPackageInfo(JNIEnv *env, const st_effect_package_info_t *package_info);
//jobject convert2EffectModuleInfo(JNIEnv *env, const st_effect_module_info_t *module_info);
//jobject convert2EffectBeautyInfo(JNIEnv *env, const st_effect_beauty_info_t *beauty_info);


//jobject convert2ClassifierResult(JNIEnv *env, const st_classifier_result_t *classifier_result);
jobject convert2FaceMeshList(JNIEnv *env, const st_mobile_face_mesh_list_t *faceMeshList);
bool convert2FaceMeshList(JNIEnv *env, jobject inputObject, st_mobile_face_mesh_list_t *face_mesh_list);
jobject convert2FaceMesh(JNIEnv *env, const st_mobile_face_mesh_t *faceMesh);
jobject convert2HeadInfo(JNIEnv *env, const st_mobile_head_t *head_info);
jobject convert2HeadResultInfo(JNIEnv *env, const st_mobile_head_result_t *head_result);
bool convert2FaceMesh(JNIEnv *env, jobject faceMeshObj, st_mobile_face_mesh_t *face_mesh);
bool convert2EarInfo(JNIEnv *env, jobject earInfoObject, st_mobile_ear_t *ear_info);
bool convert2ForeheadInfo(JNIEnv *env, jobject foreheadInfoObject, st_mobile_forehead_t *forehead_info);
jobject convert2EarInfo(JNIEnv *env, const st_mobile_ear_t *ear_info);
jobject convert2ForeheadInfo(JNIEnv *env, const st_mobile_forehead_t *forehead_info);


bool convert2YuvImage(JNIEnv *env, jobject yuvImageObj, st_multiplane_image_t *yuv_image);
void releaseImagePlane(JNIEnv *env, jobject imageObj, st_multiplane_image_t *yuv_image);


jobject convert2Color(JNIEnv *env, const st_color_t *color);
jobject convert2Quaternion(JNIEnv *env, const st_quaternion_t *quaternion);
//jobject convert2BodyAvatar(JNIEnv *env, const st_mobile_body_avatar_t *body_avatar);
//jobject convert2FaceFeature(JNIEnv *env, const st_mobile_attr_face *face_feature, bool isMale);
//jobject convert2EyelidInfo(JNIEnv *env, const st_mobile_attr_face_eyelid_info *eyelid_info);
//jobject convert2GlassInfo(JNIEnv *env, const st_mobile_attr_face_glass_info *glass_info);
//jobject convert2BoyHairInfo(JNIEnv *env, const st_mobile_attr_face_hair_boy_info *hair_info);
//jobject convert2GirlHairInfo(JNIEnv *env, const st_mobile_attr_face_hair_girl_info *hair_info);
//jobject convert2MustacheInfo(JNIEnv *env, const st_mobile_attr_face_mustache_info *mustache_info);

bool convert2Color(JNIEnv *env, jobject colorObject, st_color_t *color);
bool convert2Quaternion(JNIEnv *env, jobject quaternionObject, st_quaternion_t *quaternion);
//bool convert2BodyAvatar(JNIEnv *env, jobject bodyAvatarObject, st_mobile_body_avatar_t *body_avatar);
//bool convert2Controller(JNIEnv *env, jobject controllerObject, st_bone_controller_info_t *controller);
//bool convert2st_animation_target(JNIEnv *env, jobject animationTargetObject, st_animation_target *animation_target);

jobject convert2STTransform(JNIEnv *env, const st_mobile_transform_t *transform);
//jobject convert2STBoneTransform(JNIEnv *env, const st_mobile_bone_transform_t *transform);


#endif // _ST_UTILS_H__