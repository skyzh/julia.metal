//
//  MetalView.swift
//  MetalTest
//
//  Created by Sky Zhang on 2018/08/04.
//  Copyright © 2018 Sky Zhang. All rights reserved.
//

import MetalKit

class MetalView: MTKView {
    var commandQueue: MTLCommandQueue?
    var rps: MTLRenderPipelineState?
    var cube: Node?
    var projectionMatrix: float4x4?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        device = MTLCreateSystemDefaultDevice()
        
        render()
    }
    
    func render() {
        commandQueue = device!.makeCommandQueue()!
        cube = Cube(device: device!)
        cube!.rotationZ = float4x4.degrees(toRad: 45)
        cube!.scale = 0.5
        cube!.positionY =  0.0
        cube!.positionZ = -2.0
        cube!.positionX = -0.25
        projectionMatrix = float4x4.makePerspectiveViewAngle(float4x4.degrees(toRad: 90),
                                                             aspectRatio: Float(self.drawableSize.width / self.drawableSize.height),
                                                             nearZ: 0.01, farZ: 100.0)
        let library = device!.makeDefaultLibrary()!
        let vertex_func = library.makeFunction(name: "vertex_func")
        let frag_func = library.makeFunction(name: "fragment_func")
        let rpld = MTLRenderPipelineDescriptor()
        rpld.vertexFunction = vertex_func
        rpld.fragmentFunction = frag_func
        rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            try rps = device!.makeRenderPipelineState(descriptor: rpld)
        } catch let error {
            self.printView("\(error)")
        }
        
    }
    
    override func draw() {
        super.draw()
        if let drawable = currentDrawable, let rpd = currentRenderPassDescriptor {
            rpd.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1)
            cube!.rotationZ += float4x4.degrees(toRad: 1)
            cube!.rotationY += float4x4.degrees(toRad: 1)
            cube!.rotationX += float4x4.degrees(toRad: 1)
            cube!.render(commandQueue: commandQueue!, pipelineState: rps!, drawable: drawable, renderPassDescriptor: rpd, projectionMatrix: projectionMatrix!)
        }
    }
}

