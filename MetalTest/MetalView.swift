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
    var cps: MTLComputePipelineState?
    var compute: Julia?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        device = MTLCreateSystemDefaultDevice()
        render()
    }
    
    func render() {
        commandQueue = device!.makeCommandQueue()!
        compute = Julia(device: device!)
        
        compute!.uniform.a_r = -0.4
        compute!.uniform.a_i = 0.6
        compute!.uniform.diviter = 100
        
        let library = device!.makeDefaultLibrary()!
        let kernel_func = library.makeFunction(name: "kernel_func")!
        cps = try! device!.makeComputePipelineState(function: kernel_func)
        self.framebufferOnly = false
    }
    
    override func draw() {
        super.draw()
        if let drawable = currentDrawable {
            compute!.uniform.a_i += i_delta
            compute!.uniform.a_r += r_delta
            compute!.compute(commandQueue: commandQueue!, pipelineState: cps!, drawable: drawable)
            
        }
    }
    override func mouseDragged(with event: NSEvent) {
        compute!.uniform.scale += Float(event.deltaY / 300.0)
    }
    override func scrollWheel(with event: NSEvent) {
        compute!.uniform.cx += Float(event.scrollingDeltaX / 1000.0)
        compute!.uniform.cy += Float(event.scrollingDeltaY / 1000.0)
    }
    
    var r_delta : Float = 0.0
    var i_delta : Float = 0.0
    
    override func keyDown(with event: NSEvent) {
        switch(event.keyCode) {
        case 0x7B:
            r_delta = -0.0001
        case 0x7C:
            r_delta = 0.0001
        case 0x7D:
            i_delta = -0.0001
        case 0x7E:
            i_delta = 0.0001
        case 0x31:
            compute!.uniform.diviter = Float(Int(compute!.uniform.diviter + 100) % 2000)
        default:
            break
        }
    }
    override func keyUp(with event: NSEvent) {
        switch(event.keyCode) {
        case 0x7B:
            r_delta = 0
        case 0x7C:
            r_delta = 0
        case 0x7D:
            i_delta = 0
        case 0x7E:
            i_delta = 0
        default:
            break
        }
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
}

