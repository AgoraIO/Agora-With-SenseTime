package com.sensetime.effects.display;

import android.opengl.GLES11Ext;
import android.opengl.GLES20;
import android.opengl.GLES30;
import android.util.Log;

import com.sensetime.effects.glutils.GlUtil;
import com.sensetime.effects.glutils.OpenGLUtils;
import com.sensetime.effects.glutils.TextureRotationUtil;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.util.ArrayList;
import java.util.HashMap;

public class STGLRender {
    private final static String TAG = "STGLRender";
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

    private static final String YUV_TEXTURE =
            "precision mediump float;                           \n" +
                    "varying vec2 textureCoordinate;                           \n" +
                    "uniform sampler2D y_texture;                       \n" +
                    "uniform sampler2D uv_texture;                      \n" +

                    "void main (void){                                  \n" +
                    "   float y = texture2D(y_texture, textureCoordinate).r;        \n" +

                    //We had put the Y values of each pixel to the R,G,B components by GL_LUMINANCE,
                    //that's why we're pulling it from the R component, we could also use G or B
                    "   vec2 uv = texture2D(uv_texture, textureCoordinate).xw - 0.5;       \n" +

                    //The numbers are just YUV to RGB conversion constants
                    "   float r = y + 1.370705 * uv.x;\n" +
                    "   float g = y - 0.698001 * uv.x - 0.337633 * uv.y;\n" +
                    "   float b = y + 1.732446 * uv.y;\n                          \n" +

                    //We finally set the RGB color of our pixel
                    "   gl_FragColor = vec4(r, g, b, 1.0);              \n" +
                    "}                                                  \n";

    private static final String CAMERA_INPUT_FRAGMENT_SHADER_OES = "" +
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

    public static final String CAMERA_INPUT_FRAGMENT_SHADER = "" +
            "precision mediump float;\n" +
            "varying highp vec2 textureCoordinate;\n" +
            " \n" +
            "uniform sampler2D inputImageTexture;\n" +
            " \n" +
            "void main()\n" +
            "{\n" +
            "     gl_FragColor = texture2D(inputImageTexture, textureCoordinate);\n" +
            "}";

    public static final String DRAW_POINTS_VERTEX_SHADER = "" +
            "attribute vec4 aPosition;\n" +
            "void main() {\n" +
            "  gl_PointSize = 2.0;" +
            "  gl_Position = aPosition;\n" +
            "}";

    public static final String DRAW_POINTS_FRAGMENT_SHADER = "" +
            "precision mediump float;\n" +
            "uniform vec4 uColor;\n" +
            "void main() {\n" +
            "  gl_FragColor = uColor;\n" +
            "}";

    //
    private final static String DRAW_POINTS_PROGRAM = "mPointProgram";
    private final static String DRAW_POINTS_COLOR = "uColor";
    private final static String DRAW_POINTS_POSITION = "aPosition";
    private int mDrawPointsProgram = 0;
    private int mColor = -1;
    private int mPosition = -1;
    private int[] mPointsFrameBuffers;

    private final static String PROGRAM_ID = "program";
    private final static String POSITION_COORDINATE = "position";
    private final static String TEX_COORDINATE_MATRIX = "uTexMatrix";
    private final static String TEXTURE_UNIFORM = "inputImageTexture";
    private final static String TEXTURE_COORDINATE = "inputTextureCoordinate";

    private int YUVToRGBAProgramId = -1;
    private final static String Y_TEXTURE = "y_texture";
    private final static String UV_TEXTURE = "uv_texture";
    private int yTextureLoc = -1;
    private int uvTextureLoc = -1;

    private final FloatBuffer mGLVertexMatrixBuffer;
    private final FloatBuffer mGLTexMatrixBuffer;
    // private final FloatBuffer mGLSaveTextureBuffer;

    private FloatBuffer mTextureBuffer;
    private FloatBuffer mVertexBuffer;

    private boolean mIsInitialized;
    private int glError;

    private ArrayList<HashMap<String, Integer>> mArrayPrograms;

    private int mViewPortWidth;
    private int mViewPortHeight;

    private int[] mFrameBuffers;
    private int[] mFrameBufferTextures;

    private int[] mSavePictureFrameBuffers;
    private int[] mSavePictureFrameBufferTextures;

    private int[] mFrameBuffersResize;
    private int[] mFrameBufferTexturesResize;

