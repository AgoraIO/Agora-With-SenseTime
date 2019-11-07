package io.agora.rtcwithst.views.sensetime.makeup;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.sensetime.effects.utils.Constants;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import io.agora.rtcwithst.R;

public class MakeupManager {
    private static final String[] GROUP_NAMES = {
            "口红", "腮红","修容", "眉毛", "眼影", "眼线", "眼睫毛"
    };

    private static final int[] GROUP_RES = {
            R.drawable.makeup_lip,
            R.drawable.makeup_cheeks,
            R.drawable.makeup_face,
            R.drawable.makeup_brow,
            R.drawable.makeup_eye,
            R.drawable.makeup_eyeline,
            R.drawable.makeup_eyelash,
    };

    private static final String[] GROUP_ASSET_INDEX_STRINGS = {
            "makeup_lip",
            "makeup_blush",
            "makeup_highlight",
            "makeup_brow",
            "makeup_eye",
            "makeup_eyeliner",
            "makeup_eyelash"
    };

    public static int getMakeupTypeCount() {
        return GROUP_NAMES.length;
    }

    /**
     * Get the makeup type of STMobileType by index
     * @param index
     * @return
     */
    public static int indexToMakeupType(int index) {
        switch (index) {
            case 0: return Constants.ST_MAKEUP_LIP;
            case 1: return Constants.ST_MAKEUP_BLUSH;
            case 2: return Constants.ST_MAKEUP_HIGHLIGHT;
            case 3: return Constants.ST_MAKEUP_BROW;
            case 4: return Constants.ST_MAKEUP_EYE;
            case 5: return Constants.ST_MAKEUP_EYELINER;
            case 6: return Constants.ST_MAKEUP_EYELASH;
            default: return -1;
        }
    }

    public static String getMakeupGroupName(int index) {
        switch (index) {
            case 0: return Constants.ST_MAKEUP_LIP_NAME;
            case 1: return Constants.ST_MAKEUP_BLUSH_NAME;
            case 2: return Constants.ST_MAKEUP_HIGHLIGHT_NAME;
            case 3: return Constants.ST_MAKEUP_BROW_NAME;
            case 4: return Constants.ST_MAKEUP_EYE_NAME;
            case 5: return Constants.ST_MAKEUP_EYELINER_NAME;
            case 6: return Constants.ST_MAKEUP_EYELASH_NAME;
            default: return null;
        }
    }

    static List<MakeupGroupItem> getMakeupGroupItemList() {
        List<MakeupGroupItem> list = new ArrayList<>();
        int size = GROUP_NAMES.length;
        for (int i = 0; i < size; i++) {
            MakeupGroupItem item = new MakeupGroupItem(
                    GROUP_NAMES[i], GROUP_RES[i]);
            list.add(item);
        }

        return list;
    }

    public static MakeupItemListAdapter getItemListAdapter(Context context, int group,
            MakeupItemListAdapter.OnMakeupItemClickedListener listener) {
        return new MakeupItemListAdapter(context, group, GROUP_NAMES[group],
                GROUP_RES[group], listener);
    }

    public static List<MakeupItem> getMakeupItemList(Context context, int group) {
        ArrayList<MakeupItem> makeupFiles = new ArrayList<MakeupItem>();

        String index = GROUP_ASSET_INDEX_STRINGS[group];
        List<String> makeupZips = getMakeupFilePathFromAssets(context, index);
        List<String> makeupNames = getMakeupNamesFromAssets(context, index);

        for (int i = 0; i < makeupZips.size(); i++) {
            if (makeupNames.get(i) != null) {
                makeupFiles.add(new MakeupItem(makeupNames.get(i),
                        getImageFromAssetsFile(context, index + File.separator + makeupNames.get(i) + ".png"),
                        makeupZips.get(i)));
            }
        }

        return makeupFiles;
    }

    private static List<String> getMakeupFilePathFromAssets(Context context, String className) {
        AssetManager am = context.getAssets();
        String files[] = null;
        ArrayList<String> modelFiles = new ArrayList<String>();

        try {
            files = am.list(className);
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (files == null) {
            return modelFiles;
        }

        for (String name : files) {
            if (name.endsWith(".zip")) {
                modelFiles.add(className + File.separator + name);
            }
        }

        return modelFiles;
    }

    private static List<String> getMakeupNamesFromAssets(Context context, String className) {
        String files[] = null;
        ArrayList<String> modelFiles = new ArrayList<String>();

        try {
            files = context.getAssets().list(className);
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (files != null) {
            for (String name : files) {
                if (name.contains(".zip")) {
                    modelFiles.add(name.substring(0, name.length() - 4));
                }
            }
        }

        return modelFiles;
    }

    private static Bitmap getImageFromAssetsFile(Context context, String fileName) {
        Bitmap image = null;
        InputStream is = null;
        AssetManager am = context.getResources().getAssets();
        try {
            is = am.open(fileName);
            image = BitmapFactory.decodeStream(is);
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

        return image;
    }

    static String getMakeupIndexString(int group) {
        if (group < 0 || group >= GROUP_ASSET_INDEX_STRINGS.length) {
            return "";
        }

        return GROUP_ASSET_INDEX_STRINGS[group];
    }
}
