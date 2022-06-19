package com.sensetime.stmobile.model;

public class STMobileHeadInfo {
    STMobileHeadResultInfo headResult;
    STFaceMesh headMesh;        ///< 3d mesh信息，包括3d mesh关键点及个数

    public STFaceMesh getHeadMesh() {
        return headMesh;
    }

    public STMobileHeadResultInfo getHeadRect() {
        return headResult;
    }
}
