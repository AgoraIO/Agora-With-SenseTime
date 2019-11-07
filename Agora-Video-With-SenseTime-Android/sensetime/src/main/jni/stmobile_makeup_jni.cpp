#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "st_mobile_makeup.h"
#include "utils.h"
#include<fcntl.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>

#define  LOG_TAG    "STMobileMakeupNative"

extern "C" {
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_createInstance(JNIEnv * env, jobject obj);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setMakeupForType(JNIEnv * env, jobject obj, jint type, jstring typePath);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setMakeupForTypeFromAssetsFile(JNIEnv * env, jobject obj, jint type, jstring type_path, jobject assetManager);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_addMakeupForType(JNIEnv * env, jobject obj, jint type, jstring typePath);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_addMakeupForTypeFromAssetsFile(JNIEnv * env, jobject obj, jint type, jstring type_path, jobject assetManager);

    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_removeMakeup(JNIEnv * env, jobject obj, jint packageId);
    JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_clearMakeups(JNIEnv * env, jobject obj);
    JNIEXPORT jlong JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_getTriggerAction(JNIEnv * env, jobject obj);

    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_prepare(JNIEnv * env, jobject obj, jbyteArray image, jint imageFormat, jint imageWidth, jint imageHeight, jobject humanAction);

    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_processTexture(JNIEnv * env, jobject obj, jint textureIn,
                                                                                       jobject humanAction, jint rotate, jint imageWidth, jint imageHeight, jint textureOut);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_processTextureAndOutputBuffer(JNIEnv * env, jobject obj, jint textureIn, jobject humanAction, jint rotate, jint imageWidth, jint imageHeight,
                                                                                                      jint textureOut, jint outFmt, jbyteArray imageOut);

    JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setStrengthForType(JNIEnv * env, jobject obj, jint type, jfloat value);
    JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setSmoothStrengthForType(JNIEnv * env, jobject obj, jint type, jfloat value);
    JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setResourceForType(JNIEnv * env, jobject obj, jint type, jint packageId, jobject imageData);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_destroyInstance(JNIEnv * env, jobject obj);

static inline jfieldID getMakeupHandleField(JNIEnv *env, jobject obj)
{
    jclass c = env->GetObjectClass(obj);
    // J is the type signature for long:
    return env->GetFieldID(c, "nativeMakeupHandle", "J");
}

void setMakeupHandle(JNIEnv *env, jobject obj, void *h)
{
    jlong handle = reinterpret_cast<jlong>(h);
    env->SetLongField(obj, getMakeupHandleField(env, obj), handle);
}

void *getMakeupHandle(JNIEnv *env, jobject obj)
{
    jlong handle = env->GetLongField(obj, getMakeupHandleField(env, obj));
    return reinterpret_cast<void *>(handle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_createInstance(JNIEnv * env, jobject obj)
{
    st_handle_t handle;
    int result = (int)st_mobile_makeup_create(&handle);
    if(result != 0)
    {
        LOGE("create handle failed");
        return result;
    }
    setMakeupHandle(env, obj, handle);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setMakeupForType(JNIEnv * env, jobject obj, jint type, jstring typePath)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getMakeupHandle(env, obj);

    if(handle == NULL){
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (typePath != NULL) {
        pathChars = env->GetStringUTFChars(typePath, 0);
    }

    int packageId = -1;

    result = st_mobile_makeup_set_makeup_for_type(handle, (st_makeup_type)type, pathChars, &packageId);

    if(typePath != NULL){
        env->ReleaseStringUTFChars(typePath, pathChars);
    }

    LOGE("set makeup for type result: %d", result);

    return packageId;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setMakeupForTypeFromAssetsFile(JNIEnv * env, jobject obj, jint type, jstring file_path, jobject assetManager)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t makeupHandle = getMakeupHandle(env, obj);

    if (makeupHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int packageId = 0;

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    if(file_path == NULL){
        result = st_mobile_makeup_set_makeup_for_type(makeupHandle, (st_makeup_type)type, NULL, &packageId);
        LOGE("change zip to null");
        return result;
    }

    const char* sticker_file_name_str = env->GetStringUTFChars(file_path, 0);
    if(NULL == sticker_file_name_str) {
        result = st_mobile_makeup_set_makeup_for_type(makeupHandle, (st_makeup_type)type, NULL, &packageId);
        LOGE("file_name to c_str failed, change zip to null");
        return result;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, sticker_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(file_path, sticker_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        result = st_mobile_makeup_set_makeup_for_type(makeupHandle, (st_makeup_type)type, NULL, &packageId);
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    unsigned char* buffer = NULL;
    long size = 0;
    size = AAsset_getLength(asset);
    buffer = new unsigned char[size];
    memset(buffer, '\0', size);

    long readSize = AAsset_read(asset, buffer, size);
    if (readSize != size) {
        AAsset_close(asset);
        if (buffer) {
            delete[] buffer;
        }

        result = st_mobile_makeup_set_makeup_for_type(makeupHandle, (st_makeup_type)type, NULL, &packageId);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset);

    if (size < 10) {
        LOGE("zip file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        result = st_mobile_makeup_set_makeup_for_type(makeupHandle, (st_makeup_type)type, NULL, &packageId);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(makeupHandle != NULL) {
        result = st_mobile_makeup_set_makeup_for_type_from_buffer(makeupHandle, (st_makeup_type)type, buffer, size, &packageId);
    }

    LOGE("add makeup for type from assets");

    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("st_mobile_makeup_set_makeup_for_type_from_buffer failed, %d",result);
        return result;
    }

    LOGE("add makeup for type from assets end");
    return packageId;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_addMakeupForType(JNIEnv * env, jobject obj, jint type, jstring typePath)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getMakeupHandle(env, obj);

    int packageId = -1;

    if(handle == NULL){
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (typePath != NULL) {
        pathChars = env->GetStringUTFChars(typePath, 0);
    }

    result = st_mobile_makeup_add_makeup_for_type(handle, (st_makeup_type)type, pathChars, &packageId);

    LOGE("add_makeup_for_type failed, %d",result);

    if(typePath != NULL){
        env->ReleaseStringUTFChars(typePath, pathChars);
    }

    return packageId;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_addMakeupForTypeFromAssetsFile(JNIEnv * env, jobject obj, jint type, jstring type_path, jobject assetManager)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getMakeupHandle(env, obj);

    int packageId = -1;

    if(handle == NULL){
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    if(type_path == NULL){
        LOGE("add makeup type null");
        return result;
    }

    const char* type_file_name_str = env->GetStringUTFChars(type_path, 0);
    if(NULL == type_file_name_str) {
        LOGE("add makeup type null");
        return result;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, type_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(type_path, type_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    unsigned char* buffer = NULL;
    long size = 0;
    size = AAsset_getLength(asset);
    buffer = new unsigned char[size];
    memset(buffer, '\0', size);

    long readSize = AAsset_read(asset, buffer, size);
    if (readSize != size) {
        AAsset_close(asset);
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }

        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset);

    if (size < 10) {
        LOGE("type file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(handle != NULL) {
        result = st_mobile_makeup_add_makeup_for_type_from_buffer(handle, (st_makeup_type)type, buffer, size, &packageId);
    }

    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("add_makeup_for_type_from_buffer failed, %d",result);
    }
    return packageId;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_removeMakeup(JNIEnv * env, jobject obj, jint packageId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getMakeupHandle(env, obj);

    if (handle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(handle != NULL) {
        result = st_mobile_makeup_remove_makeup(handle, packageId);
    }

    return result;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_clearMakeups(JNIEnv * env, jobject obj){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getMakeupHandle(env, obj);

    if (handle == NULL) {
        LOGE("handle is null");
        return;
    }

    if(handle != NULL) {
        st_mobile_makeup_clear_makeups(handle);
    }
}

JNIEXPORT jlong JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_getTriggerAction(JNIEnv * env, jobject obj)
{
    st_handle_t handle = getMakeupHandle(env, obj);
    if(handle != NULL) {
        unsigned long long action = -1;
        int result = st_mobile_makeup_get_trigger_action(handle, &action);
        if (result == ST_OK) {
            return action;
        }
    }

    return 0;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_prepare(JNIEnv * env, jobject obj, jbyteArray image, jint imageFormat, jint imageWidth, jint imageHeight, jobject humanAction){
    int result = ST_JNI_ERROR_DEFAULT;

    st_handle_t handle = getMakeupHandle(env, obj);

    if(handle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if (image == NULL) {
        LOGE("input image is null");
        return ST_E_INVALIDARG;
    }

    jbyte *srcdata = (jbyte*) (env->GetByteArrayElements(image, 0));
    int image_stride = getImageStride((st_pixel_format)imageFormat, imageWidth);

    st_mobile_human_action_t human_action = {0};

    if (!convert2HumanAction(env, humanAction, &human_action)) {
        memset(&human_action, 0, sizeof(st_mobile_human_action_t));
    }

    result = st_mobile_makeup_prepare(handle, (unsigned char *)srcdata,  (st_pixel_format)imageFormat,  imageWidth,
                                      imageHeight, image_stride, &human_action);

    releaseHumanAction(&human_action);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_processTexture(JNIEnv * env, jobject obj, jint textureIn,
                                                                                        jobject humanAction, jint rotate, jint imageWidth, jint imageHeight, jint textureOut)
{
    LOGI("processTexture, the width is %d, the height is %d, the rotate is %d",imageWidth, imageHeight, rotate);
    int result = ST_JNI_ERROR_DEFAULT;

    st_handle_t handle = getMakeupHandle(env, obj);

    if(handle == NULL)
    {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_mobile_human_action_t human_action = {0};

    if (!convert2HumanAction(env, humanAction, &human_action)) {
        memset(&human_action, 0, sizeof(st_mobile_human_action_t));
    }

    if(handle != NULL) {
        result  = st_mobile_makeup_process_texture(handle, textureIn, imageWidth, imageHeight, (st_rotate_type)rotate, &human_action, textureOut);
        LOGI("-->>st_mobile_makeup_process_texture --- result is %d", result);
    }

    releaseHumanAction(&human_action);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_processTextureAndOutputBuffer(JNIEnv * env, jobject obj, jint textureIn, jobject humanAction, jint rotate, jint imageWidth, jint imageHeight,
                                                                                                       jint textureOut, jint outFmt, jbyteArray imageOut) {
    LOGI("processTexture, the width is %d, the height is %d, the rotate is %d",imageWidth, imageHeight, rotate);
    int result = ST_JNI_ERROR_DEFAULT;

    st_handle_t handle = getMakeupHandle(env, obj);

    if (handle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    jbyte *dstdata = NULL;
    if (imageOut != NULL) {
        dstdata = (jbyte *) (env->GetByteArrayElements(imageOut, 0));
    }

    st_mobile_human_action_t human_action = {0};

    if (!convert2HumanAction(env, humanAction, &human_action)) {
        memset(&human_action, 0, sizeof(st_mobile_human_action_t));
    }

    if (handle != NULL) {
        result = st_mobile_makeup_process_and_output_texture(handle, textureIn, imageWidth, imageHeight, (st_rotate_type) rotate,
                                                              &human_action,  textureOut, (unsigned char *) dstdata, (st_pixel_format) outFmt);
        LOGI("-->>st_mobile_makeup_process_and_output_texture --- result is %d", result);
    }

    releaseHumanAction(&human_action);

    if (dstdata != NULL) {
        env->ReleaseByteArrayElements(imageOut, dstdata, 0);
    }

    return result;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setStrengthForType(JNIEnv * env, jobject obj, jint type, jfloat value)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getMakeupHandle(env, obj);
    if(handle != NULL) {
        st_mobile_makeup_set_strength_for_type(handle, (st_makeup_type)type, value);
    }
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setSmoothStrengthForType(JNIEnv * env, jobject obj, jint type, jfloat value)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getMakeupHandle(env, obj);
    if(handle != NULL) {
        st_mobile_makeup_set_smooth_strength(handle, (st_makeup_type)type, value);
    }
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_setResourceForType(JNIEnv * env, jobject obj, jint type, jint packageId, jobject imageData)
{
    st_handle_t handle = getMakeupHandle(env, obj);

    st_image_t image = {0};
    if (!convert2Image(env, imageData, &image)) {
        memset(&image, 0, sizeof(st_image_t));
    }

    if(handle != NULL) {
        st_mobile_makeup_set_resource_for_type(handle, (st_makeup_type)type, packageId, image);
    }
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileMakeupNative_destroyInstance(JNIEnv * env, jobject obj)
{
    st_handle_t handle = getMakeupHandle(env, obj);
    if(handle == NULL) {
        return ST_E_HANDLE;
    }
    setMakeupHandle(env, obj, NULL);
    st_mobile_makeup_destroy(handle);
    return ST_OK;
}

};