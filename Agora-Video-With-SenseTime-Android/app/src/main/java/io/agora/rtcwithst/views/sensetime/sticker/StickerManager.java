package io.agora.rtcwithst.views.sensetime.sticker;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class StickerManager {
    private static final String GROUP_PATH = "newEngine";

    private static final String[] STICKER_NAMES = {
            "bubbleNew",
            "bunnyNew",
            "catsaiyaren",
            "deformOneNew",
            "fox2",
            "hdj",
            "joker",
            "maozi_uv_01",
            "rabbiteatingNew",
            "rain",
            "senseme",
            "tools-lizi"
    };

    public static List<StickerItem> getStickerList(Context context) {
        List<StickerItem> list = new ArrayList<>();
        for (String name : STICKER_NAMES) {
            String namePath = GROUP_PATH + File.separator + name;
            StickerItem item = new StickerItem(name, namePath + ".zip",
                    getBitmapFromAssets(context, namePath + ".png"));
            list.add(item);
        }

        return list;
    }

    private static Bitmap getBitmapFromAssets(Context context, String path) {
        Bitmap image = null;
        InputStream is = null;
        AssetManager am = context.getResources().getAssets();
        try {
            is = am.open(path);
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
}
