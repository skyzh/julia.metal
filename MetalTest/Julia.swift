//
//  Julia.swift
//  MetalTest
//
//  Created by Sky Zhang on 2018/08/05.
//  Copyright © 2018 Sky Zhang. All rights reserved.
//

import MetalKit

class Julia {
    let threadGroups: MTLSize
    let threadGroupCount: MTLSize
    let N = 1536
    let inTexture: MTLTexture
    let outTexture: MTLTexture
    
    init(device: MTLDevice) {
        let td: MTLTextureDescriptor
        td = MTLTextureDescriptor()
        td.pixelFormat = .bgra8Unorm
        td.width = N
        td.height = N
        inTexture = device.makeTexture(descriptor: td)!
        td.usage = .shaderWrite
        outTexture = device.makeTexture(descriptor: td)!
        threadGroupCount = MTLSizeMake(8, 8, 1)
        threadGroups = MTLSizeMake(N / 8, N / 8, 1)
    }
    
    func compute(commandQueue: MTLCommandQueue, pipelineState: MTLComputePipelineState, drawable: CAMetalDrawable) {
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeComputeCommandEncoder()!
        renderEncoder.setComputePipelineState(pipelineState)
        renderEncoder.setTexture(drawable.texture, index: 0)
        renderEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
