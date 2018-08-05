//
//  Triangle.swift
//  MetalTest
//
//  Created by Sky Zhang on 2018/08/04.
//  Copyright © 2018 Sky Zhang. All rights reserved.
//

import Cocoa

class Triangle: Node {
    init(device: MTLDevice) {
        super.init(name: "Triangle",
                   vertices: [
                        Vertex(x: 0.0, y: 1.0, z: 0.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0, s:  0.0, t:  0.0),
                        Vertex(x: -1.0, y: -1.0, z: 0.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0, s:  0.0, t:  0.0),
                        Vertex(x: 1.0, y: -1.0, z: 0.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0, s:  0.0, t:  0.0)],
                   device: device, texture: nil)
    }
}
