package com.sensetime.stmobile.model;

public class STAttributeGlassInfo {
    int type;
    int frame;
    int shape;
    int thickness;

    public int getType() {
        return type;
    }

    public int getShape() {
        return shape;
    }

    public int getThickness() {
        return thickness;
    }

    public int getFrame() {
        return frame;
    }

    public void setType(int type) {
        this.type = type;
    }

    public void setThickness(int thickness) {
        this.thickness = thickness;
    }

    public void setShape(int shape) {
        this.shape = shape;
    }

    public void setFrame(int frame) {
        this.frame = frame;
    }
}
