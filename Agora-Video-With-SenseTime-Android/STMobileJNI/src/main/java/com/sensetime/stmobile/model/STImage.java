package com.sensetime.stmobile.model;

/**
 * Created by sensetime on 17-3-1.
 */

public class STImage {
    byte[] imageData;
    int pixelFormat;
    int width;
    int height;
    int stride;
    double timeStamp;

    public STImage(byte[] imageData, int pixelFormat, int width, int height) {
        this.imageData = imageData;
        this.pixelFormat = pixelFormat;
        this.width = width;
        this.height = height;
    }

    public STImage(byte[] imageData, int width, int height, int stride,int pixelFormat, double timeStamp){
        this.imageData = imageData;
        this.width = width;
        this.height = height;
        this.timeStamp = timeStamp;
        this.stride = stride;
        this.pixelFormat = pixelFormat;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public byte[] getImageData() {
        return imageData;
    }

    public double getTimeStamp() {
        return timeStamp;
    }

    public int getHeight() {
        return height;
    }

    public int getPixelFormat() {
        return pixelFormat;
    }

    public int getStride() {
        return stride;
    }

    public int getWidth() {
        return width;
    }

    public void setImageData(byte[] imageData) {
        this.imageData = imageData;
    }

    public void setPixelFormat(int pixelFormat) {
        this.pixelFormat = pixelFormat;
    }

    public void setStride(int stride) {
        this.stride = stride;
    }

    public void setTimeStamp(double timeStamp) {
        this.timeStamp = timeStamp;
    }
}
