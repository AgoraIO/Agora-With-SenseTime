//
//  STShaderTypes.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/10/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#ifndef STShaderTypes_h
#define STShaderTypes_h

#import <simd/simd.h>

typedef enum STVertexInputIndex {
    STVertexInputIndexVertices     = 0,
    STVertexInputIndexViewportSize = 1,
} STVertexInputIndex;


typedef struct st_pointf_tf {
    float x;    ///< 点的水平方向坐标,为浮点数
    float y;    ///< 点的竖直方向坐标,为浮点数
} st_pointf_tf;


#endif /* STShaderTypes_h */
