//
//  PointCloud+CreateVisualization.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import SceneKit

protocol PointCloud {
    func createVisualization(for points: [float3], color: UIColor, size: CGFloat) -> SCNGeometry?
}

extension PointCloud {
    
}
