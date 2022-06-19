package com.sensetime.stmobile.model;

public class STBoneTransform {
    byte[] bone_name;
    STTransform transform;

    public STTransform getTransform() {
        return transform;
    }

    public byte[] getBone_name() {
        return bone_name;
    }
}

