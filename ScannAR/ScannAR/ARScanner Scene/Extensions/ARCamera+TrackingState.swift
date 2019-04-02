//
//  ARCamera+TrackingState.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import ARKit

extension ARCamera.TrackingState {
    var presentationString: String {
        switch self {
        case .notAvailable:
            return "ScannAR tracking UNAVAILABLE"
        case .normal:
            return "ScannAR tracking NORMAL"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                return "ScannAR tracking LIMITED: Excessive motion"
            case .insufficientFeatures:
                return "ScannAR tracking LIMITED: Low detail"
            case .initializing:
                return "ScannAR is initializing"
            case .relocalizing:
                return "ScannAR is relocalizing"
            }
        }
    }
    
    var recommendation: String? {
        switch self {
        case .limited(.excessiveMotion):
            return "Try slowing down your movement, or reset the session."
        case .limited(.insufficientFeatures):
            return "Try pointing at a flat surface, or reset the session."
        case .limited(.initializing):
            return "Try moving left or right, or reset the session."
        case .limited(.relocalizing):
            return "Try returning to the location where you left off."
        default:
            return nil
        }
    }
}
