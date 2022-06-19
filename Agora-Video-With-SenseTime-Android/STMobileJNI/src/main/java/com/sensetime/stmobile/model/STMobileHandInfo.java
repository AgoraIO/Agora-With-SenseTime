package com.sensetime.stmobile.model;

public class STMobileHandInfo {
    int handId;
    STRect handRect;
    STPoint[] keyPoints;
    int keyPointsCount;
    long handAction;
    float handActionScore;

    int left_right;
    STPoint[] extra2dKeyPoints;   ///< 手部2d关键点
    STPoint3f[] extra3dKeyPoints;   ///< 手部3d关键点
    int extra2dKeyPointsCount;    ///< 手部2d关键点个数
    int extra3dKeyPointsCount;    ///< 手部3d关键点个数
    STHandDynamicGesture dynamicGesture; ///<动态手势
    STPoint[] gestureKeyPoints;   ///< 动态手部关键点
    int gestureKeyPointsCount;   ///< 动态手部关键点

    public void setKeyPointsCount(int keyPointsCount) {
        this.keyPointsCount = keyPointsCount;
    }

    public void setKeyPoints(STPoint[] keyPoints) {
        this.keyPoints = keyPoints;
    }

    public int getKeyPointsCount() {
        return keyPointsCount;
    }

    public float getHandActionScore() {
        return handActionScore;
    }

    public int getHandId() {
        return handId;
    }

    public long getHandAction() {
        return handAction;
    }

    public STPoint[] getKeyPoints() {
        return keyPoints;
    }

    public STRect getHandRect() {
        return handRect;
    }

    public void setHandAction(long handAction) {
        this.handAction = handAction;
    }

    public void setHandActionScore(float handActionScore) {
        this.handActionScore = handActionScore;
    }

    public void setHandId(int handId) {
        this.handId = handId;
    }

    public void setHandRect(STRect handRect) {
        this.handRect = handRect;
    }

    public int getExtra2dKeyPointsCount() {
        return extra2dKeyPointsCount;
    }

    public int getExtra3dKeyPointsCount() {
        return extra3dKeyPointsCount;
    }

    public int getGestureKeyPointsCount() {
        return gestureKeyPointsCount;
    }

    public int getLeft_right() {
        return left_right;
    }

    public STHandDynamicGesture getDynamicGesture() {
        return dynamicGesture;
    }

    public STPoint3f[] getExtra3dKeyPoints() {
        return extra3dKeyPoints;
    }

    public STPoint[] getExtra2dKeyPoints() {
        return extra2dKeyPoints;
    }

    public STPoint[] getGestureKeyPoints() {
        return gestureKeyPoints;
    }

    public void setDynamicGesture(STHandDynamicGesture dynamicGesture) {
        this.dynamicGesture = dynamicGesture;
    }

    public void setExtra2dKeyPoints(STPoint[] extra2dKeyPoints) {
        this.extra2dKeyPoints = extra2dKeyPoints;
    }

    public void setExtra2dKeyPointsCount(int extra2dKeyPointsCount) {
        this.extra2dKeyPointsCount = extra2dKeyPointsCount;
    }

    public void setExtra3dKeyPoints(STPoint3f[] extra3dKeyPoints) {
        this.extra3dKeyPoints = extra3dKeyPoints;
    }

    public void setExtra3dKeyPointsCount(int extra3dKeyPointsCount) {
        this.extra3dKeyPointsCount = extra3dKeyPointsCount;
    }

    public void setGestureKeyPoints(STPoint[] gestureKeyPoints) {
        this.gestureKeyPoints = gestureKeyPoints;
    }

    public void setGestureKeyPointsCount(int gestureKeyPointsCount) {
        this.gestureKeyPointsCount = gestureKeyPointsCount;
    }

    public void setLeft_right(int left_right) {
        this.left_right = left_right;
    }
}
