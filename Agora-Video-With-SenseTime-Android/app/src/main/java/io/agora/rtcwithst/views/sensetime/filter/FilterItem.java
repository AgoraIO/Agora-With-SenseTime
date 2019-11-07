package io.agora.rtcwithst.views.sensetime.filter;

import android.graphics.Bitmap;

public class FilterItem {
    public String name;
    public Bitmap icon;
    public String model;
    public float strength;

    public FilterItem(String name, Bitmap icon, String model, float strength) {
        this.name = name;
        this.icon = icon;
        this.model = model;
        this.strength = strength;
    }
}
