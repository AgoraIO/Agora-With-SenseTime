package com.sensetime.stmobile.model;

import java.util.Arrays;

public class STEffectModuleInfo {
    int moduleId;   ///< 贴纸的ID
    int packageId;  ///< 贴纸所属素材包的ID

    int moduleType;  ///< 贴纸的类型
    public byte[] name; ///< 贴纸的名字

    float strength;    ///< 贴纸的强度
    int instanceId;    ///< 贴纸对应的position id, 即st_mobile_human_action_t结果中不同类型结果中的id
    int state;         ///< 贴纸的播放状态

    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }

    public int getPackageId() {
        return packageId;
    }

    public void setPackageId(int packageId) {
        this.packageId = packageId;
    }

    public int getModuleType() {
        return moduleType;
    }

    public void setModuleType(int moduleType) {
        this.moduleType = moduleType;
    }

    public byte[] getName() {
        return name;
    }

    public void setName(byte[] name) {
        this.name = name;
    }

    public float getStrength() {
        return strength;
    }

    public void setStrength(float strength) {
        this.strength = strength;
    }

    public int getInstanceId() {
        return instanceId;
    }

    public void setInstanceId(int instanceId) {
        this.instanceId = instanceId;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    @Override
    public String toString() {
        return "STEffectModuleInfo{" +
                "moduleId=" + moduleId +
                ", packageId=" + packageId +
                ", moduleType=" + moduleType +
                ", name=" + Arrays.toString(name) +
                ", strength=" + strength +
                ", instanceId=" + instanceId +
                ", state=" + state +
                '}';
    }
}
