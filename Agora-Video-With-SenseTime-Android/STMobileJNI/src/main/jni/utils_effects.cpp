//
// Created by mac on 2021/7/5.
//

#include "utils_effects.h"
#include "prebuilt/include/st_mobile_effect.h"
#include <st_mobile_common.h>
#include <st_mobile_human_action.h>
#include <st_mobile_effect.h>

#define  LOG_TAG    "utils_effects"

void releaseEffectRenderInputParams(st_effect_render_in_param_t *param){
    if(!param) return;
    releaseHumanAction(param->p_human);
    releaseAnimal(param->p_animal_face, param->animal_face_count);
    safe_delete(param->p_custom_param);
    if (param->p_image) {
        safe_delete_array(param->p_image->image.data);
    }
    safe_delete(param->p_image);
    safe_delete(param->p_tex);
    safe_delete(param);
}

void releaseEffectRenderOutputParams(st_effect_render_out_param_t *param){
    if(!param) return;
    releaseHumanAction(param->p_human);
    safe_delete(param->p_image);
    safe_delete(param->p_tex);
}

jobject convert2EffectTexture(JNIEnv *env, const st_effect_texture_t *effect_texture){
    jclass effect_texture_cls = env->FindClass("com/sensetime/stmobile/model/STEffectTexture");

    jfieldID fieldId = env->GetFieldID(effect_texture_cls, "id", "I");
    jfieldID fieldWidth = env->GetFieldID(effect_texture_cls, "width", "I");
    jfieldID fieldHeight = env->GetFieldID(effect_texture_cls, "height", "I");
    jfieldID fieldFormat = env->GetFieldID(effect_texture_cls, "format", "I");

    jobject effectTextureObj = env->AllocObject(effect_texture_cls);

    env->SetIntField(effectTextureObj, fieldId, effect_texture->id);
    env->SetIntField(effectTextureObj, fieldWidth, effect_texture->width);
    env->SetIntField(effectTextureObj, fieldHeight, effect_texture->height);
    env->SetIntField(effectTextureObj, fieldFormat, (int)effect_texture->format);

    env->DeleteLocalRef(effect_texture_cls);

    return effectTextureObj;
}

bool convert2st_effect_texture(JNIEnv *env, jobject effectTextureObject, st_effect_texture_t *effect_texture){
    if(effectTextureObject == NULL){
        return JNI_FALSE;
    }

    jclass effect_texture_cls = env->FindClass("com/sensetime/stmobile/model/STEffectTexture");

    jfieldID fieldId = env->GetFieldID(effect_texture_cls, "id", "I");
    jfieldID fieldWidth = env->GetFieldID(effect_texture_cls, "width", "I");
    jfieldID fieldHeight = env->GetFieldID(effect_texture_cls, "height", "I");
    jfieldID fieldFormat = env->GetFieldID(effect_texture_cls, "format", "I");

    effect_texture->id = env->GetIntField(effectTextureObject, fieldId);
    effect_texture->width = env->GetIntField(effectTextureObject, fieldWidth);
    effect_texture->height = env->GetIntField(effectTextureObject, fieldHeight);
    effect_texture->format = (st_pixel_format)env->GetIntField(effectTextureObject, fieldFormat);

    env->DeleteLocalRef(effect_texture_cls);

    return JNI_TRUE;
}

bool convert2st_effect_custom_param(JNIEnv *env, jobject eventObject, st_effect_custom_param_t *input_params){
    if(eventObject == NULL){
        return false;
    }
    jclass st_input_event_class = env->FindClass("com/sensetime/stmobile/model/STEffectCustomParam");
    jfieldID fieldQuaternion = env->GetFieldID(st_input_event_class, "cameraQuaternion", "Lcom/sensetime/stmobile/model/STQuaternion;");
    jfieldID fieldCameraId = env->GetFieldID(st_input_event_class, "isFrontCamera", "Z");

    jfieldID fieldEvent = env->GetFieldID(st_input_event_class, "event", "I");

    input_params->front_camera = env->GetBooleanField(eventObject, fieldCameraId);
    input_params->event = env->GetIntField(eventObject, fieldEvent);

    jobject quaternionObj = env->GetObjectField(eventObject, fieldQuaternion);
    if(!convert2st_quaternion(env, quaternionObj, &input_params->camera_quat)){
        return false;
    }

    env->DeleteLocalRef(st_input_event_class);

    return true;
}

