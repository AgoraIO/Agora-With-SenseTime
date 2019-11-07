package io.agora.rtcwithst.views.sensetime.beauty;

import com.sensetime.stmobile.model.STBeautyParamsType;

import java.util.ArrayList;
import java.util.List;

import io.agora.rtcwithst.R;

public class BeautyOptionConfig {
    public static final String[] GROUP_NAMES = {
            "基础美颜", "美形", "微整形", "美妆", "滤镜", "调整", "贴纸"
    };

    private static final int[] GROUP_ITEM_COUNT = {
            4, 4, 15, 7, 3, 2
    };

    private static final String[][] GROUP_ITEM_NAMES = {
            { "美白", "红润", "磨皮", "去高光" },
            { "瘦脸", "大眼", "小脸", "窄脸" },
            { "瘦脸型", "下巴", "额头", "苹果肌", "瘦鼻翼", "长鼻",
                    "侧脸隆鼻", "嘴型", "缩人中", "眼距", "眼镜角度",
                    "开眼角", "亮眼", "去黑眼圈", "去法令纹", "白牙"
            },
            {},
            {},
            { "对比度", "饱和度" }
    };

    private static final int[][] GROUP_ITEM_PARAM_ID = {
            {
                    STBeautyParamsType.ST_BEAUTIFY_WHITEN_STRENGTH,
                    STBeautyParamsType.ST_BEAUTIFY_REDDEN_STRENGTH,
                    STBeautyParamsType.ST_BEAUTIFY_SMOOTH_STRENGTH,
                    STBeautyParamsType.ST_BEAUTIFY_DEHIGHLIGHT_STRENGTH,
            },

            {
                    STBeautyParamsType.ST_BEAUTIFY_SHRINK_FACE_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_ENLARGE_EYE_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_SHRINK_JAW_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_NARROW_FACE_STRENGTH
            },

            {
                    STBeautyParamsType.ST_BEAUTIFY_3D_THIN_FACE_SHAPE_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_CHIN_LENGTH_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_HAIRLINE_HEIGHT_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_APPLE_MUSLE_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_NARROW_NOSE_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_NOSE_LENGTH_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_PROFILE_RHINOPLASTY_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_MOUTH_SIZE_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_PHILTRUM_LENGTH_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_EYE_DISTANCE_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_EYE_ANGLE_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_OPEN_CANTHUS_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_BRIGHT_EYE_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_REMOVE_DARK_CIRCLES_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_REMOVE_NASOLABIAL_FOLDS_RATIO,
                    STBeautyParamsType.ST_BEAUTIFY_3D_WHITE_TEETH_RATIO
            },

            // Makeup
            { },

            // Filters
            { },

            {
                    STBeautyParamsType.ST_BEAUTIFY_CONSTRACT_STRENGTH,
                    STBeautyParamsType.ST_BEAUTIFY_SATURATION_STRENGTH
            }
    };

    public static final int[][] BEAUTY_OPTION_ICON = {
            {
                    R.drawable.beauty_whiten,
                    R.drawable.beauty_redden,
                    R.drawable.beauty_smooth,
                    R.drawable.beauty_dehighlight
            },

            {
                    R.drawable.beauty_shrink_face,
                    R.drawable.beauty_enlargeeye,
                    R.drawable.beauty_small_face,
                    R.drawable.beauty_narrow_face,
            },

            {
                    R.drawable.beauty_thin_face,
                    R.drawable.beauty_chin,
                    R.drawable.beauty_forehead,
                    R.drawable.beauty_apple_musle,
                    R.drawable.beauty_thin_nose,
                    R.drawable.beauty_long_nose,
                    R.drawable.beauty_profile_rhinoplasty,
                    R.drawable.beauty_mouth_type,
                    R.drawable.beauty_philtrum,
                    R.drawable.beauty_eye_distance,
                    R.drawable.beauty_eye_angle,
                    R.drawable.beauty_open_canthus,
                    R.drawable.beauty_bright_eye,
                    R.drawable.beauty_remove_dark_circles,
                    R.drawable.beauty_remove_nasolabial_folds,
                    R.drawable.beauty_white_teeth
            },

            {},
            {},

            {
                    R.drawable.beauty_contrast,
                    R.drawable.beauty_saturation

            }
    };

    public static final int GROUP_COUNT = GROUP_NAMES.length;

    /**
     *
     * @param group group id
     * @param index index in the group
     * @return true if this STBeautyParamType has
     *    negative values (range [-1, 1]), false if the param
     *    only range from 0 to 1.
     */
    public boolean hasNegativeBeautyValue(int group, int index) {
        int paramType = toBeautyParamType(group, index);
        if (paramType < 0) {
            return false;
        }

        return STBeautyParamsType.ST_BEAUTIFY_3D_NOSE_LENGTH_RATIO <= paramType &&
                paramType <= STBeautyParamsType.ST_BEAUTIFY_3D_EYE_ANGLE_RATIO &&
                paramType != STBeautyParamsType.ST_BEAUTIFY_3D_THIN_FACE_SHAPE_RATIO;
    }

    /**
     * Obtain the value of STBeautyParamsType from the group id
     * and the index in the group. Group id and indices of the options
     * start from 0.
     * @param group group id
     * @param index index of the option in the group
     * @return the value from STBeautyParamsType starting from 1.
     */
    public int toBeautyParamType(int group, int index) {
        if (group < 0 || group >= GROUP_COUNT ||
                group == 3 || group == 4) {
            // group 3 and 4 belong to makeup
            // and filter, respectively.
            return -1;
        }

        return GROUP_ITEM_PARAM_ID[group][index];
    }

    public List<BeautyOptionItem> getBeautyOptionListByGroup(int group) {
        List<BeautyOptionItem> list = new ArrayList<>();
        if (group < 0 || group >= GROUP_COUNT ||
            group == 3 || group == 4) {
            return list;
        }

        int size = GROUP_ITEM_COUNT[group];
        for (int i = 0; i < size; i++) {
            BeautyOptionItem item = new BeautyOptionItem(
                    GROUP_ITEM_NAMES[group][i],
                    BEAUTY_OPTION_ICON[group][i]);
            list.add(item);
        }

        return list;
    }

    public int valueToProgress(float value) {
        return (int) (value * 100);
    }

    public float progressToValue(int progress) {
        return progress / 100f;
    }
}
