#include <jni.h>

#include<fcntl.h>
#include <st_mobile_animal.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include "utils.h"

#define  LOG_TAG    "STMobileAnimal"

extern "C" {
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_createInstance(JNIEnv * env, jobject obj, jstring modelpath, jint config);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jint config, jobject assetManager);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_setParam(JNIEnv * env, jobject obj, jint type, jfloat value);
    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_reset(JNIEnv * env, jobject obj);
    JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_animalDetect(JNIEnv * env, jobject obj, jbyteArray pInputImage, jint imageFormat,
                                                                                             jint rotate, jint imageWidth, jint imageHeight);
    JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_destroyInstance(JNIEnv * env, jobject obj);

    JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_animalMirror(JNIEnv * env, jobject obj, jint width, jobjectArray animalface, jint faceCount);
    JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_animalRotate(JNIEnv * env, jobject obj, jint width, jint height, jint orientation, jobjectArray animalfaces, jint faceCount);
    JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_animalResize(JNIEnv * env, jobject obj, jfloat scale, jobjectArray animalfaces, jint faceCount);
};

static inline jfieldID getAnimalHandleField(JNIEnv *env, jobject obj)
{
    jclass c = env->GetObjectClass(obj);
    // J is the type signature for long:
    return env->GetFieldID(c, "nativeAnimalHandle", "J");
}

void setAnimalHandle(JNIEnv *env, jobject obj, void * h)
{
    jlong handle = reinterpret_cast<jlong>(h);
    env->SetLongField(obj, getAnimalHandleField(env, obj), handle);
}

