//
//  EffectsGLPreview.m
//  SenseMeEffects
//
//  Created by Sunshine on 2018/5/21.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import "EffectsGLPreview.h"
#import "EffectsGLShader.h"
#import "EffectsColorConversion.h"

@interface EffectsGLPreview ()
{
    GLint backingWidth, backingHeight;
    GLuint viewRenderbuffer, viewFramebuffer;
    CVOpenGLESTextureCacheRef _glCache;
}
@property (nonatomic, strong) EffectsGLShader *glShader;

@end

@implementation EffectsGLPreview

// Override the class method to return the OpenGL layer, as opposed to the normal CALayer
+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Set scaling to account for Retina display
        if ([self respondsToSelector:@selector(setContentScaleFactor:)])
        {
            self.contentScaleFactor = [[UIScreen mainScreen] scale];
        }
        
        // Do OpenGL Core Animation layer setup
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        if (context) {
            _glContext = context;
        }else{
            _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
            CVOpenGLESTextureCacheCreate(kCFAllocatorDefault,
                                                        NULL,
                                                        self.glContext,
                                                        NULL,
                                                        &_glCache);
        }
        
        if (!_glContext) {
            
            return nil;
        }
        
        if ([EAGLContext currentContext] != _glContext) {
            
            if (![EAGLContext setCurrentContext:_glContext]) {
                
                return nil;
            }
        }
        
        if (![self createFramebuffers]) {
            
            return nil;
        }
    }
    return self;
}

- (void)dealloc
{
    [self destroyFramebuffer];
}

- (BOOL)createFramebuffers
{
    glDisable(GL_DEPTH_TEST);
    
    // Onscreen framebuffer object
    glGenFramebuffers(1, &viewFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
    
    glGenRenderbuffers(1, &viewRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
    
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        
        NSLog(@"EffectsGLPreview : failure with framebuffer generation");
        
        return NO;
    }
    
    return YES;
}

- (void)destroyFramebuffer;
{
    if (viewFramebuffer) {
        
        glDeleteFramebuffers(1, &viewFramebuffer);
        viewFramebuffer = 0;
    }
    
    if (viewRenderbuffer) {
        
        glDeleteRenderbuffers(1, &viewRenderbuffer);
        viewRenderbuffer = 0;
    }
    
    if (_glCache) {
        CFRelease(_glCache);
    }
}

- (BOOL)getTextureWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
                          texture:(GLuint*)texture
                        cvTexture:(CVOpenGLESTextureRef*)cvTexture
                        withCache:(CVOpenGLESTextureCacheRef)cache{
    int width = (int)CVPixelBufferGetWidth(pixelBuffer);
    int height = (int)CVPixelBufferGetHeight(pixelBuffer);
    CVReturn cvRet = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                  cache,
                                                                  pixelBuffer,
                                                                  NULL,
                                                                  GL_TEXTURE_2D,
                                                                  GL_RGBA,
                                                                  width,
                                                                  height,
                                                                  GL_BGRA,
                                                                  GL_UNSIGNED_BYTE,
                                                                  0,
                                                                  cvTexture);
    if (!*cvTexture || kCVReturnSuccess != cvRet) {
        return NO;
    }
    *texture = CVOpenGLESTextureGetName(*cvTexture);
    glBindTexture(GL_TEXTURE_2D , *texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    return YES;
}

- (void)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer
                   rotate:(st_rotate_type)rotate{
    GLuint inputTexture;
    CVOpenGLESTextureRef cvTextrue;
    BOOL ret = [self getTextureWithPixelBuffer:pixelBuffer
                                       texture:&inputTexture
                                     cvTexture:&cvTextrue
                                     withCache:_glCache];
    if (cvTextrue) {
        CFRelease(cvTextrue);
    }
    if (ret) {
        [self renderTexture:inputTexture rotate:rotate];
    }else{
//        NSLog(@"@@@ get texture failure");
    }
}


- (void)renderTexture:(GLuint)texture rotate:(st_rotate_type)rotate
{
    if ([EAGLContext setCurrentContext:self.glContext]) {
        
        [self drawFrameWithTexture:texture rotate:rotate];
    }
}

- (BOOL)drawFrameWithTexture:(GLuint)texture rotate:(st_rotate_type)rotate
{
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    static const GLfloat textureVerticesRotate0[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };
    
    static const GLfloat textureVerticesRotate90[] = {
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f,  1.0f,
        0.0f,  0.0f,
    };
    
    static const GLfloat textureVerticesRotate180[] = {
        1.0f, 0.0f,
        0.0f, 0.0f,
        1.0f,  1.0f,
        0.0f,  1.0f,
    };
    
    static const GLfloat textureVerticesRotate270[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f,  0.0f,
        1.0f,  1.0f,
    };
    
    const GLfloat textureVertices[] = {
        0.0 + self.scale, 1.0 - self.scale,
        1.0 - self.scale, 1.0 - self.scale,
        0.0 + self.scale,  0.0 + self.scale,
        1.0 - self.scale,  0.0 + self.scale,
    };
    
    // Use shader program.
    if (!viewFramebuffer) {
        [self createFramebuffers];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    [self.glShader use];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    [self.glShader setIntWithName:@"videoFrame" value:0];
    GLuint p = glGetAttribLocation(self.glShader.program, "position");
    GLuint v = glGetAttribLocation(self.glShader.program, "inputTextureCoordinate");
    glEnableVertexAttribArray(p);
    glVertexAttribPointer(p, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(v);
    if (rotate == ST_CLOCKWISE_ROTATE_0) {
        glVertexAttribPointer(v, 2, GL_FLOAT, 0, 0, textureVerticesRotate0);
    } else if (rotate == ST_CLOCKWISE_ROTATE_90) {
        glVertexAttribPointer(v, 2, GL_FLOAT, 0, 0, textureVerticesRotate90);
    } else if (rotate == ST_CLOCKWISE_ROTATE_180) {
        glVertexAttribPointer(v, 2, GL_FLOAT, 0, 0, textureVerticesRotate180);
    } else if(rotate == ST_CLOCKWISE_ROTATE_270){
        glVertexAttribPointer(v, 2, GL_FLOAT, 0, 0, textureVerticesRotate270);
    }else{
        glVertexAttribPointer(v, 2, GL_FLOAT, 0, 0, textureVertices);
    }
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    BOOL isSuccess = NO;
    
    if (_glContext) {
        
        glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
        isSuccess = [_glContext presentRenderbuffer:GL_RENDERBUFFER];
    }
    
    return isSuccess;
}

#pragma mark - setter/getter
- (EffectsGLShader *)glShader{
    if (!_glShader) {
        _glShader = [[EffectsGLShader alloc] initWithVertexShader:KVertexShaderString
                                                 fragmentShader:KFragmentShaderString];
    }
    return _glShader;
}

@end
