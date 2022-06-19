package com.sensetime.stmobile.model;

import com.sensetime.stmobile.STCommonNative;

public class STYuvImage {
    public byte[] planes0;    /// Image Plane 图像平面内存地址
    public byte[] planes1;
    public byte[] planes2;
    public int[] strides = new int[3];      /// 图像每行的跨距，有效跨距应该与plane对应
    public int width;          /// image width
    public int height;         /// image height
    public int format;         /// input image format 图像的格式

    public STYuvImage(byte[] nv21Data, int width, int height){
        this.planes0 = new byte[width * height];
        this.planes1 = new byte[width * height /2];
        this.height = height;
        this.width = width;
        this.strides[0] = width;
        this.strides[1] = width;
        this.strides[2] = width;
        this.format = STCommonNative.ST_PIX_FMT_NV21;

        System.arraycopy(nv21Data, 0, this.planes0, 0, height * width);
        System.arraycopy(nv21Data, height * width, this.planes1, 0, height * width/2);
    }
}
