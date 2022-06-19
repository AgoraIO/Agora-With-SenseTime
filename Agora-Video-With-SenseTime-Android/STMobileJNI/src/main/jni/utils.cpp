#include "utils.h"
#include <st_mobile_common.h>
#include <st_mobile_human_action.h>
//#include <st_mobile_sticker.h>
//#include <st_mobile_sticker_transition.h>
//#include <st_mobile_effect.h>

#define  LOG_TAG    "utils"

long getCurrentTime() {
    struct timeval tv;
    gettimeofday(&tv,NULL);
    return tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

int getImageStride(const st_pixel_format &pixel_format, const int &outputWidth) {
    int stride = 0;
    switch(pixel_format) {
        case ST_PIX_FMT_GRAY8:
        case ST_PIX_FMT_YUV420P:
        case ST_PIX_FMT_NV12:
        case ST_PIX_FMT_NV21:
            stride = outputWidth;
            break;
        case ST_PIX_FMT_BGRA8888:
        case ST_PIX_FMT_RGBA8888:
            stride = outputWidth * 4;
            break;
        case ST_PIX_FMT_BGR888:
            stride = outputWidth * 3;
            break;
        default:
            break;
    }

    return stride;
}

jobject convert2STRect(JNIEnv *env, const st_rect_t &object_rect){
    jclass STRectClass = env->FindClass("com/sensetime/stmobile/model/STRect");

    if (STRectClass == NULL) {
        return NULL;
    }

    jobject rectObject = env->AllocObject(STRectClass);

    jfieldID rect_left = env->GetFieldID(STRectClass, "left", "I");
    jfieldID rect_top = env->GetFieldID(STRectClass, "top", "I");
    jfieldID rect_right = env->GetFieldID(STRectClass, "right", "I");
    jfieldID rect_bottom = env->GetFieldID(STRectClass, "bottom", "I");

    env->SetIntField(rectObject, rect_left, object_rect.left);
    env->SetIntField(rectObject, rect_right, object_rect.right);
    env->SetIntField(rectObject, rect_top, object_rect.top);
    env->SetIntField(rectObject, rect_bottom, object_rect.bottom);

    if(STRectClass != NULL){
        env->DeleteLocalRef(STRectClass);
    }

    return rectObject;
}

jobject convert2MobileFace106(JNIEnv *env, const st_mobile_106_t &mobile_106){
    jclass st_mobile_106_class = env->FindClass("com/sensetime/stmobile/model/STMobile106");
    jfieldID frect = env->GetFieldID(st_mobile_106_class, "rect", "Lcom/sensetime/stmobile/model/STRect;");
    jfieldID fscore = env->GetFieldID(st_mobile_106_class, "score", "F");
    jfieldID fpoints_array = env->GetFieldID(st_mobile_106_class, "points_array", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fvisibility_array = env->GetFieldID(st_mobile_106_class, "visibility_array", "[F");
    jfieldID fyaw = env->GetFieldID(st_mobile_106_class, "yaw", "F");
    jfieldID fpitch = env->GetFieldID(st_mobile_106_class, "pitch", "F");
    jfieldID froll = env->GetFieldID(st_mobile_106_class, "roll", "F");
    jfieldID feye_dist = env->GetFieldID(st_mobile_106_class, "eye_dist", "F");
    jfieldID fID = env->GetFieldID(st_mobile_106_class, "ID", "I");

    jclass st_mobile_point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_mobile_point_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_mobile_point_class, "y", "F");

    jclass st_face_rect_class = env->FindClass("com/sensetime/stmobile/model/STRect");
    jfieldID frect_left = env->GetFieldID(st_face_rect_class, "left", "I");
    jfieldID frect_top = env->GetFieldID(st_face_rect_class, "top", "I");
    jfieldID frect_right = env->GetFieldID(st_face_rect_class, "right", "I");
    jfieldID frect_bottom = env->GetFieldID(st_face_rect_class, "bottom", "I");

    jobject st_106_object = env->AllocObject(st_mobile_106_class);

    //继续获取rect
    jobject face_rect = env->AllocObject(st_face_rect_class);

    env->SetIntField(face_rect, frect_left, mobile_106.rect.left);
    env->SetIntField(face_rect, frect_right, mobile_106.rect.right);
    env->SetIntField(face_rect, frect_top, mobile_106.rect.top);
    env->SetIntField(face_rect, frect_bottom, mobile_106.rect.bottom);

    //继续获取points_array
    jobjectArray face_point_array = env->NewObjectArray(106, st_mobile_point_class, 0);
    jfloatArray face_visibility_array = env->NewFloatArray(106);
    jfloat visibility_array[106];

    for(int j=0; j<106; j++) {
        jobject st_point_object = env->AllocObject(st_mobile_point_class);

        env->SetFloatField(st_point_object, fpoint_x, mobile_106.points_array[j].x);
        env->SetFloatField(st_point_object, fpoint_y, mobile_106.points_array[j].y);

        env->SetObjectArrayElement(face_point_array, j, st_point_object);
        env->DeleteLocalRef(st_point_object);

        visibility_array[j] = mobile_106.visibility_array[j];
    }
    env->SetFloatArrayRegion(face_visibility_array, 0, 106, visibility_array);
    env->SetObjectField(st_106_object, frect, face_rect);
    env->SetFloatField(st_106_object, fscore, mobile_106.score);
    env->SetObjectField(st_106_object, fpoints_array, face_point_array);
    env->SetObjectField(st_106_object, fvisibility_array, face_visibility_array);
    env->SetFloatField(st_106_object, fyaw, mobile_106.yaw);
    env->SetFloatField(st_106_object, fpitch, mobile_106.pitch);
    env->SetFloatField(st_106_object, froll, mobile_106.roll);
    env->SetFloatField(st_106_object, feye_dist, mobile_106.eye_dist);
    env->SetIntField(st_106_object, fID, mobile_106.ID);

    env->DeleteLocalRef(face_rect);
    env->DeleteLocalRef(face_point_array);
    env->DeleteLocalRef(face_visibility_array);

    if (st_mobile_point_class != NULL) {
        env->DeleteLocalRef(st_mobile_point_class);
    }

    if (st_face_rect_class != NULL) {
        env->DeleteLocalRef(st_face_rect_class);
    }

    if (st_mobile_106_class != NULL) {
        env->DeleteLocalRef(st_mobile_106_class);
    }

    return st_106_object;
}

jobject convert2FaceAttribute(JNIEnv *env, const st_mobile_attributes_t *faceAttribute){
    jclass face_attribute_cls = env->FindClass("com/sensetime/stmobile/model/STFaceAttribute");

    jfieldID fieldAttribute_count = env->GetFieldID(face_attribute_cls, "attribute_count", "I");
    jfieldID fieldAttribute = env->GetFieldID(face_attribute_cls, "arrayAttribute", "[Lcom/sensetime/stmobile/model/STFaceAttribute$Attribute;");

    jobject faceAttributeObj = env->AllocObject(face_attribute_cls);

    env->SetIntField(faceAttributeObj, fieldAttribute_count, faceAttribute->attribute_count);

    jclass attribute_cls = env->FindClass("com/sensetime/stmobile/model/STFaceAttribute$Attribute");
    jfieldID fieldCategory = env->GetFieldID(attribute_cls, "category", "Ljava/lang/String;");
    jfieldID fieldLabel = env->GetFieldID(attribute_cls, "label", "Ljava/lang/String;");
    jfieldID fieldScore = env->GetFieldID(attribute_cls, "score", "F");

    if (faceAttribute->attribute_count > 0) {
        LOGE("attribute_count: %d", faceAttribute->attribute_count);
        jobjectArray arrayAttrObj = env->NewObjectArray(faceAttribute->attribute_count, attribute_cls, 0);
        for (int i = 0; i < faceAttribute->attribute_count; ++i) {
            st_mobile_attribute_t one = faceAttribute->p_attributes[i];
            jobject attrObj = env->AllocObject(attribute_cls);
            jstring cateObj = env->NewStringUTF(one.category);
            jstring labelObj = env->NewStringUTF(one.label);
            env->SetObjectField(attrObj, fieldCategory, cateObj);
            env->SetObjectField(attrObj, fieldLabel, labelObj);
            env->SetFloatField(attrObj, fieldScore, one.score);

            env->SetObjectArrayElement(arrayAttrObj, i, attrObj);
            env->DeleteLocalRef(cateObj);
            env->DeleteLocalRef(labelObj);
            env->DeleteLocalRef(attrObj);
        }

        env->SetObjectField(faceAttributeObj, fieldAttribute, arrayAttrObj);
        env->DeleteLocalRef(arrayAttrObj);
    }

    env->DeleteLocalRef(attribute_cls);
    env->DeleteLocalRef(face_attribute_cls);
    return faceAttributeObj;
}

jobject convert2Image(JNIEnv *env, const st_image_t *image){
    jclass image_cls = env->FindClass("com/sensetime/stmobile/model/STImage");

    jfieldID fieldImageData = env->GetFieldID(image_cls, "imageData", "[B");
    jfieldID fieldPixelFormat = env->GetFieldID(image_cls, "pixelFormat", "I");
    jfieldID fieldWidth = env->GetFieldID(image_cls, "width", "I");
    jfieldID fieldHeight = env->GetFieldID(image_cls, "height", "I");
    jfieldID fieldStride = env->GetFieldID(image_cls, "stride", "I");
    jfieldID fieldTime = env->GetFieldID(image_cls, "timeStamp", "D");

    jobject imageObj = env->AllocObject(image_cls);

    jbyteArray arrayImageData;
    arrayImageData = (env)->NewByteArray(image->width*image->height);
    jbyte* data = (jbyte*)(image->data);
    if(data == NULL){
        return NULL;
    }
    env->SetByteArrayRegion(arrayImageData, 0, image->width*image->height, data);
    env->SetObjectField(imageObj, fieldImageData, arrayImageData);

    env->SetIntField(imageObj, fieldPixelFormat, (int)image->pixel_format);
    env->SetIntField(imageObj, fieldWidth, image->width);
    env->SetIntField(imageObj, fieldHeight, image->height);
    env->SetIntField(imageObj, fieldStride, image->stride);

    env->SetDoubleField(imageObj, fieldTime, image->time_stamp);

    env->DeleteLocalRef(arrayImageData);
    env->DeleteLocalRef(image_cls);

    return imageObj;
}

jobject convert2Segment(JNIEnv *env, const st_mobile_segment_t *segment){
    jclass segment_cls = env->FindClass("com/sensetime/stmobile/model/STSegment");

    jfieldID fieldImage = env->GetFieldID(segment_cls, "image", "Lcom/sensetime/stmobile/model/STImage;");
    jfieldID fieldScore = env->GetFieldID(segment_cls, "score", "F");
    jfieldID fieldMinThrehold = env->GetFieldID(segment_cls, "minThrehold", "F");
    jfieldID fieldMaxThrehold = env->GetFieldID(segment_cls, "maxThrehold", "F");
    jfieldID fieldOffset = env->GetFieldID(segment_cls, "offset", "Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldScale = env->GetFieldID(segment_cls, "scale", "Lcom/sensetime/stmobile/model/STPoint;");

    jobject segmentObj = env->AllocObject(segment_cls);

    jobject imageObj;

    if(segment->p_segment != NULL){
        imageObj = convert2Image(env, segment->p_segment);
        env->SetObjectField(segmentObj, fieldImage, imageObj);
    }

    env->SetFloatField(segmentObj, fieldScore, segment->score);
    env->SetFloatField(segmentObj, fieldMinThrehold, segment->min_threshold);
    env->SetFloatField(segmentObj, fieldMaxThrehold, segment->max_threshold);

    jclass st_points_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_points_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_points_class, "y", "F");

    jobject offsetObj = env->AllocObject(st_points_class);
    env->SetFloatField(offsetObj, fpoint_x, segment->offset.x);
    env->SetFloatField(offsetObj, fpoint_y, segment->offset.y);
    env->SetObjectField(segmentObj, fieldOffset, offsetObj);

    jobject scaleObj = env->AllocObject(st_points_class);
    env->SetFloatField(scaleObj, fpoint_x, segment->scale.x);
    env->SetFloatField(scaleObj, fpoint_y, segment->scale.y);
    env->SetObjectField(segmentObj, fieldScale, scaleObj);

    env->DeleteLocalRef(st_points_class);

    env->DeleteLocalRef(segment_cls);

    return segmentObj;
}

jobject convert2HandInfo(JNIEnv *env, const st_mobile_hand_t *hand_info){
    jclass hand_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileHandInfo");

    jfieldID fieldHandId = env->GetFieldID(hand_info_cls, "handId", "I");
    jfieldID fieldHandRect = env->GetFieldID(hand_info_cls, "handRect", "Lcom/sensetime/stmobile/model/STRect;");
    jfieldID fieldKeyPoints = env->GetFieldID(hand_info_cls, "keyPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldKeyPointsCount = env->GetFieldID(hand_info_cls, "keyPointsCount", "I");
    jfieldID fieldHandAction = env->GetFieldID(hand_info_cls, "handAction", "J");
    jfieldID fieldHandActionScore = env->GetFieldID(hand_info_cls, "handActionScore", "F");

    jfieldID fieldLeftRight = env->GetFieldID(hand_info_cls, "left_right", "I");
    jfieldID fieldExtra2dKeyPoints = env->GetFieldID(hand_info_cls, "extra2dKeyPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldExtra3dKeyPoints = env->GetFieldID(hand_info_cls, "extra3dKeyPoints", "[Lcom/sensetime/stmobile/model/STPoint3f;");
    jfieldID fieldExtra2dKeyPointsCount = env->GetFieldID(hand_info_cls, "extra2dKeyPointsCount", "I");
    jfieldID fieldExtra3dKeyPointsCount = env->GetFieldID(hand_info_cls, "extra3dKeyPointsCount", "I");
    jfieldID fieldHandDynamicGesture = env->GetFieldID(hand_info_cls, "dynamicGesture", "Lcom/sensetime/stmobile/model/STHandDynamicGesture;");
    jfieldID fieldGestureKeyPoints = env->GetFieldID(hand_info_cls, "gestureKeyPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldGestureKeyPointsCount = env->GetFieldID(hand_info_cls, "gestureKeyPointsCount", "I");

    jobject handInfoObj = env->AllocObject(hand_info_cls);

    jclass hand_rect_class = env->FindClass("com/sensetime/stmobile/model/STRect");
    jfieldID hrect_left = env->GetFieldID(hand_rect_class, "left", "I");
    jfieldID hrect_top = env->GetFieldID(hand_rect_class, "top", "I");
    jfieldID hrect_right = env->GetFieldID(hand_rect_class, "right", "I");
    jfieldID hrect_bottom = env->GetFieldID(hand_rect_class, "bottom", "I");

    jobject handRectObj = env->AllocObject(hand_rect_class);
    env->SetIntField(handRectObj, hrect_left, hand_info->rect.left);
    env->SetIntField(handRectObj, hrect_top, hand_info->rect.top);
    env->SetIntField(handRectObj, hrect_right, hand_info->rect.right);
    env->SetIntField(handRectObj, hrect_bottom, hand_info->rect.bottom);

    env->SetObjectField(handInfoObj, fieldHandRect, handRectObj);

    jclass st_points_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_points_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_points_class, "y", "F");

    //extra_face_points
    jobjectArray key_points_array = env->NewObjectArray(hand_info->key_points_count, st_points_class, 0);
    for(int i = 0; i < hand_info->key_points_count; i++){
        jobject keyPointsObj = env->AllocObject(st_points_class);

        env->SetFloatField(keyPointsObj, fpoint_x, (hand_info->p_key_points+i)->x);
        env->SetFloatField(keyPointsObj, fpoint_y, (hand_info->p_key_points+i)->y);

        env->SetObjectArrayElement(key_points_array, i, keyPointsObj);
        env->DeleteLocalRef(keyPointsObj);
    }

    env->SetObjectField(handInfoObj, fieldKeyPoints, key_points_array);
    env->DeleteLocalRef(key_points_array);

    env->SetIntField(handInfoObj, fieldHandId, hand_info->id);
    env->SetIntField(handInfoObj, fieldKeyPointsCount, hand_info->key_points_count);
    env->SetLongField(handInfoObj, fieldHandAction, hand_info->hand_action);
    env->SetFloatField(handInfoObj, fieldHandActionScore, hand_info->score);

    jclass st_point3f_class = env->FindClass("com/sensetime/stmobile/model/STPoint3f");
    jfieldID fpoint3_x = env->GetFieldID(st_point3f_class, "x", "F");
    jfieldID fpoint3_y = env->GetFieldID(st_point3f_class, "y", "F");
    jfieldID fpoint3_z = env->GetFieldID(st_point3f_class, "z", "F");

    //extra_key_points
    if(hand_info->skeleton_keypoints_count > 0){
        jobjectArray extra_2d_key_points_array = env->NewObjectArray(hand_info->skeleton_keypoints_count, st_points_class, 0);
        for(int i = 0; i < hand_info->skeleton_keypoints_count; i++){
            jobject extraKeyPointsObj = env->AllocObject(st_points_class);

            env->SetFloatField(extraKeyPointsObj, fpoint_x, (hand_info->p_skeleton_keypoints+i)->x);
            env->SetFloatField(extraKeyPointsObj, fpoint_y, (hand_info->p_skeleton_keypoints+i)->y);

            env->SetObjectArrayElement(extra_2d_key_points_array, i, extraKeyPointsObj);
            env->DeleteLocalRef(extraKeyPointsObj);
        }

        env->SetObjectField(handInfoObj, fieldExtra2dKeyPoints, extra_2d_key_points_array);
        env->DeleteLocalRef(extra_2d_key_points_array);
    }

    if(hand_info->skeleton_3d_keypoints_count > 0){
        jobjectArray extra_3d_key_points_array = env->NewObjectArray(hand_info->skeleton_3d_keypoints_count, st_point3f_class, 0);
        for(int i = 0; i < hand_info->skeleton_3d_keypoints_count; i++){
            jobject extra3dKeyPointsObj = env->AllocObject(st_point3f_class);

            env->SetFloatField(extra3dKeyPointsObj, fpoint3_x, (hand_info->p_skeleton_3d_keypoints+i)->x);
            env->SetFloatField(extra3dKeyPointsObj, fpoint3_y, (hand_info->p_skeleton_3d_keypoints+i)->y);
            env->SetFloatField(extra3dKeyPointsObj, fpoint3_z, (hand_info->p_skeleton_3d_keypoints+i)->z);

            env->SetObjectArrayElement(extra_3d_key_points_array, i, extra3dKeyPointsObj);
            env->DeleteLocalRef(extra3dKeyPointsObj);
        }

        env->SetObjectField(handInfoObj, fieldExtra3dKeyPoints, extra_3d_key_points_array);
        env->DeleteLocalRef(extra_3d_key_points_array);
    }

    jclass st_dynamic_gesture_class = env->FindClass("com/sensetime/stmobile/model/STHandDynamicGesture");
    jfieldID has_dynamic_gesture = env->GetFieldID(st_dynamic_gesture_class, "has_dynamic_gesture", "I");
    jfieldID dynamic_gesture = env->GetFieldID(st_dynamic_gesture_class, "dynamic_gesture", "I");
    jfieldID score = env->GetFieldID(st_dynamic_gesture_class, "score", "F");
    jobject dynamicGestureObj = env->AllocObject(st_dynamic_gesture_class);
    env->SetIntField(dynamicGestureObj, has_dynamic_gesture, hand_info->hand_dynamic_gesture.has_dynamic_gesture);
    env->SetIntField(dynamicGestureObj, dynamic_gesture, hand_info->hand_dynamic_gesture.dynamic_gesture);
    env->SetFloatField(dynamicGestureObj, score, hand_info->hand_dynamic_gesture.score);
    env->SetObjectField(handInfoObj, fieldHandDynamicGesture, dynamicGestureObj);
    if(hand_info->dynamic_gesture_keypoints_count > 0){
        jobjectArray dynamic_gesture_keypoints_array = env->NewObjectArray(hand_info->dynamic_gesture_keypoints_count, st_points_class, 0);
        for(int i = 0; i < hand_info->dynamic_gesture_keypoints_count; i++){
            jobject dynamicGestureKeyPointsObj = env->AllocObject(st_points_class);
            env->SetFloatField(dynamicGestureKeyPointsObj, fpoint_x, (hand_info->p_dynamic_gesture_keypoints+i)->x);
            env->SetFloatField(dynamicGestureKeyPointsObj, fpoint_y, (hand_info->p_dynamic_gesture_keypoints+i)->y);
            env->SetObjectArrayElement(dynamic_gesture_keypoints_array, i, dynamicGestureKeyPointsObj);
            env->DeleteLocalRef(dynamicGestureKeyPointsObj);
        }
        env->SetObjectField(handInfoObj, fieldGestureKeyPoints, dynamic_gesture_keypoints_array);
        env->DeleteLocalRef(dynamic_gesture_keypoints_array);
    }
    env->SetIntField(handInfoObj, fieldLeftRight, hand_info->left_right);
    env->SetIntField(handInfoObj, fieldExtra2dKeyPointsCount, hand_info->skeleton_keypoints_count);
    env->SetIntField(handInfoObj, fieldExtra3dKeyPointsCount, hand_info->skeleton_3d_keypoints_count);
    env->SetIntField(handInfoObj, fieldGestureKeyPointsCount, hand_info->dynamic_gesture_keypoints_count);


    env->DeleteLocalRef(st_points_class);
    env->DeleteLocalRef(hand_rect_class);
    env->DeleteLocalRef(handRectObj);
    env->DeleteLocalRef(hand_info_cls);

    return handInfoObj;
}

jobject convert2FootInfo(JNIEnv *env, const st_mobile_foot_t *foot_info){
    jclass hand_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileFoot");

    jfieldID fieldHandId = env->GetFieldID(hand_info_cls, "id", "I");

    jfieldID fieldKeyPoints = env->GetFieldID(hand_info_cls, "keyPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldKeyPointsCount = env->GetFieldID(hand_info_cls, "keyPointsCount", "I");

    jobject handInfoObj = env->AllocObject(hand_info_cls);

    jclass st_points_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_points_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_points_class, "y", "F");

    //extra_face_points
    jobjectArray key_points_array = env->NewObjectArray(foot_info->key_points_count, st_points_class, 0);
    for(int i = 0; i < foot_info->key_points_count; i++){
        jobject keyPointsObj = env->AllocObject(st_points_class);

        env->SetFloatField(keyPointsObj, fpoint_x, (foot_info->p_key_points+i)->x);
        env->SetFloatField(keyPointsObj, fpoint_y, (foot_info->p_key_points+i)->y);

        env->SetObjectArrayElement(key_points_array, i, keyPointsObj);
        env->DeleteLocalRef(keyPointsObj);
    }

    env->SetObjectField(handInfoObj, fieldKeyPoints, key_points_array);
    env->DeleteLocalRef(key_points_array);
    env->SetIntField(handInfoObj, fieldKeyPointsCount, foot_info->key_points_count);
    env->DeleteLocalRef(st_points_class);
    env->DeleteLocalRef(hand_info_cls);

    return handInfoObj;
}

jobject convert2BodyInfo(JNIEnv *env, const st_mobile_body_t *body_info){
    jclass body_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileBodyInfo");

    jfieldID fieldId = env->GetFieldID(body_info_cls, "id", "I");
    jfieldID fieldKeyPoints = env->GetFieldID(body_info_cls, "keyPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldKeyPointsScore = env->GetFieldID(body_info_cls, "keyPointsScore", "[F");
    jfieldID fieldKeyPointsCount = env->GetFieldID(body_info_cls, "keyPointsCount", "I");
    jfieldID fieldContourPoints = env->GetFieldID(body_info_cls, "contourPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldContourPointsScore = env->GetFieldID(body_info_cls, "contourPointsScore", "[F");
    jfieldID fieldContourPointsCount = env->GetFieldID(body_info_cls, "contourPointsCount", "I");
    jfieldID fieldBodyAction = env->GetFieldID(body_info_cls, "bodyAction", "J");
    jfieldID fieldBodyActionScore = env->GetFieldID(body_info_cls, "bodyActionScore", "F");

    jfieldID fieldKeyPoints3d = env->GetFieldID(body_info_cls, "keyPoints3d", "[Lcom/sensetime/stmobile/model/STPoint3f;");
    jfieldID fieldKeyPoints3dScore = env->GetFieldID(body_info_cls, "keyPoints3dScore", "[F");
    jfieldID fieldKeyPoints3dCount = env->GetFieldID(body_info_cls, "keyPoints3dCount", "I");
    jfieldID fieldLabel = env->GetFieldID(body_info_cls, "label", "I");
    jfieldID fieldHandValid= env->GetFieldID(body_info_cls, "handValid", "[I");


    jobject bodyInfoObj = env->AllocObject(body_info_cls);

    jclass st_points_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_points_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_points_class, "y", "F");

    //key_points
    jobjectArray key_points_array = env->NewObjectArray(body_info->key_points_count, st_points_class, 0);
    jfloatArray key_points_score = env->NewFloatArray(body_info->key_points_count);
    jfloat key_points_score_array[body_info->key_points_count];

    for(int i = 0; i < body_info->key_points_count; i++){
        jobject keyPointsObj = env->AllocObject(st_points_class);

        env->SetFloatField(keyPointsObj, fpoint_x, (body_info->p_key_points+i)->x);
        env->SetFloatField(keyPointsObj, fpoint_y, (body_info->p_key_points+i)->y);

        env->SetObjectArrayElement(key_points_array, i, keyPointsObj);
        env->DeleteLocalRef(keyPointsObj);

        key_points_score_array[i] = body_info->p_key_points_score[i];
    }

    env->SetFloatArrayRegion(key_points_score, 0, body_info->key_points_count, key_points_score_array);
    env->SetObjectField(bodyInfoObj, fieldKeyPointsScore, key_points_score);

    env->SetObjectField(bodyInfoObj, fieldKeyPoints, key_points_array);
    env->DeleteLocalRef(key_points_score);
    env->DeleteLocalRef(key_points_array);

    //contour_points
    jobjectArray contour_points_array = env->NewObjectArray(body_info->contour_points_count, st_points_class, 0);
    jfloatArray contour_points_score = env->NewFloatArray(body_info->contour_points_count);
    jfloat contour_points_score_array[body_info->contour_points_count];

    for(int i = 0; i < body_info->contour_points_count; i++){
        jobject contourPointsObj = env->AllocObject(st_points_class);

        env->SetFloatField(contourPointsObj, fpoint_x, (body_info->p_contour_points+i)->x);
        env->SetFloatField(contourPointsObj, fpoint_y, (body_info->p_contour_points+i)->y);

        env->SetObjectArrayElement(contour_points_array, i, contourPointsObj);
        env->DeleteLocalRef(contourPointsObj);

        contour_points_score_array[i] = body_info->p_contour_points_score[i];
    }

    env->SetFloatArrayRegion(contour_points_score, 0, body_info->contour_points_count, contour_points_score_array);
    env->SetObjectField(bodyInfoObj, fieldContourPointsScore, contour_points_score);

    env->SetObjectField(bodyInfoObj, fieldContourPoints, contour_points_array);
    env->DeleteLocalRef(contour_points_score);
    env->DeleteLocalRef(contour_points_array);

    env->SetIntField(bodyInfoObj, fieldId, body_info->id);
    env->SetIntField(bodyInfoObj, fieldKeyPointsCount, body_info->key_points_count);
    env->SetIntField(bodyInfoObj, fieldContourPointsCount, body_info->contour_points_count);
//    env->SetLongField(bodyInfoObj, fieldBodyAction, body_info->body_action);
//    env->SetFloatField(bodyInfoObj, fieldBodyActionScore, body_info->body_action_score);

    jclass st_point3f_class = env->FindClass("com/sensetime/stmobile/model/STPoint3f");
    jfieldID fpoint3_x = env->GetFieldID(st_point3f_class, "x", "F");
    jfieldID fpoint3_y = env->GetFieldID(st_point3f_class, "y", "F");
    jfieldID fpoint3_z = env->GetFieldID(st_point3f_class, "z", "F");

    jfloatArray key_points_3d_score = env->NewFloatArray(body_info->key_points_3d_count);
    jfloat key_points_score_3d_array[body_info->key_points_3d_count];
    if(body_info->key_points_3d_count > 0){
        jobjectArray key_points_3d_array = env->NewObjectArray(body_info->key_points_3d_count, st_point3f_class, 0);
        for(int i = 0; i < body_info->key_points_3d_count; i++){
            jobject extra3dKeyPointsObj = env->AllocObject(st_point3f_class);
            env->SetFloatField(extra3dKeyPointsObj, fpoint3_x, (body_info->p_key_points_3d+i)->x);
            env->SetFloatField(extra3dKeyPointsObj, fpoint3_y, (body_info->p_key_points_3d+i)->y);
            env->SetFloatField(extra3dKeyPointsObj, fpoint3_z, (body_info->p_key_points_3d+i)->z);
            env->SetObjectArrayElement(key_points_3d_array, i, extra3dKeyPointsObj);
            env->DeleteLocalRef(extra3dKeyPointsObj);
            key_points_score_3d_array[i] = body_info->p_key_points_3d_score[i];
        }
        env->SetObjectField(bodyInfoObj, fieldKeyPoints3d, key_points_3d_array);
        env->DeleteLocalRef(key_points_3d_array);
    }
    env->SetFloatArrayRegion(key_points_3d_score, 0, body_info->key_points_3d_count, key_points_score_3d_array);
    env->SetObjectField(bodyInfoObj, fieldKeyPoints3dScore, key_points_3d_score);
    env->DeleteLocalRef(key_points_3d_score);

    env->SetIntField(bodyInfoObj, fieldKeyPoints3dCount, body_info->key_points_3d_count);
    env->SetIntField(bodyInfoObj, fieldLabel, body_info->label);

    jintArray hand_valid = env->NewIntArray(2);
    jint hand_valid_array[2];
    hand_valid_array[0] = body_info->hand_valid[0];
    hand_valid_array[1] = body_info->hand_valid[1];
    env->SetIntArrayRegion(hand_valid, 0, 2, hand_valid_array);
    env->SetObjectField(bodyInfoObj, fieldHandValid, hand_valid);
    env->DeleteLocalRef(hand_valid);

    env->DeleteLocalRef(st_point3f_class);


    env->DeleteLocalRef(st_points_class);
    env->DeleteLocalRef(body_info_cls);

    return bodyInfoObj;
}

jobject convert2FaceInfo(JNIEnv *env, st_mobile_face_t *face_info){
    jclass face_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileFaceInfo");

    jfieldID fieldFace = env->GetFieldID(face_info_cls, "face106", "Lcom/sensetime/stmobile/model/STMobile106;");

    jfieldID fieldExtraFacePoints = env->GetFieldID(face_info_cls, "extraFacePoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldExtraFacePointsCount = env->GetFieldID(face_info_cls, "extraFacePointsCount", "I");

    jfieldID fieldTonguePoints = env->GetFieldID(face_info_cls, "tonguePoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldTonguePointsScore = env->GetFieldID(face_info_cls, "tonguePointsScore", "[F");
    jfieldID fieldTonguePointsCount = env->GetFieldID(face_info_cls, "tonguePointsCount", "I");

    jfieldID fieldEyeballCenter = env->GetFieldID(face_info_cls, "eyeballCenter", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldEyeballCenterPointsCount = env->GetFieldID(face_info_cls, "eyeballCenterPointsCount", "I");

    jfieldID fieldEyeballContour = env->GetFieldID(face_info_cls, "eyeballContour", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldEyeballContourPointsCount = env->GetFieldID(face_info_cls, "eyeballContourPointsCount", "I");

    jfieldID fieldLeftEyeballScore = env->GetFieldID(face_info_cls, "leftEyeballScore", "F");
    jfieldID fieldRightEyeballScore = env->GetFieldID(face_info_cls, "rightEyeballScore", "F");

    jfieldID fieldFaceAction = env->GetFieldID(face_info_cls, "faceAction", "J");
    jfieldID fieldFaceActionScore = env->GetFieldID(face_info_cls, "faceActionScore", "[F");
    jfieldID fieldFaceActionScoreCount = env->GetFieldID(face_info_cls, "faceActionScoreCount", "I");

    jfieldID fieldFaceExtraInfo = env->GetFieldID(face_info_cls, "faceExtraInfo", "Lcom/sensetime/stmobile/model/STFaceExtraInfo;");

    jfieldID fieldAvatarHelpInfo = env->GetFieldID(face_info_cls, "avatarHelpInfo", "[B");
    jfieldID fieldAvatarHelpInfoLength = env->GetFieldID(face_info_cls, "avatarHelpInfoLength", "I");

    jfieldID fieldHairColor = env->GetFieldID(face_info_cls, "hairColor", "Lcom/sensetime/stmobile/model/STColor;");
    jfieldID fieldSkinType = env->GetFieldID(face_info_cls, "skin_type", "I");

    jfieldID fieldFaceMesh = env->GetFieldID(face_info_cls, "faceMesh", "Lcom/sensetime/stmobile/model/STFaceMesh;");

    jfieldID fieldGazeDirection = env->GetFieldID(face_info_cls, "gazeDirection", "[Lcom/sensetime/stmobile/model/STPoint3f;");
    jfieldID fieldGazeScore = env->GetFieldID(face_info_cls, "gazeScore", "[F");

    jfieldID fieldEarInfo = env->GetFieldID(face_info_cls, "earInfo", "Lcom/sensetime/stmobile/model/STMobileEarInfo;");
    jfieldID fieldForeheadInfo = env->GetFieldID(face_info_cls, "foreheadInfo", "Lcom/sensetime/stmobile/model/STMobileForeheadInfo;");

    jobject faceInfoObj = env->AllocObject(face_info_cls);

    //face106
    jclass face106Class = env->FindClass("com/sensetime/stmobile/model/STMobile106");

    jobject face106_object = env->AllocObject(face106Class);
    face106_object = convert2MobileFace106(env, face_info->face106);

    env->SetObjectField(faceInfoObj, fieldFace, face106_object);
    env->DeleteLocalRef(face106_object);

    jclass st_points_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_points_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_points_class, "y", "F");
    env->DeleteLocalRef(face106Class);

    //extra_face_points
    jobjectArray extra_face_points_array = env->NewObjectArray(face_info->extra_face_points_count, st_points_class, 0);
    for(int i = 0; i < face_info->extra_face_points_count; i++){
        jobject extraFacePointsObj = env->AllocObject(st_points_class);

        env->SetFloatField(extraFacePointsObj, fpoint_x, face_info->p_extra_face_points[i].x);
        env->SetFloatField(extraFacePointsObj, fpoint_y, face_info->p_extra_face_points[i].y);

        env->SetObjectArrayElement(extra_face_points_array, i, extraFacePointsObj);
        env->DeleteLocalRef(extraFacePointsObj);
    }

    env->SetObjectField(faceInfoObj, fieldExtraFacePoints, extra_face_points_array);
    env->DeleteLocalRef(extra_face_points_array);

    env->SetIntField(faceInfoObj, fieldExtraFacePointsCount, face_info->extra_face_points_count);

    env->SetFloatField(faceInfoObj, fieldLeftEyeballScore, face_info->left_eyeball_score);
    env->SetFloatField(faceInfoObj, fieldRightEyeballScore, face_info->right_eyeball_score);

    //tongue_points
    jobjectArray tongue_points_array = env->NewObjectArray(face_info->tongue_points_count, st_points_class, 0);
    jfloatArray tongue_points_score = env->NewFloatArray(face_info->tongue_points_count);
    jfloat tongue_points_score_array[face_info->tongue_points_count];

    for(int i = 0; i < face_info->tongue_points_count; i++){
        jobject tonguePointsObj = env->AllocObject(st_points_class);

        env->SetFloatField(tonguePointsObj, fpoint_x, (face_info->p_tongue_points+i)->x);
        env->SetFloatField(tonguePointsObj, fpoint_y, (face_info->p_tongue_points+i)->y);

        env->SetObjectArrayElement(tongue_points_array, i, tonguePointsObj);
        env->DeleteLocalRef(tonguePointsObj);

        tongue_points_score_array[i] = face_info->p_tongue_points_score[i];
    }

    env->SetFloatArrayRegion(tongue_points_score, 0, face_info->tongue_points_count, tongue_points_score_array);
    env->SetObjectField(faceInfoObj, fieldTonguePointsScore, tongue_points_score);

    env->SetObjectField(faceInfoObj, fieldTonguePoints, tongue_points_array);
    env->DeleteLocalRef(tongue_points_score);
    env->DeleteLocalRef(tongue_points_array);
    env->SetIntField(faceInfoObj, fieldTonguePointsCount, face_info->tongue_points_count);

    //eyeball_center
    jobjectArray eyeball_center_array = env->NewObjectArray(face_info->eyeball_center_points_count, st_points_class, 0);
    for(int i = 0; i < face_info->eyeball_center_points_count; i++){
        jobject eyeballCenterObj = env->AllocObject(st_points_class);

        env->SetFloatField(eyeballCenterObj, fpoint_x, face_info->p_eyeball_center[i].x);
        env->SetFloatField(eyeballCenterObj, fpoint_y, face_info->p_eyeball_center[i].y);

        env->SetObjectArrayElement(eyeball_center_array, i, eyeballCenterObj);
        env->DeleteLocalRef(eyeballCenterObj);
    }

    env->SetObjectField(faceInfoObj, fieldEyeballCenter, eyeball_center_array);
    env->DeleteLocalRef(eyeball_center_array);

    env->SetIntField(faceInfoObj, fieldEyeballCenterPointsCount, face_info->eyeball_center_points_count);

    //eyeball_contour
    jobjectArray eyeball_contour_array = env->NewObjectArray(face_info->eyeball_contour_points_count, st_points_class, 0);
    for(int i = 0; i < face_info->eyeball_contour_points_count; i++){
        jobject eyeballContourObj = env->AllocObject(st_points_class);

        env->SetFloatField(eyeballContourObj, fpoint_x, face_info->p_eyeball_contour[i].x);
        env->SetFloatField(eyeballContourObj, fpoint_y, face_info->p_eyeball_contour[i].y);

        env->SetObjectArrayElement(eyeball_contour_array, i, eyeballContourObj);
        env->DeleteLocalRef(eyeballContourObj);
    }

    env->SetObjectField(faceInfoObj, fieldEyeballContour, eyeball_contour_array);
    env->DeleteLocalRef(eyeball_contour_array);

    env->SetIntField(faceInfoObj, fieldEyeballContourPointsCount, face_info->eyeball_contour_points_count);

    //face Action score
    env->SetLongField(faceInfoObj, fieldFaceAction, face_info->face_action);

    env->SetIntField(faceInfoObj, fieldFaceActionScoreCount, face_info->face_action_score_count);
    jfloatArray face_action_score_array = env->NewFloatArray(face_info->face_action_score_count);
    env->SetFloatArrayRegion(face_action_score_array, 0, face_info->face_action_score_count, face_info->p_face_action_score);
    env->SetObjectField(faceInfoObj, fieldFaceActionScore, face_action_score_array);
    env->DeleteLocalRef(face_action_score_array);

    //avatar extra info
    jclass extraClass = env->FindClass("com/sensetime/stmobile/model/STFaceExtraInfo");
    jobject extra_object = env->AllocObject(extraClass);

    extra_object = convert2FaceExtraInfo(env, face_info->face_extra_info );

    env->SetObjectField(faceInfoObj, fieldFaceExtraInfo, extra_object);
    env->DeleteLocalRef(extraClass);

    //Skin color
    env->SetIntField(faceInfoObj, fieldSkinType, face_info->s_type);

    //hair color
    jclass color_class = env->FindClass("com/sensetime/stmobile/model/STColor");
    jfieldID color_r = env->GetFieldID(color_class, "r", "F");
    jfieldID color_g = env->GetFieldID(color_class, "g", "F");
    jfieldID color_b = env->GetFieldID(color_class, "b", "F");
    jfieldID color_a = env->GetFieldID(color_class, "a", "F");

    jobject stColorObj = env->AllocObject(color_class);
    env->SetFloatField(stColorObj, color_r, face_info->hair_color.r);
    env->SetFloatField(stColorObj, color_g, face_info->hair_color.g);
    env->SetFloatField(stColorObj, color_b, face_info->hair_color.b);
    env->SetFloatField(stColorObj, color_a, face_info->hair_color.a);

    env->SetObjectField(faceInfoObj, fieldHairColor, stColorObj);

    //avatar help info
    env->SetIntField(faceInfoObj, fieldAvatarHelpInfoLength, face_info->avatar_help_info_length);
    jbyteArray arrayImageData;
    arrayImageData = (env)->NewByteArray(face_info->avatar_help_info_length);
    jbyte* data = (jbyte*)(face_info->p_avatar_help_info);

    env->SetByteArrayRegion(arrayImageData, 0, face_info->avatar_help_info_length, data);
    env->SetObjectField(faceInfoObj, fieldAvatarHelpInfo, arrayImageData);
    env->DeleteLocalRef(arrayImageData);


    //mesh_points
    if(face_info->p_face_mesh != NULL){
        jobject faceMeshObj = convert2FaceMesh(env, face_info->p_face_mesh);
        env->SetObjectField(faceInfoObj, fieldFaceMesh, faceMeshObj);
    }

    //gaze
    jclass st_point3f_class = env->FindClass("com/sensetime/stmobile/model/STPoint3f");
    jfieldID fpoint3_x = env->GetFieldID(st_point3f_class, "x", "F");
    jfieldID fpoint3_y = env->GetFieldID(st_point3f_class, "y", "F");
    jfieldID fpoint3_z = env->GetFieldID(st_point3f_class, "z", "F");
    jobjectArray gaze_direction_array = (jobjectArray)env->GetObjectField(faceInfoObj, fieldGazeDirection);
    if(gaze_direction_array != NULL){
        jfloatArray gaze_score = (jfloatArray)env->GetObjectField(faceInfoObj, fieldGazeScore);
        jfloat* gazeScore = env->GetFloatArrayElements(gaze_score, 0);
        face_info->p_gaze_score = new float[2];
        memset(face_info->p_gaze_score, 0, sizeof(float)*2);
        memcpy(face_info->p_gaze_score, gazeScore, sizeof(float)*2);
        face_info->p_gaze_direction = new st_point3f_t[2];
        memset(face_info->p_gaze_direction, 0, sizeof(st_point3f_t) * 2);
        env->ReleaseFloatArrayElements(gaze_score, gazeScore, JNI_FALSE);
        env->DeleteLocalRef(gaze_score);
        for(int i = 0; i < 2; i++){
            jobject point = env->GetObjectArrayElement(gaze_direction_array, i);
            face_info->p_gaze_direction[i].x = env->GetFloatField(point, fpoint3_x);
            face_info->p_gaze_direction[i].y = env->GetFloatField(point, fpoint3_y);
            face_info->p_gaze_direction[i].z = env->GetFloatField(point, fpoint3_z);
            env->DeleteLocalRef(point);
        }
        env->DeleteLocalRef(gaze_direction_array);
    }
    env->DeleteLocalRef(st_point3f_class);
    face_info->face_action = env->GetLongField(faceInfoObj, fieldFaceAction);

    //ear and forehead info
    jobject earInfoObj = env->GetObjectField(faceInfoObj, fieldEarInfo);
    jobject foreheadInfoObj = env->GetObjectField(faceInfoObj, fieldForeheadInfo);

    if(earInfoObj != NULL){
        face_info->p_face_ear = new st_mobile_ear_t;
        if(!convert2EarInfo(env, earInfoObj, face_info->p_face_ear)){
            memset(&face_info->p_face_ear, 0, sizeof(st_mobile_ear_t));
        }
    }

    if(foreheadInfoObj != NULL){
        face_info->p_face_forehead = new st_mobile_forehead_t;
        if(!convert2ForeheadInfo(env, foreheadInfoObj, face_info->p_face_forehead)){
            memset(&face_info->p_face_forehead, 0, sizeof(st_mobile_forehead_t));
        }
    }

    env->DeleteLocalRef(st_points_class);
    env->DeleteLocalRef(face_info_cls);

    return faceInfoObj;
}

jobject convert2HumanActionSegments(JNIEnv *env, const st_mobile_human_action_segments_t *human_action_segments){
    jclass human_action_segment_cls = env->FindClass("com/sensetime/stmobile/model/STHumanActionSegments");

    jfieldID fieldImage = env->GetFieldID(human_action_segment_cls, "image", "Lcom/sensetime/stmobile/model/STSegment;");

    jfieldID fieldHair = env->GetFieldID(human_action_segment_cls, "hair", "Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldSkin = env->GetFieldID(human_action_segment_cls, "skin", "Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldHead = env->GetFieldID(human_action_segment_cls, "head", "Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldMouthParse = env->GetFieldID(human_action_segment_cls, "mouthParses", "[Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldMouthParseCount = env->GetFieldID(human_action_segment_cls, "mouthParseCount", "I");
    jfieldID fieldHeadCount = env->GetFieldID(human_action_segment_cls, "headCount", "I");
    jfieldID fieldSky = env->GetFieldID(human_action_segment_cls, "sky", "Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldDepth = env->GetFieldID(human_action_segment_cls, "depth", "Lcom/sensetime/stmobile/model/STSegment;");

    jfieldID fieldFaceOcclusion = env->GetFieldID(human_action_segment_cls, "faceOcclusions", "[Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldFaceOcclusionCount = env->GetFieldID(human_action_segment_cls, "faceOcclusionCount", "I");

    jfieldID fieldMultiSegment = env->GetFieldID(human_action_segment_cls, "multiSegment", "Lcom/sensetime/stmobile/model/STSegment;");

    jobject humanActionSegmentObj = env->AllocObject(human_action_segment_cls);

    //image
    if(human_action_segments->p_figure != NULL){
        jclass segmentClass = env->FindClass("com/sensetime/stmobile/model/STSegment");
        jobject segment_object = env->AllocObject(segmentClass);
        segment_object = convert2Segment(env, human_action_segments->p_figure);

        env->SetObjectField(humanActionSegmentObj, fieldImage, segment_object);
        env->DeleteLocalRef(segmentClass);
    }

    //hair
    if(human_action_segments->p_hair != NULL){
        jclass segmentClass = env->FindClass("com/sensetime/stmobile/model/STSegment");
        jobject segment_object = env->AllocObject(segmentClass);
        segment_object = convert2Segment(env, human_action_segments->p_hair);

        env->SetObjectField(humanActionSegmentObj, fieldHair, segment_object);
        env->DeleteLocalRef(segmentClass);
    }

    //skin
    if(human_action_segments->p_skin != NULL){
        jclass segmentClass = env->FindClass("com/sensetime/stmobile/model/STSegment");
        jobject segment_object = env->AllocObject(segmentClass);
        segment_object = convert2Segment(env, human_action_segments->p_skin);

        env->SetObjectField(humanActionSegmentObj, fieldSkin, segment_object);
        env->DeleteLocalRef(segmentClass);
    }

    //head
    env->SetIntField(humanActionSegmentObj, fieldHeadCount, human_action_segments->head_count);
    if(human_action_segments->p_head != NULL){
        jclass segmentClass = env->FindClass("com/sensetime/stmobile/model/STSegment");
        jobject segment_object = env->AllocObject(segmentClass);
        segment_object = convert2Segment(env, human_action_segments->p_head);

        env->SetObjectField(humanActionSegmentObj, fieldHead, segment_object);
        env->DeleteLocalRef(segmentClass);
    }

    //sky
    if(human_action_segments->p_sky != NULL){
        jclass segmentClass = env->FindClass("com/sensetime/stmobile/model/STSegment");
        jobject segment_object = env->AllocObject(segmentClass);
        segment_object = convert2Segment(env, human_action_segments->p_sky);

        env->SetObjectField(humanActionSegmentObj, fieldSky, segment_object);
        env->DeleteLocalRef(segmentClass);
    }

    //depth
    if(human_action_segments->p_depth != NULL){
        jclass segmentClass = env->FindClass("com/sensetime/stmobile/model/STSegment");
        jobject segment_object = env->AllocObject(segmentClass);
        segment_object = convert2Segment(env, human_action_segments->p_depth);

        env->SetObjectField(humanActionSegmentObj, fieldDepth, segment_object);
        env->DeleteLocalRef(segmentClass);
    }

    //face occ
    env->SetIntField(humanActionSegmentObj, fieldFaceOcclusionCount, human_action_segments->face_occlusion_count);

    jclass faceOccClass = env->FindClass("com/sensetime/stmobile/model/STSegment");
    jobjectArray face_occ_array = env->NewObjectArray(human_action_segments->face_occlusion_count, faceOccClass, 0);
    for(int i = 0; i < human_action_segments->face_occlusion_count; i++){
        jobject faceOccObj = env->AllocObject(faceOccClass);
        faceOccObj = convert2Segment(env, human_action_segments->p_face_occlusion+i);

        env->SetObjectArrayElement(face_occ_array, i, faceOccObj);
        env->DeleteLocalRef(faceOccObj);
    }
    env->SetObjectField(humanActionSegmentObj, fieldFaceOcclusion, face_occ_array);
    env->DeleteLocalRef(face_occ_array);
    env->DeleteLocalRef(faceOccClass);

    //mouth parse
    env->SetIntField(humanActionSegmentObj, fieldMouthParseCount, human_action_segments->mouth_parse_count);

    jclass mouthParseClass = env->FindClass("com/sensetime/stmobile/model/STSegment");
    jobjectArray mouth_parse_array = env->NewObjectArray(human_action_segments->mouth_parse_count, mouthParseClass, 0);
    for(int i = 0; i < human_action_segments->mouth_parse_count; i++){
        jobject mouthParseObj = env->AllocObject(mouthParseClass);
        mouthParseObj = convert2Segment(env, human_action_segments->p_mouth_parse+i);

        env->SetObjectArrayElement(mouth_parse_array, i, mouthParseObj);
        env->DeleteLocalRef(mouthParseObj);
    }
    env->SetObjectField(humanActionSegmentObj, fieldMouthParse, mouth_parse_array);
    env->DeleteLocalRef(mouth_parse_array);
    env->DeleteLocalRef(mouthParseClass);

    //MultiSegment
    if(human_action_segments->p_multi != NULL){
        jclass segmentClass = env->FindClass("com/sensetime/stmobile/model/STSegment");
        jobject segment_object = env->AllocObject(segmentClass);
        segment_object = convert2Segment(env, human_action_segments->p_multi);

        env->SetObjectField(humanActionSegmentObj, fieldMultiSegment, segment_object);
        env->DeleteLocalRef(segmentClass);
    }

    return humanActionSegmentObj;
}

jobject convert2HumanAction(JNIEnv *env, const st_mobile_human_action_t *human_action){
    if(human_action == nullptr) return NULL;

    jclass human_action_cls = env->FindClass("com/sensetime/stmobile/model/STHumanAction");

    jfieldID fieldFaces = env->GetFieldID(human_action_cls, "faces", "[Lcom/sensetime/stmobile/model/STMobileFaceInfo;");
    jfieldID fieldFaceCount = env->GetFieldID(human_action_cls, "faceCount", "I");

    jfieldID fieldFeets = env->GetFieldID(human_action_cls, "feets", "[Lcom/sensetime/stmobile/model/STMobileFoot;");
    jfieldID fieldFootCount = env->GetFieldID(human_action_cls, "footCount", "I");

    jfieldID fieldHands = env->GetFieldID(human_action_cls, "hands", "[Lcom/sensetime/stmobile/model/STMobileHandInfo;");
    jfieldID fieldHandCount = env->GetFieldID(human_action_cls, "handCount", "I");

    jfieldID fieldBodys = env->GetFieldID(human_action_cls, "bodys", "[Lcom/sensetime/stmobile/model/STMobileBodyInfo;");
    jfieldID fieldBodyCount = env->GetFieldID(human_action_cls, "bodyCount", "I");

    jfieldID fieldHeads = env->GetFieldID(human_action_cls, "heads", "[Lcom/sensetime/stmobile/model/STMobileHeadInfo;");
    jfieldID fieldHeadCount = env->GetFieldID(human_action_cls, "headCount", "I");

    jfieldID fieldSegments = env->GetFieldID(human_action_cls, "humanActionSegments", "Lcom/sensetime/stmobile/model/STHumanActionSegments;");

    jobject humanActionObj = env->AllocObject(human_action_cls);

    //faces
    env->SetIntField(humanActionObj, fieldFaceCount, human_action->face_count);

    jclass face_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileFaceInfo");
    jobjectArray face_info_array = env->NewObjectArray(human_action->face_count, face_info_cls, 0);
    for(int i = 0; i < human_action->face_count; i++){
        jobject faceInfoObj = env->AllocObject(face_info_cls);

        faceInfoObj = convert2FaceInfo(env, human_action->p_faces+i);

        env->SetObjectArrayElement(face_info_array, i, faceInfoObj);
        env->DeleteLocalRef(faceInfoObj);
    }

    env->SetObjectField(humanActionObj, fieldFaces, face_info_array);
    env->DeleteLocalRef(face_info_array);
    env->DeleteLocalRef(face_info_cls);

    //hands
    env->SetIntField(humanActionObj, fieldHandCount, human_action->hand_count);

    jclass hand_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileHandInfo");
    jobjectArray hand_info_array = env->NewObjectArray(human_action->hand_count, hand_info_cls, 0);
    for(int i = 0; i < human_action->hand_count; i++){
        jobject handInfoObj = env->AllocObject(hand_info_cls);

        handInfoObj = convert2HandInfo(env, human_action->p_hands+i);

        env->SetObjectArrayElement(hand_info_array, i, handInfoObj);
        env->DeleteLocalRef(handInfoObj);
    }

    env->SetObjectField(humanActionObj, fieldHands, hand_info_array);
    env->DeleteLocalRef(hand_info_array);
    env->DeleteLocalRef(hand_info_cls);

    // feets
    env->SetIntField(humanActionObj, fieldFootCount, human_action->foot_count);
    jclass foot_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileFoot");
    jobjectArray foot_info_array = env->NewObjectArray(human_action->foot_count, foot_info_cls, 0);
    for(int i = 0; i < human_action->foot_count; i++){
        jobject footInfoObj = env->AllocObject(foot_info_cls);

        footInfoObj = convert2FootInfo(env, human_action->p_feet+i);

        env->SetObjectArrayElement(foot_info_array, i, footInfoObj);
        env->DeleteLocalRef(footInfoObj);
    }

    env->SetObjectField(humanActionObj, fieldFeets, foot_info_array);
    env->DeleteLocalRef(foot_info_array);
    env->DeleteLocalRef(foot_info_cls);

    //heads
    env->SetIntField(humanActionObj, fieldHeadCount, human_action->head_count);

    jclass head_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileHeadInfo");
    jobjectArray head_info_array = env->NewObjectArray(human_action->head_count, head_info_cls, 0);
    for(int i = 0; i < human_action->head_count; i++){
        jobject headInfoObj = env->AllocObject(head_info_cls);

        headInfoObj = convert2HeadInfo(env, human_action->p_heads+i);

        env->SetObjectArrayElement(head_info_array, i, headInfoObj);
        env->DeleteLocalRef(headInfoObj);
    }

    env->SetObjectField(humanActionObj, fieldHeads, head_info_array);
    env->DeleteLocalRef(head_info_array);
    env->DeleteLocalRef(head_info_cls);

    //bodys
    env->SetIntField(humanActionObj, fieldBodyCount, human_action->body_count);

    jclass body_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileBodyInfo");
    jobjectArray body_info_array = env->NewObjectArray(human_action->body_count, body_info_cls, 0);
    for(int i = 0; i < human_action->body_count; i++){
        jobject bodyInfoObj = env->AllocObject(body_info_cls);

        bodyInfoObj = convert2BodyInfo(env, human_action->p_bodys+i);

        env->SetObjectArrayElement(body_info_array, i, bodyInfoObj);
        env->DeleteLocalRef(bodyInfoObj);
    }

    env->SetObjectField(humanActionObj, fieldBodys, body_info_array);
    env->DeleteLocalRef(body_info_array);
    env->DeleteLocalRef(body_info_cls);

    //segments
    if(human_action->p_segments != NULL){
        jclass segmentClass = env->FindClass("com/sensetime/stmobile/model/STHumanActionSegments");
        jobject segment_object = env->AllocObject(segmentClass);
        segment_object = convert2HumanActionSegments(env, human_action->p_segments);

        env->SetObjectField(humanActionObj, fieldSegments, segment_object);
        env->DeleteLocalRef(segmentClass);
    }

    env->DeleteLocalRef(human_action_cls);

    return humanActionObj;
}

void convert2HumanAction(JNIEnv *env, const st_mobile_human_action_t *human_action, jobject humanActionObj){
    if(human_action == nullptr) return;

    jclass human_action_cls = env->FindClass("com/sensetime/stmobile/model/STHumanAction");

    jfieldID fieldFaces = env->GetFieldID(human_action_cls, "faces", "[Lcom/sensetime/stmobile/model/STMobileFaceInfo;");
    jfieldID fieldFaceCount = env->GetFieldID(human_action_cls, "faceCount", "I");

    jfieldID fieldHands = env->GetFieldID(human_action_cls, "hands", "[Lcom/sensetime/stmobile/model/STMobileHandInfo;");
    jfieldID fieldHandCount = env->GetFieldID(human_action_cls, "handCount", "I");

    jfieldID fieldBodys = env->GetFieldID(human_action_cls, "bodys", "[Lcom/sensetime/stmobile/model/STMobileBodyInfo;");
    jfieldID fieldBodyCount = env->GetFieldID(human_action_cls, "bodyCount", "I");

    jfieldID fieldHeads = env->GetFieldID(human_action_cls, "heads", "[Lcom/sensetime/stmobile/model/STMobileHeadInfo;");
    jfieldID fieldHeadCount = env->GetFieldID(human_action_cls, "headCount", "I");

    jfieldID fieldSegments = env->GetFieldID(human_action_cls, "humanActionSegments", "Lcom/sensetime/stmobile/model/STHumanActionSegments;");

    //faces
    env->SetIntField(humanActionObj, fieldFaceCount, human_action->face_count);

    jclass face_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileFaceInfo");
    jobjectArray face_info_array = env->NewObjectArray(human_action->face_count, face_info_cls, 0);
    for(int i = 0; i < human_action->face_count; i++){
        jobject faceInfoObj = env->AllocObject(face_info_cls);

        faceInfoObj = convert2FaceInfo(env, human_action->p_faces+i);

        env->SetObjectArrayElement(face_info_array, i, faceInfoObj);
        env->DeleteLocalRef(faceInfoObj);
    }

    env->SetObjectField(humanActionObj, fieldFaces, face_info_array);
    env->DeleteLocalRef(face_info_array);
    env->DeleteLocalRef(face_info_cls);

    //hands
    env->SetIntField(humanActionObj, fieldHandCount, human_action->hand_count);

    jclass hand_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileHandInfo");
    jobjectArray hand_info_array = env->NewObjectArray(human_action->hand_count, hand_info_cls, 0);
    for(int i = 0; i < human_action->hand_count; i++){
        jobject handInfoObj = env->AllocObject(hand_info_cls);

        handInfoObj = convert2HandInfo(env, human_action->p_hands+i);

        env->SetObjectArrayElement(hand_info_array, i, handInfoObj);
        env->DeleteLocalRef(handInfoObj);
    }

    env->SetObjectField(humanActionObj, fieldHands, hand_info_array);
    env->DeleteLocalRef(hand_info_array);
    env->DeleteLocalRef(hand_info_cls);

    //heads
    env->SetIntField(humanActionObj, fieldHeadCount, human_action->head_count);

    jclass head_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileHeadInfo");
    jobjectArray head_info_array = env->NewObjectArray(human_action->head_count, head_info_cls, 0);
    for(int i = 0; i < human_action->head_count; i++){
        jobject headInfoObj = env->AllocObject(head_info_cls);

        headInfoObj = convert2HeadInfo(env, human_action->p_heads+i);

        env->SetObjectArrayElement(head_info_array, i, headInfoObj);
        env->DeleteLocalRef(headInfoObj);
    }

    env->SetObjectField(humanActionObj, fieldHeads, head_info_array);
    env->DeleteLocalRef(head_info_array);
    env->DeleteLocalRef(head_info_cls);

    //bodys
    env->SetIntField(humanActionObj, fieldBodyCount, human_action->body_count);

    jclass body_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileBodyInfo");
    jobjectArray body_info_array = env->NewObjectArray(human_action->body_count, body_info_cls, 0);
    for(int i = 0; i < human_action->body_count; i++){
        jobject bodyInfoObj = env->AllocObject(body_info_cls);

        bodyInfoObj = convert2BodyInfo(env, human_action->p_bodys+i);

        env->SetObjectArrayElement(body_info_array, i, bodyInfoObj);
        env->DeleteLocalRef(bodyInfoObj);
    }

    env->SetObjectField(humanActionObj, fieldBodys, body_info_array);
    env->DeleteLocalRef(body_info_array);
    env->DeleteLocalRef(body_info_cls);

    //segments
    if(human_action->p_segments != NULL){
        jclass segmentClass = env->FindClass("com/sensetime/stmobile/model/STHumanActionSegments");
        jobject segment_object = env->AllocObject(segmentClass);
        segment_object = convert2HumanActionSegments(env, human_action->p_segments);

        env->SetObjectField(humanActionObj, fieldSegments, segment_object);
        env->DeleteLocalRef(segmentClass);
    }

    env->DeleteLocalRef(human_action_cls);
}

jobject convert2AnimalFace(JNIEnv *env, const st_mobile_animal_face_t *animal_face){
    jclass animal_face_cls = env->FindClass("com/sensetime/stmobile/model/STAnimalFace");

    jfieldID fieldId = env->GetFieldID(animal_face_cls, "id", "I");
    jfieldID fieldRect = env->GetFieldID(animal_face_cls, "rect", "Lcom/sensetime/stmobile/model/STRect;");
    jfieldID fieldScore = env->GetFieldID(animal_face_cls, "score", "F");
    jfieldID fieldKeyPoints = env->GetFieldID(animal_face_cls, "p_key_points", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldKeyPointsCount = env->GetFieldID(animal_face_cls, "key_points_count", "I");
    jfieldID fieldYaw = env->GetFieldID(animal_face_cls, "yaw", "F");
    jfieldID fieldPitch = env->GetFieldID(animal_face_cls, "pitch", "F");
    jfieldID fieldRoll = env->GetFieldID(animal_face_cls, "roll", "F");
    jfieldID fieldAnimalType = env->GetFieldID(animal_face_cls, "animalType", "I");
    jfieldID fieldEarScore = env->GetFieldID(animal_face_cls, "earScore", "[F");

    jobject animalfaceObj = env->AllocObject(animal_face_cls);

    env->SetIntField(animalfaceObj, fieldId, animal_face->id);
    jobject strectObj = convert2STRect(env, animal_face->rect);
    env->SetObjectField(animalfaceObj, fieldRect, strectObj);
    env->SetFloatField(animalfaceObj, fieldScore, animal_face->score);
    env->SetIntField(animalfaceObj, fieldKeyPointsCount, animal_face->key_points_count);
    env->SetFloatField(animalfaceObj, fieldYaw, animal_face->yaw);
    env->SetFloatField(animalfaceObj, fieldPitch, animal_face->pitch);
    env->SetFloatField(animalfaceObj, fieldRoll, animal_face->roll);

    jclass st_point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_point_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_point_class, "y", "F");

    jobjectArray key_points_array = env->NewObjectArray(animal_face->key_points_count, st_point_class, 0);

    for(int i = 0; i < animal_face->key_points_count; i++){
        jobject keyPointsObj = env->AllocObject(st_point_class);

        env->SetFloatField(keyPointsObj, fpoint_x, (animal_face->p_key_points+i)->x);
        env->SetFloatField(keyPointsObj, fpoint_y, (animal_face->p_key_points+i)->y);

        env->SetObjectArrayElement(key_points_array, i, keyPointsObj);
        env->DeleteLocalRef(keyPointsObj);
    }

    env->SetIntField(animalfaceObj, fieldAnimalType, (int)animal_face->animal_type);
    if(animal_face->animal_type == ST_MOBILE_ANIMAL_DOG_FACE){
        jfloatArray ear_score = env->NewFloatArray(2);
        jfloat ear_score_array[2];
        ear_score_array[0] = animal_face->ear_score[0];
        ear_score_array[1] = animal_face->ear_score[1];
        env->SetFloatArrayRegion(ear_score, 0, 2, ear_score_array);
        env->SetObjectField(animalfaceObj, fieldEarScore, ear_score);
        env->DeleteLocalRef(ear_score);
    }

    env->SetObjectField(animalfaceObj, fieldKeyPoints, key_points_array);
    env->DeleteLocalRef(key_points_array);

    env->DeleteLocalRef(st_point_class);
    env->DeleteLocalRef(animal_face_cls);

    return animalfaceObj;
}

bool convert2st_rect_t(JNIEnv *env, jobject rectObject, st_rect_t &rect){
    if(rectObject == NULL){
        return false;
    }

    jclass STRectClass = env->GetObjectClass(rectObject);

    if (STRectClass == NULL) {
        return false;
    }

    jfieldID rect_left = env->GetFieldID(STRectClass, "left", "I");
    jfieldID rect_top = env->GetFieldID(STRectClass, "top", "I");
    jfieldID rect_right = env->GetFieldID(STRectClass, "right", "I");
    jfieldID rect_bottom = env->GetFieldID(STRectClass, "bottom", "I");

    rect.left = env->GetIntField(rectObject, rect_left);
    rect.top = env->GetIntField(rectObject, rect_top);
    rect.right = env->GetIntField(rectObject, rect_right);
    rect.bottom = env->GetIntField(rectObject, rect_bottom);

    if(STRectClass != NULL){
        env->DeleteLocalRef(STRectClass);
    }

    return true;
}

bool convert2mobile_106(JNIEnv *env, jobject face106, st_mobile_106_t &mobile_106)
{
    if (face106 == NULL) {
        return false;
    }

    jclass st_mobile_106_class = env->FindClass("com/sensetime/stmobile/model/STMobile106");
    jfieldID frect = env->GetFieldID(st_mobile_106_class, "rect", "Lcom/sensetime/stmobile/model/STRect;");
    jfieldID fscore = env->GetFieldID(st_mobile_106_class, "score", "F");
    jfieldID fpoints_array = env->GetFieldID(st_mobile_106_class, "points_array", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fvisibility_array = env->GetFieldID(st_mobile_106_class, "visibility_array", "[F");
    jfieldID fyaw = env->GetFieldID(st_mobile_106_class, "yaw", "F");
    jfieldID fpitch = env->GetFieldID(st_mobile_106_class, "pitch", "F");
    jfieldID froll = env->GetFieldID(st_mobile_106_class, "roll", "F");
    jfieldID feye_dist = env->GetFieldID(st_mobile_106_class, "eye_dist", "F");
    jfieldID fID = env->GetFieldID(st_mobile_106_class, "ID", "I");

    jclass st_mobile_point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_mobile_point_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_mobile_point_class, "y", "F");

    jclass st_face_rect_class = env->FindClass("com/sensetime/stmobile/model/STRect");
    jfieldID frect_left = env->GetFieldID(st_face_rect_class, "left", "I");
    jfieldID frect_top = env->GetFieldID(st_face_rect_class, "top", "I");
    jfieldID frect_right = env->GetFieldID(st_face_rect_class, "right", "I");
    jfieldID frect_bottom = env->GetFieldID(st_face_rect_class, "bottom", "I");

    mobile_106.score = env->GetFloatField(face106, fscore);
    mobile_106.yaw = env->GetFloatField(face106, fyaw);
    mobile_106.pitch = env->GetFloatField(face106, fpitch);
    mobile_106.roll = env->GetFloatField(face106, froll);
    mobile_106.eye_dist = env->GetFloatField(face106, feye_dist);
    mobile_106.ID = env->GetIntField(face106, fID);

    jobject faceRect = env->GetObjectField(face106, frect);
    mobile_106.rect.left = env->GetIntField(faceRect, frect_left);
    mobile_106.rect.right = env->GetIntField(faceRect, frect_right);
    mobile_106.rect.top = env->GetIntField(faceRect, frect_top);
    mobile_106.rect.bottom = env->GetIntField(faceRect, frect_bottom);

    jobjectArray points_array = (jobjectArray)env->GetObjectField(face106, fpoints_array);
    jfloatArray face_visibility_array = (jfloatArray)env->GetObjectField(face106, fvisibility_array);
    jfloat* visibility_array = env->GetFloatArrayElements(face_visibility_array, 0);

    for (int j = 0; j < 106; ++j)
    {
        jobject point = env->GetObjectArrayElement(points_array, j);

        mobile_106.points_array[j].x = env->GetFloatField(point, fpoint_x);
        mobile_106.points_array[j].y = env->GetFloatField(point, fpoint_y);
        env->DeleteLocalRef(point);

        mobile_106.visibility_array[j] = visibility_array[j];
    }

    env->ReleaseFloatArrayElements(face_visibility_array, visibility_array, JNI_FALSE);
    env->DeleteLocalRef(face_visibility_array);
    env->DeleteLocalRef(points_array);
    env->DeleteLocalRef(faceRect);
    env->DeleteLocalRef(st_mobile_106_class);
    env->DeleteLocalRef(st_face_rect_class);
    env->DeleteLocalRef(st_mobile_point_class);

    return true;
}

unsigned char *convert2JByteArrayToChars(JNIEnv *env, jbyteArray byteArray) {
    if (byteArray == NULL)
        return NULL;
    unsigned char *chars = NULL;
    jbyte *bytes;
    jboolean isCopy = 0;
    bytes = env->GetByteArrayElements(byteArray, &isCopy);
    int chars_len = env->GetArrayLength(byteArray);
    chars = new unsigned char[chars_len + 1];
    memset(chars, 0, chars_len + 1);
    memcpy(chars, bytes, chars_len);
    chars[chars_len] = 0;
    env->ReleaseByteArrayElements(byteArray, bytes, 0);
    return chars;
}

bool convert2Image(JNIEnv *env, jobject image, st_image_t *background){
    if (image == NULL) {
        return false;
    }
    jclass image_cls = env->FindClass("com/sensetime/stmobile/model/STImage");

    jfieldID fieldImageData = env->GetFieldID(image_cls, "imageData", "[B");
    jfieldID fieldPixelFormat = env->GetFieldID(image_cls, "pixelFormat", "I");
    jfieldID fieldWidth = env->GetFieldID(image_cls, "width", "I");
    jfieldID fieldHeight = env->GetFieldID(image_cls, "height", "I");
    jfieldID fieldStride = env->GetFieldID(image_cls, "stride", "I");
    jfieldID fieldTime = env->GetFieldID(image_cls, "timeStamp", "D");

    auto dataArray = (jbyteArray) env->GetObjectField(image, fieldImageData);
    background->data = convert2JByteArrayToChars(env, dataArray);

    background->pixel_format = (st_pixel_format)env->GetIntField(image, fieldPixelFormat);
    background->width = env->GetIntField(image, fieldWidth);
    background->height = env->GetIntField(image, fieldHeight);
    background->stride = env->GetIntField(image, fieldStride);
    double time_stamp = 1.0f;
    background->time_stamp = time_stamp;

    env->DeleteLocalRef(image_cls);

    //test for jni memory leak
    //jclass vm_class = env->FindClass("dalvik/system/VMDebug");
    //jmethodID dump_mid = env->GetStaticMethodID( vm_class, "dumpReferenceTables", "()V" );
    //env->CallStaticVoidMethod( vm_class, dump_mid );

    return true;
}

bool convert2Segment(JNIEnv *env, jobject segmentObj, st_mobile_segment_t *segment){
    if (segmentObj == NULL) {
        return false;
    }

    jclass segment_cls = env->FindClass("com/sensetime/stmobile/model/STSegment");

    jfieldID fieldImage = env->GetFieldID(segment_cls, "image", "Lcom/sensetime/stmobile/model/STImage;");
    jfieldID fieldScore = env->GetFieldID(segment_cls, "score", "F");
    jfieldID fieldMinThrehold = env->GetFieldID(segment_cls, "minThrehold", "F");
    jfieldID fieldMaxThrehold = env->GetFieldID(segment_cls, "maxThrehold", "F");
    jfieldID fieldOffset = env->GetFieldID(segment_cls, "offset", "Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldScale = env->GetFieldID(segment_cls, "scale", "Lcom/sensetime/stmobile/model/STPoint;");

    jobject imageObj = env->GetObjectField(segmentObj, fieldImage);

    if(imageObj != NULL){
        segment->p_segment = new st_image_t;
        memset(segment->p_segment, 0, sizeof(st_image_t));

        convert2Image(env, imageObj, segment->p_segment);
    } else{
        segment->p_segment = NULL;
    }

    segment->score = env->GetFloatField(segmentObj, fieldScore);
    segment->min_threshold = env->GetFloatField(segmentObj, fieldMinThrehold);
    segment->max_threshold = env->GetFloatField(segmentObj, fieldMaxThrehold);

    jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");

    jobject point = env->GetObjectField(segmentObj, fieldOffset);
    segment->offset.x = env->GetFloatField(point, fpoint_x);
    segment->offset.y = env->GetFloatField(point, fpoint_y);

    jobject scale = env->GetObjectField(segmentObj, fieldScale);
    segment->scale.x = env->GetFloatField(scale, fpoint_x);
    segment->scale.y = env->GetFloatField(scale, fpoint_y);

    env->DeleteLocalRef(point_class);

    env->DeleteLocalRef(segment_cls);

    return true;
}

bool convert2HandInfo(JNIEnv *env, jobject handInfoObject, st_mobile_hand_t *hand_info){
    if (handInfoObject == NULL) {
        return false;
    }

    jclass hand_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileHandInfo");

    jfieldID fieldHandId = env->GetFieldID(hand_info_cls, "handId", "I");
    jfieldID fieldHandRect = env->GetFieldID(hand_info_cls, "handRect", "Lcom/sensetime/stmobile/model/STRect;");
    jfieldID fieldKeyPoints = env->GetFieldID(hand_info_cls, "keyPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldKeyPointsCount = env->GetFieldID(hand_info_cls, "keyPointsCount", "I");
    jfieldID fieldHandAction = env->GetFieldID(hand_info_cls, "handAction", "J");
    jfieldID fieldHandActionScore = env->GetFieldID(hand_info_cls, "handActionScore", "F");

    jfieldID fieldLeftRight = env->GetFieldID(hand_info_cls, "left_right", "I");
    jfieldID fieldExtra2dKeyPoints = env->GetFieldID(hand_info_cls, "extra2dKeyPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldExtra3dKeyPoints = env->GetFieldID(hand_info_cls, "extra3dKeyPoints", "[Lcom/sensetime/stmobile/model/STPoint3f;");
    jfieldID fieldExtra2dKeyPointsCount = env->GetFieldID(hand_info_cls, "extra2dKeyPointsCount", "I");
    jfieldID fieldExtra3dKeyPointsCount = env->GetFieldID(hand_info_cls, "extra3dKeyPointsCount", "I");
    jfieldID fieldHandDynamicGesture = env->GetFieldID(hand_info_cls, "dynamicGesture", "Lcom/sensetime/stmobile/model/STHandDynamicGesture;");
    jfieldID fieldGestureKeyPoints = env->GetFieldID(hand_info_cls, "gestureKeyPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldGestureKeyPointsCount = env->GetFieldID(hand_info_cls, "gestureKeyPointsCount", "I");

    jclass hand_rect_class = env->FindClass("com/sensetime/stmobile/model/STRect");
    jfieldID hrect_left = env->GetFieldID(hand_rect_class, "left", "I");
    jfieldID hrect_top = env->GetFieldID(hand_rect_class, "top", "I");
    jfieldID hrect_right = env->GetFieldID(hand_rect_class, "right", "I");
    jfieldID hrect_bottom = env->GetFieldID(hand_rect_class, "bottom", "I");

    jobject handRectObj = env->GetObjectField(handInfoObject, fieldHandRect);
    hand_info->rect.left = env->GetIntField(handRectObj, hrect_left);
    hand_info->rect.top = env->GetIntField(handRectObj, hrect_top);
    hand_info->rect.right = env->GetIntField(handRectObj, hrect_right);
    hand_info->rect.bottom = env->GetIntField(handRectObj, hrect_bottom);

    hand_info->key_points_count = env->GetIntField(handInfoObject, fieldKeyPointsCount);

    //key_points
    hand_info->key_points_count = env->GetIntField(handInfoObject, fieldKeyPointsCount);

    if(hand_info->key_points_count > 0){
        jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
        jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
        jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");

        jobjectArray key_points_array = (jobjectArray)env->GetObjectField(handInfoObject, fieldKeyPoints);
        hand_info->p_key_points = new st_pointf_t[hand_info->key_points_count];
        memset(hand_info->p_key_points, 0, sizeof(st_pointf_t)*hand_info->key_points_count);
        for (int i = 0; i < hand_info->key_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(key_points_array, i);

            (hand_info->p_key_points+i)->x = env->GetFloatField(point, fpoint_x);
            (hand_info->p_key_points+i)->y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(key_points_array);
        env->DeleteLocalRef(point_class);
    } else{
        hand_info->p_key_points = NULL;
    }

    //extra_key_points
    hand_info->skeleton_keypoints_count = env->GetIntField(handInfoObject, fieldExtra2dKeyPointsCount);
    if(hand_info->skeleton_keypoints_count > 0) {
        //2d
        jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
        jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
        jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");

        jobjectArray extra_2d_key_points_array = (jobjectArray) env->GetObjectField(handInfoObject,
                                                                                    fieldExtra2dKeyPoints);
        hand_info->p_skeleton_keypoints = new st_pointf_t[hand_info->skeleton_keypoints_count];
        memset(hand_info->p_skeleton_keypoints, 0,
               sizeof(st_pointf_t) * hand_info->skeleton_keypoints_count);
        for (int i = 0; i < hand_info->skeleton_keypoints_count; ++i) {
            jobject point = env->GetObjectArrayElement(extra_2d_key_points_array, i);

            (hand_info->p_skeleton_keypoints + i)->x = env->GetFloatField(point, fpoint_x);
            (hand_info->p_skeleton_keypoints + i)->y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(extra_2d_key_points_array);
        env->DeleteLocalRef(point_class);
    }else{
        hand_info->p_skeleton_keypoints = NULL;
    }

    hand_info->skeleton_3d_keypoints_count = env->GetIntField(handInfoObject, fieldExtra3dKeyPointsCount);
    if(hand_info->skeleton_3d_keypoints_count > 0){
        //3d
        jclass point3_class = env->FindClass("com/sensetime/stmobile/model/STPoint3f");
        jfieldID fpoint3_x = env->GetFieldID(point3_class, "x", "F");
        jfieldID fpoint3_y = env->GetFieldID(point3_class, "y", "F");
        jfieldID fpoint3_z = env->GetFieldID(point3_class, "z", "F");

        jobjectArray extra_3d_key_points_array = (jobjectArray)env->GetObjectField(handInfoObject, fieldExtra3dKeyPoints);
        hand_info->p_skeleton_3d_keypoints = new st_point3f_t[hand_info->skeleton_3d_keypoints_count];
        memset(hand_info->p_skeleton_3d_keypoints, 0, sizeof(st_point3f_t)*hand_info->skeleton_3d_keypoints_count);
        for (int i = 0; i < hand_info->skeleton_3d_keypoints_count; ++i) {
            jobject point = env->GetObjectArrayElement(extra_3d_key_points_array, i);

            (hand_info->p_skeleton_3d_keypoints+i)->x = env->GetFloatField(point, fpoint3_x);
            (hand_info->p_skeleton_3d_keypoints+i)->y = env->GetFloatField(point, fpoint3_y);
            (hand_info->p_skeleton_3d_keypoints+i)->z = env->GetFloatField(point, fpoint3_z);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(extra_3d_key_points_array);
        env->DeleteLocalRef(point3_class);
    }else{
        hand_info->p_skeleton_3d_keypoints = NULL;
    }

    hand_info->dynamic_gesture_keypoints_count = env->GetIntField(handInfoObject, fieldGestureKeyPointsCount);
    if(hand_info->dynamic_gesture_keypoints_count > 0){
        //2d
        jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
        jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
        jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");

        jobjectArray dynamic_gesture_keypoints_array = (jobjectArray) env->GetObjectField(handInfoObject,
                                                                                          fieldGestureKeyPoints);
        hand_info->p_dynamic_gesture_keypoints = new st_pointf_t[hand_info->dynamic_gesture_keypoints_count];
        memset(hand_info->p_dynamic_gesture_keypoints, 0,
               sizeof(st_pointf_t) * hand_info->dynamic_gesture_keypoints_count);
        for (int i = 0; i < hand_info->dynamic_gesture_keypoints_count; ++i) {
            jobject point = env->GetObjectArrayElement(dynamic_gesture_keypoints_array, i);

            (hand_info->p_dynamic_gesture_keypoints + i)->x = env->GetFloatField(point, fpoint_x);
            (hand_info->p_dynamic_gesture_keypoints + i)->y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(dynamic_gesture_keypoints_array);
        env->DeleteLocalRef(point_class);
    }else{
        hand_info->p_dynamic_gesture_keypoints = NULL;
    }
    jclass st_dynamic_gesture_class = env->FindClass("com/sensetime/stmobile/model/STHandDynamicGesture");
    jfieldID has_dynamic_gesture = env->GetFieldID(st_dynamic_gesture_class, "has_dynamic_gesture", "I");
    jfieldID dynamic_gesture = env->GetFieldID(st_dynamic_gesture_class, "dynamic_gesture", "I");
    jfieldID score = env->GetFieldID(st_dynamic_gesture_class, "score", "F");
    jobject dynamicGestureObj = env->GetObjectField(handInfoObject, fieldHandDynamicGesture);
    hand_info->hand_dynamic_gesture.has_dynamic_gesture = env->GetIntField(dynamicGestureObj, has_dynamic_gesture);
    hand_info->hand_dynamic_gesture.dynamic_gesture = (st_hand_dynamic_gesture_type_t)env->GetIntField(dynamicGestureObj, dynamic_gesture);
    hand_info->hand_dynamic_gesture.score = env->GetFloatField(dynamicGestureObj, score);
    hand_info->left_right = env->GetIntField(handInfoObject, fieldLeftRight);

    hand_info->id = env->GetIntField(handInfoObject, fieldHandId);
    hand_info->hand_action = env->GetLongField(handInfoObject, fieldHandAction);
    hand_info->score = env->GetFloatField(handInfoObject, fieldHandActionScore);

    env->DeleteLocalRef(hand_info_cls);
    env->DeleteLocalRef(hand_rect_class);
    env->DeleteLocalRef(handRectObj);

    return true;
}

bool convert2FaceInfo(JNIEnv *env, jobject faceInfoObject, st_mobile_face_t *face_info){
    if (faceInfoObject == NULL) {
        return false;
    }

    jclass face_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileFaceInfo");

    jfieldID fieldFace = env->GetFieldID(face_info_cls, "face106", "Lcom/sensetime/stmobile/model/STMobile106;");

    jfieldID fieldExtraFacePoints = env->GetFieldID(face_info_cls, "extraFacePoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldExtraFacePointsCount = env->GetFieldID(face_info_cls, "extraFacePointsCount", "I");

    jfieldID fieldTonguePoints = env->GetFieldID(face_info_cls, "tonguePoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldTonguePointsScore = env->GetFieldID(face_info_cls, "tonguePointsScore", "[F");
    jfieldID fieldTonguePointsCount = env->GetFieldID(face_info_cls, "tonguePointsCount", "I");

    jfieldID fieldEyeballCenter = env->GetFieldID(face_info_cls, "eyeballCenter", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldEyeballCenterPointsCount = env->GetFieldID(face_info_cls, "eyeballCenterPointsCount", "I");

    jfieldID fieldEyeballContour = env->GetFieldID(face_info_cls, "eyeballContour", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldEyeballContourPointsCount = env->GetFieldID(face_info_cls, "eyeballContourPointsCount", "I");

    jfieldID fieldLeftEyeballScore = env->GetFieldID(face_info_cls, "leftEyeballScore", "F");
    jfieldID fieldRightEyeballScore = env->GetFieldID(face_info_cls, "rightEyeballScore", "F");

    jfieldID fieldFaceAction = env->GetFieldID(face_info_cls, "faceAction", "J");
    jfieldID fieldFaceActionScore = env->GetFieldID(face_info_cls, "faceActionScore", "[F");
    jfieldID fieldFaceActionScoreCount = env->GetFieldID(face_info_cls, "faceActionScoreCount", "I");

    jfieldID fieldFaceExtraInfo = env->GetFieldID(face_info_cls, "faceExtraInfo", "Lcom/sensetime/stmobile/model/STFaceExtraInfo;");

    jfieldID fieldAvatarHelpInfo = env->GetFieldID(face_info_cls, "avatarHelpInfo", "[B");
    jfieldID fieldAvatarHelpInfoLength = env->GetFieldID(face_info_cls, "avatarHelpInfoLength", "I");

    jfieldID fieldHairColor = env->GetFieldID(face_info_cls, "hairColor", "Lcom/sensetime/stmobile/model/STColor;");
    jfieldID fieldSkinType = env->GetFieldID(face_info_cls, "skin_type", "I");

    jfieldID fieldFaceMesh = env->GetFieldID(face_info_cls, "faceMesh", "Lcom/sensetime/stmobile/model/STFaceMesh;");

    jfieldID fieldGazeDirection = env->GetFieldID(face_info_cls, "gazeDirection", "[Lcom/sensetime/stmobile/model/STPoint3f;");
    jfieldID fieldGazeScore = env->GetFieldID(face_info_cls, "gazeScore", "[F");

    jfieldID fieldEarInfo = env->GetFieldID(face_info_cls, "earInfo", "Lcom/sensetime/stmobile/model/STMobileEarInfo;");
    jfieldID fieldForeheadInfo = env->GetFieldID(face_info_cls, "foreheadInfo", "Lcom/sensetime/stmobile/model/STMobileForeheadInfo;");


    //face106
    jobject face106Obj = env->GetObjectField(faceInfoObject, fieldFace);
    convert2mobile_106(env, face106Obj, face_info->face106);
    env->DeleteLocalRef(face106Obj);

    jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");

    //extra_face_points
    face_info->extra_face_points_count = env->GetIntField(faceInfoObject, fieldExtraFacePointsCount);

    if(face_info->extra_face_points_count > 0){
        jobjectArray extra_face_points_array = (jobjectArray)env->GetObjectField(faceInfoObject, fieldExtraFacePoints);
        face_info->p_extra_face_points = new st_pointf_t[face_info->extra_face_points_count];
        memset(face_info->p_extra_face_points, 0, sizeof(st_pointf_t)*face_info->extra_face_points_count);
        for (int i = 0; i < face_info->extra_face_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(extra_face_points_array, i);

            face_info->p_extra_face_points[i].x = env->GetFloatField(point, fpoint_x);
            face_info->p_extra_face_points[i].y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(extra_face_points_array);
    }else{
        face_info->p_extra_face_points = NULL;
    }

    face_info->left_eyeball_score = env->GetFloatField(faceInfoObject, fieldLeftEyeballScore);
    face_info->right_eyeball_score = env->GetFloatField(faceInfoObject, fieldRightEyeballScore);

    //TonguePoints
    face_info->tongue_points_count = env->GetIntField(faceInfoObject, fieldTonguePointsCount);

    if(face_info->tongue_points_count > 0){
        jfloatArray score_array= (jfloatArray)env->GetObjectField(faceInfoObject, fieldTonguePointsScore);
        float* scores = env->GetFloatArrayElements(score_array, 0);

        face_info->p_tongue_points_score = new float[face_info->tongue_points_count];
        memset(face_info->p_tongue_points_score, 0, sizeof(float)*face_info->tongue_points_count);
        memcpy(face_info->p_tongue_points_score, scores, sizeof(float)*face_info->tongue_points_count);

        env->ReleaseFloatArrayElements(score_array, scores, JNI_FALSE);
        env->DeleteLocalRef(score_array);

        jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
        jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
        jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");

        jobjectArray key_points_array = (jobjectArray)env->GetObjectField(faceInfoObject, fieldTonguePoints);
        face_info->p_tongue_points = new st_pointf_t[face_info->tongue_points_count];
        memset(face_info->p_tongue_points, 0, sizeof(st_pointf_t)*face_info->tongue_points_count);
        for (int i = 0; i < face_info->tongue_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(key_points_array, i);
            (face_info->p_tongue_points+i)->x = env->GetFloatField(point, fpoint_x);
            (face_info->p_tongue_points+i)->y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(key_points_array);
        env->DeleteLocalRef(point_class);
    } else{
        face_info->p_tongue_points = NULL;
        face_info->p_tongue_points_score = NULL;
    }


    //eyeball_center
    face_info->eyeball_center_points_count = env->GetIntField(faceInfoObject, fieldEyeballCenterPointsCount);

    if(face_info->eyeball_center_points_count > 0){
        jobjectArray eyeball_center_array = (jobjectArray)env->GetObjectField(faceInfoObject, fieldEyeballCenter);

        face_info->p_eyeball_center = new st_pointf_t[face_info->eyeball_center_points_count];
        memset(face_info->p_eyeball_center, 0, sizeof(st_pointf_t)*face_info->eyeball_center_points_count);
        for (int i = 0; i < face_info->eyeball_center_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(eyeball_center_array, i);

            face_info->p_eyeball_center[i].x = env->GetFloatField(point, fpoint_x);
            face_info->p_eyeball_center[i].y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(eyeball_center_array);
    }else{
        face_info->p_eyeball_center = NULL;
    }

    //eyeball_contour
    face_info->eyeball_contour_points_count = env->GetIntField(faceInfoObject, fieldEyeballContourPointsCount);

    if(face_info->eyeball_contour_points_count > 0){
        jobjectArray eyeball_contour_array = (jobjectArray)env->GetObjectField(faceInfoObject, fieldEyeballContour);

        face_info->p_eyeball_contour = new st_pointf_t[face_info->eyeball_contour_points_count];
        memset(face_info->p_eyeball_contour, 0, sizeof(st_pointf_t)*face_info->eyeball_contour_points_count);
        for (int i = 0; i < face_info->eyeball_contour_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(eyeball_contour_array, i);

            face_info->p_eyeball_contour[i].x = env->GetFloatField(point, fpoint_x);
            face_info->p_eyeball_contour[i].y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(eyeball_contour_array);
    } else{
        face_info->p_eyeball_contour = NULL;
    }

    //face Action score
    face_info->face_action = env->GetLongField(faceInfoObject, fieldFaceAction);

    face_info->face_action_score_count = env->GetIntField(faceInfoObject, fieldFaceActionScoreCount);
    if(face_info->face_action_score_count > 0){
        jfloatArray score_array= (jfloatArray)env->GetObjectField(faceInfoObject, fieldFaceActionScore);
        float* scores = env->GetFloatArrayElements(score_array, 0);

        face_info->p_face_action_score = new float[face_info->face_action_score_count];
        memset(face_info->p_face_action_score, 0, sizeof(float)*face_info->face_action_score_count);
        memcpy(face_info->p_face_action_score, scores, sizeof(float)*face_info->face_action_score_count);

        env->ReleaseFloatArrayElements(score_array, scores, JNI_FALSE);
        env->DeleteLocalRef(score_array);
    } else{
        face_info->p_face_action_score = NULL;
    }

    //avatar extra info
    jobject faceExtraInfoObj = env->GetObjectField(faceInfoObject, fieldFaceExtraInfo);
    if(faceExtraInfoObj != NULL){
        convert2FaceExtraInfo(env, faceExtraInfoObj, &face_info->face_extra_info);
    }


    //Skin color
    face_info->s_type = env->GetIntField(faceInfoObject, fieldSkinType);

    //hair color
    jobject hairColorObj = env->GetObjectField(faceInfoObject, fieldHairColor);

    if(hairColorObj != NULL){
        convert2Color(env, hairColorObj, &face_info->hair_color);
    }

    env->DeleteLocalRef(hairColorObj);

//    //avatar help info
    face_info->avatar_help_info_length = env->GetIntField(faceInfoObject, fieldAvatarHelpInfoLength);
    if(face_info->avatar_help_info_length > 0){
        jobject avatar_help_info = env->GetObjectField(faceInfoObject, fieldAvatarHelpInfo);
        jbyteArray *arr = reinterpret_cast<jbyteArray*>(&avatar_help_info);
        jbyte* data = env->GetByteArrayElements(*arr, NULL);

        face_info->p_avatar_help_info = new unsigned char[face_info->avatar_help_info_length];
        memset(face_info->p_avatar_help_info, 0, sizeof(unsigned char)*face_info->avatar_help_info_length);
        for (int i = 0; i < face_info->avatar_help_info_length; ++i) {
            face_info->p_avatar_help_info[i] = data[i];
        }

        env->ReleaseByteArrayElements(*arr, data, JNI_FALSE);
        env->DeleteLocalRef(avatar_help_info);
    } else{
        face_info->p_avatar_help_info = NULL;
    }

    //mesh_points
    jobject faceMeshObj = env->GetObjectField(faceInfoObject, fieldFaceMesh);
    if(faceMeshObj != NULL){
        face_info->p_face_mesh = new st_mobile_face_mesh_t;
        if(!convert2FaceMesh(env, faceMeshObj, face_info->p_face_mesh)){
            memset(&face_info->p_face_mesh, 0, sizeof(st_mobile_face_mesh_t));
        }
    }

    //gaze
    jclass st_point3f_class = env->FindClass("com/sensetime/stmobile/model/STPoint3f");
    jfieldID fpoint3_x = env->GetFieldID(st_point3f_class, "x", "F");
    jfieldID fpoint3_y = env->GetFieldID(st_point3f_class, "y", "F");
    jfieldID fpoint3_z = env->GetFieldID(st_point3f_class, "z", "F");
    jobjectArray gaze_direction_array = (jobjectArray)env->GetObjectField(faceInfoObject, fieldGazeDirection);
    if(gaze_direction_array != NULL){
        jfloatArray gaze_score = (jfloatArray)env->GetObjectField(faceInfoObject, fieldGazeScore);
        jfloat* gazeScore = env->GetFloatArrayElements(gaze_score, 0);
        face_info->p_gaze_score = new float[2];
        memset(face_info->p_gaze_score, 0, sizeof(float)*2);
        memcpy(face_info->p_gaze_score, gazeScore, sizeof(float)*2);
        face_info->p_gaze_direction = new st_point3f_t[2];
        memset(face_info->p_gaze_direction, 0, sizeof(st_point3f_t) * 2);
        env->ReleaseFloatArrayElements(gaze_score, gazeScore, JNI_FALSE);
        env->DeleteLocalRef(gaze_score);
        for(int i = 0; i < 2; i++){
            jobject point = env->GetObjectArrayElement(gaze_direction_array, i);
            face_info->p_gaze_direction[i].x = env->GetFloatField(point, fpoint3_x);
            face_info->p_gaze_direction[i].y = env->GetFloatField(point, fpoint3_y);
            face_info->p_gaze_direction[i].z = env->GetFloatField(point, fpoint3_z);
            env->DeleteLocalRef(point);
        }
        env->DeleteLocalRef(gaze_direction_array);
    }
    env->DeleteLocalRef(st_point3f_class);
    face_info->face_action = env->GetLongField(faceInfoObject, fieldFaceAction);

    //ear and forehead info
    jobject earInfoObj = env->GetObjectField(faceInfoObject, fieldEarInfo);
    jobject foreheadInfoObj = env->GetObjectField(faceInfoObject, fieldForeheadInfo);

    if(earInfoObj != NULL){
        face_info->p_face_ear = new st_mobile_ear_t;
        if(!convert2EarInfo(env, earInfoObj, face_info->p_face_ear)){
            memset(&face_info->p_face_ear, 0, sizeof(st_mobile_ear_t));
        }
    }

    if(foreheadInfoObj != NULL){
        face_info->p_face_forehead = new st_mobile_forehead_t;
        if(!convert2ForeheadInfo(env, foreheadInfoObj, face_info->p_face_forehead)){
            memset(&face_info->p_face_forehead, 0, sizeof(st_mobile_forehead_t));
        }
    }

    env->DeleteLocalRef(point_class);
    env->DeleteLocalRef(face_info_cls);

    return true;
}

bool convert2BodyInfo(JNIEnv *env, jobject bodyInfoObject, st_mobile_body_t *body_info){
    if (bodyInfoObject == NULL) {
        return false;
    }

    jclass body_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileBodyInfo");

    jfieldID fieldBodyId = env->GetFieldID(body_info_cls, "id", "I");
    jfieldID fieldKeyPoints = env->GetFieldID(body_info_cls, "keyPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldKeyPointsScore = env->GetFieldID(body_info_cls, "keyPointsScore", "[F");
    jfieldID fieldKeyPointsCount = env->GetFieldID(body_info_cls, "keyPointsCount", "I");
    jfieldID fieldContourPoints = env->GetFieldID(body_info_cls, "contourPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldContourPointsScore = env->GetFieldID(body_info_cls, "contourPointsScore", "[F");
    jfieldID fieldContourPointsCount = env->GetFieldID(body_info_cls, "contourPointsCount", "I");
    jfieldID fieldBodyAction = env->GetFieldID(body_info_cls, "bodyAction", "J");
    jfieldID fieldBodyActionScore = env->GetFieldID(body_info_cls, "bodyActionScore", "F");

    jfieldID fieldKeyPoints3d = env->GetFieldID(body_info_cls, "keyPoints3d", "[Lcom/sensetime/stmobile/model/STPoint3f;");
    jfieldID fieldKeyPoints3dScore = env->GetFieldID(body_info_cls, "keyPoints3dScore", "[F");
    jfieldID fieldKeyPoints3dCount = env->GetFieldID(body_info_cls, "keyPoints3dCount", "I");
    jfieldID fieldLabel = env->GetFieldID(body_info_cls, "label", "I");
    jfieldID fieldHandValid= env->GetFieldID(body_info_cls, "handValid", "[I");


    //key_points
    body_info->key_points_count = env->GetIntField(bodyInfoObject, fieldKeyPointsCount);

    if(body_info->key_points_count > 0){
        jfloatArray score_array= (jfloatArray)env->GetObjectField(bodyInfoObject, fieldKeyPointsScore);
        float* scores = env->GetFloatArrayElements(score_array, 0);

        body_info->p_key_points_score = new float[body_info->key_points_count];
        memset(body_info->p_key_points_score, 0, sizeof(float)*body_info->key_points_count);
        memcpy(body_info->p_key_points_score, scores, sizeof(float)*body_info->key_points_count);

        env->ReleaseFloatArrayElements(score_array, scores, JNI_FALSE);
        env->DeleteLocalRef(score_array);

        jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
        jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
        jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");

        jobjectArray key_points_array = (jobjectArray)env->GetObjectField(bodyInfoObject, fieldKeyPoints);
        body_info->p_key_points = new st_pointf_t[body_info->key_points_count];
        memset(body_info->p_key_points, 0, sizeof(st_pointf_t)*body_info->key_points_count);
        for (int i = 0; i < body_info->key_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(key_points_array, i);
            (body_info->p_key_points+i)->x = env->GetFloatField(point, fpoint_x);
            (body_info->p_key_points+i)->y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(key_points_array);
        env->DeleteLocalRef(point_class);
    } else{
        body_info->p_key_points = NULL;
        body_info->p_key_points_score = NULL;
    }

    //contour_points
    body_info->contour_points_count = env->GetIntField(bodyInfoObject, fieldContourPointsCount);

    if(body_info->contour_points_count > 0){
        jfloatArray score_array= (jfloatArray)env->GetObjectField(bodyInfoObject, fieldContourPointsScore);
        float* scores = env->GetFloatArrayElements(score_array, 0);

        body_info->p_contour_points_score = new float[body_info->contour_points_count];
        memset(body_info->p_contour_points_score, 0, sizeof(float)*body_info->contour_points_count);
        memcpy(body_info->p_contour_points_score, scores, sizeof(float)*body_info->contour_points_count);

        env->ReleaseFloatArrayElements(score_array, scores, JNI_FALSE);
        env->DeleteLocalRef(score_array);

        jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
        jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
        jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");

        jobjectArray contour_points_array = (jobjectArray)env->GetObjectField(bodyInfoObject, fieldContourPoints);
        body_info->p_contour_points = new st_pointf_t[body_info->contour_points_count];
        memset(body_info->p_contour_points, 0, sizeof(st_pointf_t)*body_info->contour_points_count);
        for (int i = 0; i < body_info->contour_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(contour_points_array, i);
            (body_info->p_contour_points+i)->x = env->GetFloatField(point, fpoint_x);
            (body_info->p_contour_points+i)->y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(contour_points_array);
        env->DeleteLocalRef(point_class);
    } else{
        body_info->p_contour_points = NULL;
        body_info->p_contour_points_score = NULL;
    }

    body_info->id = env->GetIntField(bodyInfoObject, fieldBodyId);
//    body_info->body_action = env->GetLongField(bodyInfoObject, fieldBodyAction);
//    body_info->body_action_score = env->GetFloatField(bodyInfoObject, fieldBodyActionScore);

    body_info->key_points_3d_count = env->GetIntField(bodyInfoObject, fieldKeyPoints3dCount);
    if(body_info->key_points_3d_count > 0){
        //3d
        jclass point3_class = env->FindClass("com/sensetime/stmobile/model/STPoint3f");
        jfieldID fpoint3_x = env->GetFieldID(point3_class, "x", "F");
        jfieldID fpoint3_y = env->GetFieldID(point3_class, "y", "F");
        jfieldID fpoint3_z = env->GetFieldID(point3_class, "z", "F");

        jobjectArray extra_3d_key_points_array = (jobjectArray)env->GetObjectField(bodyInfoObject, fieldKeyPoints3d);
        body_info->p_key_points_3d = new st_point3f_t[body_info->key_points_3d_count];
        memset(body_info->p_key_points_3d, 0, sizeof(st_point3f_t)*body_info->key_points_3d_count);
        for (int i = 0; i < body_info->key_points_3d_count; ++i) {
            jobject point = env->GetObjectArrayElement(extra_3d_key_points_array, i);

            (body_info->p_key_points_3d+i)->x = env->GetFloatField(point, fpoint3_x);
            (body_info->p_key_points_3d+i)->y = env->GetFloatField(point, fpoint3_y);
            (body_info->p_key_points_3d+i)->z = env->GetFloatField(point, fpoint3_z);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(extra_3d_key_points_array);
        env->DeleteLocalRef(point3_class);

        jfloatArray score_array= (jfloatArray)env->GetObjectField(bodyInfoObject, fieldKeyPoints3dScore);
        float* scores = env->GetFloatArrayElements(score_array, 0);

        body_info->p_key_points_3d_score = new float[body_info->key_points_3d_count];
        memset(body_info->p_key_points_3d_score, 0, sizeof(float)*body_info->key_points_3d_count);
        memcpy(body_info->p_key_points_3d_score, scores, sizeof(float)*body_info->key_points_3d_count);

        env->ReleaseFloatArrayElements(score_array, scores, JNI_FALSE);
        env->DeleteLocalRef(score_array);
    }else{
        body_info->p_key_points_3d = NULL;
    }

    body_info->label = env->GetIntField(bodyInfoObject, fieldLabel);

    jintArray hand_valid_array = (jintArray)env->GetObjectField(bodyInfoObject, fieldHandValid);
    int* hand_valid = env->GetIntArrayElements(hand_valid_array, 0);
    body_info->hand_valid[0] = hand_valid[0];
    body_info->hand_valid[1] = hand_valid[1];
    env->ReleaseIntArrayElements(hand_valid_array, hand_valid, JNI_FALSE);
    env->DeleteLocalRef(hand_valid_array);


    env->DeleteLocalRef(body_info_cls);

    return true;
}

bool convert2HumanActionSegments(JNIEnv *env, jobject humanActionSegmentObject, st_mobile_human_action_segments_t *human_action_segments){
    if (humanActionSegmentObject == NULL) {
        return false;
    }

    jclass human_action_segments_cls = env->FindClass("com/sensetime/stmobile/model/STHumanActionSegments");

    jfieldID fieldImage = env->GetFieldID(human_action_segments_cls, "image", "Lcom/sensetime/stmobile/model/STSegment;");

    jfieldID fieldHair = env->GetFieldID(human_action_segments_cls, "hair", "Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldHead = env->GetFieldID(human_action_segments_cls, "head", "Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldSkin = env->GetFieldID(human_action_segments_cls, "skin", "Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldSky  = env->GetFieldID(human_action_segments_cls, "sky", "Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldMouthParse = env->GetFieldID(human_action_segments_cls, "mouthParses", "[Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldMouthParseCount = env->GetFieldID(human_action_segments_cls, "mouthParseCount", "I");
    jfieldID fieldHeadCount = env->GetFieldID(human_action_segments_cls, "headCount", "I");

    jfieldID fieldFaceOcclusion = env->GetFieldID(human_action_segments_cls, "faceOcclusions", "[Lcom/sensetime/stmobile/model/STSegment;");
    jfieldID fieldFaceOcclusionCount = env->GetFieldID(human_action_segments_cls, "faceOcclusionCount", "I");

    jfieldID fieldMultiSegment = env->GetFieldID(human_action_segments_cls, "multiSegment", "Lcom/sensetime/stmobile/model/STSegment;");

    //image
    jobject imageObj = env->GetObjectField(humanActionSegmentObject, fieldImage);

    if(imageObj != NULL){
        human_action_segments->p_figure = new st_mobile_segment_t;
        memset(human_action_segments->p_figure, 0, sizeof(st_mobile_segment_t));

        convert2Segment(env, imageObj, human_action_segments->p_figure);
    } else{
        human_action_segments->p_figure = NULL;
    }

    env->DeleteLocalRef(imageObj);

    //hair
    jobject hairObj = env->GetObjectField(humanActionSegmentObject, fieldHair);

    if(hairObj != NULL){
        human_action_segments->p_hair = new st_mobile_segment_t;
        memset(human_action_segments->p_hair, 0, sizeof(st_mobile_segment_t));

        convert2Segment(env, hairObj, human_action_segments->p_hair);
    } else{
        human_action_segments->p_hair = NULL;
    }

    env->DeleteLocalRef(hairObj);

    //skin
    jobject skinObj = env->GetObjectField(humanActionSegmentObject, fieldSkin);

    if(skinObj != NULL){
        human_action_segments->p_skin = new st_mobile_segment_t;
        memset(human_action_segments->p_skin, 0, sizeof(st_mobile_segment_t));

        convert2Segment(env, skinObj, human_action_segments->p_skin);
    } else{
        human_action_segments->p_skin = NULL;
    }

    jobject skyObj = env->GetObjectField(humanActionSegmentObject, fieldSky);
    if(skyObj != NULL){
        human_action_segments->p_sky = new st_mobile_segment_t;
        memset(human_action_segments->p_sky, 0, sizeof(st_mobile_segment_t));

        convert2Segment(env, skyObj, human_action_segments->p_sky);
    } else{
        human_action_segments->p_sky = NULL;
    }

    env->DeleteLocalRef(skinObj);
    env->DeleteLocalRef(skyObj);

    //head
    jobject headObj = env->GetObjectField(humanActionSegmentObject, fieldHead);
    human_action_segments->head_count = env->GetIntField(humanActionSegmentObject, fieldHeadCount);

    if(headObj != NULL){
        human_action_segments->p_head = new st_mobile_segment_t;
        memset(human_action_segments->p_head, 0, sizeof(st_mobile_segment_t));

        convert2Segment(env, headObj, human_action_segments->p_head);
    } else{
        human_action_segments->p_head = NULL;
    }

    //face occ
    human_action_segments->face_occlusion_count = env->GetIntField(humanActionSegmentObject, fieldFaceOcclusionCount);
    if(human_action_segments->face_occlusion_count > 0){
        jobjectArray face_occ_obj_array = (jobjectArray)env->GetObjectField(humanActionSegmentObject, fieldFaceOcclusion);

        human_action_segments->p_face_occlusion = new st_mobile_segment_t[human_action_segments->face_occlusion_count];
        memset(human_action_segments->p_face_occlusion, 0, sizeof(st_mobile_segment_t)*human_action_segments->face_occlusion_count);
        for(int i = 0; i < human_action_segments->face_occlusion_count; i++){
            jobject faceOccObj = env->GetObjectArrayElement(face_occ_obj_array, i);
            convert2Segment(env, faceOccObj, human_action_segments->p_face_occlusion+i);

            env->DeleteLocalRef(faceOccObj);
        }

        env->DeleteLocalRef(face_occ_obj_array);
    } else{
        human_action_segments->p_face_occlusion = NULL;
    }

    //mouth parse
    human_action_segments->mouth_parse_count = env->GetIntField(humanActionSegmentObject, fieldMouthParseCount);
    if(human_action_segments->mouth_parse_count > 0){
        jobjectArray mouth_parse_obj_array = (jobjectArray)env->GetObjectField(humanActionSegmentObject, fieldMouthParse);

        human_action_segments->p_mouth_parse = new st_mobile_segment_t[human_action_segments->mouth_parse_count];
        memset(human_action_segments->p_mouth_parse, 0, sizeof(st_mobile_segment_t)*human_action_segments->mouth_parse_count);
        for(int i = 0; i < human_action_segments->mouth_parse_count; i++){
            jobject mouth_parseObj = env->GetObjectArrayElement(mouth_parse_obj_array, i);
            convert2Segment(env, mouth_parseObj, human_action_segments->p_mouth_parse+i);

            env->DeleteLocalRef(mouth_parseObj);
        }

        env->DeleteLocalRef(mouth_parse_obj_array);
    } else{
        human_action_segments->p_mouth_parse = NULL;
    }

    //MultiSegment
    jobject multiSegmentObj = env->GetObjectField(humanActionSegmentObject, fieldMultiSegment);

    if(multiSegmentObj != NULL){
        human_action_segments->p_multi = new st_mobile_segment_t;
        memset(human_action_segments->p_multi, 0, sizeof(st_mobile_segment_t));

        convert2Segment(env, multiSegmentObj, human_action_segments->p_multi);
    } else{
        human_action_segments->p_multi = NULL;
    }

    env->DeleteLocalRef(multiSegmentObj);
    env->DeleteLocalRef(human_action_segments_cls);

    return true;
}

bool convert2HumanAction(JNIEnv *env, jobject humanActionObject, st_mobile_human_action_t *human_action){
    if (humanActionObject == NULL) {
        return false;
    }

    jclass human_action_cls = env->FindClass("com/sensetime/stmobile/model/STHumanAction");

    jfieldID fieldFaces = env->GetFieldID(human_action_cls, "faces", "[Lcom/sensetime/stmobile/model/STMobileFaceInfo;");
    jfieldID fieldFaceCount = env->GetFieldID(human_action_cls, "faceCount", "I");

    jfieldID fieldHands = env->GetFieldID(human_action_cls, "hands", "[Lcom/sensetime/stmobile/model/STMobileHandInfo;");
    jfieldID fieldHandCount = env->GetFieldID(human_action_cls, "handCount", "I");

    jfieldID fieldBodys = env->GetFieldID(human_action_cls, "bodys", "[Lcom/sensetime/stmobile/model/STMobileBodyInfo;");
    jfieldID fieldBodyCount = env->GetFieldID(human_action_cls, "bodyCount", "I");

    jfieldID fieldSegment = env->GetFieldID(human_action_cls, "humanActionSegments", "Lcom/sensetime/stmobile/model/STHumanActionSegments;");

    //faces
    human_action->face_count = env->GetIntField(humanActionObject, fieldFaceCount);

    if(human_action->face_count > 0){
        jobjectArray faces_obj_array = (jobjectArray)env->GetObjectField(humanActionObject, fieldFaces);

        human_action->p_faces = new st_mobile_face_t[human_action->face_count];
        memset(human_action->p_faces, 0, sizeof(st_mobile_face_t)*human_action->face_count);
        for(int i = 0; i < human_action->face_count; i++){
            jobject facesObj = env->GetObjectArrayElement(faces_obj_array, i);
            convert2FaceInfo(env, facesObj, human_action->p_faces+i);

            env->DeleteLocalRef(facesObj);
        }
        env->DeleteLocalRef(faces_obj_array);
    } else {
        human_action->p_faces = NULL;
    }

    //hands
    human_action->hand_count = env->GetIntField(humanActionObject, fieldHandCount);

    if(human_action->hand_count > 0){
        jobjectArray hands_obj_array = (jobjectArray)env->GetObjectField(humanActionObject, fieldHands);

        human_action->p_hands = new st_mobile_hand_t[human_action->hand_count];
        memset(human_action->p_hands, 0, sizeof(st_mobile_hand_t)*human_action->hand_count);
        for(int i = 0; i < human_action->hand_count; i++){
            jobject handsObj = env->GetObjectArrayElement(hands_obj_array, i);
            convert2HandInfo(env, handsObj, human_action->p_hands+i);

            env->DeleteLocalRef(handsObj);
        }

        env->DeleteLocalRef(hands_obj_array);
    } else{
        human_action->p_hands = NULL;
    }

    //bodys
    human_action->body_count = env->GetIntField(humanActionObject, fieldBodyCount);

    if(human_action->body_count > 0){
        jobjectArray bodys_obj_array = (jobjectArray)env->GetObjectField(humanActionObject, fieldBodys);

        human_action->p_bodys = new st_mobile_body_t[human_action->body_count];
        memset(human_action->p_bodys, 0, sizeof(st_mobile_body_t)*human_action->body_count);
        for(int i = 0; i < human_action->body_count; i++){
            jobject bodysObj = env->GetObjectArrayElement(bodys_obj_array, i);
            convert2BodyInfo(env, bodysObj, human_action->p_bodys+i);

            env->DeleteLocalRef(bodysObj);
        }

        env->DeleteLocalRef(bodys_obj_array);
    } else{
        human_action->p_bodys = NULL;
    }

    //segments
    jobject imageObj = env->GetObjectField(humanActionObject, fieldSegment);
    if(imageObj != NULL){
        human_action->p_segments = new st_mobile_human_action_segments_t;
        memset(human_action->p_segments, 0, sizeof(st_mobile_human_action_segments_t));
        convert2HumanActionSegments(env, imageObj, human_action->p_segments);
    } else{
        human_action->p_segments = NULL;
    }
    env->DeleteLocalRef(imageObj);

    env->DeleteLocalRef(human_action_cls);

    return true;
}

jobject convert2FaceExtraInfo(JNIEnv *env, const st_mobile_face_extra_info &face_extra_info){
    jclass face_extra_info_cls = env->FindClass("com/sensetime/stmobile/model/STFaceExtraInfo");

    jfieldID fieldAffineMat = env->GetFieldID(face_extra_info_cls, "affineMat", "[[F");
    jfieldID fieldModelInputSize = env->GetFieldID(face_extra_info_cls, "modelInputSize", "I");

    jobject faceInfoObj = env->AllocObject(face_extra_info_cls);

    //Avatar
    jobjectArray arrayAffineMats;
    jclass floatArr = env->FindClass("[F");
    arrayAffineMats = env->NewObjectArray(3, floatArr, nullptr);
    for(int i = 0; i < 3; i++){
        jfloatArray arrayAffineMat = env->NewFloatArray(3);
        env->SetFloatArrayRegion(arrayAffineMat, 0, 3, face_extra_info.affine_mat[i]);
        env->SetObjectArrayElement(arrayAffineMats, i, arrayAffineMat);
        env->DeleteLocalRef(arrayAffineMat);
    }
    env->DeleteLocalRef(floatArr);
    env->SetObjectField(faceInfoObj, fieldAffineMat, arrayAffineMats);
    env->DeleteLocalRef(arrayAffineMats);

    env->SetIntField(faceInfoObj, fieldModelInputSize, face_extra_info.model_input_size);

    env->DeleteLocalRef(face_extra_info_cls);

    return faceInfoObj;
}

bool convert2FaceExtraInfo(JNIEnv *env, jobject faceExtraInfoObject, st_mobile_face_extra_info *face_extra_info){
    if (faceExtraInfoObject == NULL) {
        return false;
    }

    jclass face_info_cls = env->FindClass("com/sensetime/stmobile/model/STFaceExtraInfo");
    jfieldID fieldAffineMat = env->GetFieldID(face_info_cls, "affineMat", "[[F");
    jfieldID fieldModelInputSize = env->GetFieldID(face_info_cls, "modelInputSize", "I");

    //Avatar
    jobjectArray objAvatarAffineMat = (jobjectArray)env->GetObjectField(faceExtraInfoObject, fieldAffineMat);
    for(int i = 0; i < 3; i++){
        jfloatArray arrayAvatarAffineMat = (jfloatArray)env->GetObjectArrayElement(objAvatarAffineMat, i);
        jfloat* jfarr = env->GetFloatArrayElements(arrayAvatarAffineMat, JNI_FALSE);
        for(int j = 0; j < 3; j++){
            face_extra_info->affine_mat[i][j] = jfarr[j];
        }
        env->ReleaseFloatArrayElements(arrayAvatarAffineMat, jfarr, JNI_FALSE);
        env->DeleteLocalRef(arrayAvatarAffineMat);
    }

    face_extra_info->model_input_size = env->GetIntField(faceExtraInfoObject, fieldModelInputSize);
    env->DeleteLocalRef(face_info_cls);

    return true;
}


bool convert2YuvImage(JNIEnv *env, jobject yuvImageObj, st_multiplane_image_t *yuv_image){
    if (yuvImageObj == NULL) {
        return false;
    }

    jclass yuv_image_cls = env->FindClass("com/sensetime/stmobile/model/STYuvImage");

    jfieldID fieldPlanes0 = env->GetFieldID(yuv_image_cls, "planes0", "[B");
    jfieldID fieldPlanes1 = env->GetFieldID(yuv_image_cls, "planes1", "[B");
    jfieldID fieldPlanes2 = env->GetFieldID(yuv_image_cls, "planes2", "[B");
    jfieldID fieldStrides = env->GetFieldID(yuv_image_cls, "strides", "[I");
    jfieldID fieldWidth = env->GetFieldID(yuv_image_cls, "width", "I");
    jfieldID fieldHeight = env->GetFieldID(yuv_image_cls, "height", "I");
    jfieldID fieldFormat = env->GetFieldID(yuv_image_cls, "format", "I");

    yuv_image->width = env->GetIntField(yuvImageObj, fieldWidth);
    yuv_image->height = env->GetIntField(yuvImageObj, fieldHeight);
    yuv_image->format = (st_pixel_format)env->GetIntField(yuvImageObj, fieldFormat);

    jintArray strides_array = (jintArray)env->GetObjectField(yuvImageObj, fieldStrides);
    int* values = env->GetIntArrayElements(strides_array, 0);
    for(int i = 0; i < 3; i++){
        yuv_image->strides[i] = values[i];
    }
    env->ReleaseIntArrayElements(strides_array, values, 0);

    jobject imagePlane0 = env->GetObjectField(yuvImageObj, fieldPlanes0);
    if(imagePlane0 != NULL){
        jbyteArray arrayPlane0 = reinterpret_cast<jbyteArray>(imagePlane0);
        jbyte* dataPlane0 = env->GetByteArrayElements(arrayPlane0, NULL);
        yuv_image->planes[0] = (uint8_t*)dataPlane0;
    } else{
        yuv_image->planes[0] = NULL;
    }

    jobject imagePlane1 = env->GetObjectField(yuvImageObj, fieldPlanes1);
    if(imagePlane1 != NULL){
        jbyteArray arrayPlane1 = reinterpret_cast<jbyteArray>(imagePlane1);
        jbyte* dataPlane1 = env->GetByteArrayElements(arrayPlane1, NULL);
        yuv_image->planes[1] = (uint8_t*)dataPlane1;
    } else{
        yuv_image->planes[1] = NULL;
    }

    jobject imagePlane2 = env->GetObjectField(yuvImageObj, fieldPlanes2);
    if(imagePlane2 != NULL){
        jbyteArray arrayPlane2 = reinterpret_cast<jbyteArray>(imagePlane2);
        jbyte* dataPlane2 = env->GetByteArrayElements(arrayPlane2, NULL);
        yuv_image->planes[2] = (uint8_t*)dataPlane2;
    } else{
        yuv_image->planes[2] = NULL;
    }

    env->DeleteLocalRef(yuv_image_cls);

    return true;
}

void releaseHumanAction(st_mobile_human_action_t * p_human) {
    if(!p_human) return;
    DeleteObject(p_human->p_faces, p_human->face_count);
    DeleteObject(p_human->p_hands, p_human->hand_count);
    DeleteObject(p_human->p_bodys, p_human->body_count);

    if(p_human->p_segments){
        releaseSegment(p_human->p_segments->p_figure, 1);
        releaseSegment(p_human->p_segments->p_hair, 1);
        releaseSegment(p_human->p_segments->p_multi, 1);
        releaseSegment(p_human->p_segments->p_head, 1);
        releaseSegment(p_human->p_segments->p_skin, 1);
        releaseSegment(p_human->p_segments->p_face_occlusion, 1);
        releaseSegment(p_human->p_segments->p_mouth_parse, p_human->p_segments->mouth_parse_count);

        memset(p_human->p_segments, 0x0, sizeof(st_mobile_segment_t));
    }

    memset(p_human, 0x0, sizeof(st_mobile_human_action_t));
}

void releaseSegment(st_mobile_segment_t*& p_dst, int count){
    if (nullptr != p_dst) {
        for (int i = 0; i < count; ++i)
        {
            DeleteImage(p_dst[i].p_segment);
        }
        delete[] p_dst;
        p_dst = nullptr;
    }
}

void DeleteImage(st_image_t*& image) {
    if (image) {
        if(image->time_stamp == 1.0f){
            safe_delete_array(image->data);
        }
        safe_delete(image);
    }
}

void DeleteObject(st_mobile_face_t*& p_faces, int& face_count) {
    for (int i = 0; i < face_count; i++) {
        safe_delete_array(p_faces[i].p_extra_face_points);
        safe_delete_array(p_faces[i].p_tongue_points);
        safe_delete_array(p_faces[i].p_tongue_points_score);
        safe_delete_array(p_faces[i].p_eyeball_center);
        safe_delete_array(p_faces[i].p_eyeball_contour);
        safe_delete_array(p_faces[i].p_gaze_direction);
        safe_delete_array(p_faces[i].p_gaze_score);
        safe_delete_array(p_faces[i].p_avatar_help_info);
        if (p_faces[i].p_face_ear)
        safe_delete_array(p_faces[i].p_face_ear->p_ear_points);
        safe_delete(p_faces[i].p_face_ear);
        if (p_faces[i].p_face_forehead)
        safe_delete_array(p_faces[i].p_face_forehead->p_forehead_points);
        safe_delete(p_faces[i].p_face_forehead);
        if (p_faces[i].p_face_mesh)
        safe_delete_array(p_faces[i].p_face_mesh->p_face_mesh_points);
        safe_delete(p_faces[i].p_face_mesh);
    }
    safe_delete_array(p_faces);
    face_count = 0;
}
void DeleteObject(st_mobile_hand_t*& p_hands, int& hand_count) {
    for (int i = 0; i < hand_count; i++) {
        safe_delete_array(p_hands[i].p_key_points);
        safe_delete_array(p_hands[i].p_skeleton_keypoints);
        safe_delete_array(p_hands[i].p_skeleton_3d_keypoints);
        safe_delete_array(p_hands[i].p_dynamic_gesture_keypoints);
    }
    safe_delete_array(p_hands);
    hand_count = 0;
}
void DeleteObject(st_mobile_body_t*& p_bodys, int& body_count) {
    for (int i = 0; i < body_count; i++) {
        safe_delete_array(p_bodys[i].p_key_points);
        safe_delete_array(p_bodys[i].p_key_points_score);
        safe_delete_array(p_bodys[i].p_contour_points);
        safe_delete_array(p_bodys[i].p_contour_points_score);
        safe_delete_array(p_bodys[i].p_key_points_3d);
    }
    safe_delete_array(p_bodys);
    body_count = 0;
}

bool convert2AnimalFace(JNIEnv *env, jobject animalFaceObject, st_mobile_animal_face_t *animal_face){
    if (animalFaceObject == NULL) {
        return false;
    }

    jclass animal_face_cls = env->FindClass("com/sensetime/stmobile/model/STAnimalFace");

    jfieldID fieldId = env->GetFieldID(animal_face_cls, "id", "I");
    jfieldID fieldRect = env->GetFieldID(animal_face_cls, "rect", "Lcom/sensetime/stmobile/model/STRect;");
    jfieldID fieldScore = env->GetFieldID(animal_face_cls, "score", "F");
    jfieldID fieldKeyPoints = env->GetFieldID(animal_face_cls, "p_key_points", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldKeyPointsCount = env->GetFieldID(animal_face_cls, "key_points_count", "I");
    jfieldID fieldYaw = env->GetFieldID(animal_face_cls, "yaw", "F");
    jfieldID fieldPitch = env->GetFieldID(animal_face_cls, "pitch", "F");
    jfieldID fieldRoll = env->GetFieldID(animal_face_cls, "roll", "F");
    jfieldID fieldAnimalType = env->GetFieldID(animal_face_cls, "animalType", "I");
    jfieldID fieldEarScore = env->GetFieldID(animal_face_cls, "earScore", "[F");

    animal_face->id = env->GetIntField(animalFaceObject, fieldId);
    jobject animalFaceRect = env->GetObjectField(animalFaceObject, fieldRect);

    if(!convert2st_rect_t(env, animalFaceRect, animal_face->rect)){
        return false;
    }
    animal_face->score = env->GetFloatField(animalFaceObject, fieldScore);
    animal_face->key_points_count = env->GetIntField(animalFaceObject, fieldKeyPointsCount);
    animal_face->yaw = env->GetFloatField(animalFaceObject, fieldYaw);
    animal_face->pitch = env->GetFloatField(animalFaceObject, fieldPitch);
    animal_face->roll = env->GetFloatField(animalFaceObject, fieldRoll);

    if(animal_face->key_points_count > 0){
        jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
        jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
        jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");

        jobjectArray key_points_array = (jobjectArray)env->GetObjectField(animalFaceObject, fieldKeyPoints);
        animal_face->p_key_points = new st_pointf_t[animal_face->key_points_count];
        memset(animal_face->p_key_points, 0, sizeof(st_pointf_t)*animal_face->key_points_count);
        for (int i = 0; i < animal_face->key_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(key_points_array, i);
            (animal_face->p_key_points+i)->x = env->GetFloatField(point, fpoint_x);
            (animal_face->p_key_points+i)->y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }
        env->DeleteLocalRef(key_points_array);
        env->DeleteLocalRef(point_class);
    } else{
        animal_face->p_key_points = NULL;
    }

    animal_face->animal_type = (st_mobile_animal_type)env->GetIntField(animalFaceObject, fieldAnimalType);
    if(animal_face->animal_type == ST_MOBILE_ANIMAL_DOG_FACE){
        jfloatArray score_array= (jfloatArray)env->GetObjectField(animalFaceObject, fieldEarScore);
        float* scores = env->GetFloatArrayElements(score_array, 0);
        animal_face->ear_score[0] = scores[0];
        animal_face->ear_score[1] = scores[1];
        env->ReleaseFloatArrayElements(score_array, scores, JNI_FALSE);
        env->DeleteLocalRef(score_array);
    }

    env->DeleteLocalRef(animal_face_cls);

    return true;
}

void releaseAnimal(st_mobile_animal_face_t *animal_face, int faceCount){
    if(animal_face == NULL){
        return;
    }
    for(int i = 0; i < faceCount; i++){
        safe_delete_array(animal_face[i].p_key_points);
    }
}

jobject convert2Quaternion(JNIEnv *env, const st_quaternion_t &quaternion){
    jclass STQuaternionClass = env->FindClass("com/sensetime/stmobile/model/STQuaternion");

    if (STQuaternionClass == NULL) {
        return NULL;
    }

    jobject quaternionObject = env->AllocObject(STQuaternionClass);

    jfieldID quaternion_x = env->GetFieldID(STQuaternionClass, "x", "F");
    jfieldID quaternion_y = env->GetFieldID(STQuaternionClass, "y", "F");
    jfieldID quaternion_z = env->GetFieldID(STQuaternionClass, "z", "F");
    jfieldID quaternion_w = env->GetFieldID(STQuaternionClass, "w", "F");

    env->SetFloatField(quaternionObject, quaternion_x, quaternion.x);
    env->SetFloatField(quaternionObject, quaternion_y, quaternion.y);
    env->SetFloatField(quaternionObject, quaternion_z, quaternion.z);
    env->SetFloatField(quaternionObject, quaternion_w, quaternion.w);

    if(STQuaternionClass != NULL){
        env->DeleteLocalRef(STQuaternionClass);
    }

    return quaternionObject;
}

bool convert2st_quaternion(JNIEnv *env, jobject quaternionObject, st_quaternion_t *quaternion){
    if(quaternionObject == NULL){
        return false;
    }

    jclass STQuaternionClass = env->GetObjectClass(quaternionObject);

    if (STQuaternionClass == NULL) {
        return false;
    }

    jfieldID quaternion_x = env->GetFieldID(STQuaternionClass, "x", "F");
    jfieldID quaternion_y = env->GetFieldID(STQuaternionClass, "y", "F");
    jfieldID quaternion_z = env->GetFieldID(STQuaternionClass, "z", "F");
    jfieldID quaternion_w = env->GetFieldID(STQuaternionClass, "w", "F");

    quaternion->x = env->GetFloatField(quaternionObject, quaternion_x);
    quaternion->y = env->GetFloatField(quaternionObject, quaternion_y);
    quaternion->z = env->GetFloatField(quaternionObject, quaternion_z);
    quaternion->w = env->GetFloatField(quaternionObject, quaternion_w);

    if(STQuaternionClass != NULL){
        env->DeleteLocalRef(STQuaternionClass);
    }

    return true;
}

jobject convert2FaceMeshList(JNIEnv *env, const st_mobile_face_mesh_list_t *faceMeshList){
    jclass face_mesh_list_cls = env->FindClass("com/sensetime/stmobile/model/STFaceMeshList");

    jfieldID fieldFaceMeshList = env->GetFieldID(face_mesh_list_cls, "faceMeshList", "[Lcom/sensetime/stmobile/model/STMeshIndex;");
    jfieldID fieldFaceMeshListCount = env->GetFieldID(face_mesh_list_cls, "faceMeshListCount", "I");

    jclass mesh_index_cls = env->FindClass("com/sensetime/stmobile/model/STMeshIndex");
    jfieldID fieldv1 = env->GetFieldID(mesh_index_cls, "v1", "I");
    jfieldID fieldv2 = env->GetFieldID(mesh_index_cls, "v2", "I");
    jfieldID fieldv3 = env->GetFieldID(mesh_index_cls, "v3", "I");

    jobject faceMeshListObj = env->AllocObject(face_mesh_list_cls);

    env->SetIntField(faceMeshListObj, fieldFaceMeshListCount, faceMeshList->face_mesh_list_count);
    jobjectArray mesh_index_array = env->NewObjectArray(faceMeshList->face_mesh_list_count, mesh_index_cls, 0);
    for(int i = 0; i < faceMeshList->face_mesh_list_count; i++){
        jobject meshIndexObj = env->AllocObject(mesh_index_cls);
        env->SetIntField(meshIndexObj, fieldv1, faceMeshList->p_face_mesh_index[i].v1);
        env->SetIntField(meshIndexObj, fieldv2, faceMeshList->p_face_mesh_index[i].v2);
        env->SetIntField(meshIndexObj, fieldv3, faceMeshList->p_face_mesh_index[i].v3);
        env->SetObjectArrayElement(mesh_index_array, i, meshIndexObj);
        env->DeleteLocalRef(meshIndexObj);
    }
    env->SetObjectField(faceMeshListObj, fieldFaceMeshList, mesh_index_array);

    env->DeleteLocalRef(mesh_index_cls);
    env->DeleteLocalRef(face_mesh_list_cls);

    return faceMeshListObj;
}

bool convert2FaceMeshIndex(JNIEnv *env, jobject inputObj, st_face_mesh_index_t *face_mesh_index) {
    jclass clazz = env->FindClass("com/sensetime/stmobile/model/STMeshIndex");
    jfieldID fieldV1 = env->GetFieldID(clazz, "v1", "I");
    face_mesh_index->v1 = env->GetIntField(inputObj, fieldV1);

    jfieldID fieldV2 = env->GetFieldID(clazz, "v2", "I");
    face_mesh_index->v2 = env->GetIntField(inputObj, fieldV2);

    jfieldID fieldV3 = env->GetFieldID(clazz, "v3", "I");
    face_mesh_index->v3 = env->GetIntField(inputObj, fieldV3);

    env->DeleteLocalRef(clazz);
    return true;
}

bool convert2FaceMeshList(JNIEnv *env, jobject inputObject, st_mobile_face_mesh_list_t *face_mesh_list){
    jclass clazz = env->FindClass("com/sensetime/stmobile/model/STFaceMeshList");
    // faceMeshListCount
    jfieldID fieldFaceMeshListCount = env->GetFieldID(clazz, "faceMeshListCount", "I");
    face_mesh_list->face_mesh_list_count = env->GetIntField(inputObject, fieldFaceMeshListCount);

    // p_face_mesh_index
    jfieldID jfieldFaceMeshIndexArray = env->GetFieldID(clazz, "faceMeshList", "[Lcom/sensetime/stmobile/model/STMeshIndex;");
    jobjectArray faceMeshIndexArray = (jobjectArray) env->GetObjectField(inputObject, jfieldFaceMeshIndexArray);
    int faceMeshIndexLength = 0;
    if (faceMeshIndexArray != NULL) faceMeshIndexLength = env->GetArrayLength(faceMeshIndexArray);

    if (faceMeshIndexLength > 0) {
        face_mesh_list->p_face_mesh_index = new st_face_mesh_index_t[faceMeshIndexLength];
        memset(face_mesh_list->p_face_mesh_index, 0, sizeof(faceMeshIndexLength));
        for (int i = 0; i<faceMeshIndexLength;i++ ) {
            jobject faceMeshObj = env->GetObjectArrayElement(faceMeshIndexArray, i);
            convert2FaceMeshIndex(env, faceMeshObj, face_mesh_list->p_face_mesh_index + i);
            env->DeleteLocalRef(faceMeshObj);
        }
    }

    env->DeleteLocalRef(clazz);
    return true;
}

jobject convert2FaceMesh(JNIEnv *env, const st_mobile_face_mesh_t *faceMesh){
    jclass face_mesh_cls = env->FindClass("com/sensetime/stmobile/model/STFaceMesh");
    jobject faceMeshObj = env->AllocObject(face_mesh_cls);
    return faceMeshObj;
}

jobject convert2HeadInfo(JNIEnv *env, const st_mobile_head_t *head_info){
    jclass head_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileHeadInfo");

    jfieldID fieldHeadMesh = env->GetFieldID(head_info_cls, "headMesh", "Lcom/sensetime/stmobile/model/STFaceMesh;");
    jfieldID fieldHeadResult = env->GetFieldID(head_info_cls, "headResult", "Lcom/sensetime/stmobile/model/STMobileHeadResultInfo;");

    jobject faceInfoObj = env->AllocObject(head_info_cls);

    //mesh_points
    if(head_info->p_head_mesh != NULL){
        jobject faceMeshObj = convert2FaceMesh(env, head_info->p_head_mesh);
        env->SetObjectField(faceInfoObj, fieldHeadMesh, faceMeshObj);
    }

    //headRect info
    if(head_info->p_head_result != NULL){
        jobject headResultInfoObj = convert2HeadResultInfo(env, head_info->p_head_result);
        env->SetObjectField(faceInfoObj, fieldHeadResult, headResultInfoObj);
    }

    env->DeleteLocalRef(head_info_cls);
    return faceInfoObj;
}

jobject convert2HeadResultInfo(JNIEnv *env, const st_mobile_head_result_t *head_result){
    jclass head_result_cls = env->FindClass("com/sensetime/stmobile/model/STMobileHeadResultInfo");

    jfieldID fieldId = env->GetFieldID(head_result_cls, "id", "I");
    jfieldID fieldRect = env->GetFieldID(head_result_cls, "rect", "Lcom/sensetime/stmobile/model/STRect;");
    jfieldID fieldScore = env->GetFieldID(head_result_cls, "score", "F");
    jfieldID fieldAngle = env->GetFieldID(head_result_cls, "angle", "F");

    jobject headResultObj = env->AllocObject(head_result_cls);

    env->SetIntField(headResultObj, fieldId, head_result->id);
    jobject strectObj = convert2STRect(env, head_result->rect);
    env->SetObjectField(headResultObj, fieldRect, strectObj);
    env->SetFloatField(headResultObj, fieldScore, head_result->score);
    env->SetFloatField(headResultObj, fieldAngle, head_result->angle);

    env->DeleteLocalRef(head_result_cls);

    return headResultObj;
}

bool convert2FaceMesh(JNIEnv *env, jobject faceMeshObj, st_mobile_face_mesh_t *face_mesh){
    if(faceMeshObj == NULL){
        return false;
    }
    jclass face_mesh_cls = env->FindClass("com/sensetime/stmobile/model/STFaceMesh");
    jfieldID fieldMeshPoints = env->GetFieldID(face_mesh_cls, "meshPoints", "[Lcom/sensetime/stmobile/model/STPoint3f;");
    jfieldID fieldNormalPoints = env->GetFieldID(face_mesh_cls, "normalPoints", "[Lcom/sensetime/stmobile/model/STPoint3f;");
    jfieldID fieldMeshPointsCount = env->GetFieldID(face_mesh_cls, "meshPointsCount", "I");
    jclass point3_class = env->FindClass("com/sensetime/stmobile/model/STPoint3f");
    jfieldID fpoint3_x = env->GetFieldID(point3_class, "x", "F");
    jfieldID fpoint3_y = env->GetFieldID(point3_class, "y", "F");
    jfieldID fpoint3_z = env->GetFieldID(point3_class, "z", "F");
    //mesh_points
    face_mesh->face_mesh_points_count = env->GetIntField(faceMeshObj, fieldMeshPointsCount);
    if(face_mesh->face_mesh_points_count > 0){
        jobjectArray mesh_points_array = (jobjectArray)env->GetObjectField(faceMeshObj, fieldMeshPoints);
        face_mesh->p_face_mesh_points = new st_point3f_t[face_mesh->face_mesh_points_count];
        memset(face_mesh->p_face_mesh_points, 0, sizeof(st_point3f_t)*face_mesh->face_mesh_points_count);
        for (int i = 0; i < face_mesh->face_mesh_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(mesh_points_array, i);

            face_mesh->p_face_mesh_points[i].x = env->GetFloatField(point, fpoint3_x);
            face_mesh->p_face_mesh_points[i].y = env->GetFloatField(point, fpoint3_y);
            face_mesh->p_face_mesh_points[i].z = env->GetFloatField(point, fpoint3_z);

            env->DeleteLocalRef(point);
        }

        jobjectArray normal_points_array = (jobjectArray)env->GetObjectField(faceMeshObj, fieldNormalPoints);
        face_mesh->p_face_mesh_normal = new st_point3f_t[face_mesh->face_mesh_points_count];
        memset(face_mesh->p_face_mesh_normal, 0, sizeof(st_point3f_t)*face_mesh->face_mesh_points_count);
        for (int i = 0; i < face_mesh->face_mesh_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(normal_points_array, i);

            face_mesh->p_face_mesh_normal[i].x = env->GetFloatField(point, fpoint3_x);
            face_mesh->p_face_mesh_normal[i].y = env->GetFloatField(point, fpoint3_y);
            face_mesh->p_face_mesh_normal[i].z = env->GetFloatField(point, fpoint3_z);

            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(normal_points_array);
    }else{
        face_mesh->p_face_mesh_points = NULL;
        face_mesh->p_face_mesh_normal = NULL;
    }
    env->DeleteLocalRef(point3_class);
    env->DeleteLocalRef(face_mesh_cls);
    return true;
}

bool convert2EarInfo(JNIEnv *env, jobject earInfoObject, st_mobile_ear_t *ear_info){
    if (earInfoObject == NULL) {
        return false;
    }

    jclass ear_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileEarInfo");

    jfieldID fieldEarPoints = env->GetFieldID(ear_info_cls, "earPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldEarPointsCount = env->GetFieldID(ear_info_cls, "earPointsCount", "I");
    jfieldID fieldLeftEarScore = env->GetFieldID(ear_info_cls, "leftEarScore", "F");
    jfieldID fieldRightEarScore = env->GetFieldID(ear_info_cls, "rightEarScore", "F");

    //key_points
    ear_info->ear_points_count = env->GetIntField(earInfoObject, fieldEarPointsCount);
    if(ear_info->ear_points_count > 0){

        jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
        jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
        jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");
        jobjectArray ear_points_array = (jobjectArray)env->GetObjectField(earInfoObject, fieldEarPoints);
        ear_info->p_ear_points = new st_pointf_t[ear_info->ear_points_count];
        memset(ear_info->p_ear_points, 0, sizeof(st_pointf_t)*ear_info->ear_points_count);

        for (int i = 0; i < ear_info->ear_points_count; ++i) {

            jobject point = env->GetObjectArrayElement(ear_points_array, i);
            (ear_info->p_ear_points+i)->x = env->GetFloatField(point, fpoint_x);
            (ear_info->p_ear_points+i)->y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);

        }
        env->DeleteLocalRef(ear_points_array);
        env->DeleteLocalRef(point_class);
    } else{
        ear_info->p_ear_points = NULL;
    }

    ear_info->left_ear_score = env->GetFloatField(earInfoObject, fieldLeftEarScore);
    ear_info->right_ear_score = env->GetFloatField(earInfoObject, fieldRightEarScore);

    env->DeleteLocalRef(ear_info_cls);

    return true;
}

bool convert2ForeheadInfo(JNIEnv *env, jobject foreheadInfoObject, st_mobile_forehead_t *forehead_info){
    if (foreheadInfoObject == NULL) {
        return false;
    }

    jclass forehead_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileForeheadInfo");
    jfieldID fieldForeheadPoints = env->GetFieldID(forehead_info_cls, "foreheadPoints", "[Lcom/sensetime/stmobile/model/STPoint;");

    jfieldID fieldForeheadPointsCount = env->GetFieldID(forehead_info_cls, "foreheadPointsCount", "I");

    //key_points
    forehead_info->forehead_points_count = env->GetIntField(foreheadInfoObject, fieldForeheadPointsCount);
    if(forehead_info->forehead_points_count > 0){

        jclass point_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
        jfieldID fpoint_x = env->GetFieldID(point_class, "x", "F");
        jfieldID fpoint_y = env->GetFieldID(point_class, "y", "F");
        jobjectArray forehead_points_array = (jobjectArray)env->GetObjectField(foreheadInfoObject, fieldForeheadPoints);
        forehead_info->p_forehead_points = new st_pointf_t[forehead_info->forehead_points_count];
        memset(forehead_info->p_forehead_points, 0, sizeof(st_pointf_t)*forehead_info->forehead_points_count);
        for (int i = 0; i < forehead_info->forehead_points_count; ++i) {
            jobject point = env->GetObjectArrayElement(forehead_points_array, i);
            (forehead_info->p_forehead_points+i)->x = env->GetFloatField(point, fpoint_x);
            (forehead_info->p_forehead_points+i)->y = env->GetFloatField(point, fpoint_y);
            env->DeleteLocalRef(point);
        }

        env->DeleteLocalRef(forehead_points_array);
        env->DeleteLocalRef(point_class);
    } else{
        forehead_info->p_forehead_points = NULL;
    }

    env->DeleteLocalRef(forehead_info_cls);

    return true;
}

jobject convert2EarInfo(JNIEnv *env, const st_mobile_ear_t *ear_info){

    jclass ear_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileEarInfo");
    jfieldID fieldEarPoints = env->GetFieldID(ear_info_cls, "earPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldEarPointsCount = env->GetFieldID(ear_info_cls, "earPointsCount", "I");
    jfieldID fieldLeftEarScore = env->GetFieldID(ear_info_cls, "leftEarScore", "F");
    jfieldID fieldRightEarScore = env->GetFieldID(ear_info_cls, "rightEarScore", "F");

    jobject earInfoObj = env->AllocObject(ear_info_cls);
    jclass st_points_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_points_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_points_class, "y", "F");
    //key_points
    env->SetIntField(earInfoObj, fieldEarPointsCount, ear_info->ear_points_count);

    jobjectArray ear_points_array = env->NewObjectArray(ear_info->ear_points_count, st_points_class, 0);

    for(int i = 0; i < ear_info->ear_points_count; i++){
        jobject earPointsObj = env->AllocObject(st_points_class);

        env->SetFloatField(earPointsObj, fpoint_x, (ear_info->p_ear_points+i)->x);
        env->SetFloatField(earPointsObj, fpoint_y, (ear_info->p_ear_points+i)->y);

        env->SetObjectArrayElement(ear_points_array, i, earPointsObj);
        env->DeleteLocalRef(earPointsObj);
    }

    env->SetObjectField(earInfoObj, fieldEarPoints, ear_points_array);
    env->DeleteLocalRef(ear_points_array);

    env->SetFloatField(earInfoObj, fieldLeftEarScore, ear_info->left_ear_score);
    env->SetFloatField(earInfoObj, fieldRightEarScore, ear_info->right_ear_score);

    env->DeleteLocalRef(st_points_class);
    env->DeleteLocalRef(ear_info_cls);

    return earInfoObj;
}

jobject convert2ForeheadInfo(JNIEnv *env, const st_mobile_forehead_t *forehead_info){

    jclass forehead_info_cls = env->FindClass("com/sensetime/stmobile/model/STMobileForeheadInfo");

    jfieldID fieldForeheadPoints = env->GetFieldID(forehead_info_cls, "foreheadPoints", "[Lcom/sensetime/stmobile/model/STPoint;");
    jfieldID fieldForeheadPointsCount = env->GetFieldID(forehead_info_cls, "foreheadPointsCount", "I");

    jobject foreheadInfoObj = env->AllocObject(forehead_info_cls);

    jclass st_points_class = env->FindClass("com/sensetime/stmobile/model/STPoint");
    jfieldID fpoint_x = env->GetFieldID(st_points_class, "x", "F");
    jfieldID fpoint_y = env->GetFieldID(st_points_class, "y", "F");

    //key_points
    env->SetIntField(foreheadInfoObj, fieldForeheadPointsCount, forehead_info->forehead_points_count);
    jobjectArray forehead_points_array = env->NewObjectArray(forehead_info->forehead_points_count, st_points_class, 0);

    for(int i = 0; i < forehead_info->forehead_points_count; i++){
        jobject foreheadPointsObj = env->AllocObject(st_points_class);

        env->SetFloatField(foreheadPointsObj, fpoint_x, (forehead_info->p_forehead_points+i)->x);
        env->SetFloatField(foreheadPointsObj, fpoint_y, (forehead_info->p_forehead_points+i)->y);

        env->SetObjectArrayElement(forehead_points_array, i, foreheadPointsObj);
        env->DeleteLocalRef(foreheadPointsObj);
    }

    env->SetObjectField(foreheadInfoObj, fieldForeheadPoints, forehead_points_array);
    env->DeleteLocalRef(forehead_points_array);

    env->DeleteLocalRef(st_points_class);
    env->DeleteLocalRef(forehead_info_cls);

    return foreheadInfoObj;
}

void releaseImagePlane(JNIEnv *env, jobject imageObj, st_multiplane_image_t *yuv_image){
    jclass yuv_image_cls = env->FindClass("com/sensetime/stmobile/model/STYuvImage");

    jfieldID fieldPlanes0 = env->GetFieldID(yuv_image_cls, "planes0", "[B");
    jfieldID fieldPlanes1 = env->GetFieldID(yuv_image_cls, "planes1", "[B");
    jfieldID fieldPlanes2 = env->GetFieldID(yuv_image_cls, "planes2", "[B");

    jobject imagePlane0 = env->GetObjectField(imageObj, fieldPlanes0);
    jbyteArray arrayPlane0 = reinterpret_cast<jbyteArray>(imagePlane0);
    env->ReleaseByteArrayElements(arrayPlane0, (jbyte* )yuv_image->planes[0], 0);

    jobject imagePlane1 = env->GetObjectField(imageObj, fieldPlanes1);
    jbyteArray arrayPlane1 = reinterpret_cast<jbyteArray>(imagePlane1);
    env->ReleaseByteArrayElements(arrayPlane1, (jbyte* )yuv_image->planes[1], 0);

    jobject imagePlane2 = env->GetObjectField(imageObj, fieldPlanes2);
    jbyteArray arrayPlane2 = reinterpret_cast<jbyteArray>(imagePlane2);
    env->ReleaseByteArrayElements(arrayPlane2, (jbyte* )yuv_image->planes[2], 0);

    env->DeleteLocalRef(yuv_image_cls);
}



jobject convert2Color(JNIEnv *env, const st_color_t *color){
    jclass STColorClass = env->FindClass("com/sensetime/stmobile/model/STColor");

    if (STColorClass == NULL) {
        return NULL;
    }

    jobject colorObject = env->AllocObject(STColorClass);

    jfieldID color_r = env->GetFieldID(STColorClass, "r", "F");
    jfieldID color_g = env->GetFieldID(STColorClass, "g", "F");
    jfieldID color_b = env->GetFieldID(STColorClass, "b", "F");
    jfieldID color_a = env->GetFieldID(STColorClass, "a", "F");

    env->SetFloatField(colorObject, color_r, color->r);
    env->SetFloatField(colorObject, color_g, color->g);
    env->SetFloatField(colorObject, color_b, color->b);
    env->SetFloatField(colorObject, color_a, color->a);

    if(STColorClass != NULL){
        env->DeleteLocalRef(STColorClass);
    }

    return colorObject;
}

jobject convert2Quaternion(JNIEnv *env, const st_quaternion_t *quaternion){
    jclass STQuaternionClass = env->FindClass("com/sensetime/stmobile/model/STQuaternion");

    if (STQuaternionClass == NULL) {
        return NULL;
    }

    jobject quaternionObject = env->AllocObject(STQuaternionClass);

    jfieldID quaternion_x = env->GetFieldID(STQuaternionClass, "x", "F");
    jfieldID quaternion_y = env->GetFieldID(STQuaternionClass, "y", "F");
    jfieldID quaternion_z = env->GetFieldID(STQuaternionClass, "z", "F");
    jfieldID quaternion_w = env->GetFieldID(STQuaternionClass, "w", "F");

    env->SetFloatField(quaternionObject, quaternion_x, quaternion->x);
    env->SetFloatField(quaternionObject, quaternion_y, quaternion->y);
    env->SetFloatField(quaternionObject, quaternion_z, quaternion->z);
    env->SetFloatField(quaternionObject, quaternion_w, quaternion->w);

    if(STQuaternionClass != NULL){
        env->DeleteLocalRef(STQuaternionClass);
    }

    return quaternionObject;
}

//jobject convert2BodyAvatar(JNIEnv *env, const st_mobile_body_avatar_t *body_avatar){
//    jclass STBodyAvatarClass = env->FindClass("com/sensetime/stmobile/model/STBodyAvatar");
//    jclass STQuaternionClass = env->FindClass("com/sensetime/stmobile/model/STQuaternion");
//    jfieldID quaternion_x = env->GetFieldID(STQuaternionClass, "x", "F");
//    jfieldID quaternion_y = env->GetFieldID(STQuaternionClass, "y", "F");
//    jfieldID quaternion_z = env->GetFieldID(STQuaternionClass, "z", "F");
//    jfieldID quaternion_w = env->GetFieldID(STQuaternionClass, "w", "F");
//
//    if (STBodyAvatarClass == NULL) {
//        return NULL;
//    }
//
//    jobject bodyAvatarObject = env->AllocObject(STBodyAvatarClass);
//
//    jfieldID fieldQuaternions = env->GetFieldID(STBodyAvatarClass, "quaternions", "[Lcom/sensetime/stmobile/model/STBodyAvatar;");
//    jfieldID fieldBodyQuatCount = env->GetFieldID(STBodyAvatarClass, "bodyQuatCount", "I");
//    jfieldID fieldIsIdle = env->GetFieldID(STBodyAvatarClass, "isIdle", "Z");
//
//    env->SetIntField(bodyAvatarObject, fieldBodyQuatCount, body_avatar->body_quat_count);
////    env->SetBooleanField(bodyAvatarObject, fieldIsIdle, body_avatar->is_idle);
//
//    jobjectArray body_avatar_array = env->NewObjectArray(body_avatar->body_quat_count, STQuaternionClass, 0);
//    for(int i = 0; i < body_avatar->body_quat_count; i++){
//        jobject quaternionObj = env->AllocObject(STQuaternionClass);
//
//        env->SetFloatField(quaternionObj, quaternion_x, body_avatar->p_body_quat_array[i].x);
//        env->SetFloatField(quaternionObj, quaternion_y, body_avatar->p_body_quat_array[i].y);
//        env->SetFloatField(quaternionObj, quaternion_z, body_avatar->p_body_quat_array[i].z);
//        env->SetFloatField(quaternionObj, quaternion_w, body_avatar->p_body_quat_array[i].w);
//
//        env->SetObjectArrayElement(body_avatar_array, i, quaternionObj);
//        env->DeleteLocalRef(quaternionObj);
//    }
//
//    env->SetObjectField(bodyAvatarObject, fieldQuaternions, body_avatar_array);
//    env->DeleteLocalRef(body_avatar_array);
//
//    env->DeleteLocalRef(STBodyAvatarClass);
//    env->DeleteLocalRef(STQuaternionClass);
//
//    return bodyAvatarObject;
//}

bool convert2Color(JNIEnv *env, jobject colorObject, st_color_t *color){
    if(colorObject == NULL){
        return false;
    }

    jclass STColorClass = env->GetObjectClass(colorObject);

    if (STColorClass == NULL) {
        return false;
    }

    jfieldID color_r = env->GetFieldID(STColorClass, "r", "F");
    jfieldID color_g = env->GetFieldID(STColorClass, "g", "F");
    jfieldID color_b = env->GetFieldID(STColorClass, "b", "F");
    jfieldID color_a = env->GetFieldID(STColorClass, "a", "F");

    color->r = env->GetFloatField(colorObject, color_r);
    color->g = env->GetFloatField(colorObject, color_g);
    color->b = env->GetFloatField(colorObject, color_b);
    color->a = env->GetFloatField(colorObject, color_a);

    if(STColorClass != NULL){
        env->DeleteLocalRef(STColorClass);
    }

    return true;
}

bool convert2Quaternion(JNIEnv *env, jobject quaternionObject, st_quaternion_t *quaternion){
    if(quaternionObject == NULL){
        return false;
    }

    jclass STQuaternionClass = env->GetObjectClass(quaternionObject);

    if (STQuaternionClass == NULL) {
        return false;
    }

    jfieldID quaternion_x = env->GetFieldID(STQuaternionClass, "x", "F");
    jfieldID quaternion_y = env->GetFieldID(STQuaternionClass, "y", "F");
    jfieldID quaternion_z = env->GetFieldID(STQuaternionClass, "z", "F");
    jfieldID quaternion_w = env->GetFieldID(STQuaternionClass, "w", "F");

    quaternion->x = env->GetFloatField(quaternionObject, quaternion_x);
    quaternion->y = env->GetFloatField(quaternionObject, quaternion_y);
    quaternion->z = env->GetFloatField(quaternionObject, quaternion_z);
    quaternion->w = env->GetFloatField(quaternionObject, quaternion_w);

    if(STQuaternionClass != NULL){
        env->DeleteLocalRef(STQuaternionClass);
    }

    return true;
}

//bool convert2BodyAvatar(JNIEnv *env, jobject bodyAvatarObject, st_mobile_body_avatar_t *body_avatar){
//    if(bodyAvatarObject == NULL){
//        return false;
//    }
//
//    jclass STBodyAvatarClass = env->GetObjectClass(bodyAvatarObject);
//
//    if (STBodyAvatarClass == NULL) {
//        return false;
//    }
//
//    jfieldID fieldQuaternions = env->GetFieldID(STBodyAvatarClass, "quaternions", "[Lcom/sensetime/stmobile/model/STBodyAvatar;");
//    jfieldID fieldBodyQuatCount = env->GetFieldID(STBodyAvatarClass, "bodyQuatCount", "I");
//    jfieldID fieldIsIdle = env->GetFieldID(STBodyAvatarClass, "isIdle", "Z");
//
////    body_avatar->is_idle = env->GetBooleanField(bodyAvatarObject, fieldIsIdle);
//    body_avatar->body_quat_count = env->GetIntField(bodyAvatarObject, fieldBodyQuatCount);
//    if(body_avatar->body_quat_count > 0){
//        jobjectArray quaternion_obj_array = (jobjectArray)env->GetObjectField(bodyAvatarObject, fieldQuaternions);
//        body_avatar->p_body_quat_array = new st_quaternion_t[body_avatar->body_quat_count];
//        memset(body_avatar->p_body_quat_array, 0, sizeof(st_quaternion_t)*body_avatar->body_quat_count);
//        for(int i = 0; i < body_avatar->body_quat_count; i++){
//            jobject quaternionObj = env->GetObjectArrayElement(quaternion_obj_array, i);
//            convert2Quaternion(env, quaternionObj, body_avatar->p_body_quat_array+i);
//            env->DeleteLocalRef(quaternionObj);
//        }
//    }else{
//        body_avatar->p_body_quat_array = NULL;
//    }
//
//    if(STBodyAvatarClass != NULL){
//        env->DeleteLocalRef(STBodyAvatarClass);
//    }
//    return true;
//}

jobject convert2STTransform(JNIEnv *env, const st_mobile_transform_t *transform){
    jclass transformClass = env->FindClass("com/sensetime/stmobile/model/STTransform");

    if (transformClass == NULL) {
        return NULL;
    }

    jobject transformObject = env->AllocObject(transformClass);

    jfieldID fieldPosition = env->GetFieldID(transformClass, "position", "[F");
    jfieldID fieldEulerAngle = env->GetFieldID(transformClass, "eulerAngle", "[F");
    jfieldID fieldScale = env->GetFieldID(transformClass, "scale", "[F");

    jfloatArray positionArray = env->NewFloatArray(3);
    env->SetFloatArrayRegion(positionArray, 0, 3, transform->position);
    env->SetObjectField(transformObject, fieldPosition, positionArray);
    env->DeleteLocalRef(positionArray);

    jfloatArray eulerAngleArray = env->NewFloatArray(3);
    env->SetFloatArrayRegion(eulerAngleArray, 0, 3, transform->eulerAngle);
    env->SetObjectField(transformObject, fieldEulerAngle, eulerAngleArray);
    env->DeleteLocalRef(eulerAngleArray);

    jfloatArray scaleArray = env->NewFloatArray(3);
    env->SetFloatArrayRegion(scaleArray, 0, 3, transform->scale);
    env->SetObjectField(transformObject, fieldScale, scaleArray);
    env->DeleteLocalRef(scaleArray);

    if(transformClass != NULL){
        env->DeleteLocalRef(transformClass);
    }

    return transformObject;
}