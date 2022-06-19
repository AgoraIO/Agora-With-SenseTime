package com.sensetime.stmobile;

public class STMobileEffectParams {
    // 贴纸前后两个序列帧切换的最小时间间隔，单位为毫秒。当两个相机帧处理的间隔小于这个值的时候，
    // 当前显示的贴纸序列帧会继续显示，直到显示的时间大于该设定值贴纸才会切换到下一阵，相机帧不受影响。
    public static final int EFFECT_PARAM_MIN_FRAME_INTERVAL = 0;

    // 设置贴纸素材资源所占用的最大内存（MB），当估算内存超过这个值时，将不能再加载新的素材包
    public static final int EFFECT_PARAM_MAX_MEMORY_BUDGET_MB = 1;

    // 设置相机姿态平滑参数，标识平滑多少帧，越大延迟越高，抖动越微弱
    public static final int EFFECT_PARAM_QUATERNION_SMOOTH_FRAME = 2;

    // 禁用美颜Overlap逻辑（贴纸中的美颜会覆盖前面通过API或者贴纸生效的美颜效果，贴纸成组覆盖，API单个覆盖），默认启用Overlap
    public static final int EFFECT_PARAM_DISABLE_BEAUTY_OVERLAP = 5;

    // 传入大于0的值，禁用对于v3.1之前的素材包重新排序module的渲染顺序，该选项只会影响设置之后添加的素材。重新排序是为了在与美妆、风格素材包叠加时达到最佳效果，默认启用ReOrder
    public static final int EFFECT_PARAM_DISABLE_MODULE_REORDER = 6;

}
