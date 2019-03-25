//
//  FlashlightButton.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class FlashlightButton: RoundedButton {
    
    override var isHidden: Bool {
        didSet {
            // Never show this button if there is no torch on this device.
            guard let captureDevice = AVCaptureDevice.default(for: .video), captureDevice.hasTorch else {
                if !isHidden {
                    isHidden = true
                }
                return
            }
            
            if isHidden {
                // Toggle the flashlight off when hiding the button.
                toggledOn = false
            }
        }
    }
    
    override var toggledOn: Bool {
        didSet {
            // Update UI
            if toggledOn {
                setTitle("🔦", for: [])
                backgroundColor = .appBlue
            } else {
                setTitle("ⓘ", for: [])
                backgroundColor = .appLightBlue
            }
            
            // Toggle flashlight
            guard let captureDevice = AVCaptureDevice.default(for: .video), captureDevice.hasTorch else {
                if toggledOn {
                    toggledOn = false
                }
                return
            }
            
            do {
                try captureDevice.lockForConfiguration()
                let mode: AVCaptureDevice.TorchMode = toggledOn ? .on : .off
                if captureDevice.isTorchModeSupported(mode) {
                    captureDevice.torchMode = mode
                }
                captureDevice.unlockForConfiguration()
            } catch {
                print("Error while attempting to access flashlight.")
            }
        }
    }
}

