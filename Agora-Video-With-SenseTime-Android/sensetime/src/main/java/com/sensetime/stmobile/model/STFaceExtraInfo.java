package com.sensetime.stmobile.model;

public class STFaceExtraInfo {
    public float[][] affineMat;            ///< 仿射变换矩阵
    public int modelInputSize;

    public float[][] getAffineMat() {
        return affineMat;
    }
    public void setAffineMat(float[][] affineMat) {
        this.affineMat = affineMat;
    }
}
