package com.sensetime.stmobile.params;

public class STEffectParam {
    // 贴纸前后两个序列帧切换的最小时间间隔，单位为毫秒。当两个相机帧处理的间隔小于这个值的时候，
    public final static int EFFECT_PARAM_MIN_FRAME_INTERVAL = 0;

    // 设置贴纸素材资源所占用的最大内存（MB），当估算内存超过这个值时，将不能再加载新的素材包
    public final static int EFFECT_PARAM_MAX_MEMORY_BUDGET_MB = 1;

    // 设置贴纸是否使用外部时间戳更新
    public final static int EFFECT_PARAM_USE_INPUT_TIMESTAMP = 2;

}
