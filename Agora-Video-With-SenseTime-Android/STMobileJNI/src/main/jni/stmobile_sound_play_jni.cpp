#include "stmobile_sound_play_jni.h"
#include "utils.h"
#include "jvmutil.h"
#include "prebuilt/include/st_mobile_effect.h"

#define  LOG_TAG    "STMobileSticker"

const char *kSoundPlayPath = "com/sensetime/stmobile/STSoundPlay";

void soundLoad(void* handle, char* sound, const char* sound_name, int length)
{
    JNIEnv *env;
    bool isAttached = false;
    getEnv(&env,&isAttached);
    if(!env) {
        return;
    }

    LOGE("soundLoad");

    jclass soundPlayCls = env->FindClass(kSoundPlayPath);
    if(!soundPlayCls) {
        LOGE("Failed to get %s class", kSoundPlayPath);
        return;
    }
    jobject soundPlayObject = getSoundPlayObjInSticker(env);
    if(!soundPlayObject){
        return;
    }

    jmethodID method = env->GetMethodID(soundPlayCls, "onSoundLoaded", "(Ljava/lang/String;[B)V");
    if(!method) {
        LOGE("Failed to get method ID onSoundLoaded");
        return;
    }

    jstring soundName = stoJstring(env, (char*)sound_name);
    jbyteArray soundBytes = env->NewByteArray(length);
    env->SetByteArrayRegion(soundBytes, 0, length, (jbyte *)sound);
    env->CallVoidMethod(soundPlayObject, method, soundName, soundBytes);

    env->DeleteLocalRef(soundBytes);
    env->DeleteLocalRef(soundPlayCls);
    env->DeleteLocalRef(soundPlayObject);

    if (isAttached) {
        gJavaVM->DetachCurrentThread();
    }
}

void soundPlay(void* handle, const char* sound_name, int loop)
{
    JNIEnv *env;
    bool isAttached = false;
    getEnv(&env,&isAttached);
    if(!env) {
        return;
    }

    LOGE("soundPlay");

    jclass soundPlayCls = env->FindClass(kSoundPlayPath);
    if(!soundPlayCls) {
        LOGE("Failed to get %s class", kSoundPlayPath);
        return;
    }

    jobject soundPlayObject = getSoundPlayObjInSticker(env);
    if(!soundPlayObject) {
        return;
    }

    jmethodID method = env->GetMethodID(soundPlayCls, "onStartPlay", "(Ljava/lang/String;I)V");
    if(!method) {
        LOGE("Failed to get method ID onStartPlay");
        return;
    }

    jstring soundName = stoJstring(env, (char*)sound_name);
    env->CallVoidMethod(soundPlayObject, method, soundName, loop);

    env->DeleteLocalRef(soundPlayCls);
    env->DeleteLocalRef(soundPlayObject);

    if (isAttached) {
        gJavaVM->DetachCurrentThread();
    }
}

void soundStop(void* handle, const char* sound_name)
{
    JNIEnv *env;
    bool isAttached = false;
    getEnv(&env,&isAttached);
    if(!env) {
        return;
    }

    jclass soundPlayCls = env->FindClass(kSoundPlayPath);
    if(!soundPlayCls) {
        LOGE("Failed to get %s class", kSoundPlayPath);
        return;
    }

    LOGE("soundStop");

    jobject soundPlayObject = getSoundPlayObjInSticker(env);
    if(!soundPlayObject){
        return;
    }

    jmethodID method = env->GetMethodID(soundPlayCls, "onStopPlay", "(Ljava/lang/String;)V");
    if(!method) {
        LOGE("Failed to get method ID onStopPlay");
        return;
    }

    jstring soundName = stoJstring(env, (char*)sound_name);
    env->CallVoidMethod(soundPlayObject, method, soundName);

    env->DeleteLocalRef(soundPlayCls);
    env->DeleteLocalRef(soundPlayObject);

    if (isAttached) {
        gJavaVM->DetachCurrentThread();
    }
}

void soundPause(void* handle, const char* sound_name)
{
    JNIEnv *env;
    bool isAttached = false;
    getEnv(&env,&isAttached);
    if(!env) {
        return;
    }

    jclass soundPlayCls = env->FindClass(kSoundPlayPath);
    if(!soundPlayCls) {
        LOGE("Failed to get %s class", kSoundPlayPath);
        return;
    }

    LOGE("soundPause");

    jobject soundPlayObject = getSoundPlayObjInSticker(env);
    if(!soundPlayObject){
        return;
    }

    jmethodID method = env->GetMethodID(soundPlayCls, "onSoundPause", "(Ljava/lang/String;)V");
    if(!method) {
        LOGE("Failed to get method ID onSoundPause");
        return;
    }

    jstring soundName = stoJstring(env, (char*)sound_name);
    env->CallVoidMethod(soundPlayObject, method, soundName);

    env->DeleteLocalRef(soundPlayCls);
    env->DeleteLocalRef(soundPlayObject);

    if (isAttached) {
        gJavaVM->DetachCurrentThread();
    }
}

void soundResume(void* handle, const char* sound_name)
{
    JNIEnv *env;
    bool isAttached = false;
    getEnv(&env,&isAttached);
    if(!env) {
        return;
    }

    jclass soundPlayCls = env->FindClass(kSoundPlayPath);
    if(!soundPlayCls) {
        LOGE("Failed to get %s class", kSoundPlayPath);
        return;
    }

    LOGE("soundResume");

    jobject soundPlayObject = getSoundPlayObjInSticker(env);
    if(!soundPlayObject){
        return;
    }

    jmethodID method = env->GetMethodID(soundPlayCls, "onSoundResume", "(Ljava/lang/String;)V");
    if(!method) {
        LOGE("Failed to get method ID onSoundResume");
        return;
    }

    jstring soundName = stoJstring(env, (char*)sound_name);
    env->CallVoidMethod(soundPlayObject, method, soundName);

    env->DeleteLocalRef(soundPlayCls);
    env->DeleteLocalRef(soundPlayObject);

    if (isAttached) {
        gJavaVM->DetachCurrentThread();
    }
}

int sound_state_changed(void* handle, const st_effect_module_info_t* module_info){
    if(module_info == nullptr){
        return -1;
    }
    if(module_info->state == EFFECT_MODULE_LOADED){
        if(module_info->reserved == nullptr){
            return -1;
        }
        soundLoad(handle, ((st_effect_buffer_t*)module_info->reserved)->data_ptr, module_info->name, ((st_effect_buffer_t*)module_info->reserved)->data_len);
    } else if(module_info->state == EFFECT_MODULE_PLAYING){
        int loop = 0;
        if(module_info->reserved != nullptr){
            loop = reinterpret_cast<size_t>(module_info->reserved);
        }
        soundPlay(handle, module_info->name, loop);
    } else if(module_info->state == EFFECT_MODULE_PAUSED_LAST_FRAME){
        soundStop(handle, module_info->name);
    } else if(module_info->state == EFFECT_MODULE_PAUSED){
        soundPause(handle, module_info->name);
    }else if(module_info->state == EFFECT_MODULE_RESUMED){
        soundResume(handle, module_info->name);
    }

    return 0;
}

