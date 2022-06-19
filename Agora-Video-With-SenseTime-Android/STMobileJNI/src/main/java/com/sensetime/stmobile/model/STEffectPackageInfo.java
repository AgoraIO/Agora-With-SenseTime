package com.sensetime.stmobile.model;

public class STEffectPackageInfo {
    int packageId;  //素材包的ID
    byte[] name;    ///< 素材包的名字
    int state;        ///< 素材包当前的状态
    int moduleCount;  ///< 素材包拥有的特效数量

    public int getPackageId() {
        return packageId;
    }

    public void setPackageId(int packageId) {
        this.packageId = packageId;
    }

    public byte[] getName() {
        return name;
    }

    public void setName(byte[] name) {
        this.name = name;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public int getModuleCount() {
        return moduleCount;
    }

    public void setModuleCount(int moduleCount) {
        this.moduleCount = moduleCount;
    }
}