bool convert2st_effect_render_in_param(JNIEnv *env, jobject inputObject, st_effect_render_in_param_t *render_in_param){
    if(inputObject == NULL){
        return false;
    }

    jclass render_in_param_class = env->FindClass("com/sensetime/stmobile/model/STEffectRenderInParam");
    jfieldID fieldNativeHumanAction = env->GetFieldID(render_in_param_class, "nativeHumanActionResult", "J");
    jfieldID fieldHumanAction = env->GetFieldID(render_in_param_class, "humanAction", "Lcom/sensetime/stmobile/model/STHumanAction;");
    jfieldID fieldCustomParam = env->GetFieldID(render_in_param_class, "customParam", "Lcom/sensetime/stmobile/model/STEffectCustomParam;");
    jfieldID fieldNeedMirror = env->GetFieldID(render_in_param_class, "needMirror", "Z");
    jfieldID fieldRotate = env->GetFieldID(render_in_param_class, "rotate", "I");
    jfieldID fieldFrontRotate = env->GetFieldID(render_in_param_class, "frontRotate", "I");
    jfieldID fieldImage = env->GetFieldID(render_in_param_class, "image", "Lcom/sensetime/stmobile/STEffectInImage;");
    jfieldID fieldTimeStamp = env->GetFieldID(render_in_param_class, "timeStamp", "D");
    jfieldID fieldTexture = env->GetFieldID(render_in_param_class, "texture", "Lcom/sensetime/stmobile/model/STEffectTexture;");
    jfieldID fieldAnimalCount = env->GetFieldID(render_in_param_class, "animalFaceCount", "I");
    jfieldID fieldAnimalFaces = env->GetFieldID(render_in_param_class, "animalFaces", "[Lcom/sensetime/stmobile/model/STAnimalFace;");

    render_in_param->need_mirror = env->GetBooleanField(inputObject, fieldNeedMirror);
    render_in_param->rotate = (st_rotate_type)env->GetIntField(inputObject, fieldRotate);
    render_in_param->front_rotate = (st_rotate_type)env->GetIntField(inputObject, fieldFrontRotate);
    render_in_param->time_stamp = env->GetDoubleField(inputObject, fieldTimeStamp);

    jobject humanActionObj = env->GetObjectField(inputObject, fieldHumanAction);
    if(humanActionObj != NULL){
        render_in_param->p_human = new st_mobile_human_action_t;
        memset(render_in_param->p_human, 0, sizeof(st_mobile_human_action_t));
        convert2HumanAction(env, humanActionObj, render_in_param->p_human);
    } else {
        jlong native_human_action_result = env->GetLongField(inputObject, fieldNativeHumanAction);

        if(native_human_action_result != 0){
            st_mobile_human_action_t *human_action = new st_mobile_human_action_t;
            memset(human_action, 0, sizeof(st_mobile_human_action_t));
            st_mobile_human_action_copy(reinterpret_cast<st_mobile_human_action_t *>(native_human_action_result), human_action);
            render_in_param->p_human = human_action;

            if(render_in_param->p_human != nullptr && render_in_param->p_human->p_segments != nullptr){
                for (int i = 0; i < render_in_param->p_human->p_segments->mouth_parse_count; ++i) {
                    if(render_in_param->p_human->p_segments->p_mouth_parse[i].p_segment != nullptr){
                        render_in_param->p_human->p_segments->p_mouth_parse[i].p_segment->time_stamp = 1.0f;
                    }
                }
                if(render_in_param->p_human->p_segments->p_figure != nullptr && render_in_param->p_human->p_segments->p_figure->p_segment){
                    render_in_param->p_human->p_segments->p_figure->p_segment->time_stamp = 1.0f;
                }

                if(render_in_param->p_human->p_segments->p_hair != nullptr && render_in_param->p_human->p_segments->p_hair->p_segment){
                    render_in_param->p_human->p_segments->p_hair->p_segment->time_stamp = 1.0f;
                }

                if(render_in_param->p_human->p_segments->p_multi != nullptr && render_in_param->p_human->p_segments->p_multi->p_segment){
                    render_in_param->p_human->p_segments->p_multi->p_segment->time_stamp = 1.0f;
                }

                if(render_in_param->p_human->p_segments->p_head != nullptr && render_in_param->p_human->p_segments->p_head->p_segment){
                    render_in_param->p_human->p_segments->p_head->p_segment->time_stamp = 1.0f;
                }

                if(render_in_param->p_human->p_segments->p_skin != nullptr && render_in_param->p_human->p_segments->p_skin->p_segment){
                    render_in_param->p_human->p_segments->p_skin->p_segment->time_stamp = 1.0f;
                }

                if(render_in_param->p_human->p_segments->p_sky != nullptr && render_in_param->p_human->p_segments->p_sky->p_segment){
                    render_in_param->p_human->p_segments->p_sky->p_segment->time_stamp = 1.0f;
                }

                if(render_in_param->p_human->p_segments->p_face_occlusion != nullptr && render_in_param->p_human->p_segments->p_face_occlusion->p_segment){
                    render_in_param->p_human->p_segments->p_face_occlusion->p_segment->time_stamp = 1.0f;
                }
            }
        } else{
            //LOGE("sensetime jni error: input human_action is null");
            render_in_param->p_human = NULL;
        }
    }
    env->DeleteLocalRef(humanActionObj);

    jobject customParamObj = env->GetObjectField(inputObject, fieldCustomParam);
    if(customParamObj != NULL){
        render_in_param->p_custom_param = new st_effect_custom_param_t ;
        memset(render_in_param->p_custom_param, 0, sizeof(st_effect_custom_param_t));
        convert2st_effect_custom_param(env, customParamObj, render_in_param->p_custom_param);
    } else{
//        LOGE("sensetime jni error: input custom_param is null");
        render_in_param->p_custom_param = NULL;
    }
    env->DeleteLocalRef(customParamObj);

    jobject imageObj = env->GetObjectField(inputObject, fieldImage);
    if(imageObj != NULL){
        render_in_param->p_image = new st_effect_in_image_t ;
        memset(render_in_param->p_image, 0, sizeof(st_image_t));

        convert2InImage(env, imageObj, render_in_param->p_image);
    } else{
//        LOGE("sensetime jni error: input image is null");
        render_in_param->p_image = NULL;
    }
    env->DeleteLocalRef(imageObj);

    jobject textureObj = env->GetObjectField(inputObject, fieldTexture);
    if(textureObj != NULL){
        render_in_param->p_tex = new st_effect_texture_t ;
        memset(render_in_param->p_tex, 0, sizeof(st_effect_texture_t));

        convert2st_effect_texture(env, textureObj, render_in_param->p_tex);
    } else{
        LOGE("sensetime jni error: input texture is null");
        render_in_param->p_tex = NULL;
    }
    env->DeleteLocalRef(textureObj);

    //animal faces
    render_in_param->animal_face_count = env->GetIntField(inputObject, fieldAnimalCount);

    if(render_in_param->animal_face_count > 0){
        jobjectArray faces_obj_array = (jobjectArray)env->GetObjectField(inputObject, fieldAnimalFaces);

        render_in_param->p_animal_face = new st_mobile_animal_face_t[render_in_param->animal_face_count];
        memset(render_in_param->p_animal_face, 0, sizeof(st_mobile_animal_face_t)*render_in_param->animal_face_count);
        for(int i = 0; i < render_in_param->animal_face_count; i++){
            jobject facesObj = env->GetObjectArrayElement(faces_obj_array, i);
            convert2AnimalFace(env, facesObj, render_in_param->p_animal_face+i);

            env->DeleteLocalRef(facesObj);
        }
        env->DeleteLocalRef(faces_obj_array);
    } else {
        render_in_param->p_animal_face = NULL;
    }

    env->DeleteLocalRef(render_in_param_class);

    return true;
}

