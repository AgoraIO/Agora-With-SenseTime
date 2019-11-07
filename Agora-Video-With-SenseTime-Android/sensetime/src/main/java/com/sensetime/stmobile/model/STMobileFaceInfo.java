package com.sensetime.stmobile.model;

public class STMobileFaceInfo {
    public STMobile106 face106;            ///< 人脸信息，包含矩形框、106点、head pose信息等

    public STPoint[] extraFacePoints;      ///< 眼睛、眉毛、嘴唇关键点. 没有检测到时为NULL
    public int extraFacePointsCount;       ///< 眼睛、眉毛、嘴唇关键点个数. 检测到时为ST_MOBILE_EXTRA_FACE_POINTS_COUNT, 没有检测到时为0

    public STPoint[] tonguePoints;         ///< 舌头关键点数组
    public float[] tonguePointsScore;      ///< 舌头关键点对应的置信度[0,1] 值越大，置信度越高
    public int tonguePointsCount;          ///< 舌头关键点的数目

    public STPoint[] eyeballCenter;        ///< 眼球中心关键点. 没有检测到时为NULL
    public int eyeballCenterPointsCount;   ///< 眼球中心关键点个数. 检测到时为ST_MOBILE_EYEBALL_CENTER_POINTS_COUNT, 没有检测到时为0

    public STPoint[] eyeballContour;       ///< 眼球轮廓关键点. 没有检测到时为NULL
    public int eyeballContourPointsCount;  ///< 眼球轮廓关键点个数. 检测到时为ST_MOBILE_EYEBALL_CONTOUR_POINTS_COUNT, 没有检测到时为0

    public float leftEyeballScore;         ///< 左眼球检测结果（中心点和轮廓点）置信度: [0, 1.0], 建议阈值0.95
    public float rightEyeballScore;        ///< 右眼球检测结果（中心点和轮廓点）置信度: [0, 1.0], 建议阈值0.95

    public long faceAction;                ///< 脸部动作
    public float[] faceActionScore;        ///< 各脸部动作置信度:eye, mouth, pitch, yaw, brow
    public int faceActionScoreCount;       ///< 脸部动作个数

    public byte[] avatarHelpInfo;          ///< avatar辅助信息,仅限内部使用，严禁修改
    public int avatarHelpInfoLength;       ///< avatar辅助信息字节长度

    public STMobile106 getFace() {
        return face106;
    }

    public void setFace(STMobile106 face) {
        this.face106 = face;
    }

    public long getFaceAction() {
        return faceAction;
    }

    public void setFaceAction(long face_action) {
        this.faceAction = face_action;
    }

    public int getExtraFacePointsCount(){
        return extraFacePointsCount;
    }

    public STPoint[] getExtraFacePoints(){
        return extraFacePoints;
    }

    public int getEyeballCenterPointsCount(){
        return eyeballCenterPointsCount;
    }

    public STPoint[] getEyeballCenter(){
        return eyeballCenter;
    }

    public int getEyeballContourPointsCount(){
        return eyeballContourPointsCount;
    }

    public STPoint[] getEyeballContour(){
        return eyeballContour;
    }
}
