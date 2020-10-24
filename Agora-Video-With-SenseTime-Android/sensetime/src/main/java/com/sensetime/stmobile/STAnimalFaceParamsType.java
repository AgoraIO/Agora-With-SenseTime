package com.sensetime.stmobile;

/**
 * Created by sensetime on 18-8-1.
 */

public class STAnimalFaceParamsType {

    /// 设置检测到的最大猫脸数目N,持续track已检测到的N个猫脸直到猫脸数小于N再继续做detect.默认32
    public final static int ST_MOBILE_CAT_LIMIT = 1;
    /// 设置tracker每多少帧进行一次detect.
    public final static int ST_MOBILE_CAT_DETECT_INTERVAL_LIMIT = 2;
    /// 设置猫脸跟踪的阈值
    public final static int ST_MOBILE_CAT_THRESHOLD = 3;
    /// 设置猫脸预处理图像的最长边，最小320， 默认值1500。 值越大，耗时越长，检测到的数目会多一些
    public final static int ST_MOBILE_CAT_PREPROCESS_MAX_SIZE = 4;
}
