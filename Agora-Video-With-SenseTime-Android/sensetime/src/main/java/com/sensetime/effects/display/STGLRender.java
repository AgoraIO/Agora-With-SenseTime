package com.sensetime.effects.display;

import java.nio.ByteBuffer;

public class STGLRender {
    private final static String TAG = "STGLRender";

    private PreProcessProgram mProcessProgram;
    private RotateProgram mRotateProgram;

    public STGLRender() {
        mProcessProgram = new PreProcessProgram();
        mRotateProgram = new RotateProgram();
    }

    public void adjustPreProcessImageSize(int width, int height) {
        mProcessProgram.resize(width, height);
    }

    public int preProcess(int textureId, ByteBuffer buffer) {
        return mProcessProgram.preProcess(textureId, buffer);
    }

    public void adjustTextureBuffer(int orientation, boolean flipHorizontal, boolean flipVertical) {
        mProcessProgram.adjustTextureBuffer(orientation, flipHorizontal, flipVertical);
    }

    public void adjustRotateImageSize(int width, int height) {
        mRotateProgram.resize(width, height);
    }

    public int transform(int textureId, float[] texMatrix) {
        return mRotateProgram.rotate(textureId, texMatrix);
    }

    public void destroyPrograms() {
        mProcessProgram.destroyProgram();
        mRotateProgram.destroyProgram();
    }
}