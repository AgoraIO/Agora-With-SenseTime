package com.sensetime.stmobile.model;

/**
 * 肢体检测结果
*/
public class STMobileBodyInfo {
    int id;                 ///< body id

    STPoint[] keyPoints;    ///< body关键点
    float[] keyPointsScore; ///< 关键点的置信度[0,1] 值越大，置信度越高
    int keyPointsCount;     ///< body关键点个数 目前为4或14

    STPoint[] contourPoints;    ///< 肢体轮廓点
    float[] contourPointsScore; ///< 肢体轮廓点键点的置信度[0,1] 值越大，置信度越高
    int contourPointsCount;     ///< 肢体轮廓点个数

    long bodyAction;         ///< body动作，本版本无效
    float bodyActionScore;  ///< body动作置信度,本版本无效

    STPoint3f[] keyPoints3d;	///< 肢体3d点
    float[] keyPoints3dScore;  ///< 肢体3d点置信度
    int keyPoints3dCount;		///< 肢体3d点个数(0或17）
    int label; //< 肢体label 0表示正常 1表示双手抱胸 2表示双手抱头
    int[] handValid;


    public STPoint[] getKeyPoints(){
        return keyPoints;
    }

    public float[] getKeyPointsScore(){
        return keyPointsScore;
    }

    public STPoint[] getContourPoints(){
        return contourPoints;
    }

    public float[] getContourPointsScore(){
        return contourPointsScore;
    }

    public void setId(int id) {
        this.id = id;
    }

    public float getBodyActionScore() {
        return bodyActionScore;
    }

    public int getContourPointsCount() {
        return contourPointsCount;
    }

    public int getId() {
        return id;
    }

    public int getKeyPointsCount() {
        return keyPointsCount;
    }

    public long getBodyAction() {
        return bodyAction;
    }

    public void setBodyAction(long bodyAction) {
        this.bodyAction = bodyAction;
    }

    public void setBodyActionScore(float bodyActionScore) {
        this.bodyActionScore = bodyActionScore;
    }

    public void setContourPoints(STPoint[] contourPoints) {
        this.contourPoints = contourPoints;
    }

    public void setContourPointsCount(int contourPointsCount) {
        this.contourPointsCount = contourPointsCount;
    }

    public void setContourPointsScore(float[] contourPointsScore) {
        this.contourPointsScore = contourPointsScore;
    }

    public void setKeyPoints(STPoint[] keyPoints) {
        this.keyPoints = keyPoints;
    }

    public void setKeyPointsCount(int keyPointsCount) {
        this.keyPointsCount = keyPointsCount;
    }

    public void setKeyPointsScore(float[] keyPointsScore) {
        this.keyPointsScore = keyPointsScore;
    }


    public int getLabel() {
        return label;
    }

    public float[] getKeyPoints3dScore() {
        return keyPoints3dScore;
    }

    public int getKeyPoints3dCount() {
        return keyPoints3dCount;
    }

    public STPoint3f[] getKeyPoints3d() {
        return keyPoints3d;
    }

    public int[] getHandValid() {
        return handValid;
    }

}
