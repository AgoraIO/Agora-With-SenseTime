package com.sensetime.stmobile.model;

public class STTransform {
    float[] position;
    float[] eulerAngle;    // euler in angle.
    float[] scale;

    public float[] getEulerAngle() {
        return eulerAngle;
    }

    public float[] getPosition() {
        return position;
    }

    public float[] getScale() {
        return scale;
    }
}

