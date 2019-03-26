//
//  DetectedBoundingBox.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import ARKit

class DetectedBoundingBox: SCNNode {
    
    init(points: [float3], scale: CGFloat, color: UIColor = .appGreen) {
        super.init()
        
        var localMin = float3(repeating: Float.greatestFiniteMagnitude)
        var localMax = float3(repeating: -Float.greatestFiniteMagnitude)
        
        for point in points {
            localMin = min(localMin, point)
            localMax = max(localMax, point)
        }
        
        self.simdPosition += (localMax + localMin) / 2
        let extent = localMax - localMin
        let wireframe = Wireframe(extent: extent, color: color, scale: scale)
        self.addChildNode(wireframe)
        print("X: \(extent.x * 39.3701), Y: \(extent.y * 39.3701), Z: \(extent.z * 39.3701)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
