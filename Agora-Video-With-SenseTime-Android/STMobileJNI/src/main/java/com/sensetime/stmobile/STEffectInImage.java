package com.sensetime.stmobile;

import com.sensetime.stmobile.model.STImage;

public class STEffectInImage {

    // 输入的图片信息
    STImage image;

    // 输入图片的旋转信息（相对于输入的texture而言）
    int rotate;

    // 输入图片是否水平镜像
    boolean mirror;

    public STEffectInImage(STImage image, int rotate, boolean mirror) {
        this.image = image;
        this.rotate = rotate;
        this.mirror = mirror;
    }

    public STImage getImage() {
        return image;
    }

    public void setImage(STImage image) {
        this.image = image;
    }

    public int getRotate() {
        return rotate;
    }

    public void setRotate(int rotate) {
        this.rotate = rotate;
    }

    public boolean isMirror() {
        return mirror;
    }

    public void setMirror(boolean mirror) {
        this.mirror = mirror;
    }
}
