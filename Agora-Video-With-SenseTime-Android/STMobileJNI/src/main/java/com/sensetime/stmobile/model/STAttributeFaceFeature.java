package com.sensetime.stmobile.model;

public class STAttributeFaceFeature {

    STAttributeEyelidInfo eyelidInfo;
    STAttributeGlassInfo glassInfo;
    STAttributeGirlHairInfo hairGirlInfo;
    STAttributeBoyHairInfo hairBoyInfo;
    STAttributeMustacheInfo mustacheInfo;

    STAttributeGirlEyebrowInfo eyebrowGirlInfo;
    STAttributeBoyEyebrowInfo eyebrowBoyInfo;

    public STAttributeGirlHairInfo getHairGirlInfo() {
        return hairGirlInfo;
    }

    public STAttributeMustacheInfo getMustacheInfo() {
        return mustacheInfo;
    }

    public STAttributeBoyHairInfo getHairBoyInfo() {
        return hairBoyInfo;
    }

    public STAttributeGirlEyebrowInfo getEyebrowGirlInfo() {
        return eyebrowGirlInfo;
    }

    public STAttributeBoyEyebrowInfo getEyebrowBoyInfo() {
        return eyebrowBoyInfo;
    }

    public STAttributeGlassInfo getGlassInfo() {
        return glassInfo;
    }

    public STAttributeEyelidInfo getEyelidInfo() {
        return eyelidInfo;
    }
}
