//
// Created by mac on 2021/7/5.
//

#ifndef SENSEMEEFFECTS_UTILS_AVATAR_H
#define SENSEMEEFFECTS_UTILS_AVATAR_H

#include <sys/time.h>
#include <time.h>
#include <jni.h>
#include <stdio.h>
#include <stdlib.h>
#include <android/log.h>
#include <string.h>
#include "utils.h"
#include <st_mobile_attribute_face_feature.h>
#include <st_mobile_gen_avatar.h>

jobject convert2FaceFeature(JNIEnv *env, const st_mobile_attr_face *face_feature, bool isMale);
jobject convert2EyelidInfo(JNIEnv *env, const st_mobile_attr_face_eyelid_info *eyelid_info);
jobject convert2GlassInfo(JNIEnv *env, const st_mobile_attr_face_glass_info *glass_info);
jobject convert2BoyHairInfo(JNIEnv *env, const st_mobile_attr_face_hair_boy_info *hair_info);
jobject convert2GirlHairInfo(JNIEnv *env, const st_mobile_attr_face_hair_girl_info *hair_info);
jobject convert2MustacheInfo(JNIEnv *env, const st_mobile_attr_face_mustache_info *mustache_info);

bool convert2Controller(JNIEnv *env, jobject controllerObject, st_bone_controller_info_t *controller);
bool convert2st_animation_target(JNIEnv *env, jobject animationTargetObject, st_animation_target *animation_target);
jobject convert2STBoneTransform(JNIEnv *env, const st_mobile_bone_transform_t *transform);


#endif //SENSEMEEFFECTS_UTILS_AVATAR_H
