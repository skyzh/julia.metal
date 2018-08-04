//
//  Shaders.metal
//  MetalTest
//
//  Created by Sky Zhang on 2018/08/04.
//  Copyright © 2018 Sky Zhang. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position;
    float4 color;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

struct Uniforms {
    float4x4 modelMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut vertex_func(
                          constant VertexIn *vertices [[buffer(0)]],
                          constant Uniforms &uniforms [[buffer(1)]],
                          uint vid [[vertex_id]]) {
    float4x4 mv_Matrix = uniforms.modelMatrix;
    float4x4 proj_Matrix = uniforms.projectionMatrix;
    VertexIn VertexIn = vertices[vid];
    VertexOut VertexOut;
    VertexOut.position = proj_Matrix * mv_Matrix * VertexIn.position;
    VertexOut.color = VertexIn.color;
    return VertexOut;
}

fragment float4 fragment_func(VertexOut vert [[stage_in]]) {
    return vert.color;
}
