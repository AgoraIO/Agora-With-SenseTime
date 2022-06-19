package com.sensetime.stmobile.model;

/**
 * 脚部检测结果
 */
public class STMobileFoot {
    // 脚的ID
    private int id;

    // 脚的置信度
    private float score;

    // 矩形框
    private STRect rect;

    // 脚部关键点
    private STPoint[] keyPoints;

    // 脚部关键点个数
    private int keyPointsCount;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public float getScore() {
        return score;
    }

    public void setScore(float score) {
        this.score = score;
    }

    public STRect getRect() {
        return rect;
    }

    public void setRect(STRect rect) {
        this.rect = rect;
    }

    public STPoint[] getpKeyPoints() {
        return keyPoints;
    }

    public void setpKeyPoints(STPoint[] pKeyPoints) {
        this.keyPoints = pKeyPoints;
    }

    public int getKeyPointsCount() {
        return keyPointsCount;
    }

    public void setKeyPointsCount(int keyPointsCount) {
        this.keyPointsCount = keyPointsCount;
    }
}
