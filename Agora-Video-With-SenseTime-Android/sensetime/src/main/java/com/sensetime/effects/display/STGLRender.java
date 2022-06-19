package com.sensetime.effects.display;

import android.opengl.Matrix;

public class STGLRender {
    private final static String TAG = "STGLRender";
    private float[] oesMVPMatrix = new float[16];

    private OESProgram mOESProgram;

    public STGLRender() {
        mOESProgram = new OESProgram();
    }

    public void adjustOESImageSize(int width, int height, int rotation, boolean flipH, boolean flipV) {
        boolean resize = mOESProgram.resize(width, height);
        if (resize) {
            float[] tmp = new float[16];
            Matrix.setIdentityM(tmp, 0);

            boolean _flipH = flipH;
            boolean _flipV = flipV;
            if(rotation % 180 != 0){
                _flipH = flipV;
                _flipV = flipH;
            }

            if (_flipH) {
                Matrix.rotateM(tmp, 0, tmp, 0, 180, 0, 1f, 0);
            }
            if (_flipV) {
                Matrix.rotateM(tmp, 0, tmp, 0, 180, 1f, 0f, 0);
            }

            float _rotation = rotation;
            if (_rotation != 0) {
                if(_flipH != _flipV){
                    _rotation *= -1;
                }
                Matrix.rotateM(tmp, 0, tmp, 0, _rotation, 0, 0, 1);
            }

            Matrix.setIdentityM(oesMVPMatrix, 0);
            Matrix.multiplyMM(oesMVPMatrix, 0, tmp, 0, oesMVPMatrix, 0);
        }
    }

    public int processOES(int textureId, float[] texMatrix) {
        return mOESProgram.process(textureId, texMatrix, oesMVPMatrix);
    }

    public void destroyPrograms() {
        mOESProgram.destroyProgram();
    }
}
