package com.sensetime.stmobile;

public class STAvatarParams {

    public static final int AVATAR_FEATURE_IDX_BROW = 4;

    public static final int AVATAR_FACING_BODY_FRONT = 0;
    public static final int AVATAR_FACING_BODY_LEFT_45 = 1;
    public static final int AVATAR_FACING_BODY_RIGHT_45 = 2;
    public static final int AVATAR_FACING_HEAD_FRONT = 3;
    public static final int AVATAR_FACING_HEAD_LEFT_45 = 4;
    public static final int AVATAR_FACING_HEAD_RIGHT_45 = 5;

    /// 捏脸编辑
    public static final int AVATAR_DISPLAY_PINCHING = 0;
    /// 只显示头部的实时跟踪
    public static final int AVATAR_DISPLAY_FACE_TRACKING = 1;
    /// 显示完整肢体的实时跟踪
    public static final int AVATAR_DISPLAY_BODY_TRACKING = 2;

    public static final int ST_AVATAR_CTRL_BROW_HORIZONTAL = 0;                 //眉毛整体左右
    public static final int ST_AVATAR_CTRL_BROW_VERTICAL = 1;                   //眉毛整体上下
    public static final int ST_AVATAR_CTRL_BROW_HEADER_HORIZONTAL = 2;          //眉头左右
    public static final int ST_AVATAR_CTRL_BROW_HEADER_VERTICAL = 3;            //眉头上下
    public static final int ST_AVATAR_CTRL_BROW_ARCH_HORIZONTAL = 4;            //眉弓左右
    public static final int ST_AVATAR_CTRL_BROW_ARCH_VERTICAL = 5;              //眉弓上下
    public static final int ST_AVATAR_CTRL_BROW_TAIL_HORIZONTAL = 6;            //眉尾左右
    public static final int ST_AVATAR_CTRL_BROW_TAIL_VERTICAL = 7;              //眉尾上下
    public static final int ST_AVATAR_CTRL_EYE_VERTICAL = 8;                    //调整双眼上下位置
    public static final int ST_AVATAR_CTRL_EYE_DISTANCE = 9;                    //调节双眼左右位置
    public static final int ST_AVATAR_CTRL_EYE_OPEN = 10;                       //调节双眼睁大程度
    public static final int ST_AVATAR_CTRL_EYE_SIZE = 11;                       //调节双眼整体大小
    public static final int ST_AVATAR_CTRL_EYE_IN_CORNER_VERTICAL = 12;         //内眼角上下调节
    public static final int ST_AVATAR_CTRL_EYE_IN_CORNER_HORIZONTAL = 13;       //内眼角左右调节
    public static final int ST_AVATAR_CTRL_UPPER_EYELID_HORIZONTAL = 14;        //上眼皮左右调节
    public static final int ST_AVATAR_CTRL_UPPER_EYELID_VERTICAL = 15;          //上眼皮上下调节
    public static final int ST_AVATAR_CTRL_LOWER_EYELID_HORIZONTAL = 16;        //下眼皮左右调节
    public static final int ST_AVATAR_CTRL_LOWER_EYELID_VERTICAL = 17;          //下眼皮上下调节
    public static final int ST_AVATAR_CTRL_EYE_OUT_CORNER_VERTICAL = 18;        //外眼角上下调节
    public static final int ST_AVATAR_CTRL_EYE_OUT_CORNER_HORIZONTAL = 19;      //外眼角左右调节
    public static final int ST_AVATAR_CTRL_NOSE_LENGTH = 20;                    //鼻子长短
    public static final int ST_AVATAR_CTRL_NOSE_SIZE = 21;                      //鼻子大小
    public static final int ST_AVATAR_CTRL_NOSE_ANGLE = 22;                     //鼻子挺拔
    public static final int ST_AVATAR_CTRL_NOSTRIL_SIZE = 23;                   //鼻翼大小
    public static final int ST_AVATAR_CTRL_NOSTRIL_VERTICAL = 24;               //鼻翼上下
    public static final int ST_AVATAR_CTRL_NOSE_BRIDGE_HEIGHT = 25;             //鼻梁高低
    public static final int ST_AVATAR_CTRL_NOSE_HEAD_SIZE = 26;                 //鼻头大小
    public static final int ST_AVATAR_CTRL_NOSE_HEAD_ANGLE = 27;                //鼻头朝向
    public static final int ST_AVATAR_CTRL_MOUTH_SIZE = 28;                     //嘴巴变大变小
    public static final int ST_AVATAR_CTRL_MOUTH_VERTICAL = 29;                 //嘴巴变宽变窄
    public static final int ST_AVATAR_CTRL_MOUTH_CORNER_LENGTH = 30;            //嘴巴上移下移
    public static final int ST_AVATAR_CTRL_MOUTH_CORNER_VERTICAL = 31;          //嘴巴向前或后突出
    public static final int ST_AVATAR_CTRL_UPPER_LIP_THICK = 32;                //嘴角上扬下撇
    public static final int ST_AVATAR_CTRL_UPPER_LIP_PEAK = 33;                 //人中上移下移
    public static final int ST_AVATAR_CTRL_LOWER_LIP_THICK = 34;                //嘴峰变宽变窄
    public static final int ST_AVATAR_CTRL_LOWER_LIP_SQURENESS = 35;            //上嘴变厚变薄
    public static final int ST_AVATAR_CTRL_LIP_MARK_VERTICAL = 36;              //上嘴峰变高变低
    public static final int ST_AVATAR_CTRL_LIP_ARC = 37;                        //上嘴唇突出向下
    public static final int ST_AVATAR_CTRL_LIP_MARK_UP_DOWN = 38;               //唇珠向上向下
    public static final int ST_AVATAR_CTRL_LIP_ARC_UP_DOWN = 39;                //唇线向上向下
    public static final int ST_AVATAR_CTRL_LOWER_LIP = 40;                      //下唇变厚变薄
    public static final int ST_AVATAR_CTRL_LOWER_LIP_PEAK = 41;                 //下唇峰上移下移
    public static final int ST_AVATAR_CTRL_LOWER_LIP_SIDE = 42;                 //下唇两侧上移下移
    public static final int ST_AVATAR_CTRL_MOUTH_CORNER = 43;                   //嘴角变宽变细
    public static final int ST_AVATAR_CTRL_HEAD_HORIZONTAL_SIZE = 44;           //整头胖瘦
    public static final int ST_AVATAR_CTRL_HEAD_VERTICAL_SIZE = 45;             //整头长短
    public static final int ST_AVATAR_CTRL_FOREHEAD_HEIGHT = 46;                //额头高低
    public static final int ST_AVATAR_CTRL_FOREHEAD_WIDTH = 47;                 //额头宽窄
    public static final int ST_AVATAR_CTRL_JAW_POINT_LENGTH = 48;               //下巴尖长短
    public static final int ST_AVATAR_CTRL_JAW_LENGTH = 49;                     //下巴长短
    public static final int ST_AVATAR_CTRL_JAW_SQUARENESS = 50;                 //下巴尖方
    public static final int ST_AVATAR_CTRL_JAW_HEIGHT = 51;                     //下颚高低
    public static final int ST_AVATAR_CTRL_JAW_WIDTH = 52;                      //下颚宽窄
    public static final int ST_AVATAR_CTRL_CHEEK_WIDTH = 53;                    //颧骨宽窄
    public static final int ST_AVATAR_CTRL_CHEEK_THICK = 54;                    //腮部凹凸
    public static final int ST_AVATAR_CTRL_CHEST_HEIGHT = 55;                   //胸高低
    public static final int ST_AVATAR_CTRL_CHEST_SIZE = 56;                     //胸大小
    public static final int ST_AVATAR_CTRL_WAIST_SIZE = 57;                     //腰大小
    public static final int ST_AVATAR_CTRL_HIPS_SIZE = 58;                      //臀大小
    public static final int ST_AVATAR_CTRL_HIPS_HEIGHT = 59;                    //臀翘程度
    public static final int ST_AVATAR_CTRL_EYE_VERTICAL_SIZE = 60;              //调节双眼宽窄程度
    public static final int ST_AVATAR_CTRL_BODY_SIZE = 61;                      //调节身体整体大小

