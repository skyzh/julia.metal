//
//  Node.swift
//  MetalTest
//
//  Created by Sky Zhang on 2018/08/04.
//  Copyright © 2018 Sky Zhang. All rights reserved.
//

import Cocoa
import MetalKit
import simd

class Node {
    let device: MTLDevice
    let name: String
    let vertexCount: Int
    let vertexBuffer: MTLBuffer
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0
    
    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var scale: Float     = 1.0
    
    init(name: String, vertices: Array<Vertex>, device: MTLDevice) {
        self.name = name
        self.device = device
        
        var vertexData = Array<Float>()
        for vertex in vertices {
            vertexData += vertex.floatBuffer()
        }
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        self.vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize)!
        self.vertexCount = vertices.count
    }
    
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, renderPassDescriptor: MTLRenderPassDescriptor, projectionMatrix: float4x4){
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setCullMode(MTLCullMode.front)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        var nodeModelMatrix = self.modelMatrix()
        var projectionMatrix = projectionMatrix
        let uniformBuffer = device.makeBuffer(length: MemoryLayout<Float>.size * float4x4.numberOfElements() * 2)!
        let bufferPointer = uniformBuffer.contents()
        memcpy(bufferPointer, &nodeModelMatrix, MemoryLayout<Float>.size * float4x4.numberOfElements())
        memcpy(bufferPointer + MemoryLayout<Float>.size * float4x4.numberOfElements(), &projectionMatrix, MemoryLayout<Float>.size * float4x4.numberOfElements())
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount,
                                     instanceCount: vertexCount/3)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func modelMatrix() -> float4x4 {
        var matrix = float4x4()
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        return matrix
    }
}
