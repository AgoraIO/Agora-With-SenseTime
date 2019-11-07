package io.agora.rtcwithst.views.sensetime.makeup;

import android.graphics.Bitmap;

public class MakeupItem {
    public String name;
    public Bitmap icon;
    public String makeupFile;

    public MakeupItem(String name, Bitmap icon, String makeupFile) {
        this.name = name;
        this.icon = icon;
        this.makeupFile = makeupFile;
    }
}
