package com.sensetime.effects;

public interface STEffectListener {
    void onBeautyModeSelected(int mode, int value);

    void onBeautyStrengthSelected(int mode, float strength);

    void onBeautyParamSelected(int param, float value);

    void onFilterSelected(String filterPath, float strength);

    void onMakeupSelected(int type, String typePath, float strength);

    void onStickerSelected(String path, boolean attach);

    float onGetBeautyParamValue(int param);

    String onGetCurrentFilterPath();

    String onGetCurrentGroupMakeup(String index);
}
