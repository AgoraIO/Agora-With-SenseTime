package com.sensetime.effects.display;

import android.opengl.GLES11Ext;
import android.opengl.GLES20;

import com.sensetime.effects.glutils.GlUtil;
import com.sensetime.effects.glutils.OpenGLUtils;
import com.sensetime.effects.glutils.TextureRotationUtil;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

public class STGLRender {
    private final static String TAG = "STGLRender";

    /**
     * Receives a texture matrix, thus transforming texture
     * coordinates from OES streaming texture image to
     * texture 2D coordinates.
     * The resulting image is of type texture 2D after being
     * sampled by a texture2D sampler in the fragment shader.
     */
    private static final String CAMERA_INPUT_VERTEX_SHADER =
            "uniform mat4 uTexMatrix;\n" +
            "attribute vec4 position;\n" +
            "attribute vec4 inputTextureCoordinate;\n" +
            "\n" +
            "varying vec2 textureCoordinate;\n" +
            "\n" +
            "void main()\n" +
            "{\n" +
            "	gl_Position = position;\n" +
            "	textureCoordinate = (uTexMatrix * inputTextureCoordinate).xy;\n" +
            "}";

    private static final String CAMERA_INPUT_FRAGMENT_SHADER_OES =
            "#extension GL_OES_EGL_image_external : require\n" +
            "\n" +
            "precision mediump float;\n" +
            "varying vec2 textureCoordinate;\n" +
            "uniform samplerExternalOES inputImageTexture;\n" +
            "\n" +
            "void main()\n" +
            "{\n" +
            "	gl_FragColor = texture2D(inputImageTexture, textureCoordinate);\n" +
            "}";

    private final static String PROGRAM_ID = "program";
    private final static String POSITION_COORDINATE = "position";
    private final static String TEX_COORDINATE_MATRIX = "uTexMatrix";
    private final static String TEXTURE_UNIFORM = "inputImageTexture";
    private final static String TEXTURE_COORDINATE = "inputTextureCoordinate";

    private final FloatBuffer mGLVertexMatrixBuffer;
    private final FloatBuffer mGLTexMatrixBuffer;
    // private final FloatBuffer mGLSaveTextureBuffer;

    private FloatBuffer mTextureBuffer;
    private FloatBuffer mVertexBuffer;

    private RotationProgram mProgram;

    public STGLRender() {
        mGLVertexMatrixBuffer = ByteBuffer.allocateDirect(
                TextureRotationUtil.VERTEX_MATRIX.length * 4)
                .order(ByteOrder.nativeOrder())
                .asFloatBuffer();
        mGLVertexMatrixBuffer.put(TextureRotationUtil.VERTEX_MATRIX).position(0);

        mGLTexMatrixBuffer = ByteBuffer.allocateDirect(
                TextureRotationUtil.TEXTURE_NO_ROTATION.length * 4)
                .order(ByteOrder.nativeOrder())
                .asFloatBuffer();
        mGLTexMatrixBuffer.put(TextureRotationUtil.TEXTURE_NO_ROTATION).position(0);

        mProgram = new RotationProgram(CAMERA_INPUT_VERTEX_SHADER,
                CAMERA_INPUT_FRAGMENT_SHADER_OES);
    }

    private class RotationProgram {
        int program;

        // locations in the shader program
        int vertexCoordLocation;
        int texCoordLocation;
        int texTransformMatrixLocation;
        int texSampleLocation;

        // Frame buffer binds a texture which stores
        // the writing result to the frame buffer.
        int[] framebuffer = new int[1];
        int[] targetTexture = new int[1];
        int width;
        int height;

        RotationProgram(String vertex, String fragment) {
            program = initProgram(vertex, fragment);
        }

        private int initProgram(String vertex, String fragment) {
            int program = OpenGLUtils.loadProgram(vertex, fragment);
            vertexCoordLocation = GLES20.glGetAttribLocation(program, POSITION_COORDINATE);
            texCoordLocation = GLES20.glGetAttribLocation(program, TEXTURE_COORDINATE);
            texTransformMatrixLocation = GLES20.glGetUniformLocation(program, TEX_COORDINATE_MATRIX);
            texSampleLocation = GLES20.glGetUniformLocation(program, TEXTURE_UNIFORM);
            return program;
        }

        void update(int width, int height) {
            GLES20.glGenFramebuffers(1, framebuffer, 0);
            GlUtil.checkGlError("glGenFramebuffers");

            if (this.width != width || this.height != height) {
                this.width = width;
                this.height = height;
                destroyCurrentTexture();
                bindFramebuffer(width, height);
            }
        }

        private void bindFramebuffer(int width, int height) {
            GLES20.glGenTextures(1, targetTexture, 0);
            GlUtil.checkGlError("glGenTextures");

            GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, targetTexture[0]);
            GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, width, height, 0,
                    GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, null);

            GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D,
                    GLES20.GL_TEXTURE_MAG_FILTER, GLES20.GL_LINEAR);
            GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D,
                    GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_LINEAR);
            GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D,
                    GLES20.GL_TEXTURE_WRAP_S, GLES20.GL_CLAMP_TO_EDGE);
            GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D,
                    GLES20.GL_TEXTURE_WRAP_T, GLES20.GL_CLAMP_TO_EDGE);

            GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, framebuffer[0]);
            GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER,
                    GLES20.GL_COLOR_ATTACHMENT0,
                    GLES20.GL_TEXTURE_2D,
                    targetTexture[0], 0);

            GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, 0);
            GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
        }

        int preProcess(int textureId, float[] texMatrix, ByteBuffer buffer) {
            GLES20.glUseProgram(program);
            GlUtil.checkGlError("glUseProgram");

            mGLVertexMatrixBuffer.position(0);
            GLES20.glVertexAttribPointer(vertexCoordLocation, 2, GLES20.GL_FLOAT, false, 0, mGLVertexMatrixBuffer);
            GLES20.glEnableVertexAttribArray(vertexCoordLocation);
            GlUtil.checkGlError("glEnableVertexAttribArray");

            mTextureBuffer.position(0);
            GLES20.glVertexAttribPointer(texCoordLocation, 2, GLES20.GL_FLOAT, false, 0, mTextureBuffer);
            GLES20.glEnableVertexAttribArray(texCoordLocation);
            GlUtil.checkGlError("glEnableVertexAttribArray");

            GLES20.glUniformMatrix4fv(texTransformMatrixLocation, 1, false, texMatrix, 0);
            GlUtil.checkGlError("glUniformMatrix4fv TEX matrix");

            GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
            GLES20.glBindTexture(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, textureId);
            GLES20.glUniform1i(texSampleLocation, 0);

            GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, framebuffer[0]);
            GlUtil.checkGlError("glBindFramebuffer");
            GLES20.glViewport(0, 0, width, height);
            GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, 4);

            if (buffer != null) {
                GLES20.glReadPixels(0, 0, width, height, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, buffer);
            }

            GLES20.glDisableVertexAttribArray(vertexCoordLocation);
            GLES20.glDisableVertexAttribArray(texCoordLocation);
            GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
            GLES20.glBindTexture(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, 0);
            GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
            GLES20.glUseProgram(0);

            return targetTexture[0];
        }

        void destroy() {
            if (program != 0) {
                GLES20.glDeleteProgram(program);
            }

            destroyCurrentTexture();

            if (framebuffer[0] != 0) {
                GLES20.glDeleteFramebuffers(1, framebuffer, 0);
                framebuffer[0] = 0;
            }
        }

        private void destroyCurrentTexture() {
            if (targetTexture[0] != 0) {
                GLES20.glDeleteTextures(1, targetTexture, 0);
                targetTexture[0] = 0;
            }
        }
    }

    public void init(int width, int height) {
        mProgram.update(width, height);
    }

    public int preProcess(int textureId, float[] texMatrix, ByteBuffer buffer) {
        return mProgram.preProcess(textureId, texMatrix, buffer);
    }

    public void calculateVertexBuffer(int displayW, int displayH, int imageW, int imageH) {
        int outputHeight = displayH;
        int outputWidth = displayW;

        float ratio1 = (float) outputWidth / imageW;
        float ratio2 = (float) outputHeight / imageH;
        float ratioMin = Math.min(ratio1, ratio2);
        int imageWidthNew = Math.round(imageW * ratioMin);
        int imageHeightNew = Math.round(imageH * ratioMin);

        float ratioWidth = imageWidthNew / (float) outputWidth;
        float ratioHeight = imageHeightNew / (float) outputHeight;

        float[] cube = new float[]{
                TextureRotationUtil.VERTEX_MATRIX[0] / ratioHeight, TextureRotationUtil.VERTEX_MATRIX[1] / ratioWidth,
                TextureRotationUtil.VERTEX_MATRIX[2] / ratioHeight, TextureRotationUtil.VERTEX_MATRIX[3] / ratioWidth,
                TextureRotationUtil.VERTEX_MATRIX[4] / ratioHeight, TextureRotationUtil.VERTEX_MATRIX[5] / ratioWidth,
                TextureRotationUtil.VERTEX_MATRIX[6] / ratioHeight, TextureRotationUtil.VERTEX_MATRIX[7] / ratioWidth,
        };

        if (mVertexBuffer == null) {
            mVertexBuffer = ByteBuffer.allocateDirect(cube.length * 4)
                    .order(ByteOrder.nativeOrder())
                    .asFloatBuffer();
        }
        mVertexBuffer.clear();
        mVertexBuffer.put(cube).position(0);
    }

    public void adjustTextureBuffer(int orientation, boolean flipHorizontal, boolean flipVertical) {
        float[] textureCords = TextureRotationUtil.TEXTURE_NO_ROTATION;

        if (mTextureBuffer == null) {
            mTextureBuffer = ByteBuffer.
                    allocateDirect(textureCords.length * 4).
                    order(ByteOrder.nativeOrder()).
                    asFloatBuffer();
        }

        mTextureBuffer.clear();
        mTextureBuffer.put(textureCords).position(0);
    }

    public void destroyPrograms() {
        mProgram.destroy();
    }
}