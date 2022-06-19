//
// Created by mac on 2021/7/5.
//
#include "utils_avatar.h"

#define  LOG_TAG    "utils_avatar"

jobject convert2FaceFeature(JNIEnv *env, const st_mobile_attr_face *face_feature, bool isMale){
    jclass face_feature_cls = env->FindClass("com/sensetime/stmobile/model/STAttributeFaceFeature");
    jfieldID fieldEyelidInfo = env->GetFieldID(face_feature_cls, "eyelidInfo", "Lcom/sensetime/stmobile/model/STAttributeEyelidInfo;");
    jfieldID fieldGlassInfo = env->GetFieldID(face_feature_cls, "glassInfo", "Lcom/sensetime/stmobile/model/STAttributeGlassInfo;");
    jfieldID fieldBoyHairInfo = env->GetFieldID(face_feature_cls, "hairBoyInfo", "Lcom/sensetime/stmobile/model/STAttributeBoyHairInfo;");
    jfieldID fieldGirlHairInfo = env->GetFieldID(face_feature_cls, "hairGirlInfo", "Lcom/sensetime/stmobile/model/STAttributeGirlHairInfo;");
    jfieldID fieldIdMustacheInfo = env->GetFieldID(face_feature_cls, "mustacheInfo", "Lcom/sensetime/stmobile/model/STAttributeMustacheInfo;");
    jfieldID fieldBoyEyebrowInfo = env->GetFieldID(face_feature_cls, "eyebrowBoyInfo", "Lcom/sensetime/stmobile/model/STAttributeBoyEyebrowInfo;");
    jfieldID fieldGirlEyebrowInfo = env->GetFieldID(face_feature_cls, "eyebrowGirlInfo", "Lcom/sensetime/stmobile/model/STAttributeGirlEyebrowInfo;");

    jobject faceFeatureObject = env->AllocObject(face_feature_cls);

    env->SetObjectField(faceFeatureObject, fieldEyelidInfo, convert2EyelidInfo(env, &face_feature->eyelid));
    env->SetObjectField(faceFeatureObject, fieldGlassInfo, convert2GlassInfo(env, &face_feature->glass));
    if(isMale){
        env->SetObjectField(faceFeatureObject, fieldBoyHairInfo, convert2BoyHairInfo(env, &face_feature->hair.boy));
//        env->SetObjectField(faceFeatureObject, fieldBoyEyebrowInfo, convert2BoyEyebrowInfo(env, &face_feature->eyebrow.boy));
    }else{
        env->SetObjectField(faceFeatureObject, fieldGirlHairInfo, convert2GirlHairInfo(env, &face_feature->hair.girl));
//        env->SetObjectField(faceFeatureObject, fieldGirlEyebrowInfo, convert2GirlEyebrowInfo(env, &face_feature->eyebrow.girl));
    }
    env->SetObjectField(faceFeatureObject, fieldIdMustacheInfo, convert2MustacheInfo(env, &face_feature->mustache));

    env->DeleteLocalRef(face_feature_cls);
    return faceFeatureObject;
}

jobject convert2EyelidInfo(JNIEnv *env, const st_mobile_attr_face_eyelid_info *eyelid_info){
    jclass eyelid_info_cls = env->FindClass("com/sensetime/stmobile/model/STAttributeEyelidInfo");
    jfieldID fieldEyelidType = env->GetFieldID(eyelid_info_cls, "type", "I");
    jobject eyelidInfoObject = env->AllocObject(eyelid_info_cls);
    env->SetIntField(eyelidInfoObject, fieldEyelidType, eyelid_info->eyelid_type);
    env->DeleteLocalRef(eyelid_info_cls);
    return eyelidInfoObject;
}
jobject convert2GlassInfo(JNIEnv *env, const st_mobile_attr_face_glass_info *glass_info){
    jclass glass_info_cls = env->FindClass("com/sensetime/stmobile/model/STAttributeGlassInfo");
    jfieldID fieldGlassType = env->GetFieldID(glass_info_cls, "type", "I");
    jfieldID fieldGlassFrame = env->GetFieldID(glass_info_cls, "frame", "I");
    jfieldID fieldGlassShape = env->GetFieldID(glass_info_cls, "shape", "I");
    jfieldID fieldGlassThickness = env->GetFieldID(glass_info_cls, "thickness", "I");
    jobject glassInfoObject = env->AllocObject(glass_info_cls);

    env->SetIntField(glassInfoObject, fieldGlassType, glass_info->glass_type);
    env->SetIntField(glassInfoObject, fieldGlassFrame, glass_info->glass_frame);
    env->SetIntField(glassInfoObject, fieldGlassShape, glass_info->glass_shape);
    env->SetIntField(glassInfoObject, fieldGlassThickness, glass_info->glass_thickness);

    env->DeleteLocalRef(glass_info_cls);
    return glassInfoObject;
}
jobject convert2BoyHairInfo(JNIEnv *env, const st_mobile_attr_face_hair_boy_info *hair_info){
    jclass hair_info_cls = env->FindClass("com/sensetime/stmobile/model/STAttributeBoyHairInfo");
    jfieldID fieldHairFringe = env->GetFieldID(hair_info_cls, "type", "I");
    jobject hairInfoObject = env->AllocObject(hair_info_cls);

    env->SetIntField(hairInfoObject, fieldHairFringe, hair_info->type);

    env->DeleteLocalRef(hair_info_cls);
    return hairInfoObject;
}

