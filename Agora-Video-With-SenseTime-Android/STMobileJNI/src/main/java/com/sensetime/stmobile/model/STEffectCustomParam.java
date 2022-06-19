package com.sensetime.stmobile.model;

public class STEffectCustomParam {
    STQuaternion cameraQuaternion;
    boolean isFrontCamera;
    int event;  // user defined.


    /**
     * 自定义参数
     *
     * @param cameraQuaternion 相机姿态的四元数，不需要可传null
     * @param frontCamera 是否为前置相机
     * @param event 用户定义的事件id，不需要可传0
     */
    public STEffectCustomParam(STQuaternion cameraQuaternion, boolean frontCamera, int event){
        this.cameraQuaternion = cameraQuaternion;
        this.event = event;
        this.isFrontCamera = frontCamera;
    }

    public STQuaternion getCameraQuaternion() {
        return cameraQuaternion;
    }

    public int getEvent() {
        return event;
    }

    public boolean isFrontCamera() {
        return isFrontCamera;
    }

    public void setCameraQuaternion(STQuaternion cameraQuaternion) {
        this.cameraQuaternion = cameraQuaternion;
    }

    public void setEvent(int event) {
        this.event = event;
    }

    public void setFrontCamera(boolean frontCamera) {
        isFrontCamera = frontCamera;
    }
}