bool convert2st_effect_render_out_param(JNIEnv *env, jobject outputObject, st_effect_render_out_param_t *render_out_param){
    if(outputObject == NULL){
        return false;
    }

    jclass render_out_param_class = env->FindClass("com/sensetime/stmobile/model/STEffectRenderOutParam");
    jfieldID fieldHumanAction = env->GetFieldID(render_out_param_class, "humanAction", "Lcom/sensetime/stmobile/model/STHumanAction;");
    jfieldID fieldImage = env->GetFieldID(render_out_param_class, "image", "Lcom/sensetime/stmobile/model/STImage;");
    jfieldID fieldTexture = env->GetFieldID(render_out_param_class, "texture", "Lcom/sensetime/stmobile/model/STEffectTexture;");

    jobject humanActionObj = env->GetObjectField(outputObject, fieldHumanAction);
    if(humanActionObj != NULL){
        render_out_param->p_human = new st_mobile_human_action_t;
        memset(render_out_param->p_human, 0, sizeof(st_mobile_human_action_t));
        convert2HumanAction(env, humanActionObj, render_out_param->p_human);
    } else{
        //LOGE("sensetime jni error: input human_action is null");
        render_out_param->p_human = NULL;
    }
    env->DeleteLocalRef(humanActionObj);

    jobject imageObj = env->GetObjectField(outputObject, fieldImage);
    if(imageObj != NULL){
        render_out_param->p_image = new st_image_t ;
        memset(render_out_param->p_image, 0, sizeof(st_image_t));

        convert2Image(env, imageObj, render_out_param->p_image);
    } else{
        //LOGE("sensetime jni error: input image is null");
        render_out_param->p_image = NULL;
    }
    env->DeleteLocalRef(imageObj);

    jobject textureObj = env->GetObjectField(outputObject, fieldTexture);
    if(textureObj != NULL){
        render_out_param->p_tex = new st_effect_texture_t ;
        memset(render_out_param->p_tex, 0, sizeof(st_effect_texture_t));

        convert2st_effect_texture(env, textureObj, render_out_param->p_tex);
    } else{
        LOGE("sensetime jni error: input texture is null");
        render_out_param->p_tex = NULL;
    }
    env->DeleteLocalRef(textureObj);

    env->DeleteLocalRef(render_out_param_class);

    return true;
}