void* getAnimalHandle(JNIEnv *env, jobject obj)
{
    jlong handle = env->GetLongField(obj, getAnimalHandleField(env, obj));
    return reinterpret_cast<void *>(handle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_createInstance(JNIEnv * env, jobject obj, jstring modelpath, jint config)
{
    st_handle_t  animal_handle = NULL;
    if (modelpath == NULL) {
        LOGE("model path is null");
        return ST_E_INVALIDARG;
    }
    const char *modelpathChars = env->GetStringUTFChars(modelpath, 0);
    LOGI("-->> modelpath=%s, config=%d", modelpathChars, config);
    int result = st_mobile_tracker_animal_face_create(modelpathChars, config, &animal_handle);
    if(result != 0){
        LOGE("create handle for animal failed");
        env->ReleaseStringUTFChars(modelpath, modelpathChars);
        return result;
    }
    setAnimalHandle(env, obj, animal_handle);
    env->ReleaseStringUTFChars(modelpath, modelpathChars);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jint config, jobject assetManager){
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

    if (size < 100){
        LOGE("Model file is too samll");
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }
        return ST_JNI_ERROR_FILE_SIZE;
    }

    int result = st_mobile_tracker_animal_face_create_from_buffer(buffer, size, (int)config, &handle);
    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("create handle failed, %d",result);
        return result;
    }

    setAnimalHandle(env, obj, handle);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_setParam(JNIEnv * env, jobject obj, jint type, jfloat value)
{
    st_handle_t handle = getAnimalHandle(env, obj);
    if(handle == NULL)
    {
        return JNI_FALSE;
    }
    LOGE("set Param for %d, %f", type, value);
    int result = (int)st_mobile_tracker_animal_face_setparam(handle,(st_animal_face_param_type)type,value);
    return 0;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_reset(JNIEnv * env, jobject obj)
{
    st_handle_t animalhandle = getAnimalHandle(env, obj);
    if(animalhandle != NULL)
    {
        return st_mobile_tracker_animal_face_reset(animalhandle);
    }

    return ST_E_HANDLE;
}


JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_animalDetect(JNIEnv * env, jobject obj, jbyteArray pInputImage, jint imageFormat,
                                                                                                   jint rotate, jint imageWidth, jint imageHeight)
{
    LOGI("animalDetect, the width is %d, the height is %d, the rotate is %d",imageWidth, imageHeight, rotate);
    st_handle_t animalhandle = getAnimalHandle(env, obj);
    if(getAnimalHandle == NULL)
    {
        LOGE("handle is null");
        return NULL;
    }

    if (pInputImage == NULL) {
        LOGE("input image is null");
        return NULL;
    }

    jbyte *srcdata = (jbyte*) (env->GetByteArrayElements(pInputImage, 0));
    int image_stride = getImageStride((st_pixel_format)imageFormat, imageWidth);

    st_mobile_animal_face_t* animal_face;
    int animal_face_count = 0;

    int result = -1;
    long startTime = getCurrentTime();
    if(animalhandle != NULL)
    {
        LOGI("before detect");
        result =  st_mobile_tracker_animal_face_track(animalhandle, (unsigned char *)srcdata,  (st_pixel_format)imageFormat,  imageWidth,
                                                imageHeight, image_stride, (st_rotate_type)rotate, &animal_face, &animal_face_count);
        LOGI("st_mobile_tracker_animal_face_track --- result is %d", result);
    }

    long afterdetectTime = getCurrentTime();
    LOGI("the animal detected time is %ld", (afterdetectTime - startTime));
    LOGE("the face count is %d", animal_face_count);
    env->ReleaseByteArrayElements(pInputImage, srcdata, 0);

    jobjectArray animal_face_array = NULL;
    if (result == ST_OK && animal_face_count > 0)
    {
        jclass animal_face_cls = env->FindClass("com/sensetime/stmobile/model/STAnimalFace");
        animal_face_array = env->NewObjectArray(animal_face_count, animal_face_cls, 0);

        for(int i = 0; i < animal_face_count; i++){
            jobject animalFace = NULL;
            animalFace = convert2AnimalFace(env, animal_face+i);
            env->SetObjectArrayElement(animal_face_array, i, animalFace);
            env->DeleteLocalRef(animalFace);
        }
        env->DeleteLocalRef(animal_face_cls);

    }

    return animal_face_array;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_destroyInstance(JNIEnv * env, jobject obj)
{
    st_handle_t animalhandle = getAnimalHandle(env, obj);
    if(animalhandle != NULL)
    {
        LOGI(" animal handle destory");
        setAnimalHandle(env,obj,NULL);
        st_mobile_tracker_animal_face_destroy(animalhandle);
    }
}

JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_animalMirror(JNIEnv * env, jobject obj, jint width, jobjectArray animalfaces, jint faceCount)
{
    if(animalfaces == NULL){
        return NULL;
    }

    st_mobile_animal_face_t* animal_face = new st_mobile_animal_face_t[faceCount];
    for(int i = 0; i < faceCount; i++){
        jobject animalFace = env->GetObjectArrayElement(animalfaces, i);
        if (!convert2AnimalFace(env, animalFace, animal_face + i)) {
            memset(&animal_face, 0, sizeof(animal_face));
        }
    }

    st_mobile_animal_face_mirror(width, animal_face, faceCount);

    jclass animal_face_cls = env->FindClass("com/sensetime/stmobile/model/STAnimalFace");

    jobjectArray animalFaces = env->NewObjectArray(faceCount, animal_face_cls, 0);
    for(int i = 0; i < faceCount; i++){
        jobject animalFace = env->AllocObject(animal_face_cls);
        animalFace = convert2AnimalFace(env, animal_face + i);
        env->SetObjectArrayElement(animalFaces, i, animalFace);
        env->DeleteLocalRef(animalFace);
    }
    env->DeleteLocalRef(animal_face_cls);
    releaseAnimal(animal_face, faceCount);

    return animalFaces;
}

JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_animalRotate(JNIEnv * env, jobject obj, jint width, jint height, jint orientation, jobjectArray animalfaces, jint faceCount)
{
    if(animalfaces == NULL){
        return NULL;
    }
    st_mobile_animal_face_t* animal_face = new st_mobile_animal_face_t[faceCount];
    for(int i = 0; i < faceCount; i++){
        jobject animalFace = env->GetObjectArrayElement(animalfaces, i);
        if (!convert2AnimalFace(env, animalFace, animal_face + i)) {
            memset(&animal_face, 0, sizeof(animal_face));
        }
    }

    st_mobile_animal_face_rotate(width, height, (st_rotate_type)orientation, animal_face, faceCount);

    jclass animal_face_cls = env->FindClass("com/sensetime/stmobile/model/STAnimalFace");

    jobjectArray animalFaces = env->NewObjectArray(faceCount, animal_face_cls, 0);
    for(int i = 0; i < faceCount; i++){
        jobject animalFace = env->AllocObject(animal_face_cls);
        animalFace = convert2AnimalFace(env, animal_face + i);
        env->SetObjectArrayElement(animalFaces, i, animalFace);
        env->DeleteLocalRef(animalFace);
    }
    env->DeleteLocalRef(animal_face_cls);

    releaseAnimal(animal_face, faceCount);

    return animalFaces;
}

JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobileAnimalNative_animalResize(JNIEnv * env, jobject obj, jfloat scale, jobjectArray animalfaces, jint faceCount)
{
    if(animalfaces == NULL){
        LOGE("animal handle is null");
        return NULL;
    }

    st_mobile_animal_face_t* animal_face = new st_mobile_animal_face_t[faceCount];
    for(int i = 0; i < faceCount; i++){
        jobject animalFace = env->GetObjectArrayElement(animalfaces, i);
        if (!convert2AnimalFace(env, animalFace, animal_face + i)) {
            memset(&animal_face, 0, sizeof(animal_face));
        }
    }

    st_mobile_animal_face_resize(scale, animal_face, faceCount);

    jclass animal_face_cls = env->FindClass("com/sensetime/stmobile/model/STAnimalFace");

    jobjectArray animalFaces = env->NewObjectArray(faceCount, animal_face_cls, 0);
    for(int i = 0; i < faceCount; i++){
        jobject animalFace = env->AllocObject(animal_face_cls);
        animalFace = convert2AnimalFace(env, animal_face + i);
        env->SetObjectArrayElement(animalFaces, i, animalFace);
        env->DeleteLocalRef(animalFace);
    }
    env->DeleteLocalRef(animal_face_cls);

    releaseAnimal(animal_face, faceCount);

    return animalfaces;
}


