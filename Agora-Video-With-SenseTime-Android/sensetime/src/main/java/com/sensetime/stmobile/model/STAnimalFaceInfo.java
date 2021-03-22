package com.sensetime.stmobile.model;

public class STAnimalFaceInfo {
    private STAnimalFace[] animalFaces;
    private int faceCount;

    public STAnimalFaceInfo(STAnimalFace[] animalFaces, int faceCount){
        this.animalFaces = animalFaces;
        this.faceCount = faceCount;
    }

    public STAnimalFace[] getAnimalFaces(){
        return animalFaces;
    }

    public int getFaceCount(){
        return faceCount;
    }
}
