package com.sensetime.stmobile.model;

public class STSegment {

    STImage image;
    float score;
    float minThrehold;
    float maxThrehold;
    STPoint offset;
    STPoint scale;

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

    public void setImage(STImage image) {
        this.image = image;
    }

    public void setScore(float score) {
        this.score = score;
    }

    public void setMaxThrehold(float maxThrehold) {
        this.maxThrehold = maxThrehold;
    }

    public void setMinThrehold(float minThrehold) {
        this.minThrehold = minThrehold;
    }

    public void setOffset(STPoint offset) {
        this.offset = offset;
    }

    public void setScale(STPoint scale) {
        this.scale = scale;
    }
}
