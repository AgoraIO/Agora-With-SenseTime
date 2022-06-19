package com.sensetime.stmobile.model;

import java.util.Arrays;

public class STEffectTryonInfo {
    STColor color;      // 颜色
    float strength;     // 强度
    float midtone;      // 明暗度
    float highlight;    // 高光
    int lipFinishType;  // 口红质地类型
    int regionCount;    // 当前效果的区域数量
    STEffectsTryOnRegionInfo[] regionInfo;// 区域信息，最多支持6个区域

    public int getRegionCount() {
        return regionCount;
    }

    public void setRegionCount(int regionCount) {
        this.regionCount = regionCount;
    }

    public int getLipFinishType() {
        return lipFinishType;
    }

    public void setLipFinishType(int lipFinishType) {
        this.lipFinishType = lipFinishType;
    }

    public STColor getColor() {
        return color;
    }

    public void setColor(STColor color) {
        this.color = color;
    }

    public float getStrength() {
        return strength;
    }

    public void setStrength(float strength) {
        this.strength = strength;
    }

    public float getMidtone() {
        return midtone;
    }

    public void setMidtone(float midtone) {
        this.midtone = midtone;
    }

    public float getHighlight() {
        return highlight;
    }

    public void setHighlight(float highlight) {
        this.highlight = highlight;
    }

    public STEffectsTryOnRegionInfo[] getRegionInfo() {
        return regionInfo;
    }

    public void setRegionInfo(STEffectsTryOnRegionInfo[] regionInfo) {
        this.regionInfo = regionInfo;
    }

    @Override
    public String toString() {
        return "STEffectTryonInfo{" +
                "color=" + color +
                ", strength=" + strength +
                ", midtone=" + midtone +
                ", highlight=" + highlight +
                ", lipFinishType=" + lipFinishType +
                ", regionCount=" + regionCount +
                ", regionInfo=" + Arrays.toString(regionInfo) +
                '}';
    }
}
