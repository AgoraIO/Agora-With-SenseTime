package com.sensetime.stmobile.model;

public class STMobileEarInfo {

    public STPoint[] earPoints;     ///< 耳朵关键点. 没有检测到时为NULL.耳朵左右各有18个关键点，共36个关键点，1-5为左耳靠近内耳区域的一条线，6-18为左耳外耳廓，19-23为右耳靠近内耳区域的一条线，24-36为右耳外耳廓
    public int earPointsCount;      ///< 耳朵关键点个数. 检测到时为ST_MOBILE_EAR_POINTS_COUNT, 没有检测到时为0
    public float leftEarScore;      ///< 左耳检测结果置信度: [0.0, 1.0]
    public float rightEarScore;     ///< 右耳检测结果置信度: [0.0, 1.0]

}
