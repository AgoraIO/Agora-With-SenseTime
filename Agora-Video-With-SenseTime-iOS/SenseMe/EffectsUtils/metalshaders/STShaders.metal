//
//  STShaders.metal
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/10/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include "STShaderTypes.h"

struct RasterizerData
{
    float4 position [[position]]; // position 关键字
    
    float pointsize [[point_size]]; // point_size 关键字
};

vertex RasterizerData vertexShader(uint vertexID [[vertex_id]], constant st_pointf_tf *vertices [[buffer(STVertexInputIndexVertices)]], constant vector_uint2 *viewportSizePointer [[buffer(STVertexInputIndexViewportSize)]])
{
    RasterizerData out;
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);

    vector_float2 viewportSize = vector_float2(*viewportSizePointer);
    
    float2 pixelSpacePosition = { vertices[vertexID].x - viewportSize.x / 2.0,  -(vertices[vertexID].y - viewportSize.y / 2.0)};

    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);

    out.pointsize = 5.0;
    
    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]])
{
    // Return the interpolated color.
    return { 0.0, 1.0, 0.0, 1.0 };
}

