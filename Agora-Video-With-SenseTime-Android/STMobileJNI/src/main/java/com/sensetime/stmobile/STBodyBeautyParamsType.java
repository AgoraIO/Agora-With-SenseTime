package com.sensetime.stmobile;

/**
 * define body beauty params
 */
public class STBodyBeautyParamsType {
    //set body detect max number N(Default value is 1). if the detected body count is N, keep tracking; if body count is less than N and then continue to do detect. The larger the N, the longer the cost time.
    public final static int ST_BODY_BEAUTIFY_PARAM_BODY_LIMIT = 0;

    //set body detect threshold. The higher the threshold, the more accurate the key points.
    public final static int ST_BODY_BEAUTIFY_PARAM_DETECT_THRESHOLD = 1;
    //set how many frames detect once(Default: body count > 0, the value is 30; body count == 0, the value is 10(30/3)). The higher the value, the lower the occupancy rate of CPU, but the longer the new body is detected.
    public final static int ST_BODY_BEAUTIFY_PARAM_DETECT_INTERVAL = 2;

    //body beauty whole ratio. [0.0, INFINITE), 1.0 is original, [0, 1) is thinner , (1, INFINITE) is fatter
    public final static int ST_BODY_BEAUTIFY_PARAM_WHOLE_RATIO = 3;

    //body beauty head ratio. [0.0, INFINITE), 1.0 is original, [0, 1) is thinner , (1, INFINITE) is fatter
    public final static int ST_BODY_BEAUTIFY_PARAM_HEAD_RATIO = 4;

    //body beauty shoulder ratio. [0.0, INFINITE), 1.0 is original, [0, 1) is thinner , (1, INFINITE) is fatter
    public final static int ST_BODY_BEAUTIFY_PARAM_SHOULDER_RATIO = 5;

    //body beauty waist ratio. [0.0, INFINITE), 1.0 is original, [0, 1) is thinner , (1, INFINITE) is fatter
    public final static int ST_BODY_BEAUTIFY_PARAM_WAIST_RATIO = 6;

    //body beauty hip ratio. [0.0, INFINITE), 1.0 is original, [0, 1) is thinner , (1, INFINITE) is fatter
    public final static int ST_BODY_BEAUTIFY_PARAM_HIP_RATIO = 7;

    //body beauty leg ratio. [0.0, INFINITE), 1.0 is original, [0, 1) is thinner , (1, INFINITE) is fatter
    public final static int ST_BODY_BEAUTIFY_PARAM_LEG_RATIO = 8;

    //body beauty long leg ratio. [0.0, INFINITE), 1.0 is original, [0, 1) is thinner , (1, INFINITE) is fatter
    public final static int ST_BODY_BEAUTIFY_PARAM_LONG_LEG_RATIO = 9;

    //signal for take picture
    public final static int ST_BODY_BEAUTIFY_PARAM_TAKE_PICTURE = 10;

    //set body beauty mode: camera preview input
    public final static int ST_BEAUTIFY_PREVIEW = 0;

    //set body beauty mode: video input
    public final static int ST_BEAUTIFY_VIDEO = 1;

    //set body beauty mode: photo input
    public final static int ST_BEAUTIFY_PHOTO = 2;

    public final static int ST_BEAUTIFY_BODY_REF_PART = 0;           /// 按美体部位的比例调节
    public final static int ST_BEAUTIFY_BODY_REF_HEAD = 1;           /// 按头的比例去调节对应美体部位

    /// 美体输入、输出纹理为RGBA格式
    public final static int ST_BODY_BEAUTIFY_TEX_RGBA = 0;
    /// 美体输入、输出纹理为YUV格式（目前只在Android手机上支持）
    public final static int ST_BODY_BEAUTIFY_TEX_YUV = 1;
}


