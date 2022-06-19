package com.sensetime.stmobile.model;

public class STMobileFaceInfo {
    public STMobile106 face106;           ///< 人脸信息，包含矩形框、106点、head pose信息等

    public STPoint[] extraFacePoints;     ///< 眼睛、眉毛、嘴唇关键点. 没有检测到时为NULL
    public int extraFacePointsCount;      ///< 眼睛、眉毛、嘴唇关键点个数. 检测到时为ST_MOBILE_EXTRA_FACE_POINTS_COUNT, 没有检测到时为0

    STPoint[] tonguePoints;    ///< 舌头关键点数组
    float[] tonguePointsScore; ///< 舌头关键点对应的置信度[0,1] 值越大，置信度越高
    int tonguePointsCount;     ///< 舌头关键点的数目

    STPoint[] eyeballCenter;       ///< 眼球中心关键点. 没有检测到时为NULL
    public int eyeballCenterPointsCount;  //< 眼球中心关键点个数. 检测到时为ST_MOBILE_EYEBALL_CENTER_POINTS_COUNT, 没有检测到时为0

    STPoint[] eyeballContour;      ///< 眼球轮廓关键点. 没有检测到时为NULL
    public int eyeballContourPointsCount; ///< 眼球轮廓关键点个数. 检测到时为ST_MOBILE_EYEBALL_CONTOUR_POINTS_COUNT, 没有检测到时为0

    float leftEyeballScore;        ///< 左眼球检测结果（中心点和轮廓点）置信度: [0, 1.0], 建议阈值0.95
    float rightEyeballScore;       ///< 右眼球检测结果（中心点和轮廓点）置信度: [0, 1.0], 建议阈值0.95

    long faceAction;                ///< 脸部动作
    float[] faceActionScore;        ///< 各脸部动作置信度:eye, mouth, pitch, yaw, brow
    int faceActionScoreCount;       ///< 脸部动作个数

    byte[] avatarHelpInfo;          ///< avatar辅助信息,仅限内部使用，严禁修改
    int avatarHelpInfoLength;       ///< avatar辅助信息字节长度

    public int skin_type;           ///< 肤色
    public STColor hairColor;

    STFaceExtraInfo faceExtraInfo;

    public STPoint3f gazeDirection[];     ///< 视线方向
    public float gazeScore[];             ///< 视线置信度: [0.0, 1.0], 建议阈值为0.5
    public STFaceMesh faceMesh;        ///< 3d mesh信息，包括3d mesh关键点及个数
    public STMobileEarInfo earInfo;       ///< 耳朵信息，包括耳朵关键点及个数，左右耳置信度
    public STMobileForeheadInfo foreheadInfo; ///< 额头点信息，包括额头点坐标和个数


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

    public byte[] getAvatarHelpInfo() {
        return avatarHelpInfo;
    }

    public float getLeftEyeballScore() {
        return leftEyeballScore;
    }

    public float getRightEyeballScore() {
        return rightEyeballScore;
    }

    public float[] getFaceActionScore() {
        return faceActionScore;
    }

    public float[] getTonguePointsScore() {
        return tonguePointsScore;
    }

    public int getAvatarHelpInfoLength() {
        return avatarHelpInfoLength;
    }

    public int getFaceActionScoreCount() {
        return faceActionScoreCount;
    }

    public int getTonguePointsCount() {
        return tonguePointsCount;
    }

    public STFaceExtraInfo getFaceExtraInfo() {
        return faceExtraInfo;
    }

    public STMobile106 getFace106() {
        return face106;
    }

    public STPoint[] getTonguePoints() {
        return tonguePoints;
    }

    public void setAvatarHelpInfo(byte[] avatarHelpInfo) {
        this.avatarHelpInfo = avatarHelpInfo;
    }

    public void setAvatarHelpInfoLength(int avatarHelpInfoLength) {
        this.avatarHelpInfoLength = avatarHelpInfoLength;
    }

    public void setExtraFacePoints(STPoint[] extraFacePoints) {
        this.extraFacePoints = extraFacePoints;
    }

    public void setExtraFacePointsCount(int extraFacePointsCount) {
        this.extraFacePointsCount = extraFacePointsCount;
    }

    public void setEyeballCenter(STPoint[] eyeballCenter) {
        this.eyeballCenter = eyeballCenter;
    }

    public void setEyeballCenterPointsCount(int eyeballCenterPointsCount) {
        this.eyeballCenterPointsCount = eyeballCenterPointsCount;
    }

    public void setEyeballContour(STPoint[] eyeballContour) {
        this.eyeballContour = eyeballContour;
    }

    public void setEyeballContourPointsCount(int eyeballContourPointsCount) {
        this.eyeballContourPointsCount = eyeballContourPointsCount;
    }

    public void setFace106(STMobile106 face106) {
        this.face106 = face106;
    }

    public void setFaceActionScore(float[] faceActionScore) {
        this.faceActionScore = faceActionScore;
    }

    public void setFaceActionScoreCount(int faceActionScoreCount) {
        this.faceActionScoreCount = faceActionScoreCount;
    }

    public void setFaceExtraInfo(STFaceExtraInfo faceExtraInfo) {
        this.faceExtraInfo = faceExtraInfo;
    }

    public void setLeftEyeballScore(float leftEyeballScore) {
        this.leftEyeballScore = leftEyeballScore;
    }

    public void setRightEyeballScore(float rightEyeballScore) {
        this.rightEyeballScore = rightEyeballScore;
    }

    public void setTonguePoints(STPoint[] tonguePoints) {
        this.tonguePoints = tonguePoints;
    }

    public void setTonguePointsCount(int tonguePointsCount) {
        this.tonguePointsCount = tonguePointsCount;
    }

    public void setTonguePointsScore(float[] tonguePointsScore) {
        this.tonguePointsScore = tonguePointsScore;
    }

    public float[] getGazeScore() {
        return gazeScore;
    }

    public STPoint3f[] getGazeDirection() {
        return gazeDirection;
    }

    public STFaceMesh getFaceMesh() {
        return faceMesh;
    }

    public void setGazeDirection(STPoint3f[] gazeDirection) {
        this.gazeDirection = gazeDirection;
    }

    public void setFaceMesh(STFaceMesh faceMesh) {
        this.faceMesh = faceMesh;
    }

    public void setGazeScore(float[] gazeScore) {
        this.gazeScore = gazeScore;
    }

    public STMobileEarInfo getEarInfo() {
        return earInfo;
    }

    public STMobileForeheadInfo getForeheadInfo() {
        return foreheadInfo;
    }

    public void setEarInfo(STMobileEarInfo earInfo) {
        this.earInfo = earInfo;
    }

    public void setForeheadInfo(STMobileForeheadInfo foreheadInfo) {
        this.foreheadInfo = foreheadInfo;
    }

    public int getSkinType() {
        return skin_type;
    }

    public STColor getHairColor() {
        return hairColor;
    }

    public void setHairColor(STColor hairColor) {
        this.hairColor = hairColor;
    }

    public void setSkinType(int skin_type) {
        this.skin_type = skin_type;
    }
}
