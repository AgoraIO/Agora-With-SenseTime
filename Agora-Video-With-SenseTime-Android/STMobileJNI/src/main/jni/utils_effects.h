//
// Created by mac on 2021/7/5.
//

#ifndef SENSEMEEFFECTS_UTILS_EFFECTS_H
#define SENSEMEEFFECTS_UTILS_EFFECTS_H

#include <sys/time.h>
#include <time.h>
#include <jni.h>
#include <stdio.h>
#include <stdlib.h>
#include <android/log.h>
#include <string.h>
#include "utils.h"
#include "st_mobile_effect.h"

bool convert2InImage(JNIEnv *env, jobject image, st_effect_in_image_t *background);
bool convert2TryOn(JNIEnv *env, jobject inputObject, st_effect_tryon_info_t *tryonInfo);
bool convert2TryonRegionInfo(JNIEnv *env, jobject inputObj, st_effect_tryon_region_info_t * region_info);
jobject convert2TryonRegionInfo(JNIEnv *env, const st_effect_tryon_region_info_t *region_info);
jobject convert2TryOn(JNIEnv *env, st_effect_tryon_info_t *tryonInfo);

void releaseEffectRenderInputParams(st_effect_render_in_param_t *param);
void releaseEffectRenderOutputParams(st_effect_render_out_param_t *param);

jobject convert2EffectTexture(JNIEnv *env, const st_effect_texture_t *effect_texture);
bool convert2st_effect_texture(JNIEnv *env, jobject effectTextureObject, st_effect_texture_t *effect_texture);

bool convert2st_effect_custom_param(JNIEnv *env, jobject eventObject, st_effect_custom_param_t *input_params);
bool convert2st_effect_render_in_param(JNIEnv *env, jobject inputObject, st_effect_render_in_param_t *render_in_param);
bool convert2st_effect_render_out_param(JNIEnv *env, jobject outputObject, st_effect_render_out_param_t *render_out_param);
void convert2STEffectRenderOutParam(JNIEnv *env, const st_effect_render_out_param_t *render_out_param, jobject outParamObject);
jobject convert2EffectPackageInfo(JNIEnv *env, const st_effect_package_info_t *package_info);
jobject convert2EffectModuleInfo(JNIEnv *env, const st_effect_module_info_t *module_info);
jobject convert2EffectBeautyInfo(JNIEnv *env, const st_effect_beauty_info_t *beauty_info);
jobject convert2Effect3DBeautyPartInfo(JNIEnv *env, st_effect_3D_beauty_part_info_t *part_info);
bool convert2Effect3DBeautyPartInfo(JNIEnv *env, jobject inputObject, st_effect_3D_beauty_part_info_t *part_info);

#endif //SENSEMEEFFECTS_UTILS_EFFECTS_H
