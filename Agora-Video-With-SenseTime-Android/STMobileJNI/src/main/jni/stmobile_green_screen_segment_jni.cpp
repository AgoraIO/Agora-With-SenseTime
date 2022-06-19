#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "st_mobile_green_screen_segment.h"
#include "utils.h"
#include<fcntl.h>
#define  LOG_TAG    "STMobileGreenScreenSegmentNative"

extern "C" {
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_createInstance(JNIEnv * env, jobject obj);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_process(JNIEnv * env, jobject obj, jobject imageObj, jint outputTexture);
    JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_destroyInstance(JNIEnv * env, jobject obj);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_setParam(JNIEnv * env, jobject obj, jint type, jfloat value);
    JNIEXPORT jfloat JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_getParam(JNIEnv * env, jobject obj, jint type);
};

static inline jfieldID getGreenScreenSegmentHandleField(JNIEnv *env, jobject obj)
{
    jclass c = env->GetObjectClass(obj);
    // J is the type signature for long:
    jfieldID fieldID = env->GetFieldID(c, "GreenScreenSegmentNativeHandle", "J");
    env->DeleteLocalRef(c);
    return fieldID;
}

void setGreenScreenSegmentHandle(JNIEnv *env, jobject obj, void * h)
{
    jlong handle = reinterpret_cast<jlong>(h);
    env->SetLongField(obj, getGreenScreenSegmentHandleField(env, obj), handle);
}

void* getGreenScreenSegmentHandle(JNIEnv *env, jobject obj)
{
    jlong handle = env->GetLongField(obj, getGreenScreenSegmentHandleField(env, obj));
    return reinterpret_cast<void *>(handle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_createInstance(JNIEnv * env, jobject obj)
{
    st_handle_t handle;
    int result = (int)st_mobile_green_screen_segment_create(&handle);
    if(result != 0)
    {
        LOGE("create green_screen_segment handle failed");
        return result;
    }
    setGreenScreenSegmentHandle(env, obj, handle);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_process(JNIEnv * env, jobject obj, jobject imageObj, jint outputTexture)
{
    int result = ST_OK;
    st_handle_t handle = getGreenScreenSegmentHandle(env, obj);
    if(handle == NULL){
        LOGE("green_screen_segment handle is null");
        return ST_E_HANDLE;
    }

    st_image_t image = {0};
    if (!convert2Image(env, imageObj, &image)) {
        memset(&image, 0, sizeof(st_image_t));
    }

    result = st_mobile_green_screen_segment_process(handle, &image, outputTexture);

    return result;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_destroyInstance(JNIEnv * env, jobject obj)
{
    st_handle_t handle = getGreenScreenSegmentHandle(env, obj);
    if(handle == NULL){
        return;
    }
    setGreenScreenSegmentHandle(env, obj, NULL);
    st_mobile_green_screen_segment_destroy(handle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_setParam(JNIEnv * env, jobject obj, jint type, jfloat value)
{
    int result = ST_OK;
    st_handle_t handle = getGreenScreenSegmentHandle(env, obj);
    if(handle == NULL){
        LOGE("green_screen_segment handle is null");
        return ST_E_HANDLE;
    }

    result = st_mobile_green_screen_segment_setparam(handle, (st_green_screen_segment_param_t)type, value);

    return result;
}

JNIEXPORT jfloat JNICALL Java_com_sensetime_stmobile_STMobileGreenScreenSegmentNative_getParam(JNIEnv * env, jobject obj, jint type)
{
    int result = ST_OK;
    st_handle_t handle = getGreenScreenSegmentHandle(env, obj);
    if(handle == NULL){
        LOGE("green_screen_segment handle is null");
        return ST_E_HANDLE;
    }

    float value = 0.0f;
    result = st_mobile_green_screen_segment_getparam(handle, (st_green_screen_segment_param_t)type, &value);

    return result;
}

