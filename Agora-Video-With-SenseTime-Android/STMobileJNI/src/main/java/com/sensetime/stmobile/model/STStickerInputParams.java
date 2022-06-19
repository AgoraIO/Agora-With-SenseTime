package com.sensetime.stmobile.model;

public class STStickerInputParams {
    float[] cameraQuaternion;
    int quaternionLength;
    boolean isFrontCamera;

    int customEvent;

    public STStickerInputParams(float[] quaternion, boolean isFront, int event){
        if(quaternion != null){
            cameraQuaternion = quaternion;
            quaternionLength = quaternion.length;
        }else {
            cameraQuaternion = null;
            quaternionLength = 0;
        }

        isFrontCamera = isFront;
        customEvent = event;
    }

    public void setFrontCamera(boolean frontCamera) {
        isFrontCamera = frontCamera;
    }

    public void setCameraQuaternion(float[] cameraQuaternion) {
        this.cameraQuaternion = cameraQuaternion;
    }

    public boolean isFrontCamera() {
        return isFrontCamera;
    }

    public float[] getCameraQuaternion() {
        return cameraQuaternion;
    }

    public int getCustomEvent() {
        return customEvent;
    }

    public int getQuaternionLength() {
        return quaternionLength;
    }

    public void setCustomEvent(int customEvent) {
        this.customEvent = customEvent;
    }

    public void setQuaternionLength(int quaternionLength) {
        this.quaternionLength = quaternionLength;
    }
}
