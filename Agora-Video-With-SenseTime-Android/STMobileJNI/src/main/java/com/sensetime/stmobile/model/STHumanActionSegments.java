package com.sensetime.stmobile.model;

public class STHumanActionSegments {

    private STSegment image;            ///< 前后背景分割图片信息,前景为0,背景为255,边缘部分有模糊(0-255之间),输出图像大小可以调节

    private STSegment hair;             ///< 头发分割图片信息,前景为0,背景为255,边缘部分有模糊(0-255之间),输出图像大小可以调节
    private STSegment skin;             ///< 皮肤分割图片信息,前景为0,背景为255,边缘部分有模糊(0-255之间),输出图像大小可以调节
    private STSegment head;             ///< 头部分割图片信息,前景为0,背景为255,边缘部分有模糊(0-255之间),输出图像大小可以调节
    private STSegment[] mouthParses;
    private int mouthParseCount;
    private STSegment sky;             ///<  天空分割图片信息,前景为0,背景为255,边缘部分有模糊(0-255之间),输出图像大小可以调节
    private STSegment depth;             ///<  深度估计信息

    private STSegment[] faceOcclusions;
    private int faceOcclusionCount;

    private int headCount;
    private STSegment multiSegment; ///多类分割结果图片信息,背景0，手1，头发2，眼镜3，躯干4，上臂5，下臂6，大腿7，小腿8，脚9，帽子10，随身物品11，脸12，上衣13，下装14，输出图像大小可以调节

    public STSegment getFigureSegment(){
        return image;
    }

    public STSegment getHair(){
        return hair;
    }
    public STSegment getSkin(){
        return skin;
    }
    public STSegment getHead(){
        return head;
    }

    public STSegment[] getMouthParses(){
        return mouthParses;
    }

    public int getMouthParseCount(){
        return mouthParseCount;
    }

    public STSegment getMultiSegment(){
        return multiSegment;
    }

    public int getHeadCount(){
        return headCount;
    }

    public int getFaceOcclusionCount() {
        return faceOcclusionCount;
    }

    public STSegment[] getFaceOcclusions() {
        return faceOcclusions;
    }

    public STSegment getDepth() {
        return depth;
    }

    public STSegment getSky() {
        return sky;
    }

    public STSegment getImage() {
        return image;
    }
}
