#include "stmobile_sticker_event_callback_jni.h"
#include "utils.h"
#include "jvmutil.h"

#define  LOG_TAG    "STMobileStickerCallbackNative"

const char *kStickerEventPath = "com/sensetime/stmobile/STStickerEvent";

void packageEvent(void* handle, const char* package_name, int packageID, int event, int displayed_frame)
{
    JNIEnv *env;
    bool isAttached = false;
    getEnv(&env,&isAttached);
    if(!env) {
        return;
    }

    LOGE("packageEvent");

    jclass stickerEventPathCls = env->FindClass(kStickerEventPath);
    if(!stickerEventPathCls) {
        LOGE("Failed to get %s class", kStickerEventPath);
        return;
    }
    jobject packageEventObject = getEventObjInSticker(env);
    if(!packageEventObject){
        return;
    }

    jmethodID method = env->GetMethodID(stickerEventPathCls, "onPackageEvent", "(Ljava/lang/String;III)V");
    if(!method) {
        LOGE("Failed to get method ID onPackageEvent");
        return;
    }

    jstring packageName = stoJstring(env, (char*)package_name);
    env->CallVoidMethod(packageEventObject, method, packageName, packageID, event, displayed_frame);

    env->DeleteLocalRef(stickerEventPathCls);
    env->DeleteLocalRef(packageEventObject);

    if (isAttached) {
        gJavaVM->DetachCurrentThread();
    }
}

void animationEvent(void* handle, const char* module_name, int module_id, int animation_event, int current_frame, int position_id, unsigned long long position_type)
{
    JNIEnv *env;
    bool isAttached = false;
    getEnv(&env,&isAttached);
    if(!env) {
        return;
    }

    LOGE("animationEvent");

    jclass animationEventPathCls = env->FindClass(kStickerEventPath);
    if(!animationEventPathCls) {
        LOGE("Failed to get %s class", kStickerEventPath);
        return;
    }
    jobject animationEventObject = getEventObjInSticker(env);
    if(!animationEventObject){
        return;
    }

    jmethodID method = env->GetMethodID(animationEventPathCls, "onAnimationEvent", "(Ljava/lang/String;IIIIJ)V");
    if(!method) {
        LOGE("Failed to get method ID onPackageEvent");
        return;
    }

    jstring moduleName = stoJstring(env, (char*)module_name);
    env->CallVoidMethod(animationEventObject, method, moduleName, module_id, animation_event, current_frame, position_id, position_type);

    env->DeleteLocalRef(animationEventPathCls);
    env->DeleteLocalRef(animationEventObject);

    if (isAttached) {
        gJavaVM->DetachCurrentThread();
    }
}

void keyFrameEvent(void* handle, const char* material_name, int frame)
{
    JNIEnv *env;
    bool isAttached = false;
    getEnv(&env,&isAttached);
    if(!env) {
        return;
    }

    LOGE("animationEvent");

    jclass keyFrameEventPathCls = env->FindClass(kStickerEventPath);
    if(!keyFrameEventPathCls) {
        LOGE("Failed to get %s class", kStickerEventPath);
        return;
    }
    jobject keyFrameEventObject = getEventObjInSticker(env);
    if(!keyFrameEventObject){
        return;
    }

    jmethodID method = env->GetMethodID(keyFrameEventPathCls, "onAnimationEvent", "(Ljava/lang/String;I)V");
    if(!method) {
        LOGE("Failed to get method ID onPackageEvent");
        return;
    }

    jstring materialName = stoJstring(env, (char*)material_name);
    env->CallVoidMethod(keyFrameEventObject, method, materialName, frame);

    env->DeleteLocalRef(keyFrameEventPathCls);
    env->DeleteLocalRef(keyFrameEventObject);

    if (isAttached) {
        gJavaVM->DetachCurrentThread();
    }
}



