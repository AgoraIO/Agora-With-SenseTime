package com.sensetime.stmobile.params;

/**
 * 定义可以美颜的类型
 */
public class STBeautyParamsType {
    public final static int ST_BEAUTIFY_REDDEN_STRENGTH = 1; // 红润强度, [0,1.0], 0.0不做红润
    public final static int ST_BEAUTIFY_SMOOTH_MODE = 2;     /// 磨皮模式, 默认值1.0, 1.0表示对全图磨皮, 0.0表示只对人脸磨皮
    public final static int ST_BEAUTIFY_SMOOTH_STRENGTH = 3; // 磨皮强度, [0,1.0], 0.0不做磨皮
    public final static int ST_BEAUTIFY_WHITEN_STRENGTH = 4;    /// 美白强度, [0,1.0], 0.0不做美白
    public final static int ST_BEAUTIFY_ENLARGE_EYE_RATIO = 5;    /// 大眼比例, [0,1.0], 0.0不做大眼效果
    public final static int ST_BEAUTIFY_SHRINK_FACE_RATIO = 6;    /// 瘦脸比例, [0,1.0], 0.0不做瘦脸效果
    public final static int ST_BEAUTIFY_SHRINK_JAW_RATIO = 7;     /// 小脸比例, [0,1.0], 0.0不做小脸效果
    public final static int ST_BEAUTIFY_CONSTRACT_STRENGTH = 8; // 对比度
    public final static int ST_BEAUTIFY_SATURATION_STRENGTH = 9; // 饱和度
    public final static int ST_BEAUTIFY_DEHIGHLIGHT_STRENGTH = 10; // 去高光强度, [0,1.0], 默认值1, 0.0不做高光
    public final static int ST_BEAUTIFY_NARROW_FACE_STRENGTH = 11; // 窄脸强度, [0,1.0], 默认值0, 0.0不做窄脸
    public final static int ST_BEAUTIFY_ROUND_EYE_RATIO = 12;       /// 圆眼比例, [0,1.0], 默认值0.0, 0.0不做圆眼
    public final static int ST_BEAUTIFY_SHRINK_CHEEKBONE_RATIO = 13; /// 瘦颧骨比例， [0, 1.0], 默认值0.0， 0.0不做瘦颧骨
    public final static int ST_BEAUTIFY_SHARPEN_STRENGTH = 14;      /// 锐化强度，[0, 1.0], 默认值0.0， 0.0不做锐化
    public final static int ST_BEAUTIFY_THINNER_HEAD_RATIO = 15;    /// 小头比例, [0, 1.0], 默认值0.0, 0.0不做小头效果

    public final static int ST_BEAUTIFY_SHRINK_JAWBONE_RATIO = 19;              /// 瘦下颔骨比例， [0, 1.0], 默认值0.0， 0.0不做瘦颧骨
    public final static int ST_BEAUTIFY_3D_NARROW_NOSE_RATIO = 20;    // 瘦鼻比例，[0, 1.0], 默认值为0.0，0.0不做瘦鼻
    public final static int ST_BEAUTIFY_3D_NOSE_LENGTH_RATIO = 21;     // 鼻子长短比例，[-1, 1], 默认值为0.0, [-1, 0]为短鼻，[0, 1]为长鼻
    public final static int ST_BEAUTIFY_3D_CHIN_LENGTH_RATIO = 22;     // 下巴长短比例，[-1, 1], 默认值为0.0，[-1, 0]为短下巴，[0, 1]为长下巴
    public final static int ST_BEAUTIFY_3D_MOUTH_SIZE_RATIO = 23;      // 嘴型比例，[-1, 1]，默认值为0.0，[-1, 0]为放大嘴巴，[0, 1]为缩小嘴巴
    public final static int ST_BEAUTIFY_3D_PHILTRUM_LENGTH_RATIO = 24; // 人中长短比例，[-1, 1], 默认值为0.0，[-1, 0]为短人中，[0, 1]为长人中
    public final static int ST_BEAUTIFY_3D_HAIRLINE_HEIGHT_RATIO = 25;   // 发际线高低比例，[-1, 1], 默认值为0.0，[-1, 0]为高发际线，[0, 1]为低发际线
    public final static int ST_BEAUTIFY_3D_THIN_FACE_SHAPE_RATIO = 26;   ///  瘦脸型比例， [0,1.0], 默认值0.0, 0.0不做瘦脸型效果
    public final static int ST_BEAUTIFY_3D_EYE_DISTANCE_RATIO = 27;             /// 眼距比例，[-1, 1]，默认值为0.0，[-1, 0]为减小眼距，[0, 1]为增加眼距
    public final static int ST_BEAUTIFY_3D_EYE_ANGLE_RATIO = 28;                /// 眼睛角度调整比例，[-1, 1]，默认值为0.0，[-1, 0]为左眼逆时针旋转，[0, 1]为左眼顺时针旋转，右眼与左眼相对
    public final static int ST_BEAUTIFY_3D_OPEN_CANTHUS_RATIO = 29;             /// 开眼角比例，[0, 1.0]，默认值为0.0， 0.0不做开眼角
    public final static int ST_BEAUTIFY_3D_PROFILE_RHINOPLASTY_RATIO = 30;      /// 侧脸隆鼻比例，[0, 1.0]，默认值为0.0，0.0不做侧脸隆鼻效果
    public final static int ST_BEAUTIFY_3D_BRIGHT_EYE_RATIO = 31;               /// 亮眼比例，[0, 1.0]，默认值为0.0，0.0不做亮眼
    public final static int ST_BEAUTIFY_3D_REMOVE_DARK_CIRCLES_RATIO = 32;      /// 去黑眼圈比例，[0, 1.0]，默认值为0.0，0.0不做去黑眼圈
    public final static int ST_BEAUTIFY_3D_REMOVE_NASOLABIAL_FOLDS_RATIO = 33;  /// 去法令纹比例，[0, 1.0]，默认值为0.0，0.0不做去法令纹
    public final static int ST_BEAUTIFY_3D_WHITE_TEETH_RATIO = 34;              /// 白牙比例，[0, 1.0]，默认值为0.0，0.0不做白牙
    public final static int ST_BEAUTIFY_3D_APPLE_MUSLE_RATIO = 35;              /// 苹果肌比例，[0, 1.0]，默认值为0.0，0.0不做苹果肌
    public final static int ST_BEAUTIFY_3D_OPEN_EXTERNAL_CANTHUS_RATIO  = 36;             /// 开外眼角比例，[0, 1.0]，默认值为0.0， 0.0不做开外眼角
    public final static int ST_BEAUTIFY_3D_SHRINK_ROUND_FACE_RATIO = 37;        /// 圆脸瘦脸比例， [0, 1.0], 默认值0.0， 0.0不做瘦脸
    public final static int ST_BEAUTIFY_3D_SHRINK_LONG_FACE_RATIO = 38;         /// 长脸瘦脸比例， [0, 1.0], 默认值0.0， 0.0不做瘦脸
    public final static int ST_BEAUTIFY_3D_SHRINK_GODDESS_FACE_RATIO = 39;      /// 女神瘦脸比例， [0, 1.0], 默认值0.0， 0.0不做瘦脸
    public final static int ST_BEAUTIFY_3D_SHRINK_NATURAL_FACE_RATIO = 40;      /// 自然瘦脸比例， [0, 1.0], 默认值0.0， 0.0不做瘦脸

}