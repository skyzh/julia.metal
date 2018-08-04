//
//  Vertex.swift
//  MetalTest
//
//  Created by Sky Zhang on 2018/08/04.
//  Copyright © 2018 Sky Zhang. All rights reserved.
//

import Foundation

struct Vertex{
    
    var x,y,z: Float
    var r,g,b,a: Float
    
    func floatBuffer() -> [Float] {
        return [x,y,z,1.0,r,g,b,a]
    }
}
