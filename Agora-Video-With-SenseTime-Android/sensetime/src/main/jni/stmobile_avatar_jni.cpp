#include <jni.h>
#include <st_mobile_common.h>
#include <st_mobile_avatar.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include "utils.h"

#define  LOG_TAG    "STMobileAvatar"

extern "C" {
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_createInstance(JNIEnv * env, jobject obj, jstring modelpath);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager);
JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_destroyInstance(JNIEnv * env, jobject obj);
JNIEXPORT jlong JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_getAvatarDetectConfig(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_avatarExpressionDetect(JNIEnv * env, jobject obj, jint rotate, jint imageWidth, jint imageHeight, jobject humanActionInput, jfloatArray outputArray);
}

static inline jfieldID getAvatarHandleField(JNIEnv *env, jobject obj)
{
    jclass c = env->GetObjectClass(obj);
    // J is the type signature for long:
    return env->GetFieldID(c, "nativeAvatarHandle", "J");
}

void setAvatarHandle(JNIEnv *env, jobject obj, void * h)
{
    jlong handle = reinterpret_cast<jlong>(h);
    env->SetLongField(obj, getAvatarHandleField(env, obj), handle);
}

void* getAvatarHandle(JNIEnv *env, jobject obj)
{
    jlong handle = env->GetLongField(obj, getAvatarHandleField(env, obj));
    return reinterpret_cast<void *>(handle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_createInstance(JNIEnv * env, jobject obj, jstring modelpath)
{
    st_handle_t  ha_handle = NULL;
    if (modelpath == NULL) {
        LOGE("model path is null");
        return ST_E_INVALIDARG;
    }
    const char *modelpathChars = env->GetStringUTFChars(modelpath, 0);
    LOGI("-->> modelpath=%s", modelpathChars);
    int result = st_mobile_avatar_create(&ha_handle, modelpathChars);
    if(result != 0){
        LOGE("create handle for human action failed");
        env->ReleaseStringUTFChars(modelpath, modelpathChars);
        return result;
    }
    setAvatarHandle(env, obj, ha_handle);
    env->ReleaseStringUTFChars(modelpath, modelpathChars);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager){
    st_handle_t handle = NULL;
    if(NULL == model_path){
        LOGE("model_path is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    const char* model_file_name_str = env->GetStringUTFChars(model_path, 0);
    if(NULL == model_file_name_str){
        LOGE("change model_path to c_str failed");
        return ST_JNI_ERROR_INVALIDARG;
    }
    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr){
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    LOGE("asset %s",model_file_name_str);
    AAsset* asset = AAssetManager_open(mgr, model_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(model_path, model_file_name_str);
    char* buffer = NULL;
    int size = 0;
    if (NULL == asset){
        LOGE("open asset file failed");
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    size = AAsset_getLength(asset);
    buffer = new char[size];
    memset(buffer,'\0',size);
    int readSize = AAsset_read(asset,buffer,size);

    if (readSize != size){
        AAsset_close(asset);
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }
        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset);

    if (size < 1000){
        LOGE("Model file is too samll");
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }
        return ST_JNI_ERROR_FILE_SIZE;
    }

    int result = st_mobile_avatar_create_from_buffer(&handle, buffer, size);
    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("create handle failed, %d",result);
        return result;
    }

    setAvatarHandle(env, obj, handle);
    return result;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_destroyInstance(JNIEnv * env, jobject obj)
{
    st_handle_t avatarhandle = getAvatarHandle(env, obj);
    if(avatarhandle != NULL)
    {
        LOGI(" Avatar handle destory");
        setAvatarHandle(env,obj,NULL);
        st_mobile_avatar_destroy(avatarhandle);
    }
}

JNIEXPORT jlong JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_getAvatarDetectConfig(JNIEnv * env, jobject obj)
{
    st_handle_t avatarhandle = getAvatarHandle(env, obj);
    unsigned long long result;
    if(avatarhandle != NULL)
    {
        result = st_mobile_avatar_get_detect_config(avatarhandle);
    }
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAvatarNative_avatarExpressionDetect(JNIEnv * env, jobject obj, jint rotate, jint imageWidth, jint imageHeight, jobject humanActionInput, jfloatArray outputArray)
{
    LOGI("Avatardetect, the width is %d, the height is %d, the rotate is %d",imageWidth, imageHeight, rotate);
    st_handle_t avatarhandle = getAvatarHandle(env, obj);
    if(avatarhandle == NULL)
    {
        LOGE("handle is null");
        return NULL;
    }

    st_mobile_face_t human_face_input = {0};

    if (!convert2FaceInfo(env, humanActionInput, &human_face_input)) {
        memset(&human_face_input, 0, sizeof(st_mobile_face_t));
    }

    jfloat* outArray = env->GetFloatArrayElements(outputArray, NULL);
    int result = -1;
    long startTime = getCurrentTime();
    if(avatarhandle != NULL)
    {
        LOGI("before get expression");
        result = st_mobile_avatar_get_expression(avatarhandle, imageWidth, imageHeight, (st_rotate_type)rotate, &human_face_input, outArray);
        LOGI("st_mobile_avatar_get_expression --- result is %d", result);
    }

    long afterdetectTime = getCurrentTime();
    LOGI("the avatar detected time is %ld", (afterdetectTime - startTime));
    env->ReleaseFloatArrayElements(outputArray, outArray, 0);

    return result;
}
