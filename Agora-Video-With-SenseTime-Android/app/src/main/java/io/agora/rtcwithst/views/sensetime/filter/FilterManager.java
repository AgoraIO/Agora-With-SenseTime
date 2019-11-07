package io.agora.rtcwithst.views.sensetime.filter;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.sensetime.effects.utils.FileUtils;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class FilterManager {
    private static final float DEFAULT_FLOAT_STRENGTH = 0.65f;

    private static final String FILTER_PREFIX = "filter_portrait/filter_style_";
    private static final String FILTER_NAME_SUFFIX = ".png";
    private static final String FILTER_MODEL_SUFFIX = ".model";

    private static final String[] FILTER_RES_NAMES = {
            "original", "babypink", "ol"
    };

    private static final String[] FILTER_NAMES = {
            "Original", "BabyPink", "OfficeLady"
    };

    public static List<FilterItem> getFilterList(Context context) {
        List<FilterItem> list = new ArrayList<>();

        FilterItem item = new FilterItem(FILTER_NAMES[0],
                getFilterBitmap(context, FILTER_RES_NAMES[0]),
                null, 0);
        list.add(item);

        int size = FILTER_NAMES.length;
        List<String> modelFilePaths = FileUtils.copyFilterModelFiles(context, "filter_portrait");

        for (int i = 1; i < size; i++) {
            item = new FilterItem(FILTER_NAMES[i],
                    getFilterBitmap(context, FILTER_RES_NAMES[i]),
                    modelFilePaths.get(i - 1), DEFAULT_FLOAT_STRENGTH);
            list.add(item);
        }
        return list;
    }

    private static Bitmap getFilterBitmap(Context context, String name) {
        AssetManager am = context.getResources().getAssets();

        InputStream is = null;
        Bitmap bm = null;
        try {
            is = am.open(FILTER_PREFIX + name + FILTER_NAME_SUFFIX);
            bm = BitmapFactory.decodeStream(is);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return bm;
    }
}