void convert2STEffectRenderOutParam(JNIEnv *env, const st_effect_render_out_param_t *render_out_param, jobject outParamObject){
    jclass STEffectRenderOutParamClass = env->FindClass("com/sensetime/stmobile/model/STEffectRenderOutParam");
    jfieldID fieldHumanAction = env->GetFieldID(STEffectRenderOutParamClass, "humanAction", "Lcom/sensetime/stmobile/model/STHumanAction;");
    jfieldID fieldImage = env->GetFieldID(STEffectRenderOutParamClass, "image", "Lcom/sensetime/stmobile/model/STImage;");
    jfieldID fieldTexture = env->GetFieldID(STEffectRenderOutParamClass, "texture", "Lcom/sensetime/stmobile/model/STEffectTexture;");

    //human action
    jclass humanActionClass = env->FindClass("com/sensetime/stmobile/model/STHumanAction");
    jobject humanActionObject = env->AllocObject(humanActionClass);

    if(render_out_param->p_human != NULL){
        humanActionObject = convert2HumanAction(env, render_out_param->p_human);
    }
    env->SetObjectField(outParamObject, fieldHumanAction, humanActionObject);
    env->DeleteLocalRef(humanActionClass);

    //image
    jclass imageClass = env->FindClass("com/sensetime/stmobile/model/STImage");
    jobject imageObject = env->AllocObject(imageClass);

    if(render_out_param->p_image != NULL){
        imageObject = convert2Image(env, render_out_param->p_image);
    }
    env->SetObjectField(outParamObject, fieldImage, imageObject);
    env->DeleteLocalRef(imageClass);

    //texture
    jclass textureClass = env->FindClass("com/sensetime/stmobile/model/STEffectTexture");
    jobject textureObject = env->AllocObject(textureClass);

    textureObject = convert2EffectTexture(env, render_out_param->p_tex);

    env->SetObjectField(outParamObject, fieldTexture, textureObject);
    env->DeleteLocalRef(textureClass);

    env->DeleteLocalRef(STEffectRenderOutParamClass);
}

