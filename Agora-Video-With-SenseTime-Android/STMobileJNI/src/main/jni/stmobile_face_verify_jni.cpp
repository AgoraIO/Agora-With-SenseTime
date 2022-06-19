#include <jni.h>
#include <android/log.h>
#include "utils.h"

#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <st_mobile_common.h>
#include <st_mobile_verify.h>

#define  LOG_TAG "STMobileFaceVerifyNative"

extern "C" {
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_createInstance(JNIEnv * env, jobject obj, jstring modelPath);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager);
    JNIEXPORT jbyteArray JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_getFeature(JNIEnv * env, jobject obj, jobject pInputImage, jobject face106Array);
    JNIEXPORT float JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_getFeaturesCompareScore(JNIEnv * env, jobject obj, jbyteArray pFeature_1, jbyteArray pFeature_2);
    JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_destroyInstance(JNIEnv * env, jobject obj);
}

static inline jfieldID getFaceVerifyHandleField(JNIEnv *env, jobject obj)
{
    jclass c = env->GetObjectClass(obj);
    // J is the type signature for long:
    return env->GetFieldID(c, "STMobileFaceVerifyNativeHandle", "J");
}

void setFaceVerifyHandle(JNIEnv *env, jobject obj, void * h)
{
    jlong handle = reinterpret_cast<jlong>(h);
    env->SetLongField(obj, getFaceVerifyHandleField(env, obj), handle);
}

void* getFaceVerifyHandle(JNIEnv *env, jobject obj)
{
    jlong handle = env->GetLongField(obj, getFaceVerifyHandleField(env, obj));
    return reinterpret_cast<void *>(handle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_createInstance(JNIEnv * env, jobject obj, jstring modelPath) {
    st_handle_t  ha_handle = NULL;
	if (modelPath == NULL) {
	    LOGE("model path is null");
	    return ST_E_INVALIDARG;
	}
    const char *model_path_Chars = env->GetStringUTFChars(modelPath, 0);

    int result = st_mobile_verify_create(model_path_Chars, &ha_handle);
    if(result != 0) {
        LOGE("create handle for face verify failed");
        env->ReleaseStringUTFChars(modelPath, model_path_Chars);
        return result;
    }

    setFaceVerifyHandle(env, obj, ha_handle);
    env->ReleaseStringUTFChars(modelPath, model_path_Chars);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager){
    st_handle_t handle = NULL;
    if(NULL == model_path){
        LOGE("model_file_name is null, create handle with null model");
        return ST_E_INVALIDARG;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_E_INVALIDARG;
    }

    const char* model_file_name_str = env->GetStringUTFChars(model_path, 0);
    if(NULL == model_file_name_str) {
        LOGE("change model_file_name to c_str failed");
        return ST_E_INVALIDARG;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_E_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, model_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(model_path, model_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        return ST_E_FILE_NOT_FOUND;
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
        return ST_E_FILE_NOT_FOUND;
    }

    AAsset_close(asset);

    if (size < 1000) {
        LOGE("Model file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        return ST_E_INVALID_FILE_FORMAT;
    }

    int result = st_mobile_verify_create_from_buffer(buffer, size, &handle);
    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("create handle failed, %d",result);
        return result;
    }

    setFaceVerifyHandle(env, obj, handle);
    return result;
}

JNIEXPORT jbyteArray JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_getFeature(JNIEnv * env, jobject obj, jobject pInputImage, jobject face106Array){
    st_handle_t handle = getFaceVerifyHandle(env, obj);
    if(handle == NULL) {
        LOGE("handle is null");
        return NULL;
    }

    if (pInputImage == NULL) {
        LOGE("input image is null");
        return NULL;
    }

    if (face106Array == NULL) {
        LOGE("face 106 is null");
        return NULL;
    }

    st_image_t image = {0};
    if (!convert2Image(env, pInputImage, &image)) {
        memset(&image, 0, sizeof(st_image_t));
    }

    st_mobile_106_t p_mobile_106 = {0};
    if (!convert2mobile_106(env, face106Array, p_mobile_106)) {
        memset(&p_mobile_106, 0, sizeof(st_mobile_106_t));
    }

    char *pFeature = NULL;
    unsigned int size = 0;

    int result = st_mobile_verify_get_feature(handle, &image, p_mobile_106.points_array, 106, &pFeature, &size);
    LOGE("result get_feature : %d", result);

    if (result == ST_OK) {
        if (pFeature == NULL) {
            LOGE("face pFeature is null, please allocate it on java");
        } else {
            jbyteArray pFeatureArray = env->NewByteArray(size);
            env->SetByteArrayRegion(pFeatureArray, 0, size, (jbyte*)pFeature);

            return pFeatureArray;
        }
    }

    return NULL;
}

JNIEXPORT float JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_getFeaturesCompareScore(JNIEnv * env, jobject obj, jbyteArray pFeature_1, jbyteArray pFeature_2)
{
    st_handle_t handle = getFaceVerifyHandle(env, obj);
    if(handle == NULL) {
        LOGE("handle is null");
        return ST_E_INVALIDARG;
    }

    if (pFeature_1 == NULL || pFeature_2 == NULL) {
        LOGE("input feature is null");
        return ST_E_INVALIDARG;
    }

    jbyte *feature_1 = (jbyte*) (env->GetByteArrayElements(pFeature_1, 0));
    jbyte *feature_2 = (jbyte*) (env->GetByteArrayElements(pFeature_2, 0));
    int len_1 = env->GetArrayLength(pFeature_1);
    int len_2 = env->GetArrayLength(pFeature_2);

    float score = 0;

    int result = st_mobile_verify_get_features_compare_score(handle, (char *)feature_1, len_1, (char *)feature_2, len_2, &score);

    env->ReleaseByteArrayElements(pFeature_1, feature_1, 0);
    env->ReleaseByteArrayElements(pFeature_2, feature_2, 0);
    LOGE("result compare_score : %d", result);

    return score;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileFaceVerifyNative_destroyInstance(JNIEnv * env, jobject obj)
{
    st_handle_t handle = getFaceVerifyHandle(env, obj);
	if(handle != NULL) {
	    LOGI(" face verify destroy");
        setFaceVerifyHandle(env, obj, NULL);
	    st_mobile_verify_destroy(handle);
	}
}