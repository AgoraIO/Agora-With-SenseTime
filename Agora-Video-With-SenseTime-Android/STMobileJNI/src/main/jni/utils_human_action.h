//
// Created by mac on 2021/7/5.
//

#ifndef SENSEMEEFFECTS_UTILS_HUMAN_ACTION_H
#define SENSEMEEFFECTS_UTILS_HUMAN_ACTION_H
#include <sys/time.h>
#include <time.h>
#include <jni.h>
#include <stdio.h>
#include <stdlib.h>
#include <android/log.h>
#include <string.h>
#include "utils.h"
#include <st_mobile_classify.h>
jobject convert2ClassifierResult(JNIEnv *env, const st_classifier_result_t *classifier_result);

#endif //SENSEMEEFFECTS_UTILS_HUMAN_ACTION_H