jobject convert2EffectPackageInfo(JNIEnv *env, const st_effect_package_info_t *package_info){
    jclass package_info_cls = env->FindClass("com/sensetime/stmobile/model/STEffectPackageInfo");

    jfieldID fieldPackageId = env->GetFieldID(package_info_cls, "packageId", "I");
    jfieldID fieldModuleCount = env->GetFieldID(package_info_cls, "moduleCount", "I");
    jfieldID fieldState = env->GetFieldID(package_info_cls, "state", "I");
    jfieldID fieldName = env->GetFieldID(package_info_cls, "name", "[B");

    jobject packageInfoObj = env->AllocObject(package_info_cls);

    env->SetIntField(packageInfoObj, fieldState, (int)package_info->state);
    env->SetIntField(packageInfoObj, fieldPackageId, package_info->package_id);
    env->SetIntField(packageInfoObj, fieldModuleCount, (int)package_info->module_count);

    jbyteArray arrayName;
    jbyte* name = (jbyte*)(package_info->name);
    int len = strlen(package_info->name);
    arrayName = (env)->NewByteArray(len);

    if(name == NULL){
        return NULL;
    }
    env->SetByteArrayRegion(arrayName, 0, len, name);
    env->SetObjectField(packageInfoObj, fieldName, arrayName);

    env->DeleteLocalRef(arrayName);
    env->DeleteLocalRef(package_info_cls);

    return packageInfoObj;
}

jobject convert2EffectModuleInfo(JNIEnv *env, const st_effect_module_info_t *module_info){
    jclass module_info_cls = env->FindClass("com/sensetime/stmobile/model/STEffectModuleInfo");

    jfieldID fieldPackageId = env->GetFieldID(module_info_cls, "packageId", "I");
    jfieldID fieldModuleId = env->GetFieldID(module_info_cls, "moduleId", "I");
    jfieldID fieldState = env->GetFieldID(module_info_cls, "state", "I");
    jfieldID fieldName = env->GetFieldID(module_info_cls, "name", "[B");
    jfieldID fieldModuleType = env->GetFieldID(module_info_cls, "moduleType", "I");
    jfieldID fieldStrength = env->GetFieldID(module_info_cls, "strength", "F");
    jfieldID fieldInstanceId = env->GetFieldID(module_info_cls, "instanceId", "I");

    jobject packageInfoObj = env->AllocObject(module_info_cls);

    env->SetIntField(packageInfoObj, fieldState, (int)module_info->state);
    env->SetIntField(packageInfoObj, fieldPackageId, module_info->package_id);
    env->SetIntField(packageInfoObj, fieldModuleId, module_info->module_id);
    env->SetIntField(packageInfoObj, fieldModuleType, (int)module_info->type);
    env->SetIntField(packageInfoObj, fieldInstanceId, module_info->instance_id);
    env->SetFloatField(packageInfoObj, fieldStrength, module_info->strength);

    jbyteArray arrayName;
    jbyte* name = (jbyte*)(module_info->name);
    int len = strlen(module_info->name);
    arrayName = (env)->NewByteArray(len + 1);

    if(name == NULL){
        return NULL;
    }
    env->SetByteArrayRegion(arrayName, 0, len + 1, name);
    env->SetObjectField(packageInfoObj, fieldName, arrayName);

    env->DeleteLocalRef(arrayName);
    env->DeleteLocalRef(module_info_cls);

    return packageInfoObj;
}

