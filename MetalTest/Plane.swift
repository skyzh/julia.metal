//
//  Plane.swift
//  MetalTest
//
//  Created by Sky Zhang on 2018/08/05.
//  Copyright © 2018 Sky Zhang. All rights reserved.
//

import MetalKit

class Plane: Node {
    init(device: MTLDevice, texture: MTLTexture) {
        let A = Vertex(x: -1.0, y:   1.0, z:   0.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, s:  0.0, t:  0.0)
        let B = Vertex(x: -1.0, y:  -1.0, z:   0.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, s:  0.0, t:  1.0)
        let C = Vertex(x:  1.0, y:  -1.0, z:   0.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, s:  1.0, t:  1.0)
        let D = Vertex(x:  1.0, y:   1.0, z:   0.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0, s:  1.0, t:  0.0)
        
        let verticesArray:Array<Vertex> = [
            A,B,C ,A,C,D
        ]
        
        super.init(name: "plane", vertices: verticesArray, device: device, texture: texture)
    }
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, renderPassDescriptor: MTLRenderPassDescriptor){
        super.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, renderPassDescriptor: renderPassDescriptor, projectionMatrix: float4x4())
    }
    
    override func modelMatrix() -> float4x4 {
        return float4x4()
    }
}
