package com.sensetime.stmobile.model;

/**
 * Created by sensetime on 18-8-1.
 */

public class STAnimalFace {

    int id;                 ///<  每个检测到的猫脸拥有唯一的ID.猫脸跟踪丢失以后重新被检测到,会有一个新的ID
    STRect rect;         ///< 代表面部的矩形区域
    float score;            ///< 置信度
    STPoint[] p_key_points;  ///< 关键点
    int key_points_count;       ///< 关键点个数
    float yaw;              ///< 水平转角,真实度量的左负右正
    float pitch;            ///< 俯仰角,真实度量的上负下正
    float roll;             ///< 旋转角,真实度量的左负右正

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public STRect getRect() {
        return rect;
    }

    public void setRect(STRect rect) {
        this.rect = rect;
    }

    public float getScore() {
        return score;
    }

    public void setScore(float score) {
        this.score = score;
    }

    public STPoint[] getP_key_points() {
        return p_key_points;
    }

    public void setP_key_points(STPoint[] p_key_points) {
        this.p_key_points = p_key_points;
    }

    public int getKey_points_count() {
        return key_points_count;
    }

    public void setKey_points_count(int key_points_count) {
        this.key_points_count = key_points_count;
    }

    public float getYaw() {
        return yaw;
    }

    public void setYaw(float yaw) {
        this.yaw = yaw;
    }

    public float getPitch() {
        return pitch;
    }

    public void setPitch(float pitch) {
        this.pitch = pitch;
    }

    public float getRoll() {
        return roll;
    }

    public void setRoll(float roll) {
        this.roll = roll;
    }
}