jobject convert2EffectBeautyInfo(JNIEnv *env, const st_effect_beauty_info_t *beauty_info){
    jclass beauty_info_cls = env->FindClass("com/sensetime/stmobile/model/STEffectBeautyInfo");


    jfieldID fieldName = env->GetFieldID(beauty_info_cls, "name", "[B");
    jfieldID fieldType = env->GetFieldID(beauty_info_cls, "type", "I");
    jfieldID fieldMode = env->GetFieldID(beauty_info_cls, "mode", "I");
    jfieldID fieldStrength = env->GetFieldID(beauty_info_cls, "strength", "F");

    jobject beautyInfoObj = env->AllocObject(beauty_info_cls);

    env->SetIntField(beautyInfoObj, fieldType, (int)beauty_info->type);
    env->SetIntField(beautyInfoObj, fieldMode, (int)beauty_info->mode);
    env->SetFloatField(beautyInfoObj, fieldStrength, beauty_info->strength);

    jbyteArray arrayName;
    jbyte* name = (jbyte*)(beauty_info->name);
    int len = strlen(beauty_info->name);
    arrayName = (env)->NewByteArray(len);

    if(name == NULL){
        return NULL;
    }
    env->SetByteArrayRegion(arrayName, 0, len, name);
    env->SetObjectField(beautyInfoObj, fieldName, arrayName);

    env->DeleteLocalRef(arrayName);
    env->DeleteLocalRef(beauty_info_cls);

    return beautyInfoObj;
}

bool convert2TryonRegionInfo(JNIEnv *env, jobject inputObj, st_effect_tryon_region_info_t * region_info) {
    jclass clazz = env->FindClass("com/sensetime/stmobile/model/STEffectsTryOnRegionInfo");
    // region_id
    jfieldID fieldRegionId = env->GetFieldID(clazz, "regionId", "I");
    region_info->region_id = env->GetIntField(inputObj, fieldRegionId);

    // strength
    jfieldID fieldStrength = env->GetFieldID(clazz, "strength", "F");
    region_info->strength = env->GetFloatField(inputObj, fieldStrength);

    // color
    jfieldID fieldColor = env->GetFieldID(clazz, "color", "Lcom/sensetime/stmobile/model/STColor;");
    jobject colorObject = env->GetObjectField(inputObj, fieldColor);
    if (colorObject != NULL) {
        convert2Color(env, colorObject, &region_info->color);
    }

    env->DeleteLocalRef(clazz);
    env->DeleteLocalRef(colorObject);
    return true;
}

jobject convert2TryonRegionInfo(JNIEnv *env, const st_effect_tryon_region_info_t region_info) {
    jclass clazz = env->FindClass("com/sensetime/stmobile/model/STEffectsTryOnRegionInfo");
    jobject regionInfoObj = env->AllocObject(clazz);

    // region_id
    jfieldID fieldRegionId = env->GetFieldID(clazz, "regionId", "I");
    env->SetIntField(regionInfoObj, fieldRegionId, region_info.region_id);

    // strength
    jfieldID fieldStrength = env->GetFieldID(clazz, "strength", "F");
    env->SetFloatField(regionInfoObj, fieldStrength, region_info.strength);

    // color
    jfieldID fieldColor = env->GetFieldID(clazz, "color", "Lcom/sensetime/stmobile/model/STColor;");
    jobject stColorObj = convert2Color(env, &region_info.color);
    env->SetObjectField(regionInfoObj, fieldColor, stColorObj);

    env->DeleteLocalRef(clazz);
    return regionInfoObj;
}

