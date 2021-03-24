package com.sensetime.stmobile.model;

public class STSegment {

    public STImage image;
    public float score;
    public float minThrehold;
    public float maxThrehold;
    public STPoint offset;
    public STPoint scale;

    public STImage getImage(){
        return image;
    }

    public float getMinThrehold(){
        return minThrehold;
    }

    public float getMaxThrehold() {
        return maxThrehold;
    }

    public STPoint getOffset(){
        return offset;
    }

    public STPoint getScale() {
        return scale;
    }

    public float getScore() {
        return score;
    }
}
