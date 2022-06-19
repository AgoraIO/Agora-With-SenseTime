#include <jni.h>

#include<fcntl.h>
#include <st_mobile_gen_avatar.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <st_mobile_common.h>
#include "utils.h"
#include "utils_avatar.h"

#define  LOG_TAG    "STMobilePinchAvatarNative"

extern "C"{
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_createInstance(JNIEnv * env, jobject obj, jint config);
//    JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager);
JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_destroyInstance(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadBasePackage(JNIEnv * env, jobject obj, jstring path, jintArray packageId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadBasePackageFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray packageId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setAvatarVisiable(JNIEnv * env, jobject obj, jboolean visiable);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_autoPinchFace(JNIEnv * env, jobject obj, jint imageWidth, jint imageHeight, jint rotate, jobject humanAction, jboolean isMale);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getFaceFeatures(JNIEnv * env, jobject obj, jint featureIdx);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadBoneTransformConfig(JNIEnv * env, jobject obj, jstring path);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_updateBoneControllerInfo(JNIEnv * env, jobject obj, jobjectArray controllers, jint count);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadBoneTransformConfigFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeSkinColor(JNIEnv * env, jobject obj, jobject color);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addFeature(JNIEnv * env, jobject obj, jstring path, jintArray featureId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setFeatureVisiable(JNIEnv * env, jobject obj, jint featureId, jboolean visiable);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addFeatureFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray featureId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeFeatureColor(JNIEnv * env, jobject obj, jint featureId, jobject color);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeFeature(JNIEnv * env, jobject obj, jint featureId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_clearFeatures(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addMakeUp(JNIEnv * env, jobject obj, jstring path, jintArray makeupId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addMakeUpFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray makeupId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeMakeUpColor(JNIEnv * env, jobject obj, jint makeupId, jobject color);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeMakeUp(JNIEnv * env, jobject obj, jint makeupId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_clearMakeUps(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setFacingMode(JNIEnv * env, jobject obj, jint faceMode);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_rotate(JNIEnv * env, jobject obj, jfloat rotateAngle);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getFacingMode(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_exportPinchConfig(JNIEnv * env, jobject obj, jstring exportJsonPath);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getPinchConfigBufferLength(JNIEnv * env, jobject obj, jintArray bufferLength, jint dataFormat);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_exportPinchConfigToBuffer(JNIEnv * env, jobject obj, jbyteArray outputBuffer, jint dataFormat);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadPinchConfig(JNIEnv * env, jobject obj, jstring configPath);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadPinchConfigFromAsset(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jint dataFormat);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadPinchConfigFromBuffer(JNIEnv * env, jobject obj, jbyteArray buffer, jint len, jint dataFormat);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadAnimationClip(JNIEnv * env, jobject obj, jstring path, jintArray clipId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_unloadAnimationClip(JNIEnv * env, jobject obj, jint clipId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadAnimationClipFromAssetsFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray clipId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_playAnimationStack(JNIEnv * env, jobject obj, jobjectArray targets);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getAnimationClipCount(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeAnimation(JNIEnv * env, jobject obj, jint clipId, jfloat transitSec);
JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_stopAnimation(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setDisplayMode(JNIEnv * env, jobject obj, jint displayMode);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getDisplayMode(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_processTexture(JNIEnv * env, jobject obj, jobject humanActionNativeObj, jint textureInput, jint imageWidth, jint imageHeight, jint rotate, jobject humanAction, jint textureOutput);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_processTexture2(JNIEnv * env, jobject obj, jlong humanActionNativeHandle, jlong humanActionNativeResult, jint textureInput, jint imageWidth, jint imageHeight, jint rotate, jint textureOutput);
JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_resetBodyPose(JNIEnv * env, jobject obj);
JNIEXPORT jlong JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getDetectConfig(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setBackgroundFromBuffer(JNIEnv * env, jobject obj, jbyteArray imageData, jint backgroundType, jintArray backgroundId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setBackgroundColor(JNIEnv * env, jobject obj, jobject color);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setBackgroundFromPath(JNIEnv * env, jobject obj, jstring path, jintArray backgroundId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeBackground(JNIEnv * env, jobject obj, jint backgroundId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setCameraLookAt(JNIEnv * env, jobject obj, jfloatArray position, jfloatArray target, jfloatArray up, jfloat transitSec);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setCameraPerspective(JNIEnv * env, jobject obj, jfloat fov, jfloat aspect, jfloat znear, jfloat zfar);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setCameraOrthogonal(JNIEnv * env, jobject obj, jfloat left, jfloat right, jfloat bottom, jfloat top, jfloat znear, jfloat zfar);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_lockFaceFittingCamera(JNIEnv * env, jobject obj, jboolean lock);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_resetFacePose(JNIEnv * env, jobject obj, jint postType);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addAvatar(JNIEnv * env, jobject obj, jstring avatarPath, jintArray avatarId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addAvatarFromBuffer(JNIEnv * env, jobject obj, jstring avatarPath, jobject assetManager, jintArray avatarId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeAvatar(JNIEnv * env, jobject obj, int avatarId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_rotateAvatar(JNIEnv * env, jobject obj, float angle);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_translateAvatar(JNIEnv * env, jobject obj, jfloatArray translate);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_scaleAvatar(JNIEnv * env, jobject obj, jfloatArray scale);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_activeAvatar(JNIEnv * env, jobject obj, jint activeId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_cloneAvatar(JNIEnv * env, jobject obj, jint srcAvatarId, jintArray avatarId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_freezeFeatureDynamicBone(JNIEnv * env, jobject obj, jint featureId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadGenfaceConfig(JNIEnv * env, jobject obj, jstring modelPath, jstring configPath, jstring pinchModelPath);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadGenfaceConfigFromBuffer(JNIEnv * env, jobject obj, jobject assetManager, jstring modelPath, jstring configPath, jstring pinchModelPath);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_genFace(JNIEnv * env, jobject obj, jbyteArray data, jint format, jint imageWidth, jint imageHeight, jint rotate, jobject humanAction, jboolean isMale, jint avatarId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_genPinchFaceBlendShapeCount(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_resetGenFace(JNIEnv * env, jobject obj, jint avatarId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_unloadGenfaceConfig(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setFittingScale(JNIEnv *env, jobject obj, jint part, jfloat scale);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setUpbodyIkEnabled(JNIEnv *env, jobject obj, jboolean enable);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getEyebrowType(JNIEnv *env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addAsset(JNIEnv * env, jobject obj, jstring path, jintArray assetId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeAssetColor(JNIEnv * env, jobject obj, jint makeupId, jobjectArray color, int count);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addAssetFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray assetId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeAsset(JNIEnv * env, jobject obj, jint assetId);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeAllAsset(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_genPinchFaceBoneCount(JNIEnv * env, jobject obj);
JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getAutoPinchResult(JNIEnv * env, jobject obj, jint imageWidth, jint imageHeight, jint rotate, jobject humanAction, jboolean isMale,
                                                                                                jint boneTransformCount, jobjectArray boneTransformArray, jint blendShapeSize, jfloatArray blendShapeArray, jint featureIdCount, jintArray featureIdArray);

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getFaceExpression(JNIEnv *env, jobject obj, jint width, jint height, jint rotate, jobject humanActionObj, jfloatArray values);
JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_calcStandardPose(JNIEnv *env, jobject obj, jint width, jint height, jint rotate, jobject humanAction, jfloat fov);
};

static inline jfieldID getPinchAvatarHandleField(JNIEnv *env, jobject obj){
    jclass c = env->GetObjectClass(obj);
    // J is the type signature for long:
    return env->GetFieldID(c, "nativeAvatarHandle", "J");
}

void* getPinchAvatarHandle(JNIEnv *env, jobject obj){
    jlong handle = env->GetLongField(obj, getPinchAvatarHandleField(env, obj));
    return reinterpret_cast<void *>(handle);
}

void setPinchAvatarHandle(JNIEnv *env, jobject obj, void * h){
    jlong handle = reinterpret_cast<jlong>(h);
    env->SetLongField(obj, getPinchAvatarHandleField(env, obj), handle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_createInstance(JNIEnv * env, jobject obj, jint config)
{
    st_handle_t  avatar_handle = NULL;

    int result = st_mobile_gen_avatar_create(config, &avatar_handle);
    if(result != 0){
        LOGE("create handle for avatar failed");
        return result;
    }
    setPinchAvatarHandle(env, obj, avatar_handle);
    return result;
}

//JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_createInstanceFromAssetFile(JNIEnv * env, jobject obj, jstring model_path, jobject assetManager){
//    st_handle_t handle = NULL;
//    if(NULL == model_path){
//        LOGE("model_path is null");
//        return ST_JNI_ERROR_INVALIDARG;
//    }
//
//    if(NULL == assetManager){
//        LOGE("assetManager is null");
//        return ST_JNI_ERROR_INVALIDARG;
//    }
//
//    const char* model_file_name_str = env->GetStringUTFChars(model_path, 0);
//    if(NULL == model_file_name_str){
//        LOGE("change model_path to c_str failed");
//        return ST_JNI_ERROR_INVALIDARG;
//    }
//    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
//    if(NULL == mgr){
//        LOGE("native assetManager is null");
//        return ST_JNI_ERROR_INVALIDARG;
//    }
//
//    LOGE("asset %s",model_file_name_str);
//    AAsset* asset = AAssetManager_open(mgr, model_file_name_str, AASSET_MODE_UNKNOWN);
//    env->ReleaseStringUTFChars(model_path, model_file_name_str);
//    char* buffer = NULL;
//    int size = 0;
//    if (NULL == asset){
//        LOGE("open asset file failed");
//        return ST_JNI_ERROR_FILE_OPEN_FIALED;
//    }
//
//    size = AAsset_getLength(asset);
//    buffer = new char[size];
//    memset(buffer,'\0',size);
//    int readSize = AAsset_read(asset,buffer,size);
//
//    if (readSize != size){
//        AAsset_close(asset);
//        if(buffer){
//            delete[] buffer;
//            buffer = NULL;
//        }
//        return ST_JNI_ERROR_FILE_SIZE;
//    }
//
//    AAsset_close(asset);
//
//    if (size < 1000){
//        LOGE("Model file is too samll");
//        if(buffer){
//            delete[] buffer;
//            buffer = NULL;
//        }
//        return ST_JNI_ERROR_FILE_SIZE;
//    }
//
//    int result = st_mobile_gen_avatar_create_from_buffer(&handle, buffer, size);
//    if(buffer){
//        delete[] buffer;
//        buffer = NULL;
//    }
//
//    if(result != 0){
//        LOGE("create handle failed, %d",result);
//        return result;
//    }
//
//    setPinchAvatarHandle(env, obj, handle);
//    return result;
//}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_destroyInstance(JNIEnv * env, jobject obj){
    st_handle_t handle = getPinchAvatarHandle(env, obj);
    if(handle != NULL)
    {
        LOGI(" avatar handle destory");
        setPinchAvatarHandle(env, obj, NULL);
        st_mobile_gen_avatar_destroy(handle);
    }
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadBasePackage(JNIEnv * env, jobject obj, jstring path, jintArray packageId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (path != NULL) {
        pathChars = env->GetStringUTFChars(path, 0);
    }

    int package_id = 0;

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_reset_avatar(avatarhandle, pathChars, &package_id);
    }

    if(packageId != NULL){
        env->SetIntArrayRegion(packageId, 0, 1, &package_id);
    }

    if (pathChars != NULL) {
        env->ReleaseStringUTFChars(path, pathChars);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadBasePackageFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray packageId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int package_id = 0;

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    if(path == NULL){
        result = st_mobile_gen_avatar_reset_avatar(avatarHandle, NULL, &package_id);
        LOGE("change sticker to null");
        return result;
    }

    const char* sticker_file_name_str = env->GetStringUTFChars(path, 0);
    if(NULL == sticker_file_name_str) {
        result = st_mobile_gen_avatar_reset_avatar(avatarHandle, NULL, &package_id);
        LOGE("file_name to c_str failed, change sticker to null");
        return result;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, sticker_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(path, sticker_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        result = st_mobile_gen_avatar_reset_avatar(avatarHandle, NULL, &package_id);
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    char* buffer = NULL;
    long size = 0;
    size = AAsset_getLength(asset);
    buffer = new char[size];
    memset(buffer, '\0', size);

    long readSize = AAsset_read(asset, buffer, size);
    if (readSize != size) {
        AAsset_close(asset);
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }

        result = st_mobile_gen_avatar_reset_avatar(avatarHandle, NULL, &package_id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset);

    if (size < 100) {
        LOGE("Model file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        result = st_mobile_gen_avatar_reset_avatar(avatarHandle, NULL, &package_id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(avatarHandle != NULL) {
        result = st_mobile_gen_avatar_reset_avatar_from_buffer(avatarHandle, buffer, size, &package_id);
    }

    if(packageId != NULL){
        env->SetIntArrayRegion(packageId, 0, 1, &package_id);
    }

    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("load_package_from_buffer failed, %d",result);
        return result;
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setAvatarVisiable(JNIEnv * env, jobject obj, jboolean visiable){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarhandle != NULL){
        result = st_mobile_gen_avatar_set_avatar_visible(avatarhandle, visiable);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_autoPinchFace(JNIEnv * env, jobject obj, jint imageWidth, jint imageHeight, jint rotate, jobject humanAction, jboolean isMale){
    LOGE("autoPinchFace, the width is %d, the height is %d, the rotate is %d",imageWidth, imageHeight, rotate);
    int result = ST_JNI_ERROR_DEFAULT;

    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if(avatarhandle == NULL)
    {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_mobile_human_action_t human_action = {0};

    if (!convert2HumanAction(env, humanAction, &human_action)) {
        memset(&human_action, 0, sizeof(st_mobile_human_action_t));
    }

    long startTime = getCurrentTime();
    if(avatarhandle != NULL)
    {
        result  = st_mobile_gen_avatar_auto_pinch_face(avatarhandle, imageWidth, imageHeight, (st_rotate_type)rotate, &human_action, isMale);
        LOGI("-->>st_mobile_gen_avatar_auto_pinch_face --- result is %d", result);
    }

    long afterStickerTime = getCurrentTime();
    LOGI("process avatar time is %ld", (afterStickerTime - startTime));
    //	env->ReleasePrimitiveArrayCritical(pInputImage, srcdata, 0);

    releaseHumanAction(&human_action);

    //jclass vm_class = env->FindClass("dalvik/system/VMDebug");
    //jmethodID dump_mid = env->GetStaticMethodID( vm_class, "dumpReferenceTables", "()V" );
    //env->CallStaticVoidMethod( vm_class, dump_mid );

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getFaceFeatures(JNIEnv * env, jobject obj, jint featureIdx){
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int type_id;
    st_mobile_gen_avatar_get_face_features(avatarhandle, (st_avatar_feature_idx_t)featureIdx, &type_id);

    return type_id;
}

//JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadBoneTransformConfig(JNIEnv * env, jobject obj, jstring path){
//    int result = ST_JNI_ERROR_DEFAULT;
//    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);
//
//    if (avatarhandle == NULL) {
//        LOGE("handle is null");
//        return ST_E_HANDLE;
//    }
//
//    const char *pathChars = NULL;
//    if (path != NULL) {
//        pathChars = env->GetStringUTFChars(path, 0);
//    }
//
//    if(avatarhandle != NULL) {
//        result = st_mobile_gen_avatar_load_bone_transform_config(avatarhandle, pathChars);
//    }
//    if (pathChars != NULL) {
//        env->ReleaseStringUTFChars(path, pathChars);
//    }
//
//    return result;
//}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_updateBoneControllerInfo(JNIEnv * env, jobject obj, jobjectArray controllers, jint count){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_bone_controller_info_t* controller_infos = new st_bone_controller_info_t[count];
    for(int i = 0; i < count; i++){
        jobject controller = env->GetObjectArrayElement(controllers, i);
        if(!convert2Controller(env, controller, controller_infos + i)){
            memset(controller_infos + i, 0, sizeof(st_bone_controller_info_t));
        }
    }

    result = st_mobile_gen_avatar_update_bone_controller_info(avatarhandle, controller_infos, count);
    LOGE("updateBoneControllerInfo() result: %d", result);
    return result;
}

//JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadBoneTransformConfigFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager){
//    int result = ST_JNI_ERROR_DEFAULT;
//    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);
//
//    if (avatarHandle == NULL) {
//        LOGE("handle is null");
//        return ST_E_HANDLE;
//    }
//
//    if(NULL == assetManager){
//        LOGE("assetManager is null");
//        return ST_JNI_ERROR_INVALIDARG;
//    }
//
//    if(path == NULL){
//        result = st_mobile_gen_avatar_load_base_package(avatarHandle, NULL);
//        LOGE("change sticker to null");
//        return result;
//    }
//
//    const char* sticker_file_name_str = env->GetStringUTFChars(path, 0);
//    if(NULL == sticker_file_name_str) {
//        result = st_mobile_gen_avatar_load_base_package(avatarHandle, NULL);
//        LOGE("file_name to c_str failed, change sticker to null");
//        return result;
//    }
//
//    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
//    if(NULL == mgr) {
//        LOGE("native assetManager is null");
//        return ST_JNI_ERROR_INVALIDARG;
//    }
//
//    AAsset* asset = AAssetManager_open(mgr, sticker_file_name_str, AASSET_MODE_UNKNOWN);
//    env->ReleaseStringUTFChars(path, sticker_file_name_str);
//    if (NULL == asset) {
//        LOGE("open asset file failed");
//        result = st_mobile_gen_avatar_load_base_package(avatarHandle, NULL);
//        return ST_JNI_ERROR_FILE_OPEN_FIALED;
//    }
//
//    char* buffer = NULL;
//    long size = 0;
//    size = AAsset_getLength(asset);
//    buffer = new char[size];
//    memset(buffer, '\0', size);
//
//    long readSize = AAsset_read(asset, buffer, size);
//    if (readSize != size) {
//        AAsset_close(asset);
//        if(buffer){
//            delete[] buffer;
//            buffer = NULL;
//        }
//
//        result = st_mobile_gen_avatar_load_base_package(avatarHandle, NULL);
//        return ST_JNI_ERROR_FILE_SIZE;
//    }
//
//    AAsset_close(asset);
//
//    if (size < 100) {
//        LOGE("Model file is too short");
//        if (buffer) {
//            delete[] buffer;
//            buffer = NULL;
//        }
//        result = st_mobile_gen_avatar_load_base_package(avatarHandle, NULL);
//        return ST_JNI_ERROR_FILE_SIZE;
//    }
//
//    if(avatarHandle != NULL) {
//        result = st_mobile_gen_avatar_load_bone_transform_config_from_buffer(avatarHandle, buffer, size);
//    }
//
//    if(buffer){
//        delete[] buffer;
//        buffer = NULL;
//    }
//
//    if(result != 0){
//        LOGE("load_package_from_buffer failed, %d",result);
//        return result;
//    }
//
//    return result;
//}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeSkinColor(JNIEnv * env, jobject obj, jobject color){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_color_t st_color = {0};

    if (!convert2Color(env, color, &st_color)) {
        memset(&st_color, 0, sizeof(st_color_t));
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_change_skin_color(avatarHandle, &st_color);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addFeature(JNIEnv * env, jobject obj, jstring path, jintArray featureId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (path != NULL) {
        pathChars = env->GetStringUTFChars(path, 0);
    }

    int id = 0;

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_add_feature(avatarhandle, pathChars, &id);
        LOGI("add feature result: %d", result);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(featureId, 0 ,1, &id);
    }

    if (pathChars != NULL) {
        env->ReleaseStringUTFChars(path, pathChars);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setFeatureVisiable(JNIEnv * env, jobject obj, jint featureId, jboolean visiable){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_set_feature_visible(avatarHandle, featureId, visiable);
    }

    return result;

}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addFeatureFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray featureId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    int id = 0;

    if(path == NULL){
        result = st_mobile_gen_avatar_add_feature(avatarHandle, NULL, &id);
        LOGE("change sticker to null");
        return result;
    }

    const char* sticker_file_name_str = env->GetStringUTFChars(path, 0);
    if(NULL == sticker_file_name_str) {
        result = st_mobile_gen_avatar_add_feature(avatarHandle, NULL, &id);
        LOGE("file_name to c_str failed, change sticker to null");
        return result;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, sticker_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(path, sticker_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        result = st_mobile_gen_avatar_add_feature(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    char* buffer = NULL;
    long size = 0;
    size = AAsset_getLength(asset);
    buffer = new char[size];
    memset(buffer, '\0', size);

    long readSize = AAsset_read(asset, buffer, size);
    if (readSize != size) {
        AAsset_close(asset);
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }

        result = st_mobile_gen_avatar_add_feature(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset);

    if (size < 100) {
        LOGE("Model file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        result = st_mobile_gen_avatar_add_feature(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(avatarHandle != NULL) {
        result = st_mobile_gen_avatar_add_feature_from_buffer(avatarHandle, buffer, size, &id);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(featureId, 0 ,1, &id);
    }

    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("load_package_from_buffer failed, %d",result);
        return result;
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeFeatureColor(JNIEnv * env, jobject obj, jint featureId, jobject color){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_color_t st_color = {0};

    if (!convert2Color(env, color, &st_color)) {
        memset(&st_color, 0, sizeof(st_color_t));
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_change_feature_color(avatarHandle, featureId, &st_color);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeFeature(JNIEnv * env, jobject obj, jint featureId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_remove_feature(avatarHandle, featureId);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_clearFeatures(JNIEnv * env, jobject obj){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_clear_features(avatarHandle);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addMakeUp(JNIEnv * env, jobject obj, jstring path, jintArray makeupId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (path != NULL) {
        pathChars = env->GetStringUTFChars(path, 0);
    }

    int id = 0;

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_add_makeup(avatarhandle, pathChars, &id);
        LOGE("add makeup result: %d", result);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(makeupId, 0, 1, &id);
    }

    if (pathChars != NULL) {
        env->ReleaseStringUTFChars(path, pathChars);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addMakeUpFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray makeupId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    int id = 0;

    if(path == NULL){
        result = st_mobile_gen_avatar_add_makeup(avatarHandle, NULL, &id);
        LOGE("change sticker to null");
        return result;
    }

    const char* sticker_file_name_str = env->GetStringUTFChars(path, 0);
    if(NULL == sticker_file_name_str) {
        result = st_mobile_gen_avatar_add_makeup(avatarHandle, NULL, &id);
        LOGE("file_name to c_str failed, change sticker to null");
        return result;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, sticker_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(path, sticker_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        result = st_mobile_gen_avatar_add_makeup(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    char* buffer = NULL;
    long size = 0;
    size = AAsset_getLength(asset);
    buffer = new char[size];
    memset(buffer, '\0', size);

    long readSize = AAsset_read(asset, buffer, size);
    if (readSize != size) {
        AAsset_close(asset);
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }

        result = st_mobile_gen_avatar_add_makeup(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset);

    if (size < 100) {
        LOGE("Model file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        result = st_mobile_gen_avatar_add_makeup(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(avatarHandle != NULL) {
        result = st_mobile_gen_avatar_add_makeup_from_buffer(avatarHandle, buffer, size, &id);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(makeupId, 0, 1, &id);
    }

    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("load_package_from_buffer failed, %d",result);
        return result;
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeMakeUpColor(JNIEnv * env, jobject obj, jint makeupId, jobject color){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_color_t st_color = {0};

    if (!convert2Color(env, color, &st_color)) {
        memset(&st_color, 0, sizeof(st_color_t));
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_change_makeup_color(avatarHandle, makeupId, &st_color);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeMakeUp(JNIEnv * env, jobject obj, jint makeupId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_remove_makeup(avatarHandle, makeupId);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_clearMakeUps(JNIEnv * env, jobject obj){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_clear_makeups(avatarHandle);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setFacingMode(JNIEnv * env, jobject obj, jint faceMode){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_set_facing_mode(avatarHandle, (st_avatar_facing_mode_t)faceMode);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_rotate(JNIEnv * env, jobject obj, jfloat rotateAngle){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_rotate(avatarHandle, rotateAngle);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getFacingMode(JNIEnv * env, jobject obj){
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);
    int result = ST_JNI_ERROR_DEFAULT;
    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }


    st_avatar_facing_mode_t facingMode;
    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_get_facing_mode(avatarHandle, &facingMode);
    }

    return facingMode;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_exportPinchConfig(JNIEnv * env, jobject obj, jstring exportJsonPath){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char* export_path = env->GetStringUTFChars(exportJsonPath, 0);
    LOGI("-->> modelpath=%s", export_path);
    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_export_pinch_config(avatarHandle, export_path, ST_MOBILE_GENAVATAR_RIGHT_HAND_COORD);
    }

    if(result != 0){
        LOGE("create handle for avatar failed");
        env->ReleaseStringUTFChars(exportJsonPath, export_path);
        return result;
    }
    env->ReleaseStringUTFChars(exportJsonPath, export_path);
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getPinchConfigBufferLength(JNIEnv * env, jobject obj, jintArray bufferLength, jint dataFormat){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int buffer_length = 0;

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_get_pinch_config_buffer_length(avatarHandle, nullptr, (st_avatar_pinch_data_format)dataFormat, &buffer_length, ST_MOBILE_GENAVATAR_RIGHT_HAND_COORD);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(bufferLength, 0, 1, &buffer_length);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_exportPinchConfigToBuffer(JNIEnv * env, jobject obj, jbyteArray outputBuffer, jint dataFormat){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int bufferLength = 0;
    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_get_pinch_config_buffer_length(avatarHandle, nullptr, (st_avatar_pinch_data_format)dataFormat, &bufferLength, ST_MOBILE_GENAVATAR_RIGHT_HAND_COORD);
        if(bufferLength > 0){
            jbyte *buffer = (jbyte*) (env->GetPrimitiveArrayCritical(outputBuffer, 0));
            result = st_mobile_gen_avatar_export_pinch_config_to_buffer(avatarHandle, nullptr, (st_avatar_pinch_data_format)dataFormat, (char *)buffer, &bufferLength, ST_MOBILE_GENAVATAR_RIGHT_HAND_COORD);
            env->ReleasePrimitiveArrayCritical(outputBuffer,buffer,0);
        }
    }
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadPinchConfig(JNIEnv * env, jobject obj, jstring configPath){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (configPath != NULL) {
        pathChars = env->GetStringUTFChars(configPath, 0);
    }

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_load_pinch_config(avatarhandle, pathChars);
    }
    if (pathChars != NULL) {
        env->ReleaseStringUTFChars(configPath, pathChars);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadPinchConfigFromAsset(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jint dataFormat){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    if(path == NULL){
        result = st_mobile_gen_avatar_load_pinch_config(avatarHandle, NULL);
        LOGE("change sticker to null");
        return result;
    }

    const char* sticker_file_name_str = env->GetStringUTFChars(path, 0);
    if(NULL == sticker_file_name_str) {
        result = st_mobile_gen_avatar_load_pinch_config(avatarHandle, NULL);
        LOGE("file_name to c_str failed, change sticker to null");
        return result;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, sticker_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(path, sticker_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        result = st_mobile_gen_avatar_load_pinch_config(avatarHandle, NULL);
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    char* buffer = NULL;
    long size = 0;
    size = AAsset_getLength(asset);
    buffer = new char[size];
    memset(buffer, '\0', size);

    long readSize = AAsset_read(asset, buffer, size);
    if (readSize != size) {
        AAsset_close(asset);
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }

        result = st_mobile_gen_avatar_load_pinch_config(avatarHandle, NULL);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset);

    if (size < 100) {
        LOGE("Model file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        result = st_mobile_gen_avatar_load_pinch_config(avatarHandle, NULL);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(avatarHandle != NULL) {
        result = st_mobile_gen_avatar_load_pinch_config_from_buffer(avatarHandle, buffer, size, (st_avatar_pinch_data_format)dataFormat);
    }

    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("load_package_from_buffer failed, %d",result);
        return result;
    }

    return result;
}


JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadPinchConfigFromBuffer(JNIEnv * env, jobject obj, jbyteArray buffer, jint len, jint dataFromat)
{

    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);
    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if (buffer == NULL) {
        LOGE("buffer is null");
        return ST_E_INVALIDARG;
    }

    jbyte *srcdata = (jbyte*) (env->GetByteArrayElements(buffer, 0));
    if(avatarHandle != NULL) {
        result = st_mobile_gen_avatar_load_pinch_config_from_buffer(avatarHandle, (const char *)srcdata, len, (st_avatar_pinch_data_format)dataFromat);
    }

    env->ReleaseByteArrayElements(buffer, srcdata, 0);
    if(result != 0){
        LOGE("load_pinch_config_from_buffer failed, %d",result);

    }
    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadAnimationClip(JNIEnv * env, jobject obj, jstring path, jintArray clipId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (path != NULL) {
        pathChars = env->GetStringUTFChars(path, 0);
    }

    int id = 0;

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_load_animation_clip(avatarhandle, pathChars, &id);
        LOGE("add clip result: %d", result);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(clipId, 0, 1, &id);
    }

    if (pathChars != NULL) {
        env->ReleaseStringUTFChars(path, pathChars);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadAnimationClipFromAssetsFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray clipId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    int id = 0;
    if(path == NULL){
        result = st_mobile_gen_avatar_load_animation_clip(avatarHandle, NULL, &id);
        LOGE("change sticker to null");
        return result;
    }

    const char* avatar_file_name_str = env->GetStringUTFChars(path, 0);
    if(NULL == avatar_file_name_str) {
        result = st_mobile_gen_avatar_load_animation_clip(avatarHandle, NULL, &id);
        LOGE("file_name to c_str failed, change sticker to null");
        return result;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, avatar_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(path, avatar_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        result = st_mobile_gen_avatar_load_animation_clip(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    char* buffer = NULL;
    long size = 0;
    size = AAsset_getLength(asset);
    buffer = new char[size];
    memset(buffer, '\0', size);

    long readSize = AAsset_read(asset, buffer, size);
    if (readSize != size) {
        AAsset_close(asset);
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }

        result = st_mobile_gen_avatar_load_animation_clip(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset);

    if (size < 100) {
        LOGE("Model file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        result = st_mobile_gen_avatar_load_animation_clip(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(avatarHandle != NULL) {
        result = st_mobile_gen_avatar_load_animation_clip_from_buffer(avatarHandle, buffer, size, &id);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(clipId, 0, 1, &id);
    }

    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("load_package_from_buffer failed, %d",result);
        return result;
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_playAnimationStack(JNIEnv * env, jobject obj, jobjectArray targets){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(targets == NULL){
        return ST_E_INVALIDARG;
    }

    int count = env->GetArrayLength(targets);

    st_animation_target* animation_targets = new st_animation_target[count];
    for(int i = 0; i < count; i++){
        jobject animation_target = env->GetObjectArrayElement(targets, i);
        if(!convert2st_animation_target(env, animation_target, animation_targets + i)){
            memset(animation_targets + i, 0, sizeof(st_animation_target));
        }
    }

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_play_animation_stack(avatarhandle, animation_targets, count);
        LOGE("play animation stack result: %d", result);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getAnimationClipCount(JNIEnv * env, jobject obj){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int count = 0;
    result = st_mobile_gen_avatar_get_animation_clip_count(avatarHandle, &count);

    if(result != 0){
        LOGE("load_package_from_buffer failed, %d",result);
        return result;
    }

    return count;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_unloadAnimationClip(JNIEnv * env, jobject obj, jint clipId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    result = st_mobile_gen_avatar_unload_animation_clip(avatarHandle, clipId);

    if(result != 0){
        LOGE("unload animation failed, %d",result);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeAnimation(JNIEnv * env, jobject obj, jint clipId, jfloat transitSec){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    result = st_mobile_gen_avatar_change_animation(avatarHandle, clipId, transitSec);

    if(result != 0){
        LOGE("load_package_from_buffer failed, %d",result);
        return result;
    }

    return result;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_stopAnimation(JNIEnv * env, jobject obj){
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
    }

    st_mobile_gen_avatar_stop_animation(avatarhandle);
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setDisplayMode(JNIEnv * env, jobject obj, jint displayMode){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_set_display_mode(avatarhandle, (st_avatar_display_mode_t)displayMode);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getDisplayMode(JNIEnv * env, jobject obj){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }
    st_avatar_display_mode_t displayMode;
    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_get_display_mode(avatarhandle, &displayMode);
    }

    return displayMode;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_processTexture(JNIEnv * env, jobject obj, jobject humanActionNativeObj, jint textureInput, jint imageWidth, jint imageHeight, jint rotate, jobject humanAction, jint textureOutput){
    //LOGE("processTexture, the width is %d, the height is %d, the rotate is %d",imageWidth, imageHeight, rotate);
    int result = ST_JNI_ERROR_DEFAULT;

    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if(avatarhandle == NULL)
    {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_mobile_human_action_t human_action = {0};

    if (!convert2HumanAction(env, humanAction, &human_action)) {
        memset(&human_action, 0, sizeof(st_mobile_human_action_t));
    }

    jclass STHumanActionClass = env->GetObjectClass(humanActionNativeObj);
    jfieldID humanActionHandleField = env->GetFieldID(STHumanActionClass, "nativeHumanActionHandle", "J");
    jlong handle = env->GetLongField(humanActionNativeObj, humanActionHandleField);
    void* humanActionHandle = reinterpret_cast<void *>(handle);
    st_mobile_body_avatar_t* body_avatar = {0};
    int bodyAvatarCount = 0;
    if(humanActionHandle != NULL) {
//        result = st_mobile_body_avatar_get_quaternion(humanActionHandle, imageWidth, imageHeight, (st_rotate_type)rotate, &human_action, &body_avatar, &bodyAvatarCount);
    }

//    if(human_action.body_count > 0)
//    LOGE("bbbbbbbbbbbbbb bodyAvatarCount, %d,   %d", human_action.p_bodys[0].key_points_3d_count, bodyAvatarCount);
//    for(int i = 0; i < bodyAvatarCount; i++){
//        LOGE("bbbbbbbbb bodyQuatCount, %d", body_avatar->body_quat_count);
//        for(int j = 0; j < body_avatar->body_quat_count; j++){
//            LOGE("bbbbbbbbb bodyQuat, %f  %f  %f  %f", body_avatar->p_body_quat_array[j].x, body_avatar->p_body_quat_array[j].y, body_avatar->p_body_quat_array[j].z, body_avatar->p_body_quat_array[j].w);
//        }
//    }

    long startTime = getCurrentTime();
    if(avatarhandle != NULL)
    {
        result  = st_mobile_gen_avatar_process_texture(avatarhandle, textureInput, imageWidth, imageHeight, (st_rotate_type)rotate, &human_action, body_avatar, bodyAvatarCount, textureOutput);
        LOGI("-->>st_mobile_avatar_process_texture --- result is %d", result);
    }

    long afterStickerTime = getCurrentTime();
    LOGI("process avatar time is %ld", (afterStickerTime - startTime));
    //	env->ReleasePrimitiveArrayCritical(pInputImage, srcdata, 0);

    releaseHumanAction(&human_action);

    //jclass vm_class = env->FindClass("dalvik/system/VMDebug");
    //jmethodID dump_mid = env->GetStaticMethodID( vm_class, "dumpReferenceTables", "()V" );
    //env->CallStaticVoidMethod( vm_class, dump_mid );

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_processTexture2(JNIEnv * env, jobject obj, jlong humanActionNativeHandle, jlong humanActionNativeResult, jint textureInput, jint imageWidth, jint imageHeight, jint rotate, jint textureOutput){
    LOGE("processTexture, the width is %d, the height is %d, the rotate is %d",imageWidth, imageHeight, rotate);
    int result = ST_JNI_ERROR_DEFAULT;

    if(humanActionNativeHandle <= 0 || humanActionNativeResult <= 0){
        LOGE("handle is invalid");
        return ST_E_HANDLE;
    }

    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if(avatarhandle == NULL)
    {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_mobile_human_action_t* human_action = reinterpret_cast<st_mobile_human_action_t *>(humanActionNativeResult);
    st_handle_t humanActionHandle = reinterpret_cast<st_mobile_human_action_t *>(humanActionNativeHandle);

    st_mobile_body_avatar_t* body_avatar = {0};
    int bodyAvatarCount = 0;
    if(humanActionHandle != NULL && human_action != NULL) {
//        result = st_mobile_body_avatar_get_quaternion(humanActionHandle, imageWidth, imageHeight, (st_rotate_type)rotate, human_action, &body_avatar, &bodyAvatarCount);
    }

//    if(human_action.body_count > 0)
//    LOGE("bbbbbbbbbbbbbb bodyAvatarCount, %d,   %d", human_action.p_bodys[0].key_points_3d_count, bodyAvatarCount);
//    for(int i = 0; i < bodyAvatarCount; i++){
//        LOGE("bbbbbbbbb bodyQuatCount, %d", body_avatar->body_quat_count);
//        for(int j = 0; j < body_avatar->body_quat_count; j++){
//            LOGE("bbbbbbbbb bodyQuat, %f  %f  %f  %f", body_avatar->p_body_quat_array[j].x, body_avatar->p_body_quat_array[j].y, body_avatar->p_body_quat_array[j].z, body_avatar->p_body_quat_array[j].w);
//        }
//    }

    long startTime = getCurrentTime();
    if(avatarhandle != NULL && human_action != NULL)
    {
        result  = st_mobile_gen_avatar_process_texture(avatarhandle, textureInput, imageWidth, imageHeight, (st_rotate_type)rotate, human_action, body_avatar, bodyAvatarCount, textureOutput);
        LOGI("-->>st_mobile_avatar_process_texture --- result is %d", result);
    }

    long afterStickerTime = getCurrentTime();
    LOGI("process avatar time is %ld", (afterStickerTime - startTime));
    //	env->ReleasePrimitiveArrayCritical(pInputImage, srcdata, 0);

    //jclass vm_class = env->FindClass("dalvik/system/VMDebug");
    //jmethodID dump_mid = env->GetStaticMethodID( vm_class, "dumpReferenceTables", "()V" );
    //env->CallStaticVoidMethod( vm_class, dump_mid );

    return result;
}

JNIEXPORT void JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_resetBodyPose(JNIEnv * env, jobject obj){
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);
    if(avatarhandle != NULL)
    {
        st_mobile_gen_avatar_reset_body_pose(avatarhandle);
    }
}

JNIEXPORT jlong JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getDetectConfig(JNIEnv * env, jobject obj){
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);
    if(avatarhandle != NULL)
    {
        unsigned long long action = -1;
        int result = st_mobile_gen_avatar_get_detect_config(avatarhandle, &action);
        if (result == ST_OK) {
            return action;
        }
    }
    return 0;
}


JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setBackgroundFromBuffer(JNIEnv * env, jobject obj, jbyteArray imageData, jint backgroundType, jintArray backgroundId){
    int result = ST_JNI_ERROR_DEFAULT;

    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if(avatarhandle == NULL)
    {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int id = 0;

    jbyte *srcdata = (env->GetByteArrayElements(imageData, 0));
    int dataLength = env->GetArrayLength(imageData);

    result = st_mobile_gen_avatar_set_background_from_buffer(avatarhandle, (const char *)srcdata, dataLength, (st_render_background_type_t)backgroundType, &id);

    if(result == ST_OK){
        env->SetIntArrayRegion(backgroundId, 0, 1, &id);
    }

    env->ReleaseByteArrayElements(imageData, srcdata, 0);


    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setBackgroundColor(JNIEnv * env, jobject obj, jobject color){
    int result = ST_JNI_ERROR_DEFAULT;

    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if(avatarhandle == NULL)
    {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_color_t st_color = {0};

    if (!convert2Color(env, color, &st_color)) {
        memset(&st_color, 0, sizeof(st_color_t));
    }

    result = st_mobile_gen_avatar_set_background_color(avatarhandle, &st_color);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setBackgroundFromPath(JNIEnv * env, jobject obj, jstring path, jintArray backgroundId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (path != NULL) {
        pathChars = env->GetStringUTFChars(path, 0);
    }

    int id = 0;

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_set_background_from_path(avatarhandle, pathChars, &id);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(backgroundId, 0, 1, &id);
    }

    if (pathChars != NULL) {
        env->ReleaseStringUTFChars(path, pathChars);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeBackground(JNIEnv * env, jobject obj, jint backgroundId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_remove_background(avatarhandle, backgroundId);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setCameraLookAt(JNIEnv * env, jobject obj, jfloatArray position, jfloatArray target, jfloatArray up, jfloat transitSec){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    float _position[3];
    float _target[3];
    float _up[3];

    env->GetFloatArrayRegion(position, 0, 3, _position);
    env->GetFloatArrayRegion(target, 0, 3, _target);
    env->GetFloatArrayRegion(up, 0, 3, _up);

    result = st_mobile_gen_avatar_set_camera_lookat(avatarhandle, _position, _target, _up, transitSec);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setCameraPerspective(JNIEnv * env, jobject obj, jfloat fov, jfloat aspect, jfloat znear, jfloat zfar){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    result = st_mobile_gen_avatar_set_camera_perspective(avatarhandle, fov, aspect, znear, zfar);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setCameraOrthogonal(JNIEnv * env, jobject obj, jfloat left, jfloat right, jfloat bottom, jfloat top, jfloat znear, jfloat zfar){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    result = st_mobile_gen_avatar_set_camera_orthogonal(avatarhandle, left, right, bottom, top, znear, zfar);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_lockFaceFittingCamera(JNIEnv * env, jobject obj, jboolean lock){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    result = st_mobile_gen_avatar_lock_face_fitting_camera(avatarhandle, lock);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_resetFacePose(JNIEnv * env, jobject obj, jint postType){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    result = st_mobile_gen_avatar_reset_face_pose(avatarhandle, (st_face_pose_type_t)postType);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addAvatar(JNIEnv * env, jobject obj, jstring avatarPath, jintArray avatarId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (avatarPath != NULL) {
        pathChars = env->GetStringUTFChars(avatarPath, 0);
    }

    int id = 0;

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_add_avatar(avatarhandle, pathChars, &id);
        LOGE("add clip result: %d", result);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(avatarId, 0, 1, &id);
    }

    if (pathChars != NULL) {
        env->ReleaseStringUTFChars(avatarPath, pathChars);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addAvatarFromBuffer(JNIEnv * env, jobject obj, jstring avatarPath, jobject assetManager, jintArray avatarId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    int id = 0;
    if(avatarPath == NULL){
        result = st_mobile_gen_avatar_add_avatar(avatarHandle, NULL, &id);
        LOGE("change sticker to null");
        return result;
    }

    const char* avatar_file_name_str = env->GetStringUTFChars(avatarPath, 0);
    if(NULL == avatar_file_name_str) {
        result = st_mobile_gen_avatar_add_avatar(avatarHandle, NULL, &id);
        LOGE("file_name to c_str failed, change sticker to null");
        return result;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, avatar_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(avatarPath, avatar_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        result = st_mobile_gen_avatar_add_avatar(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    char* buffer = NULL;
    long size = 0;
    size = AAsset_getLength(asset);
    buffer = new char[size];
    memset(buffer, '\0', size);

    long readSize = AAsset_read(asset, buffer, size);
    if (readSize != size) {
        AAsset_close(asset);
        if(buffer){
            delete[] buffer;
            buffer = NULL;
        }

        result = st_mobile_gen_avatar_add_avatar(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset);

    if (size < 100) {
        LOGE("Model file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        result = st_mobile_gen_avatar_add_avatar(avatarHandle, NULL, &id);
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(avatarHandle != NULL) {
        result = st_mobile_gen_avatar_add_avatar_from_buffer(avatarHandle, buffer, size, &id);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(avatarId, 0, 1, &id);
    }

    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("load_package_from_buffer failed, %d",result);
        return result;
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeAvatar(JNIEnv * env, jobject obj, int avatarId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_remove_avatar(avatarHandle, avatarId);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_rotateAvatar(JNIEnv * env, jobject obj, float angle){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_rotate_avatar(avatarHandle, angle);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_translateAvatar(JNIEnv * env, jobject obj, jfloatArray translate){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    float* translates = env->GetFloatArrayElements(translate, 0);
    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_translate_avatar(avatarHandle, translates);
    }
    env->ReleaseFloatArrayElements(translate, translates, 0);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_scaleAvatar(JNIEnv * env, jobject obj, jfloatArray scale){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    float* scales = env->GetFloatArrayElements(scale, 0);
    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_scale_avatar(avatarHandle, scales);
    }
    env->ReleaseFloatArrayElements(scale, scales, 0);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_activeAvatar(JNIEnv * env, jobject obj, jint activeId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_activate_avatar(avatarHandle, activeId);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getActivedAvatar(JNIEnv * env, jobject obj, jintArray activeId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int active_id = 0;

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_get_active_avatar(avatarHandle, &active_id);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(activeId, 0, 1, &active_id);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_cloneAvatar(JNIEnv * env, jobject obj, jint srcAvatarId, jintArray avatarId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int avatar_id = 0;

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_clone_avatar(avatarHandle, srcAvatarId, &avatar_id);
    }

    if(result == ST_OK){
        env->SetIntArrayRegion(avatarId, 0, 1, &avatar_id);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_freezeFeatureDynamicBone(JNIEnv * env, jobject obj, jint featureId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int avatar_id = 0;

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_freeze_feature_dynamic_bone(avatarHandle, featureId);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadGenfaceConfig(JNIEnv * env, jobject obj, jstring modelPath, jstring configPath, jstring pinchModelPath){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *modelpathChars = NULL;
    if (modelPath != NULL) {
        modelpathChars = env->GetStringUTFChars(modelPath, 0);
    }

    const char *confipathChars = NULL;
    if (configPath != NULL) {
        confipathChars = env->GetStringUTFChars(configPath, 0);
    }

    const char *pinchmodelpathChars = NULL;
    if (pinchModelPath != NULL) {
        pinchmodelpathChars = env->GetStringUTFChars(pinchModelPath, 0);
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_load_genface_config(avatarHandle, modelpathChars, confipathChars, pinchmodelpathChars);
    }

    if (modelPath != NULL) {
        env->ReleaseStringUTFChars(modelPath, modelpathChars);
    }

    if (confipathChars != NULL) {
        env->ReleaseStringUTFChars(configPath, confipathChars);
    }

    if (pinchmodelpathChars != NULL) {
        env->ReleaseStringUTFChars(pinchModelPath, pinchmodelpathChars);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_loadGenfaceConfigFromBuffer(JNIEnv * env, jobject obj, jobject assetManager, jstring modelPath, jstring configPath, jstring pinchModelPath){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    int id = 0;
    if(modelPath == NULL || configPath == NULL || pinchModelPath == NULL){
        return result;
    }
    const char* model_path = env->GetStringUTFChars(modelPath, 0);
    const char* config_path = env->GetStringUTFChars(configPath, 0);
    const char* pinch_model_path = env->GetStringUTFChars(pinchModelPath, 0);

    if(NULL == model_path || NULL == config_path || NULL == pinch_model_path) {
        return result;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset1 = AAssetManager_open(mgr, model_path, AASSET_MODE_UNKNOWN);
    AAsset* asset2 = AAssetManager_open(mgr, config_path, AASSET_MODE_UNKNOWN);
    AAsset* asset3 = AAssetManager_open(mgr, pinch_model_path, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(modelPath, model_path);
    env->ReleaseStringUTFChars(configPath, config_path);
    env->ReleaseStringUTFChars(pinchModelPath, pinch_model_path);
    if (NULL == asset1 || NULL == asset2 || NULL == asset3) {
        LOGE("open asset file failed");
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    char* buffer1 = NULL;
    char* buffer2 = NULL;
    char* buffer3 = NULL;
    long size1 = 0, size2 = 0, size3 = 0;
    size1 = AAsset_getLength(asset1);
    size2 = AAsset_getLength(asset2);
    size3 = AAsset_getLength(asset3);
    buffer1 = new char[size1];
    buffer2 = new char[size2];
    buffer3 = new char[size3];
    memset(buffer1, '\0', size1);
    memset(buffer2, '\0', size2);
    memset(buffer3, '\0', size3);

    long readSize1 = AAsset_read(asset1, buffer1, size1);
    long readSize2 = AAsset_read(asset2, buffer2, size2);
    long readSize3 = AAsset_read(asset3, buffer3, size3);
    if (readSize1 != size1 || readSize2 != size2 || readSize3 != size3) {
        AAsset_close(asset1);
        AAsset_close(asset2);
        AAsset_close(asset3);
        if(buffer1){
            delete[] buffer1;
            buffer1 = NULL;
        }
        if(buffer2){
            delete[] buffer2;
            buffer2 = NULL;
        }
        if(buffer3){
            delete[] buffer3;
            buffer3 = NULL;
        }

        return ST_JNI_ERROR_FILE_SIZE;
    }

    AAsset_close(asset1);
    AAsset_close(asset2);
    AAsset_close(asset3);
    if (size1 < 100 || size2 < 100 || size3 < 100) {
        LOGE("Model file is too short");
        if (buffer1) {
            delete[] buffer1;
            buffer1 = NULL;
        }
        if(buffer2){
            delete[] buffer2;
            buffer2 = NULL;
        }
        if(buffer3){
            delete[] buffer3;
            buffer3 = NULL;
        }
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(avatarHandle != NULL) {
        result = st_mobile_gen_avatar_load_genface_config_from_buffer(avatarHandle, (const unsigned char*)buffer1, size1, (const unsigned char*)buffer2, size2, (const unsigned char*)buffer3, size3);
    }

    if(buffer1){
        delete[] buffer1;
        buffer1 = NULL;
    }

    if(buffer2){
        delete[] buffer2;
        buffer2 = NULL;
    }

    if(buffer3){
        delete[] buffer3;
        buffer3 = NULL;
    }

    if(result != 0){
        LOGE("genface_config_buffer failed, %d",result);
        return result;
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_genFace(JNIEnv * env, jobject obj, jbyteArray data, jint format, jint imageWidth, jint imageHeight, jint rotate, jobject humanAction, jboolean isMale, jint avatarId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if(avatarHandle == NULL)
    {
        LOGE("handle is null");
        return ST_E_INVALIDARG;
    }

    if (data == NULL) {
        LOGE("input image is null");
        return ST_E_INVALIDARG;
    }

    jbyte *srcdata = (jbyte*) (env->GetByteArrayElements(data, 0));
    int image_stride = getImageStride((st_pixel_format)format, imageWidth);

    st_mobile_human_action_t st_humanaction = {0};
    if(!convert2HumanAction(env, humanAction, &st_humanaction)){
        memset(&st_humanaction, 0, sizeof(st_mobile_human_action_t));
    }

    long startTime = getCurrentTime();
    if(avatarHandle != NULL)
    {
        LOGI("before genface");
        result =  st_mobile_gen_avatar_genface(avatarHandle, (unsigned char *)srcdata,  (st_pixel_format)format,  imageWidth,
                                               imageHeight, image_stride, (st_rotate_type)rotate, &st_humanaction, isMale, avatarId);
        LOGI("genface --- result is %d", result);
    }

    long afterdetectTime = getCurrentTime();
    env->ReleaseByteArrayElements(data, srcdata, 0);

    releaseHumanAction(&st_humanaction);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_genPinchFaceBlendShapeCount(JNIEnv * env, jobject obj){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int count = 0;

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_get_pinch_face_blendshape_count(avatarHandle, &count);
    }

    if(result == ST_OK){
        return count;
    }else{
        return -1;
    }
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_resetGenFace(JNIEnv * env, jobject obj, jint avatarId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_reset_genface(avatarHandle, avatarId);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_unloadGenfaceConfig(JNIEnv * env, jobject obj){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_unload_genface_config(avatarHandle);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setFittingScale(JNIEnv *env, jobject obj,
                                                                                             jint part, jfloat scale) {
    // TODO: implement setFittingScale()
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if(avatarHandle == NULL)
    {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL)
    {
        LOGI("before setFittingScale");
        result =  st_mobile_gen_avatar_set_fitting_scale(avatarHandle, (st_avatar_part_t)part, scale);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setUpbodyIkEnabled(JNIEnv *env, jobject obj,
                                                                                                jboolean enable) {
    // TODO: implement setUpbodyIkEnabled()
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if(avatarHandle == NULL)
    {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarHandle != NULL)
    {
        LOGI("before setUpbodyIkEnabled");
        result =  st_mobile_gen_avatar_set_upbody_ik_enabled(avatarHandle, enable);
    }

    return result;
}


JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getEyebrowType(JNIEnv *env, jobject obj) {
    // TODO: implement setUpbodyIkEnabled()
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if(avatarHandle == NULL){
        LOGE("handle is null");
        return -1;
    }

    st_avatar_eyebrow_t id = AVATAR_UNKNOWN_EYEBROW;
    if(avatarHandle != NULL){
        LOGI("before get_eyebrow_type");
        result =  st_mobile_gen_avatar_get_eyebrow_type(avatarHandle, &id);
    }

    if(result == ST_OK){
        return (int)id;
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addAsset(JNIEnv * env, jobject obj, jstring path, jintArray assetId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    const char *pathChars = NULL;
    if (path != NULL) {
        pathChars = env->GetStringUTFChars(path, 0);
    }

    int asset_id = 0;

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_add_asset(avatarhandle, pathChars, &asset_id);
//        LOGE("addAsset path: %s", pathChars);
//        LOGE("addAsset result: %d", result);
    }

    if(assetId != NULL){
        env->SetIntArrayRegion(assetId, 0, 1, &asset_id);
    }

    if (pathChars != NULL) {
        env->ReleaseStringUTFChars(path, pathChars);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_addAssetFromAssetFile(JNIEnv * env, jobject obj, jstring path, jobject assetManager, jintArray assetId){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int package_id = 0;

    if(NULL == assetManager){
        LOGE("assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    if(path == NULL){
        LOGE("change sticker to null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    const char* sticker_file_name_str = env->GetStringUTFChars(path, 0);
    if(NULL == sticker_file_name_str) {
        LOGE("file_name to c_str failed");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    if(NULL == mgr) {
        LOGE("native assetManager is null");
        return ST_JNI_ERROR_INVALIDARG;
    }

    AAsset* asset = AAssetManager_open(mgr, sticker_file_name_str, AASSET_MODE_UNKNOWN);
    env->ReleaseStringUTFChars(path, sticker_file_name_str);
    if (NULL == asset) {
        LOGE("open asset file failed");
        return ST_JNI_ERROR_FILE_OPEN_FIALED;
    }

    char* buffer = NULL;
    long size = 0;
    size = AAsset_getLength(asset);
    buffer = new char[size];
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

    if (size < 100) {
        LOGE(" file is too short");
        if (buffer) {
            delete[] buffer;
            buffer = NULL;
        }
        return ST_JNI_ERROR_FILE_SIZE;
    }

    if(avatarHandle != NULL) {
        result = st_mobile_gen_avatar_add_asset_from_buffer(avatarHandle, (const unsigned char *)buffer, size, &package_id);
    }

    if(assetId != NULL){
        env->SetIntArrayRegion(assetId, 0, 1, &package_id);
    }

    if(buffer){
        delete[] buffer;
        buffer = NULL;
    }

    if(result != 0){
        LOGE("add_asset_from_buffer failed, %d",result);
        return result;
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_changeAssetColor(JNIEnv * env, jobject obj, jint assetId, jobjectArray colors, int count){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == nullptr) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }
    auto *st_colors = new st_color_t[count];
    for(int i=0; i<count; i++) {
        jobject st_color = env->GetObjectArrayElement(colors, i);
        if (!convert2Color(env, st_color, st_colors+i)) {
            memset(st_colors + i, 0, sizeof(st_color_t));
        }
    }
    if(avatarHandle != nullptr){
        result = st_mobile_gen_avatar_change_asset_color(avatarHandle, assetId, st_colors, count);
    }

    if(st_colors) delete[] st_colors;

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeAsset(JNIEnv * env, jobject obj, jint assetId){
//    LOGE("removeAsset %d", assetId);
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int asset_id = assetId;
    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_remove_asset(avatarhandle, asset_id);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_removeAllAsset(JNIEnv * env, jobject obj){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if (avatarhandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    if(avatarhandle != NULL) {
        result = st_mobile_gen_avatar_remove_all_assets(avatarhandle);
    }

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_genPinchFaceBoneCount(JNIEnv * env, jobject obj){
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if (avatarHandle == NULL) {
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    int count = 0;

    if(avatarHandle != NULL){
        result = st_mobile_gen_avatar_get_pinch_face_bone_count(avatarHandle, &count);
    }

    if(result == ST_OK){
        return count;
    }else{
        return -1;
    }
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getAutoPinchResult(JNIEnv * env, jobject obj, jint imageWidth, jint imageHeight, jint rotate, jobject humanAction, jboolean isMale,
                                                                                                jint boneTransformCount, jobjectArray boneTransformArray, jint blendShapeSize, jfloatArray blendShapeArray, jint featureIdCount, jintArray featureIdArray){
    int result = ST_JNI_ERROR_DEFAULT;

    st_handle_t avatarhandle = getPinchAvatarHandle(env, obj);

    if(avatarhandle == NULL){
        LOGE("handle is null");
        return ST_E_HANDLE;
    }

    st_mobile_human_action_t human_action = {0};
    if (!convert2HumanAction(env, humanAction, &human_action)) {
        memset(&human_action, 0, sizeof(st_mobile_human_action_t));
    }

    st_mobile_bone_transform_t *bone_array = new st_mobile_bone_transform_t[boneTransformCount];
    memset(bone_array, 0, sizeof(st_mobile_bone_transform_t)*boneTransformCount);
    float *blend_shape_array = new float[blendShapeSize];
    int *feature_id_array = new int[featureIdCount];

    if(avatarhandle != NULL){
        result = st_mobile_gen_avatar_get_autopinch_result(avatarhandle, imageWidth, imageHeight, (st_rotate_type)rotate, &human_action, isMale,
                                                           bone_array, boneTransformCount,
                                                           blend_shape_array, blendShapeSize,
                                                           feature_id_array, featureIdCount, ST_MOBILE_GENAVATAR_RIGHT_HAND_COORD);
    }

    if(result == ST_OK){
        for (int i = 0; i < boneTransformCount; ++i) {
            jobject bodyAvatarObj = convert2STBoneTransform(env, &bone_array[i]);
            if (bodyAvatarObj != NULL) {
                env->SetObjectArrayElement(boneTransformArray, i, bodyAvatarObj);
            }
            env->DeleteLocalRef(bodyAvatarObj);
        }
        env->SetFloatArrayRegion(blendShapeArray, 0, blendShapeSize, blend_shape_array);
        env->SetIntArrayRegion(featureIdArray, 0, featureIdCount, feature_id_array);
    }

    safe_delete_array(bone_array);
    safe_delete_array(blend_shape_array);
    safe_delete_array(feature_id_array);

    return result;
}

JNIEXPORT jint JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_getFaceExpression(JNIEnv *env, jobject obj, jint width, jint height, jint rotate, jobject humanAction, jfloatArray values) {
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if(avatarHandle == NULL){
        LOGE("handle is null");
        return -1;
    }

    jfloat *expressions = (jfloat*) (env->GetFloatArrayElements(values, 0));
    int length = env->GetArrayLength(values);

    st_mobile_human_action_t human_action = {0};
    if (!convert2HumanAction(env, humanAction, &human_action)) {
        memset(&human_action, 0, sizeof(st_mobile_human_action_t));
    }

    if(avatarHandle != NULL){
        result =  st_mobile_gen_avatar_get_face_expression(avatarHandle, width, height, (st_rotate_type)rotate, &human_action, expressions, length);
    }

    if(result == ST_OK){
        env->SetFloatArrayRegion(values, 0, length, expressions);
    }

    env->ReleaseFloatArrayElements(values, expressions, 0);
    releaseHumanAction(&human_action);

    return result;
}

JNIEXPORT jobjectArray JNICALL Java_com_sensetime_stmobile_STMobilePinchAvatarNative_calcStandardPose(JNIEnv *env, jobject obj, jint width, jint height, jint rotate, jobject humanAction, jfloat fov) {
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, obj);

    if(avatarHandle == NULL){
        LOGE("handle is null");
        return NULL;
    }

    st_mobile_human_action_t human_action = {0};
    if (!convert2HumanAction(env, humanAction, &human_action)) {
        memset(&human_action, 0, sizeof(st_mobile_human_action_t));
    }

    st_mobile_transform_t *transforms = new st_mobile_transform_t[human_action.face_count];
    memset(transforms, 0, sizeof(st_mobile_transform_t)*human_action.face_count);

    if(avatarHandle != NULL){
        result =  st_mobile_gen_avatar_calc_standard_pose(avatarHandle, width, height, (st_rotate_type)rotate, fov, human_action.p_faces, human_action.face_count, transforms);
    }

    if(result == ST_OK){
        jclass transform_cls = env->FindClass("com/sensetime/stmobile/model/STTransform");
        jobjectArray transform_array = env->NewObjectArray(human_action.face_count, transform_cls, 0);
        for(int i = 0; i < human_action.face_count; i++){
            jobject transformObj = env->AllocObject(transform_cls);

            transformObj = convert2STTransform(env, transforms+i);

            env->SetObjectArrayElement(transform_array, i, transformObj);
            env->DeleteLocalRef(transformObj);
        }
        env->DeleteLocalRef(transform_cls);

        delete[] transforms;
        releaseHumanAction(&human_action);

        return transform_array;
    }

    delete[] transforms;
    releaseHumanAction(&human_action);

    return NULL;
}


extern "C"
JNIEXPORT jint JNICALL
Java_com_sensetime_stmobile_STMobilePinchAvatarNative_setOption(JNIEnv *env, jobject thiz,
                                                                jint option, jboolean val) {
    int result = ST_JNI_ERROR_DEFAULT;
    st_handle_t avatarHandle = getPinchAvatarHandle(env, thiz);

    if(avatarHandle == NULL){
        LOGE("handle is null");
        return NULL;
    }
    int ret = -1;//st_mobile_gen_avatar_set_option(avatarHandle, static_cast<st_mobile_genavatar_option_t>(option), val);
    return ret;
}