    enum FacePoseType {
        ST_RESET_FACE_POSE_FRONT,
        ST_RESET_FACE_POSE_CURRENT;
    }

    public enum BackgroundType {
        ST_BACKGROUND_IMG_JPEG,
        ST_BACKGROUND_IMG_PNG,
        ST_BACKGROUND_IMG_TGA,
        ST_BACKGROUND_SEQUENCE
    }

    public enum DataFormat {
        AVATAR_PINCH_DATA_ZIP,
        AVATAR_PINCH_DATA_JSON,
    }

    /// @brief 标识Avatar身体各部位的枚举值
    public enum STAvatarPart {
        ST_AVATAR_PART_HEAD,        // Avatar头部
        ST_AVATAR_PART_UP_BODY,     // Avatar上半身
        ST_AVATAR_PART_COUNT,
    }

    /// @brief 目前检测输出的眉毛类型，其中男性4类，女性5类。
    public class STAvatarEyebrow {
        public static final int AVATAR_UNKNOWN_EYEBROW = 0;
        public static final int AVATAR_MALE_THIN_FLAT_EYEBROW = 1;          // 男性细平眉
        public static final int AVATAR_MALE_THICK_FLAT_EYEBROW = 2;         // 男性粗平眉
        public static final int AVATAR_MALE_DASHING_EYEBROW = 3;            // 男性剑眉
        public static final int AVATAR_MALE_SLANTED_EYEBROW = 4;            // 男性八字眉
        public static final int AVATAR_FEMALE_THIN_FLAT_EYEBROW = 5;        // 女性细平眉
        public static final int AVATAR_FEMALE_THICK_FLAT_EYEBROW = 6;       // 女性粗平眉
        public static final int AVATAR_FEMALE_THIN_RAISED_EYEBROW = 7;      // 女性细调眉
        public static final int AVATAR_FEMALE_THICK_RAISED_EYEBROW = 8;     // 女性粗挑眉
        public static final int AVATAR_FEMALE_BENT_EYEBROW = 9;             // 女性弯弯眉
    }
}