    private boolean mNeedResize = false;
    private int mWidthResize = 180;
    private int mHeightResize = 320;


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

        //mGLSaveTextureBuffer = ByteBuffer.allocateDirect(
        //        TextureRotationUtil.TEXTURE_NO_ROTATION.length * 4)
        //        .order(ByteOrder.nativeOrder())
        //        .asFloatBuffer();

        // mGLSaveTextureBuffer.put(TextureRotationUtil.getPhotoRotation(
        //  0, false, true)).position(0);

        mArrayPrograms = new ArrayList<HashMap<String, Integer>>(2) {{
            for (int i = 0; i < 2; ++i) {
                HashMap<String, Integer> hashMap = new HashMap<>();
                hashMap.put(PROGRAM_ID, 0);
                hashMap.put(POSITION_COORDINATE, -1);
                hashMap.put(TEXTURE_UNIFORM, -1);
                hashMap.put(TEXTURE_COORDINATE, -1);
                hashMap.put(TEX_COORDINATE_MATRIX, -1);
                add(hashMap);
            }
        }};
    }

    public void init(int width, int height) {
        initInner(width, height, -1, -1);
    }

    public void init(int width, int height, int widthResize, int heightResize) {
        initInner(width, height, widthResize, heightResize);
    }

    private void initInner(int width, int height, int widthResize, int heightResize) {
        if (mViewPortWidth == width && mViewPortHeight == height) {
            return;
        }

        initProgram(CAMERA_INPUT_FRAGMENT_SHADER_OES, mArrayPrograms.get(0));
        initProgram(CAMERA_INPUT_FRAGMENT_SHADER, mArrayPrograms.get(1));
        initYUVProgram(CAMERA_INPUT_VERTEX_SHADER, YUV_TEXTURE);
        mViewPortWidth = width;
        mViewPortHeight = height;

        mWidthResize = widthResize;
        mHeightResize = heightResize;

        if (mWidthResize > 0 && mHeightResize > 0) {
            mNeedResize = true;
        }

        initFrameBuffers(width, height);
        mIsInitialized = true;
    }

    private void initFrameBuffers(int width, int height) {
        destroyFrameBuffers();
        destroyResizeFrameBuffers();

        if (mFrameBuffers == null) {
            mFrameBuffers = new int[2];
            mFrameBufferTextures = new int[2];

            GLES20.glGenFramebuffers(2, mFrameBuffers, 0);
            GLES20.glGenTextures(2, mFrameBufferTextures, 0);

            bindFrameBuffer(mFrameBufferTextures[0], mFrameBuffers[0], width, height);
            bindFrameBuffer(mFrameBufferTextures[1], mFrameBuffers[1], width, height);
        }

        if (mSavePictureFrameBuffers == null) {
            mSavePictureFrameBuffers = new int[1];
            mSavePictureFrameBufferTextures = new int[1];
            GLES20.glGenFramebuffers(1, mSavePictureFrameBuffers, 0);
            GLES20.glGenTextures(1, mSavePictureFrameBufferTextures, 0);
            bindFrameBuffer(mSavePictureFrameBufferTextures[0], mSavePictureFrameBuffers[0], width, height);
        }

        if (mNeedResize && mFrameBuffersResize == null) {
            mFrameBuffersResize = new int[2];
            mFrameBufferTexturesResize = new int[2];
            GLES20.glGenFramebuffers(2, mFrameBuffersResize, 0);
            GLES20.glGenTextures(2, mFrameBufferTexturesResize, 0);
            bindFrameBuffer(mFrameBufferTexturesResize[0], mFrameBuffersResize[0], mWidthResize, mHeightResize);
            bindFrameBuffer(mFrameBufferTexturesResize[1], mFrameBuffersResize[1], mWidthResize, mHeightResize);
        }
    }

    public void destroyFrameBuffers() {
        if (mFrameBufferTextures != null) {
            GLES20.glDeleteTextures(2, mFrameBufferTextures, 0);
            mFrameBufferTextures = null;
        }

        if (mFrameBuffers != null) {
            GLES20.glDeleteFramebuffers(2, mFrameBuffers, 0);
            mFrameBuffers = null;
        }

        if (mSavePictureFrameBufferTextures != null) {
            GLES20.glDeleteTextures(1, mSavePictureFrameBufferTextures, 0);
            mSavePictureFrameBufferTextures = null;
        }

        if (mSavePictureFrameBuffers != null) {
            GLES20.glDeleteFramebuffers(1, mSavePictureFrameBuffers, 0);
            mSavePictureFrameBuffers = null;
        }

        if (mPointsFrameBuffers != null) {
            GLES20.glDeleteFramebuffers(1, mPointsFrameBuffers, 0);
            mPointsFrameBuffers = null;
        }
    }

    public void destroyResizeFrameBuffers() {
        if (mFrameBufferTexturesResize != null) {
            GLES20.glDeleteTextures(2, mFrameBufferTexturesResize, 0);
            mFrameBufferTexturesResize = null;
        }
        if (mFrameBuffersResize != null) {
            GLES20.glDeleteFramebuffers(2, mFrameBuffersResize, 0);
            mFrameBuffersResize = null;
        }
    }

    private void bindFrameBuffer(int textureId, int frameBuffer, int width, int height) {
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, textureId);
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

        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, frameBuffer);
        GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER, GLES20.GL_COLOR_ATTACHMENT0,
                GLES20.GL_TEXTURE_2D, textureId, 0);

        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, 0);
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
    }

    private void initProgram(String fragment, HashMap<String, Integer> programInfo) {
        int proID = programInfo.get(PROGRAM_ID);
        if (proID == 0) {
            proID = OpenGLUtils.loadProgram(CAMERA_INPUT_VERTEX_SHADER, fragment);
            programInfo.put(PROGRAM_ID, proID);
            programInfo.put(POSITION_COORDINATE, GLES20.glGetAttribLocation(proID, POSITION_COORDINATE));
            programInfo.put(TEXTURE_UNIFORM, GLES20.glGetUniformLocation(proID, TEXTURE_UNIFORM));
            programInfo.put(TEXTURE_COORDINATE, GLES20.glGetAttribLocation(proID, TEXTURE_COORDINATE));
            programInfo.put(TEX_COORDINATE_MATRIX, GLES20.glGetUniformLocation(proID, TEX_COORDINATE_MATRIX));
        }
    }

    private void initYUVProgram(String vertext, String fragment) {
        YUVToRGBAProgramId = OpenGLUtils.loadProgram(vertext, fragment);
        yTextureLoc = GLES20.glGetUniformLocation(YUVToRGBAProgramId, Y_TEXTURE);
        uvTextureLoc = GLES20.glGetUniformLocation(YUVToRGBAProgramId, UV_TEXTURE);
    }

    public void initDrawPoints() {
        mDrawPointsProgram = OpenGLUtils.loadProgram(DRAW_POINTS_VERTEX_SHADER, DRAW_POINTS_FRAGMENT_SHADER);
        mColor = GLES20.glGetAttribLocation(mDrawPointsProgram, DRAW_POINTS_POSITION);
        mPosition = GLES20.glGetUniformLocation(mDrawPointsProgram, DRAW_POINTS_COLOR);

        if (mPointsFrameBuffers == null) {
            mPointsFrameBuffers = new int[1];

            GLES20.glGenFramebuffers(1, mPointsFrameBuffers, 0);
        }
    }

    public int preProcess(int textureId, ByteBuffer buffer, int bufIndex, float[] texMatrix) {
        if (mFrameBuffers == null || !mIsInitialized)
            return OpenGLUtils.NO_TEXTURE;

        int program = mArrayPrograms.get(0).get(PROGRAM_ID);
        Log.i(TAG, "use program: " + program);
        GLES20.glUseProgram(program);
        GlUtil.checkGlError("glUseProgram");

        mGLVertexMatrixBuffer.position(0);
        int glAttribPosition = mArrayPrograms.get(0).get(POSITION_COORDINATE);
        GLES20.glVertexAttribPointer(glAttribPosition, 2, GLES20.GL_FLOAT, false, 0, mGLVertexMatrixBuffer);
        GLES20.glEnableVertexAttribArray(glAttribPosition);

        mTextureBuffer.position(0);
        int glAttribTextureCoordinate = mArrayPrograms.get(0).get(TEXTURE_COORDINATE);
        GLES20.glVertexAttribPointer(glAttribTextureCoordinate, 2, GLES20.GL_FLOAT, false, 0, mTextureBuffer);
        GLES20.glEnableVertexAttribArray(glAttribTextureCoordinate);

        int glUniformTexLocation = mArrayPrograms.get(0).get(TEX_COORDINATE_MATRIX);
        GLES20.glUniformMatrix4fv(glUniformTexLocation, 1, false, texMatrix, 0);
        GlUtil.checkGlError("glUniformMatrix4fv TEX matrix");

        if (textureId != -1) {
            GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
            GLES20.glBindTexture(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, textureId);
            GLES20.glUniform1i(mArrayPrograms.get(0).get(TEXTURE_UNIFORM), 0);
        }

        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, mFrameBuffers[bufIndex]);
        GlUtil.checkGlError("glBindFramebuffer");
        GLES20.glViewport(0, 0, mViewPortWidth, mViewPortHeight);

        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, 4);

        if (buffer != null) {
            if (mNeedResize) {
                GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, mFrameBuffersResize[bufIndex]);
                GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER, GLES20.GL_COLOR_ATTACHMENT0,
                        GLES20.GL_TEXTURE_2D, mFrameBufferTexturesResize[bufIndex], 0);
                GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);

                GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, mFrameBuffers[bufIndex]);
                //GLES30.glReadBuffer(GLES30.GL_COLOR_ATTACHMENT0);
                GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, mFrameBuffersResize[bufIndex]);
                GLES20.glViewport(0, 0, mWidthResize, mHeightResize);
                // GLES30.glBlitFramebuffer(0, 0, mViewPortWidth, mViewPortHeight, 0, 0, mWidthResize, mHeightResize, GLES20.GL_COLOR_BUFFER_BIT, GLES30.GL_NEAREST);
                GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
                GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);

                GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, mFrameBuffersResize[bufIndex]);
                GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, 4);
                GLES20.glReadPixels(0, 0, mWidthResize, mHeightResize, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, buffer);
                GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
            } else {
                GLES20.glReadPixels(0, 0, mViewPortWidth, mViewPortHeight, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, buffer);
            }
        }

        if (mNeedResize) {
            GLES20.glViewport(0, 0, mViewPortWidth, mViewPortHeight);
        }

        GLES20.glDisableVertexAttribArray(glAttribPosition);
        GLES20.glDisableVertexAttribArray(glAttribTextureCoordinate);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, 0);

        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
        GLES20.glUseProgram(0);

        return mNeedResize ? mFrameBufferTexturesResize[bufIndex] : mFrameBufferTextures[bufIndex];
        // return mFrameBufferTextures[bufIndex];
    }

    public int onDrawFrame(final int textureId) {
        if (!mIsInitialized) {
            return OpenGLUtils.NOT_INIT;
        }

        GLES20.glUseProgram(mArrayPrograms.get(1).get(PROGRAM_ID));

        mVertexBuffer.position(0);
        int glAttribPosition = mArrayPrograms.get(1).get(POSITION_COORDINATE);
        GLES20.glVertexAttribPointer(glAttribPosition, 2, GLES20.GL_FLOAT, false, 0, mVertexBuffer);
        GLES20.glEnableVertexAttribArray(glAttribPosition);

        mGLTexMatrixBuffer.position(0);
        int glAttribTextureCoordinate = mArrayPrograms.get(1).get(TEXTURE_COORDINATE);
        GLES20.glVertexAttribPointer(glAttribTextureCoordinate, 2, GLES20.GL_FLOAT, false, 0,
                mGLTexMatrixBuffer);
        GLES20.glEnableVertexAttribArray(glAttribTextureCoordinate);

        if (textureId != OpenGLUtils.NO_TEXTURE) {
            GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
            GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, textureId);
            GLES20.glUniform1i(mArrayPrograms.get(1).get(TEXTURE_UNIFORM), 0);
        }

        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, 4);
        GLES20.glDisableVertexAttribArray(glAttribPosition);
        GLES20.glDisableVertexAttribArray(glAttribTextureCoordinate);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, 0);
        return OpenGLUtils.ON_DRAWN;
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
        // float[] textureCords = TextureRotationUtil.
        //       getRotation(orientation, flipHorizontal, flipVertical);
        // LogUtils.d(TAG, "==========rotation: " + orientation + " flipVertical: " + flipVertical
        //       + " texturePos: " + Arrays.toString(textureCords));

        // Special attention: here we actually do not want SenseTime to
        // handle the rotation of image when rendering effects.
        // So, the texture coordinates should not be rotated or flipped.

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
        Log.i(TAG, "delete Programs");
        for (HashMap<String, Integer> map: mArrayPrograms) {
            if (map != null) {
                GLES20.glDeleteProgram(map.get(PROGRAM_ID));
            }
        }
    }
}