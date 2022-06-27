//
//  EffectsPointsPainter.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/10/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EffectsPointsPainter.h"
#import "STShaderTypes.h"

@import Metal;

@interface EffectsPointsPainter ()

@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;

@end

@implementation EffectsPointsPainter
{
    CVMetalTextureCacheRef _CVMTLTextureCache;
    id<MTLTexture> _metalTexture;

    id<MTLRenderPipelineState> _renderPipelineState;
    vector_uint2 _viewPortSize;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        MTLRenderPipelineDescriptor * renderPipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        id<MTLLibrary> library = [self.device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertexShader"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragmentShader"];
        renderPipelineDescriptor.vertexFunction = vertexFunction;
        renderPipelineDescriptor.fragmentFunction = fragmentFunction;
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        
        _renderPipelineState = [self.device newRenderPipelineStateWithDescriptor:renderPipelineDescriptor error:nil];
    }
    return self;
}

- (void)createMetalTextureWithWidth:(int)width height:(int)height andPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    _viewPortSize.x = width;
    _viewPortSize.y = height;
    
    CVReturn cvret;
    // 1. Create a Metal Core Video texture cache from the pixel buffer.
    cvret = CVMetalTextureCacheCreate(
                                      kCFAllocatorDefault,
                                      nil,
                                      self.device,
                                      nil,
                                      &_CVMTLTextureCache);
    
    NSAssert(cvret == kCVReturnSuccess, @"Failed to create Metal texture cache");
    
    // 2. Create a CoreVideo pixel buffer backed Metal texture image from the texture cache.
    CVMetalTextureRef CVMTLTexture;
    cvret = CVMetalTextureCacheCreateTextureFromImage(
                                                      kCFAllocatorDefault,
                                                      _CVMTLTextureCache,
                                                      pixelBuffer, nil,
                                                      MTLPixelFormatBGRA8Unorm_sRGB,
                                                      width, height,
                                                      0,
                                                      &CVMTLTexture);
    
    NSAssert(cvret == kCVReturnSuccess, @"Failed to create CoreVideo Metal texture from image");
    
    // 3. Get a Metal texture using the CoreVideo Metal texture reference.
    id<MTLTexture> metalTexture = CVMetalTextureGetTexture(CVMTLTexture);
    CFRelease(CVMTLTexture);
    NSAssert(metalTexture, @"Failed to create Metal texture CoreVideo Metal Texture");
    _metalTexture = metalTexture;
}

-(void)renderPointsWithDetectResult:(st_mobile_human_action_t)detectResult {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor * renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    renderPassDescriptor.colorAttachments[0].texture = _metalTexture;
//    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0.0, 0.0, 1.0);
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionLoad;
//    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    id<MTLRenderCommandEncoder> renderCommandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    if (renderPassDescriptor) {
        
        [renderCommandEncoder setViewport:(MTLViewport){ 0, 0,  _viewPortSize.x, _viewPortSize.y, 0, 1 }];
        for (int i = 0; i < detectResult.face_count; i ++) {
            [renderCommandEncoder setVertexBytes:&(detectResult.p_faces[i].face106.points_array) length:sizeof(detectResult.p_faces[i].face106.points_array) atIndex:STVertexInputIndexVertices];
            [renderCommandEncoder setVertexBytes:&_viewPortSize length:sizeof(_viewPortSize) atIndex:STVertexInputIndexViewportSize];
            [renderCommandEncoder setRenderPipelineState:_renderPipelineState];
                        
            [renderCommandEncoder drawPrimitives:MTLPrimitiveTypePoint vertexStart:0 vertexCount:sizeof(detectResult.p_faces[i].face106.points_array) / sizeof(st_pointf_t)];
        }

        for (int i = 0; i < detectResult.foot_count; i ++) {
            int currentPointCount = detectResult.p_feet[i].key_points_count;
            st_pointf_t points_array[currentPointCount];
            for (int j = 0; j < currentPointCount; j ++) {
                points_array[j] = detectResult.p_feet[i].p_key_points[j];
            }
            [renderCommandEncoder setVertexBytes:&(points_array) length:sizeof(points_array) atIndex:STVertexInputIndexVertices];
            [renderCommandEncoder setVertexBytes:&_viewPortSize length:sizeof(_viewPortSize) atIndex:STVertexInputIndexViewportSize];
            [renderCommandEncoder setRenderPipelineState:_renderPipelineState];
            
            [renderCommandEncoder drawPrimitives:MTLPrimitiveTypePoint vertexStart:0 vertexCount:currentPointCount];
        }
        
        [renderCommandEncoder endEncoding];
    }
    [commandBuffer commit];
    [commandBuffer waitUntilScheduled];
}

-(id<MTLDevice>)device {
    if (!_device) {
        _device = MTLCreateSystemDefaultDevice();
    }
    return _device;
}

-(id<MTLCommandQueue>)commandQueue {
    if (!_commandQueue) {
        _commandQueue = [self.device newCommandQueue];
    }
    return _commandQueue;
}

-(void)dealloc {
    if (_CVMTLTextureCache) {
        CVMetalTextureCacheFlush(_CVMTLTextureCache, 0);
    }
}

@end