jobject convert2GirlHairInfo(JNIEnv *env, const st_mobile_attr_face_hair_girl_info *hair_info){
    jclass hair_info_cls = env->FindClass("com/sensetime/stmobile/model/STAttributeGirlHairInfo");
    jfieldID fieldHairFringe = env->GetFieldID(hair_info_cls, "fringe", "I");
    jfieldID fieldHairBuckle = env->GetFieldID(hair_info_cls, "buckle", "I");
    jfieldID fieldHairLength = env->GetFieldID(hair_info_cls, "length", "I");
    jfieldID fieldHairShape = env->GetFieldID(hair_info_cls, "shape", "I");

    jobject hairInfoObject = env->AllocObject(hair_info_cls);

    LOGE("jni girl hair info: fringe: %d, buckle: %d, length: %d, shape: %d", (int)hair_info->fringe,  (int)hair_info->buckle, (int)hair_info->length, (int)hair_info->shape);

    env->SetIntField(hairInfoObject, fieldHairFringe, hair_info->fringe);
    env->SetIntField(hairInfoObject, fieldHairBuckle, hair_info->buckle);
    env->SetIntField(hairInfoObject, fieldHairLength, hair_info->length);
    env->SetIntField(hairInfoObject, fieldHairShape, hair_info->shape);

    env->DeleteLocalRef(hair_info_cls);
    return hairInfoObject;
}

//jobject convert2BoyEyebrowInfo(JNIEnv *env, const st_mobile_attr_face_eyebrow_girl_info_t *eyebrow_info){
//    jclass eyebrow_info_cls = env->FindClass("com/sensetime/stmobile/model/STAttributeBoyEyebrowInfo");
//    jfieldID fieldEyebrowThickness = env->GetFieldID(eyebrow_info_cls, "thickness", "I");
//    jfieldID fieldEyebrowShape = env->GetFieldID(eyebrow_info_cls, "shape", "I");
//
//    jobject eyebrowInfoObject = env->AllocObject(eyebrow_info_cls);
//
//    env->SetIntField(eyebrowInfoObject, fieldEyebrowThickness, eyebrow_info->thickness);
//    env->SetIntField(eyebrowInfoObject, fieldEyebrowShape, eyebrow_info->shape);
//
//    env->DeleteLocalRef(eyebrow_info_cls);
//    return eyebrowInfoObject;
//}
//
//jobject convert2GirlEyebrowInfo(JNIEnv *env, const st_mobile_attr_face_eyebrow_girl_info_t *eyebrow_info){
//    jclass eyebrow_info_cls = env->FindClass("com/sensetime/stmobile/model/STAttributeGirlEyebrowInfo");
//    jfieldID fieldEyebrowThickness = env->GetFieldID(eyebrow_info_cls, "thickness", "I");
//    jfieldID fieldEyebrowShape = env->GetFieldID(eyebrow_info_cls, "shape", "I");
//
//    jobject eyebrowInfoObject = env->AllocObject(eyebrow_info_cls);
//
//    env->SetIntField(eyebrowInfoObject, fieldEyebrowThickness, eyebrow_info->thickness);
//    env->SetIntField(eyebrowInfoObject, fieldEyebrowShape, eyebrow_info->shape);
//
//    env->DeleteLocalRef(eyebrow_info_cls);
//    return eyebrowInfoObject;
//}

