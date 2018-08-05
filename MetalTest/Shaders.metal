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
    float2 texCoord;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float2 texCoord;
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
    VertexOut.texCoord = VertexIn.texCoord;
    return VertexOut;
}

fragment float4 fragment_func(VertexOut interpolated [[stage_in]],
                               texture2d<float>  tex2D     [[ texture(0) ]],
                               sampler           sampler2D [[ sampler(0) ]]) {
    float4 color = tex2D.sample(sampler2D, interpolated.texCoord);
    return color;
}

kernel void kernel_func(texture2d<float, access::write> outTexture [[texture(0)]],
                            uint2 gid [[thread_position_in_grid]]) {
    int width = outTexture.get_width(), height = outTexture.get_height();
    float z_r = float(gid.x) / width * 1.0 - 0.5, z_i = float(gid.y) / height * 1.0 - 0.5;
    float a_r = -0.8, a_i = 0.156;
    int iter = 0;
    for (iter = 0; iter < 1000; iter++) {
        if (z_r * z_r + z_i * z_i > 4.0) break;
        // z * z + k
        float _r = z_r, _i = z_i;
        z_r = _r * _r - _i * _i + a_r;
        z_i = 2 * _r * _i + a_i;
    }
    float _color = (float)iter / 500.0;
    float color = _color >= 1.0 ? 1.0 : _color;
    outTexture.write(float4(color, color, color, 1.0), gid);
}
