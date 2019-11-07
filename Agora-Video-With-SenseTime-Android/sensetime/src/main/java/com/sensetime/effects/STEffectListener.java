package com.sensetime.effects;

public interface STEffectListener {
    void onBeautyParamSelected(int param, float value);
    void onFilterSelected(String filterPath, float strength);
    void onMakeupSelected(int type, String index, String typePath);
    void onStickerSelected(String path);
    float onGetBeautyParamValue(int param);
    String onGetCurrentFilterPath();
    String onGetCurrentGroupMakeup(String index);
}
