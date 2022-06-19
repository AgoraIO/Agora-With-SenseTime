package com.sensetime.stmobile.model;

import com.sensetime.stmobile.STEffectInImage;

public class STEffectRenderInParam {
    long nativeHumanActionResult;
    STHumanAction humanAction;
    private STAnimalFace[] animalFaces;
    private int animalFaceCount;
    int rotate;
    int frontRotate;
    boolean needMirror;
    STEffectCustomParam customParam;
    STEffectTexture texture;
    STEffectInImage image;
    double timeStamp;

    /**
     * 引擎渲染接口输入参数
     *
     * @param nativeHumanActionResult 人脸等检测结果，不需要可传0（如基础美颜、滤镜功能）
     * @param animalFaceInfo 动物检测信息，不需要可传null
     * @param rotate 人脸在纹理中的方向
     * @param needMirror 传入图像与显示图像是否是镜像关系
     * @param customParam 用户自定义参数，不需要可传null
     * @param texture 输入纹理，不可传null
     * @param image 输入图像数据，不需要可传null
     */
    public STEffectRenderInParam(long nativeHumanActionResult, STAnimalFaceInfo animalFaceInfo, int rotate, int frontRotate, boolean needMirror, STEffectCustomParam customParam, STEffectTexture texture, STEffectInImage image){
        this.nativeHumanActionResult = nativeHumanActionResult;
        this.animalFaces = (animalFaceInfo != null ? animalFaceInfo.getAnimalFaces() : null);
        this.animalFaceCount = (animalFaceInfo != null ? animalFaceInfo.getFaceCount() : 0);
        this.rotate = rotate;
        this.frontRotate = frontRotate;
        this.needMirror = needMirror;
        this.customParam = customParam;
        this.texture = texture;
        this.image = image;
        this.timeStamp = System.currentTimeMillis();
    }

    /**
     * 引擎渲染接口输入参数
     *
     * @param humanAction 人脸等检测结果，不需要可传null（如基础美颜、滤镜功能）
     * @param animalFaceInfo 动物检测信息，不需要可传null
     * @param rotate 人脸在纹理中的方向
     * @param needMirror 传入图像与显示图像是否是镜像关系
     * @param customParam 用户自定义参数，不需要可传null
     * @param texture 输入纹理，不可传null
     * @param image 输入图像数据，不需要可传null
     */
    public STEffectRenderInParam(STHumanAction humanAction, STAnimalFaceInfo animalFaceInfo, int rotate, int frontRotate, boolean needMirror, STEffectCustomParam customParam, STEffectTexture texture, STEffectInImage image){
        this.humanAction = humanAction;
        this.animalFaces = (animalFaceInfo != null ? animalFaceInfo.getAnimalFaces() : null);
        this.animalFaceCount = (animalFaceInfo != null ? animalFaceInfo.getFaceCount() : 0);
        this.rotate = rotate;
        this.frontRotate = frontRotate;
        this.needMirror = needMirror;
        this.customParam = customParam;
        this.texture = texture;
        this.image = image;
        this.timeStamp = System.currentTimeMillis();
    }

    public boolean isNeedMirror() {
        return needMirror;
    }

    public int getFrontRotate() {
        return frontRotate;
    }

    public int getRotate() {
        return rotate;
    }

    public STEffectCustomParam getCustomParam() {
        return customParam;
    }

    public STHumanAction getHumanAction() {
        return humanAction;
    }

    public STAnimalFaceInfo getAnimalFaceInfo() {
        return new STAnimalFaceInfo(this.animalFaces,this.animalFaceCount);
    }

    public STEffectTexture getTexture() {
        return texture;
    }

    public STEffectInImage getImage() {
        return image;
    }

    public int getAnimalFaceCount() {
        return animalFaceCount;
    }

    public STAnimalFace[] getAnimalFaces() {
        return animalFaces;
    }

    public void setAnimalFaceCount(int animalFaceCount) {
        this.animalFaceCount = animalFaceCount;
    }

    public void setAnimalFaces(STAnimalFace[] animalFaces) {
        this.animalFaces = animalFaces;
    }

    public void setCustomParam(STEffectCustomParam customParam) {
        this.customParam = customParam;
    }

    public void setFrontRotate(int frontRotate) {
        this.frontRotate = frontRotate;
    }

    public void setHumanAction(STHumanAction humanAction) {
        this.humanAction = humanAction;
    }

    public void setImage(STEffectInImage image) {
        this.image = image;
    }

    public void setNeedMirror(boolean needMirror) {
        this.needMirror = needMirror;
    }

    public void setRotate(int rotate) {
        this.rotate = rotate;
    }

    public void setTexture(STEffectTexture texture) {
        this.texture = texture;
    }

    public long getNativeHumanActionResult() {
        return nativeHumanActionResult;
    }

    public void setNativeHumanActionResult(long nativeHumanActionResult) {
        this.nativeHumanActionResult = nativeHumanActionResult;
    }
}