jobject convert2MustacheInfo(JNIEnv *env, const st_mobile_attr_face_mustache_info *mustache_info){
    jclass mustache_info_cls = env->FindClass("com/sensetime/stmobile/model/STAttributeMustacheInfo");
    jfieldID fieldMustacheMiddle = env->GetFieldID(mustache_info_cls, "position_middle", "I");
    jfieldID fieldMustacheBottom = env->GetFieldID(mustache_info_cls, "position_bottom", "I");
    jfieldID fieldMustacheBottomSide = env->GetFieldID(mustache_info_cls, "position_bottom_side", "I");
    jobject mustacheInfoObject = env->AllocObject(mustache_info_cls);

    env->SetIntField(mustacheInfoObject, fieldMustacheMiddle, mustache_info->mustache_middle);
    env->SetIntField(mustacheInfoObject, fieldMustacheBottom, mustache_info->mustache_bottom);
    env->SetIntField(mustacheInfoObject, fieldMustacheBottomSide, mustache_info->mustache_bottom_side);

    env->DeleteLocalRef(mustache_info_cls);
    return mustacheInfoObject;
}

bool convert2Controller(JNIEnv *env, jobject controllerObject, st_bone_controller_info_t *controller){
    if (controllerObject == NULL) {
        return false;
    }

    jclass controller_cls = env->FindClass("com/sensetime/stmobile/model/STPCController");

    jfieldID fieldId = env->GetFieldID(controller_cls, "id", "I");
    jfieldID fieldValue = env->GetFieldID(controller_cls, "value", "F");

    controller->id = (st_avatar_controller_id_t)env->GetIntField(controllerObject, fieldId);
    controller->value = env->GetFloatField(controllerObject, fieldValue);

    env->DeleteLocalRef(controller_cls);
    return true;
}

bool convert2st_animation_target(JNIEnv *env, jobject animationTargetObject, st_animation_target *animation_target){
    if (animationTargetObject == NULL) {
        return false;
    }

    jclass animation_target_cls = env->FindClass("com/sensetime/stmobile/model/STAnimationTarget");

    jfieldID fieldClipId = env->GetFieldID(animation_target_cls, "animClipId", "I");
    jfieldID fieldLoopNum = env->GetFieldID(animation_target_cls, "loopNum", "I");
    jfieldID fieldSmoothSec = env->GetFieldID(animation_target_cls, "smoothSec", "F");

    animation_target->anim_clip_id = env->GetIntField(animationTargetObject, fieldClipId);
    animation_target->loop_num = env->GetIntField(animationTargetObject, fieldLoopNum);
    animation_target->smooth_sec = env->GetFloatField(animationTargetObject, fieldSmoothSec);

    env->DeleteLocalRef(animation_target_cls);
    return true;
}

jobject convert2STBoneTransform(JNIEnv *env, const st_mobile_bone_transform_t *transform){
    jclass transformClass = env->FindClass("com/sensetime/stmobile/model/STBoneTransform");

    if (transformClass == NULL) {
        return NULL;
    }

    jobject transformObject = env->AllocObject(transformClass);

    jfieldID fieldName = env->GetFieldID(transformClass, "bone_name", "[B");
    jfieldID fieldTransform= env->GetFieldID(transformClass, "transform", "Lcom/sensetime/stmobile/model/STTransform;");

    jbyteArray arrayName;
    jbyte* name = (jbyte*)(transform->bone_name);
    int len = strlen(transform->bone_name);
    arrayName = (env)->NewByteArray(len);

    if(name == NULL){
        return NULL;
    }
    env->SetByteArrayRegion(arrayName, 0, len, name);
    env->SetObjectField(transformObject, fieldName, arrayName);
    env->DeleteLocalRef(arrayName);

    jclass tranClass = env->FindClass("com/sensetime/stmobile/model/STTransform");
    jobject segment_object = env->AllocObject(tranClass);
    segment_object = convert2STTransform(env, &transform->transform);

    env->SetObjectField(transformObject, fieldTransform, segment_object);
    env->DeleteLocalRef(tranClass);

    env->DeleteLocalRef(transformClass);

    return transformObject;
}