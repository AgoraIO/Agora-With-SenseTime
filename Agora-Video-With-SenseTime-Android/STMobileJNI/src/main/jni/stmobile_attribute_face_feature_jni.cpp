#include <jni.h>
#include <st_mobile_common.h>
#include <st_mobile_attribute_face_feature.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include "utils.h"
#include "utils_avatar.h"

#define  LOG_TAG    "STMobileAttributeFaceFeatureNative"

extern "C" {
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_createInstance(JNIEnv * env, jobject obj, jstring modelpath);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileHumanActionNative_createInstanceWithSubModels(JNIEnv * env, jobject obj, jobjectArray modelPaths, jint modelCount);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_addSubModel(JNIEnv * env, jobject obj, jstring modelpath);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_addSubModelFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_removeSubModelByConfig(JNIEnv * env, jobject obj, jint config);
JNIEXPORT jobject JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_faceFeaturesDetect(JNIEnv * env, jobject obj, jobject face, jint gender, jint faceCount, jbyteArray pInputImage, jint imageFormat,
                                                                                                            jlong face_feature_config, jint rotate, jint imageWidth, jint imageHeight);
JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_destroyInstance(JNIEnv * env, jobject obj);
};

static inline jfieldID getAttributeFaceFeatureHandleField(JNIEnv *env, jobject obj)
{
    jclass c = env->GetObjectClass(obj);
    // J is the type signature for long:
    return env->GetFieldID(c, "nativeAttributeFaceFeatureHandle", "J");
}

void setAttributeFaceFeatureHandle(JNIEnv *env, jobject obj, void * h)
{
    jlong handle = reinterpret_cast<jlong>(h);
    env->SetLongField(obj, getAttributeFaceFeatureHandleField(env, obj), handle);
}