jobject convert2TryOn(JNIEnv *env, st_effect_tryon_info_t *tryonInfo) {
    jclass clazz = env->FindClass("com/sensetime/stmobile/model/STEffectTryonInfo");
    jobject tryOnObject = env->AllocObject(clazz);

    jfieldID fieldStrength = env->GetFieldID(clazz, "strength", "F");
    env->SetFloatField(tryOnObject, fieldStrength, (float )tryonInfo->strength);

    jfieldID fieldMidTone = env->GetFieldID(clazz, "midtone", "F");
    env->SetFloatField(tryOnObject, fieldMidTone, tryonInfo->midtone);

    jfieldID fieldLipFinishType = env->GetFieldID(clazz, "lipFinishType", "I");
    env->SetIntField(tryOnObject, fieldLipFinishType, (int)tryonInfo->lip_finish_type);

    jfieldID fieldHighLight = env->GetFieldID(clazz, "highlight", "F");
    env->SetFloatField(tryOnObject, fieldHighLight, tryonInfo->highlight);

    jfieldID fieldSTColor = env->GetFieldID(clazz, "color", "Lcom/sensetime/stmobile/model/STColor;");
    jobject stColorObj = convert2Color(env, &tryonInfo->color);
    env->SetObjectField(tryOnObject, fieldSTColor, stColorObj);

    // region_count
    jfieldID fieldRegionCount = env->GetFieldID(clazz, "regionCount", "I");
    env->SetIntField(tryOnObject, fieldRegionCount, tryonInfo->region_count);

    // region_info[6]
    int count = tryonInfo->region_count;
    jfieldID jfieldRegionInfo = env->GetFieldID(clazz, "regionInfo", "[Lcom/sensetime/stmobile/model/STEffectsTryOnRegionInfo;");
    jclass regionInfoClazz = env->FindClass("com/sensetime/stmobile/model/STEffectsTryOnRegionInfo");
    jobjectArray regionInfoArray = env->NewObjectArray(count, regionInfoClazz, 0);
    for (int i=0; i<count;i++) {
        jobject regionInfoObj = convert2TryonRegionInfo(env, tryonInfo->region_info[i]);
        env->SetObjectArrayElement(regionInfoArray, i, regionInfoObj);
        env->DeleteLocalRef(regionInfoObj);
    }
    env->SetObjectField(tryOnObject, jfieldRegionInfo, regionInfoArray);
    env->DeleteLocalRef(regionInfoClazz);

    env->DeleteLocalRef(clazz);
//    env->DeleteLocalRef(tryOnObject);
    return tryOnObject;
}

bool convert2TryOn(JNIEnv *env, jobject inputObject, st_effect_tryon_info_t *tryonInfo) {
    jclass clazz = env->FindClass("com/sensetime/stmobile/model/STEffectTryonInfo");

    jfieldID fieldColor = env->GetFieldID(clazz, "color","Lcom/sensetime/stmobile/model/STColor;");
    jobject colorObject = env->GetObjectField(inputObject, fieldColor);
    if (colorObject != nullptr) {
        convert2Color(env, colorObject, &tryonInfo->color);
    }

    jfieldID fieldStrength = env->GetFieldID(clazz, "strength", "F");
    tryonInfo->strength = env->GetFloatField(inputObject, fieldStrength);

    jfieldID fieldLipFinishType = env->GetFieldID(clazz, "lipFinishType", "I");
    tryonInfo->lip_finish_type = static_cast<st_effect_lipstick_finish_t>(env->GetIntField(
            inputObject, fieldLipFinishType));

    jfieldID jfieldMidtone = env->GetFieldID(clazz, "midtone", "F");
    tryonInfo->midtone = env->GetFloatField(inputObject, jfieldMidtone);

    jfieldID fieldHighLight = env->GetFieldID(clazz, "highlight", "F");
    tryonInfo->highlight = env->GetFloatField(inputObject, fieldHighLight);

    // region_count
    jfieldID fieldRegionCount = env->GetFieldID(clazz, "regionCount", "I");
    tryonInfo->region_count = env->GetIntField(inputObject, fieldRegionCount);

    // region_info[]
    jfieldID fieldRegionInfoArray = env->GetFieldID(clazz, "regionInfo", "[Lcom/sensetime/stmobile/model/STEffectsTryOnRegionInfo;");
    jobjectArray regionInfoArray = (jobjectArray) env->GetObjectField(inputObject, fieldRegionInfoArray);
    int length = env->GetIntField(inputObject, fieldRegionCount);
    if (length > 0) {
        //tryonInfo->region_info[length];
        memset(tryonInfo->region_info, 0, sizeof(length));
        for (int i=0;i<length;i++) {
            jobject regionObj = env->GetObjectArrayElement(regionInfoArray, i);
            convert2TryonRegionInfo(env, regionObj, tryonInfo->region_info+i);
            env->DeleteLocalRef(regionObj);
        }
    }

    env->DeleteLocalRef(clazz);
    env->DeleteLocalRef(colorObject);
    return true;
}

