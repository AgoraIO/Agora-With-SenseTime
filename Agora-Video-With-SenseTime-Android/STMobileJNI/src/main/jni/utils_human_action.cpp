//
// Created by mac on 2021/7/5.
//
#include "utils_human_action.h"

#define  LOG_TAG    "utils_effects"

jobject convert2ClassifierResult(JNIEnv *env, const st_classifier_result_t *classifier_result){

    jclass classifier_result_cls = env->FindClass("com/sensetime/stmobile/model/STClassifierResult");

    jfieldID fieldId = env->GetFieldID(classifier_result_cls, "id", "I");
    jfieldID fieldScore = env->GetFieldID(classifier_result_cls, "score", "F");
    jfieldID fieldName = env->GetFieldID(classifier_result_cls, "name", "Ljava/lang/String;");

    jobject classifierResultObj = env->AllocObject(classifier_result_cls);
    env->SetIntField(classifierResultObj, fieldId, classifier_result->id);
    env->SetFloatField(classifierResultObj, fieldScore, classifier_result->score);

    jstring nameObj = env->NewStringUTF(classifier_result->name);
    env->SetObjectField(classifierResultObj, fieldName, nameObj);
    env->DeleteLocalRef(classifier_result_cls);

    return classifierResultObj;
}

