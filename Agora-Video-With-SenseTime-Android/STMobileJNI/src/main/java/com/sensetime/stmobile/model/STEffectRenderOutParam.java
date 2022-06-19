package com.sensetime.stmobile.model;

public class STEffectRenderOutParam {
    STEffectTexture texture;
    STImage image;
    STHumanAction humanAction;

    /**
     * 引擎渲染接口输出参数
     *
     * @param texture 输出纹理信息，需上层初始化
     * @param humanAction 输出脸部变形后的人脸检测结果，不需要可传null
     * @param image 输出图像数据，用于推流等场景，不需要可传null
     */
    public STEffectRenderOutParam(STEffectTexture texture, STImage image, STHumanAction humanAction){
        this.texture = texture;
        this.image = image;
        this.humanAction = humanAction;
    }

    public STImage getImage() {
        return image;
    }

    public STEffectTexture getTexture() {
        return texture;
    }

    public STHumanAction getHumanAction() {
        return humanAction;
    }

    public void setImage(STImage image) {
        this.image = image;
    }

    public void setTexture(STEffectTexture texture) {
        this.texture = texture;
    }

    public void setHumanAction(STHumanAction humanAction) {
        this.humanAction = humanAction;
    }
}