void* getAttributeFaceFeatureHandle(JNIEnv *env, jobject obj)
{
    jlong handle = env->GetLongField(obj, getAttributeFaceFeatureHandleField(env, obj));
    return reinterpret_cast<void *>(handle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_createInstance(JNIEnv * env, jobject obj, jstring modelpath)
{
    st_handle_t  ha_handle = NULL;
    if (modelpath == NULL) {
        LOGE("model path is null");
        return ST_E_INVALIDARG;
    }
    const char *modelpathChars = env->GetStringUTFChars(modelpath, 0);
    LOGI("-->> modelpath=%s", modelpathChars);
    int result = st_mobile_attr_face_create(modelpathChars, &ha_handle);
    if(result != 0){
        LOGE("create handle for attribute face feature failed");
        env->ReleaseStringUTFChars(modelpath, modelpathChars);
        return result;
    }
    setAttributeFaceFeatureHandle(env, obj, ha_handle);
    env->ReleaseStringUTFChars(modelpath, modelpathChars);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager){
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
    unsigned char* buffer = NULL;
    int size = 0;
    if (NULL == asset){
        LOGE("open asset file failed");
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    size = AAsset_getLength(asset);
    buffer = new unsigned char[size];
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

    int result = st_mobile_attr_face_create_from_buffer(buffer, size, &handle);
    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("create handle failed, %d",result);
        return result;
    }

    setAttributeFaceFeatureHandle(env, obj, handle);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_createInstanceWithSubModels(JNIEnv * env, jobject obj, jobjectArray modelPaths, jint modelCount)
{
    st_handle_t human_action_handle = NULL;

    if (modelPaths == NULL) {
        LOGE("model path is null");
        return ST_E_INVALIDARG;
    }

    jint count = env->GetArrayLength(modelPaths);
    const char *modelpathChars[count];
    jstring modelPathStrings[count];

    for(int i = 0; i < count; i++){
        modelPathStrings[i] = (jstring)env->GetObjectArrayElement(modelPaths, i);
        modelpathChars[i] = env->GetStringUTFChars(modelPathStrings[i], 0);
    }

    int result = st_mobile_attr_face_create_with_sub_models(modelpathChars, count, &human_action_handle);

    if(result == 0){
        setAttributeFaceFeatureHandle(env, obj, human_action_handle);
    }

    for(int i = 0; i < count; i++){
        env->ReleaseStringUTFChars(modelPathStrings[i], modelpathChars[i]);
    }
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_addSubModel(JNIEnv * env, jobject obj, jstring modelpath)
{
    st_handle_t attributeFaceFeaturehandle = getAttributeFaceFeatureHandle(env, obj);
    if(attributeFaceFeaturehandle == NULL) {
        LOGE("handle is null");
        return ST_E_INVALIDARG;
    }

    if (modelpath == NULL) {
        LOGE("model path is null");
        return ST_E_INVALIDARG;
    }
    const char *modelpathChars = env->GetStringUTFChars(modelpath, 0);
    int result = st_mobile_attr_face_add_sub_model(attributeFaceFeaturehandle, modelpathChars);

    LOGE("add sub model result: %d", result);
    env->ReleaseStringUTFChars(modelpath, modelpathChars);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_addSubModelFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager){

    st_handle_t attributeFaceFeaturehandle = getAttributeFaceFeatureHandle(env, obj);
    if(attributeFaceFeaturehandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(NULL == model_path){
        LOGE("model_file_name is null, create handle with null model");
        return ST_JNI_ERROR_INVALIDARG;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    const char* model_file_name_str = env->GetStringUTFChars(model_path, 0);
    if(NULL == model_file_name_str) {
        LOGE("change model_file_name to c_str failed");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, model_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(model_path, model_file_name_str);
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

    if (size < 1000) {
        LOGE("Model file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        return ST_JNI_ERROR_FILE_SIZE;
    }

    int result = st_mobile_attr_face_add_sub_model_from_buffer(attributeFaceFeaturehandle, buffer, size);
    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("add sub model failed, %d",result);
        return result;
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_removeSubModelByConfig(JNIEnv * env, jobject obj, jint config){
    st_handle_t attributeFaceFeaturehandle = getAttributeFaceFeatureHandle(env, obj);
    if(attributeFaceFeaturehandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int ret = st_mobile_attr_face_remove_model_by_config(attributeFaceFeaturehandle, config);

    return ret;
}

JNIEXPORT jobject JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_faceFeaturesDetect(JNIEnv * env, jobject obj, jobject face, jint gender, jint faceCount, jbyteArray pInputImage, jint imageFormat,
                                                                                                            jlong face_feature_config, jint rotate, jint imageWidth, jint imageHeight)
{
    LOGI("detectFaceFeatures, the width is %d, the height is %d, the rotate is %d",imageWidth, imageHeight, rotate);
    st_handle_t attributeFaceFeaturehandle = getAttributeFaceFeatureHandle(env, obj);
    if(attributeFaceFeaturehandle == NULL)
    {
        LOGE("handle is null");
        return NULL;
    }
    if (pInputImage == NULL) {
        LOGE("input image is null");
        return NULL;
    }

    if(faceCount <= 0){
        LOGE("input faceCount is invalid");
        return NULL;
    }

    st_mobile_face_t* st_face = new st_mobile_face_t[faceCount];
    if (!convert2FaceInfo(env, face, st_face)) {
        memset(&st_face, 0, sizeof(st_face));
    }

    st_mobile_attr_gender* st_gender = new st_mobile_attr_gender[faceCount];
    st_gender[0] = (st_mobile_attr_gender)gender;

    jbyte *srcdata = (jbyte*) (env->GetByteArrayElements(pInputImage, 0));
    int image_stride = getImageStride((st_pixel_format)imageFormat, imageWidth);

    st_mobile_attr_face_t* attribute_face_feature;

    int result = -1;
    long startTime = getCurrentTime();
    if(attributeFaceFeaturehandle != NULL)
    {
        LOGI("before detect");
        result =  st_mobile_attr_face_detect(attributeFaceFeaturehandle, st_face, st_gender, faceCount, (unsigned char *)srcdata,  (st_pixel_format)imageFormat, imageWidth,
                                             imageHeight, image_stride, (st_rotate_type)rotate, face_feature_config, &attribute_face_feature);
        LOGI("st_mobile_attribute_detect_face_features --- result is %d", result);
    }

    long afterdetectTime = getCurrentTime();
    LOGI("the face features detected time is %ld", (afterdetectTime - startTime));
    env->ReleaseByteArrayElements(pInputImage, srcdata, 0);

    jobject faceFeature = NULL;
    if (result == ST_OK)
    {
        faceFeature = convert2FaceFeature(env, attribute_face_feature, gender == GENDER_MALE);
    }
    delete[] st_gender;
    delete[] st_face;

    return faceFeature;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileAttributeFaceFeatureNative_destroyInstance(JNIEnv * env, jobject obj)
{
    st_handle_t attributeFaceFeaturehandle = getAttributeFaceFeatureHandle(env, obj);
    if(attributeFaceFeaturehandle != NULL)
    {
        LOGI("attribute face feature destory");
        setAttributeFaceFeatureHandle(env,obj,NULL);
        st_mobile_attr_face_destroy(attributeFaceFeaturehandle);
    }
}