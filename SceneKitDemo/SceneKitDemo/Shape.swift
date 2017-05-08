//
//  Shape.swift
//  SceneKitDemo
//
//  Created by CF on 2017/5/8.
//  Copyright © 2017年 klone. All rights reserved.
//

import Foundation

public enum shape:Int {

    case box = 0
    case sphere
    case pyramid
    case torus
    case capsule
    case cylinder
    case cone
    case tube
    
    static func randomShape() -> shape {
        let max = tube.rawValue
        let random = arc4random_uniform(UInt32(max+1))
        return shape(rawValue: Int(random))!
    }
}
