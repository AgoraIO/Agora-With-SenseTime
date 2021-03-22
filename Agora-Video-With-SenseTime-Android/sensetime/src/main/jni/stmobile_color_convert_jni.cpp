#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "st_mobile_color_convert.h"
#include "utils.h"
#include<fcntl.h>
#define  LOG_TAG    "com.sensetime.stmobile.STMobileColorConvertNative"

extern "C" {
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_createInstance(JNIEnv * env, jobject obj);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_setTextureSize(JNIEnv * env, jobject obj, jint width, jint height);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_nv21BufferToRgbaTexture(JNIEnv * env, jobject obj, jint imageWidth, jint imageHeight, jint orientation, jboolean needMirror,
                                                                                            jbyteArray pInputImage, jint textureOut);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_rgbaTextureToNv21Buffer(JNIEnv * env, jobject obj, jint textureId, jint width, jint height, jbyteArray pOutputImage);

    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_nv12BufferToRgbaTexture(JNIEnv * env, jobject obj, jint imageWidth, jint imageHeight, jint orientation, jboolean needMirror,
                                                                                                      jbyteArray pInputImage, jint textureOut);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_rgbaTextureToNv12Buffer(JNIEnv * env, jobject obj, jint textureId, jint width, jint height, jbyteArray pOutputImage);

    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_rgbaTextureToGray8Buffer(JNIEnv * env, jobject obj, jint textureId, jint width, jint height, jbyteArray pOutputImage);

    JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_destroyInstance(JNIEnv * env, jobject obj);
};

static inline jfieldID getColorConvertHandleField(JNIEnv *env, jobject obj)
{
    jclass c = env->GetObjectClass(obj);
    // J is the type signature for long:
    jfieldID fieldID = env->GetFieldID(c, "colorConvertNativeHandle", "J");
    env->DeleteLocalRef(c);
    return fieldID;
}

void setColorConvertHandle(JNIEnv *env, jobject obj, void * h)
{
    jlong handle = reinterpret_cast<jlong>(h);
    env->SetLongField(obj, getColorConvertHandleField(env, obj), handle);
}

void* getColorConvertHandle(JNIEnv *env, jobject obj)
{
    jlong handle = env->GetLongField(obj, getColorConvertHandleField(env, obj));
    return reinterpret_cast<void *>(handle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_createInstance(JNIEnv * env, jobject obj)
{
    st_handle_t handle;
    int result = (int)st_mobile_color_convert_create(&handle);
    if(result != 0)
    {
        LOGE("create ColorConvert handle failed");
        return result;
    }
    setColorConvertHandle(env, obj, handle);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_setTextureSize(JNIEnv * env, jobject obj, jint width, jint height)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getColorConvertHandle(env, obj);
    if(handle == NULL){
        LOGE("ColorConvert handle is null");
        return ST_E_HANDLE;
    }

    if(handle != NULL) {
        result = st_mobile_color_convert_set_size(handle, width, height);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_nv21BufferToRgbaTexture(JNIEnv * env, jobject obj, jint imageWidth, jint imageHeight, jint orientation, jboolean needMirror,
                                                                                           jbyteArray pInputImage, jint textureOut)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getColorConvertHandle(env, obj);
    if(handle == NULL){
       LOGE("ColorConvert handle is null");
       return ST_E_HANDLE;
    }

    jbyte *srcdata = (jbyte*) (env->GetPrimitiveArrayCritical(pInputImage, 0));

    if(handle != NULL) {
        result = st_mobile_nv21_buffer_to_rgba_tex(handle, imageWidth, imageHeight, (st_rotate_type)orientation, (bool)needMirror, (unsigned char *)srcdata, textureOut);
    }
    env->ReleasePrimitiveArrayCritical(pInputImage, srcdata, 0);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_rgbaTextureToNv21Buffer(JNIEnv * env, jobject obj, jint textureId, jint width, jint height, jbyteArray pOutputImage)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getColorConvertHandle(env, obj);
    if(handle == NULL){
        LOGE("ColorConvert handle is null");
        return ST_E_HANDLE;
    }

    jbyte *dstdata = (jbyte*) env->GetPrimitiveArrayCritical(pOutputImage, 0);

    if(handle != NULL) {
        result = st_mobile_rgba_tex_to_nv21_tex(handle, textureId, width, height, (unsigned char *)dstdata);
    }
    env->ReleasePrimitiveArrayCritical(pOutputImage, dstdata, 0);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_nv12BufferToRgbaTexture(JNIEnv * env, jobject obj, jint imageWidth, jint imageHeight, jint orientation, jboolean needMirror,
                                                                                                      jbyteArray pInputImage, jint textureOut)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getColorConvertHandle(env, obj);
    if(handle == NULL){
        LOGE("ColorConvert handle is null");
        return ST_E_HANDLE;
    }

    jbyte *srcdata = (jbyte*) (env->GetPrimitiveArrayCritical(pInputImage, 0));

    if(handle != NULL) {
        result = st_mobile_nv12_buffer_to_rgba_tex(handle, imageWidth, imageHeight, (st_rotate_type)orientation, (bool)needMirror, (unsigned char *)srcdata, textureOut);
    }
    env->ReleasePrimitiveArrayCritical(pInputImage, srcdata, 0);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_rgbaTextureToNv12Buffer(JNIEnv * env, jobject obj, jint textureId, jint width, jint height, jbyteArray pOutputImage)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getColorConvertHandle(env, obj);
    if(handle == NULL){
        LOGE("ColorConvert handle is null");
        return ST_E_HANDLE;
    }

    jbyte *dstdata = (jbyte*) env->GetPrimitiveArrayCritical(pOutputImage, 0);

    if(handle != NULL) {
        result = st_mobile_rgba_tex_to_nv12_buffer(handle, textureId, width, height, (unsigned char *)dstdata);
    }
    env->ReleasePrimitiveArrayCritical(pOutputImage, dstdata, 0);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_rgbaTextureToGray8Buffer(JNIEnv * env, jobject obj, jint textureId, jint width, jint height, jbyteArray pOutputImage)
{
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t handle = getColorConvertHandle(env, obj);
    if(handle == NULL){
        LOGE("ColorConvert handle is null");
        return ST_E_HANDLE;
    }

    jbyte *dstdata = (jbyte*) env->GetPrimitiveArrayCritical(pOutputImage, 0);

    st_multiplane_image_t input_image = {0};
    memset(&input_image, 0, sizeof(st_multiplane_image_t));
    input_image.width = width;
    input_image.height = height;
    input_image.format = ST_PIX_FMT_GRAY8;
    input_image.strides[0] = width;
    input_image.strides[1] = width;
    input_image.strides[2] = width;
    input_image.planes[0] = (unsigned char *)dstdata;

    if(handle != NULL) {
        result = st_mobile_convert_rgba_tex_2_gray8_buffer(handle, textureId, &input_image);
    }
    env->ReleasePrimitiveArrayCritical(pOutputImage, dstdata, 0);

    return result;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileColorConvertNative_destroyInstance(JNIEnv * env, jobject obj)
{
    st_handle_t handle = getColorConvertHandle(env, obj);
    if(handle == NULL)
    {
        return;
    }
    setColorConvertHandle(env, obj, NULL);
    st_mobile_color_convert_destroy(handle);
}