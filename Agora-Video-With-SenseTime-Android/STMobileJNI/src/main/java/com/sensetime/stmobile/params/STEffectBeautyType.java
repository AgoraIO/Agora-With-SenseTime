package com.sensetime.stmobile.params;

@SuppressWarnings({"unused", "RedundantSuppression"})
public class STEffectBeautyType {
    // 磨皮1
    public static final int SMOOTH1_MODE = 1;
    public static final int SMOOTH2_MODE = 2;

    // 美白
    public static final int WHITENING1_MODE = 0;
    public static final int WHITENING2_MODE = 1;
    public static final int WHITENING3_MODE = 2;

    // 基础美颜 base
    public static final int EFFECT_BEAUTY_BASE_WHITTEN                      = 101;  // 美白
    public static final int EFFECT_BEAUTY_BASE_REDDEN                       = 102;  // 红润
    public static final int EFFECT_BEAUTY_BASE_FACE_SMOOTH                  = 103;  // 磨皮

    // 美形 reshape
    public static final int EFFECT_BEAUTY_RESHAPE_SHRINK_FACE               = 201;  // 瘦脸
    public static final int EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE               = 202;  // 大眼
    public static final int EFFECT_BEAUTY_RESHAPE_SHRINK_JAW                = 203;  // 小脸
    public static final int EFFECT_BEAUTY_RESHAPE_NARROW_FACE               = 204;  // 窄脸
    public static final int EFFECT_BEAUTY_RESHAPE_ROUND_EYE                 = 205;  // 圆眼

    // 微整形 plastic
    public static final int EFFECT_BEAUTY_PLASTIC_THINNER_HEAD              = 301;  // 小头
    public static final int EFFECT_BEAUTY_PLASTIC_THIN_FACE                 = 302;  // 瘦脸型
    public static final int EFFECT_BEAUTY_PLASTIC_CHIN_LENGTH               = 303;  // 下巴
    public static final int EFFECT_BEAUTY_PLASTIC_HAIRLINE_HEIGHT           = 304;  // 额头
    public static final int EFFECT_BEAUTY_PLASTIC_APPLE_MUSLE               = 305;  // 苹果肌
    public static final int EFFECT_BEAUTY_PLASTIC_NARROW_NOSE               = 306;  // 瘦鼻翼
    public static final int EFFECT_BEAUTY_PLASTIC_NOSE_LENGTH               = 307;  // 长鼻
    public static final int EFFECT_BEAUTY_PLASTIC_PROFILE_RHINOPLASTY       = 308;  // 侧脸隆鼻
    public static final int EFFECT_BEAUTY_PLASTIC_MOUTH_SIZE                = 309;  // 嘴型
    public static final int EFFECT_BEAUTY_PLASTIC_PHILTRUM_LENGTH           = 310;  // 缩人中
    public static final int EFFECT_BEAUTY_PLASTIC_EYE_DISTANCE              = 311;  // 眼距
    public static final int EFFECT_BEAUTY_PLASTIC_EYE_ANGLE                 = 312;  // 眼睛角度
    public static final int EFFECT_BEAUTY_PLASTIC_OPEN_CANTHUS              = 313;  // 开眼角
    public static final int EFFECT_BEAUTY_PLASTIC_BRIGHT_EYE                = 314;  // 亮眼
    public static final int EFFECT_BEAUTY_PLASTIC_REMOVE_DARK_CIRCLES       = 315;  // 祛黑眼圈
    public static final int EFFECT_BEAUTY_PLASTIC_REMOVE_NASOLABIAL_FOLDS   = 316;  // 祛法令纹
    public static final int EFFECT_BEAUTY_PLASTIC_WHITE_TEETH               = 317;  // 白牙
    public static final int EFFECT_BEAUTY_PLASTIC_SHRINK_CHEEKBONE          = 318;  // 瘦颧骨
    public static final int EFFECT_BEAUTY_PLASTIC_OPEN_EXTERNAL_CANTHUS     = 319;  // 开外眼角比例
    public static final int EFFECT_BEAUTY_PLASTIC_SHRINK_JAWBONE            = 320;  ///< 瘦下颔，【0, 1.0], 默认值0.0， 0.0不做瘦下颔
    public static final int EFFECT_BEAUTY_PLASTIC_SHRINK_ROUND_FACE         = 321;  ///< 圆脸瘦脸，【0, 1.0], 默认值0.0， 0.0不做瘦脸
    public static final int EFFECT_BEAUTY_PLASTIC_SHRINK_LONG_FACE          = 322;  ///< 长脸瘦脸，【0, 1.0], 默认值0.0， 0.0不做瘦脸
    public static final int EFFECT_BEAUTY_PLASTIC_SHRINK_GODDESS_FACE       = 323;  ///< 女神瘦脸，【0, 1.0], 默认值0.0， 0.0不做瘦脸
    public static final int EFFECT_BEAUTY_PLASTIC_SHRINK_NATURAL_FACE       = 324;  ///< 自然瘦脸，【0, 1.0], 默认值0.0， 0.0不做瘦脸
    public static final int EFFECT_BEAUTY_PLASTIC_SHRINK_WHOLE_HEAD         = 325;  ///整体缩放小头


    // 调整 tone
    public static final int EFFECT_BEAUTY_TONE_CONTRAST                     = 601;  // 对比度
    public static final int EFFECT_BEAUTY_TONE_SATURATION                   = 602;  // 饱和度
    public static final int EFFECT_BEAUTY_TONE_SHARPEN                      = 603;  // 锐化
    public static final int EFFECT_BEAUTY_TONE_CLEAR                        = 604;  // 清晰度

    // 美妆 makeup
    public static final int EFFECT_BEAUTY_HAIR_DYE                          = 401;  // 染发
    public static final int EFFECT_BEAUTY_MAKEUP_LIP                        = 402;  // 口红
    public static final int EFFECT_BEAUTY_MAKEUP_CHEEK                      = 403;  // 腮红
    public static final int EFFECT_BEAUTY_MAKEUP_NOSE                       = 404;  // 修容
    public static final int EFFECT_BEAUTY_MAKEUP_EYE_BROW                   = 405;  // 眉毛
    public static final int EFFECT_BEAUTY_MAKEUP_EYE_SHADOW                 = 406;  // 眼影
    public static final int EFFECT_BEAUTY_MAKEUP_EYE_LINE                   = 407;  // 眼线
    public static final int EFFECT_BEAUTY_MAKEUP_EYE_LASH                   = 408;  // 眼睫毛
    public static final int EFFECT_BEAUTY_MAKEUP_EYE_BALL                   = 409;  // 美瞳
    public static final int EFFECT_BEAUTY_MAKEUP_ALL                        = 410;  // 整妆

    // 滤镜 filter
    public static final int EFFECT_BEAUTY_FILTER                            = 501;  // 滤镜

    // 试妆 tryon
    public static final int EFFECT_BEAUTY_TRYON_HAIR_COLOR                  = 701;  // 染发
    public static final int EFFECT_BEAUTY_TRYON_LIPSTICK                    = 702;  // 口红

    public static final int EFFECT_BEAUTY_3D_MICRO_PLASTIC                  = 801;  // 3D 微整形

}