bool convert2InImage(JNIEnv *env, jobject inImageObj, st_effect_in_image_t *inImage) {
    if (inImage == NULL) {
        return false;
    }
    jclass image_cls = env->FindClass("com/sensetime/stmobile/STEffectInImage");

    jfieldID fieldMirror = env->GetFieldID(image_cls, "mirror", "Z");
    jfieldID fieldRotate = env->GetFieldID(image_cls, "rotate", "I");

    inImage->rotate = static_cast<st_rotate_type>(env->GetIntField(inImageObj, fieldRotate));
    inImage->b_mirror = env->GetBooleanField(inImageObj, fieldMirror);

    jfieldID fieldImage = env->GetFieldID(image_cls, "image", "Lcom/sensetime/stmobile/model/STImage;");
    jobject imageObject = env->GetObjectField(inImageObj, fieldImage);
    if (imageObject != nullptr) {
        convert2Image(env, imageObject, &inImage->image);
    }
    env->DeleteLocalRef(image_cls);
    env->DeleteLocalRef(imageObject);
    return true;
}

jobject convert2Effect3DBeautyPartInfo(JNIEnv *env, st_effect_3D_beauty_part_info_t *part_info) {
    jclass clazz = env->FindClass("com/sensetime/stmobile/model/STEffect3DBeautyPartInfo");
    jobject beautyPartInfoObject = env->AllocObject(clazz);

    // name
    jfieldID fieldName = env->GetFieldID(clazz, "name", "[B");
    jbyte* name = (jbyte*)part_info->name;
    int len = strlen(part_info->name);
    jbyteArray arrayName = env->NewByteArray(len);
    env->SetByteArrayRegion(arrayName, 0, len, name);
    env->SetObjectField(beautyPartInfoObject, fieldName, arrayName);

    jfieldID fieldPartId = env->GetFieldID(clazz, "part_id", "I");
    env->SetIntField(beautyPartInfoObject, fieldPartId, part_info->part_id);

    jfieldID fieldStrength = env->GetFieldID(clazz, "strength", "F");
    env->SetFloatField(beautyPartInfoObject, fieldStrength, part_info->strength);

    // strength_min
    jfieldID fieldIdStrengthMin = env->GetFieldID(clazz, "strength_min", "F");
    env->SetFloatField(beautyPartInfoObject, fieldIdStrengthMin, part_info->strength_min);

    // strength_max
    jfieldID fieldIdStrengthMax = env->GetFieldID(clazz, "strength_max", "F");
    env->SetFloatField(beautyPartInfoObject, fieldIdStrengthMax, part_info->strength_max);

    env->DeleteLocalRef(arrayName);
    env->DeleteLocalRef(clazz);
    return beautyPartInfoObject;
}

bool convert2Effect3DBeautyPartInfo(JNIEnv *env, jobject inputObject, st_effect_3D_beauty_part_info_t *part_info) {
    jclass clazz = env->FindClass("com/sensetime/stmobile/model/STEffect3DBeautyPartInfo");

    // name
    jfieldID fieldName = env->GetFieldID(clazz, "name", "[B");
    jbyteArray nameArray = (jbyteArray)env->GetObjectField(inputObject, fieldName);
    jbyte *bytes = env->GetByteArrayElements(nameArray, 0);
    int chars_len = env->GetArrayLength(nameArray);
    memset(part_info->name, 0, chars_len + 1);
    memcpy(part_info->name, bytes, chars_len);
    part_info->name[chars_len] = 0;

    // part_id
    jfieldID fieldPartId = env->GetFieldID(clazz, "part_id", "I");
    part_info->part_id = env->GetIntField(inputObject, fieldPartId);

    // strength
    jfieldID fieldStrength = env->GetFieldID(clazz, "strength", "F");
    part_info->strength = env->GetFloatField(inputObject, fieldStrength);

    // strength_min
    jfieldID fieldStrengthMin = env->GetFieldID(clazz, "strength_min", "F");
    part_info->strength_min = env->GetFloatField(inputObject, fieldStrengthMin);

    // strength_max
    jfieldID fieldStrengthMax = env->GetFieldID(clazz, "strength_max", "F");
    part_info->strength_min = env->GetFloatField(inputObject, fieldStrengthMax);

    env->DeleteLocalRef(clazz);
    env->ReleaseByteArrayElements(nameArray, bytes, 0);

    return true;
}