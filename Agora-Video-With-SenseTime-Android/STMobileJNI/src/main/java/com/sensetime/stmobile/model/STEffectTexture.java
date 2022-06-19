package com.sensetime.stmobile.model;

public class STEffectTexture {
    int id;
    int width;
    int height;
    int format;

    /**
     * 纹理参数
     *
     * @param id 纹理id
     * @param width 纹理宽度
     * @param height 纹理高度
     * @param format 纹理格式 目前仅支持RGBA
     */
    public STEffectTexture(int id, int width, int height, int format){
        this.id = id;
        this.width = width;
        this.height = height;
        this.format = format;
    }

    public int getId() {
        return id;
    }

    public int getWidth() {
        return width;
    }

    public int getHeight() {
        return height;
    }

    public int getFormat() {
        return format;
    }

    public void setFormat(int format) {
        this.format = format;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setWidth(int width) {
        this.width = width;
    }
}
