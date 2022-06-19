package com.sensetime.stmobile.model;

public class STEffect3DBeautyPartInfo {

    private byte[] name = new byte[256];
    private int part_id;
    private float strength;
    private float strength_min;
    private float strength_max;

    public byte[] getName() {
        return name;
    }

    public void setName(byte[] name) {
        this.name = name;
    }

    public int getPart_id() {
        return part_id;
    }

    public void setPart_id(int part_id) {
        this.part_id = part_id;
    }

    public float getStrength() {
        return strength;
    }

    public void setStrength(float strength) {
        this.strength = strength;
    }

    public float getStrength_min() {
        return strength_min;
    }

    public void setStrength_min(float strength_min) {
        this.strength_min = strength_min;
    }

    public float getStrength_max() {
        return strength_max;
    }

    public void setStrength_max(float strength_max) {
        this.strength_max = strength_max;
    }

    @Override
    public String toString() {
        return "STEffect3DBeautyPartInfo{" +
                "name=" + new String(name) +
                ", part_id=" + part_id +
                ", strength=" + strength +
                ", strength_min=" + strength_min +
                ", strength_max=" + strength_max +
                '}';
    }
}
