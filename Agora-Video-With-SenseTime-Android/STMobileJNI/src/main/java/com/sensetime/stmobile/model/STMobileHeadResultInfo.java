package com.sensetime.stmobile.model;

public class STMobileHeadResultInfo {
    STRect rect;               ///< 矩形区域
    int id;                     ///< 目标ID, 用于表示在目标跟踪中的相同目标在不同帧多次出现
    float score;                ///< 目标置信度，用于表示此目标在当前帧中的置信度 (0 - 10)
    float angle;                ///< 目标roll角，用于表示此目标在当前帧中的旋转信息，原图中目标逆时针旋转angle度后，目标会是正方向 (0 - 360)

    public float getAngle() {
        return angle;
    }

    public float getScore() {
        return score;
    }

    public int getId() {
        return id;
    }

    public STRect getRect() {
        return rect;
    }
}
