
#include "EffectsColorConversion.h"

#define RINGIZE(x) #x
#define RINGIZE2(x) RINGIZE(x)
#define SHADER_STRING(text) @ RINGIZE2(text)

// Color Conversion Constants (YUV to RGB) including adjustment from 16-235/16-240 (video range)

//BT.601 witch is the standard for SDTV
GLfloat kColorConversion601Default[] = {
    1.164, 1.164, 1.164,
    0.0,   -0.392, 2.017,
    1.596, -0.813, 0.0,
};

//BT.601 full range
GLfloat kColorConversion601FullRangeDefault[]={
    1.0,1.0,1.0,
    0.0,-0.343,1.765,
    1.4,-0.711,0.0,
};

// BT.709, which is the standard for HDTV.
GLfloat kColorConversion709Default[] = {
    1.164,  1.164, 1.164,
    0.0, -0.213, 2.112,
    1.793, -0.533,   0.0,
};

GLfloat *kColorConversion601 = kColorConversion601Default;
GLfloat *kColorConversion601FullRange = kColorConversion601FullRangeDefault;
GLfloat *kColorConversion709 = kColorConversion709Default;

NSString *const KVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;
 }
 );

NSString *const KFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 uniform sampler2D videoFrame;
 void main()
 {
    gl_FragColor = texture2D(videoFrame, textureCoordinate);
 }
 );

NSString *const kYUVVideoRangeConversionForRGFragmentShaderString = SHADER_STRING
(
 verying highp vec2 textureCoordinate;
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;
 
 void main()
 {
    mediump vec3 yuv;
    lowp vec3 rgb;
    yuv.x = texture2D(luminanceTexture, textureCoordinate);
    yuv.yz = texture2D(chrominanceTexture, textureCoordinate);
    rgb = colorConversionMatrix * yuv;
    gl_FragColor = vec4(rgb, 1);
}
 );

NSString *const kYUVFullRangeConversionForLAFragmentShaderString1 = SHADER_STRING
(
 varying highp vec2 textureCoordinate;

 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;

 void main()
 {
     mediump vec3 yuv;
     lowp vec3 rgb;

     yuv.x = texture2D(luminanceTexture, textureCoordinate).r;
     yuv.yz = texture2D(chrominanceTexture, textureCoordinate).ar - vec2(0.5, 0.5);
     rgb = colorConversionMatrix * yuv;

     gl_FragColor = vec4(rgb, 1);
 }

);

NSString *const kYUVFullRangeConversionForLAFragmentShaderString = SHADER_STRING
(

 precision mediump float;
 varying vec2 textureCoordinate;

 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;


 void main()
 {
     float y = texture2D(luminanceTexture, textureCoordinate).r;
     // map to [-0.5, 0.5]
// #ifdef NV21
//     vec2 uv = texture2D(chrominanceTexture, textureCoordinate).xw - 0.5;
// #elif defined(NV12)
     vec2 uv = texture2D(chrominanceTexture, textureCoordinate).wx - 0.5;
// #endif

     float r = y + 1.370705 * uv.x;
     float g = y - 0.698001 * uv.x - 0.337633 * uv.y;
     float b = y + 1.732446 * uv.y;

     gl_FragColor = vec4(r, g, b, 1.0);
 }
 );


NSString *const kYUVVideoRangeConversionForLAFragmentShaderString = SHADER_STRING
(
varying highp vec2 textureCoordinate;
 
 uniform sampler2D luminanceTexture;
 uniform sampler2D chrominanceTexture;
 uniform mediump mat3 colorConversionMatrix;
 
 void main()
 {
     mediump vec3 yuv;
     lowp vec3 rgb;
     
     yuv.x = texture2D(luminanceTexture, textureCoordinate).r - (16.0/255.0);
     yuv.yz = texture2D(chrominanceTexture, textureCoordinate).ra - vec2(0.5, 0.5);
     rgb = colorConversionMatrix * yuv;
     
     gl_FragColor = vec4(rgb, 1);
 }
 );
