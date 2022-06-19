package com.sensetime.stmobile.model;

public class STQuaternion {
    float x;
    float y;
    float z;
    float w;

    public STQuaternion(float x, float y, float z, float w){
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    public STQuaternion(float[] values){
        if(values != null && values.length >= 4){
            this.x = values[0];
            this.y = values[1];
            this.z = values[2];
            this.w = values[3];
        }
    }

    public float getW() {
        return w;
    }

    public float getX() {
        return x;
    }

    public float getY() {
        return y;
    }

    public float getZ() {
        return z;
    }

    @Override
    public String toString() {
        return "STQuaternion{" +
                "x=" + x +
                ", y=" + y +
                ", z=" + z +
                ", w=" + w +
                '}';
    }
}
