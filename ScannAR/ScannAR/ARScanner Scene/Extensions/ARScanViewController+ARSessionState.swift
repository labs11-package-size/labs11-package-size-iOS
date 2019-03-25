//
//  ARScanViewController+ARSessionState.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

extension ARScanViewController {
    
    enum State {
        case startARSession
        case notReady
        case scanning
        case testing
    }
    
    /// - Tag: ARObjectScanningConfiguration
    // The current state the application is in
    var state: State {
        get {
            return self.internalState
        }
        set {
            // 1. Check that preconditions for the state change are met.
            var newState = newValue
            switch newValue {
            case .startARSession:
                break
            case .notReady:
                // Immediately switch to .ready if tracking state is normal.
                if let camera = self.sceneView.session.currentFrame?.camera {
                    switch camera.trackingState {
                    case .normal:
                        newState = .scanning
                    default:
                        break
                    }
                } else {
                    newState = .startARSession
                }
            case .scanning:
                // Immediately switch to .notReady if tracking state is not normal.
                if let camera = self.sceneView.session.currentFrame?.camera {
                    switch camera.trackingState {
                    case .normal:
                        break
                    default:
                        newState = .notReady
                    }
                } else {
                    newState = .startARSession
                }
            case .testing:
                guard scan?.boundingBoxExists == true || referenceObjectToTest != nil else {
                    print("Error: Scan is not ready to be tested.")
                    return
                }
            }
            
            // 2. Apply changes as needed per state.
            internalState = newState
            
            switch newState {
            case .startARSession:
                print("State: Starting ARSession")
                scan = nil
                testRun = nil
                modelURL = nil
                self.setNavigationBarTitle("")
                instructionsVisible = false
                showBackButton(false)
                nextButton.isEnabled = false
                flashlightButton.isHidden = true
                
                // Make sure the SCNScene is cleared of any SCNNodes from previous scans.
                sceneView.scene = SCNScene()
                
                let configuration = ARObjectScanningConfiguration()
                configuration.planeDetection = .horizontal
                sceneView.session.run(configuration, options: .resetTracking)
                cancelMaxScanTimeTimer()
                cancelMessageExpirationTimer()
            case .notReady:
                print("State: Not ready to scan")
                scan = nil
                testRun = nil
                self.setNavigationBarTitle("")
                flashlightButton.isHidden = true
                showBackButton(false)
                nextButton.isEnabled = false
                nextButton.setTitle("Next", for: [])
                displayInstruction(Message("Please wait for stable tracking"))
                cancelMaxScanTimeTimer()
            case .scanning:
                print("State: Scanning")
                if scan == nil {
                    self.scan = ARScan(sceneView)
                    self.scan?.state = .ready
                }
                testRun = nil
                
                startMaxScanTimeTimer()
            case .testing:
                print("State: Testing")
                self.setNavigationBarTitle("Test")
                flashlightButton.isHidden = false
                nextButton.isEnabled = true
                nextButton.setTitle("Save", for: [])
                
                testRun = ARObjectDetectTestController(sceneView: sceneView)
                testObjectDetection()
                cancelMaxScanTimeTimer()
            }
            
            NotificationCenter.default.post(name: ARScanViewController.appStateChangedNotification,
                                            object: self,
                                            userInfo: [ARScanViewController.appStateUserInfoKey: self.state])
        }
    }
    
    @objc
    func scanningStateChanged(_ notification: Notification) {
        guard self.state == .scanning, let scan = notification.object as? ARScan, scan === self.scan else { return }
        guard let scanState = notification.userInfo?[ARScan.stateUserInfoKey] as? ARScan.State else { return }
        
        DispatchQueue.main.async {
            switch scanState {
            case .ready:
                print("State: Ready to scan")
                self.setNavigationBarTitle("Ready to scan")
                self.showBackButton(false)
                self.nextButton.setTitle("Next", for: [])
                self.flashlightButton.isHidden = true
                if scan.ghostBoundingBoxExists {
                    self.displayInstruction(Message("Tap 'Next' to create an approximate bounding box around the product or object you want to scan. Try to conform the bounding box as closely as possible to the object."))
                    self.nextButton.isEnabled = true
                } else {
                    self.displayInstruction(Message("Point at a nearby object to scan."))
                    self.nextButton.isEnabled = false
                }
            case .defineBoundingBox:
                print("State: Define bounding box")
                self.displayInstruction(Message("Position and resize bounding box using gestures.\n" +
                    "Long press the desired side to push/pull them in or out. "))
                self.setNavigationBarTitle("Define bounding box")
                self.showBackButton(true)
                self.nextButton.isEnabled = scan.boundingBoxExists
                self.flashlightButton.isHidden = true
                self.nextButton.setTitle("Scan", for: [])
            case .scanning:
                self.displayInstruction(Message("Scan the object from all sides that you are " +
                    "except the bottom. Move 360 degrees around the object to accomplish this. Do not move the object itself while scanning!"))
                if let boundingBox = scan.scannedObject.boundingBox {
                    self.setNavigationBarTitle("Scan (\(boundingBox.progressPercentage)%)")
                } else {
                    self.setNavigationBarTitle("Scan 0%")
                }
                self.showBackButton(true)
                self.nextButton.isEnabled = true
                self.flashlightButton.isHidden = false
                self.nextButton.setTitle("Finish", for: [])
                // Disable plane detection (even if no plane has been found yet at this time) for performance reasons.
                self.sceneView.stopPlaneDetection()
            case .adjustingOrigin:
                print("State: Adjusting Origin")
                self.displayInstruction(Message("Adjust origin using gestures.\n"))
                self.setNavigationBarTitle("Adjust origin")
                self.showBackButton(true)
                self.nextButton.isEnabled = true
                self.flashlightButton.isHidden = false
                self.nextButton.setTitle("Test", for: [])
            }
        }
    }
    
    func switchToPreviousState() {
        switch state {
        case .startARSession:
            break
        case .notReady:
            state = .startARSession
        case .scanning:
            if let scan = scan {
                switch scan.state {
                case .ready:
                    restartButtonTapped(self)
                case .defineBoundingBox:
                    scan.state = .ready
                case .scanning:
                    scan.state = .defineBoundingBox
                case .adjustingOrigin:
                    scan.state = .scanning
                }
            }
        case .testing:
            state = .scanning
            scan?.state = .adjustingOrigin
        }
    }
    
    func switchToNextState() {
        switch state {
        case .startARSession:
            state = .notReady
        case .notReady:
            state = .scanning
        case .scanning:
            if let scan = scan {
                switch scan.state {
                case .ready:
                    scan.state = .defineBoundingBox
                case .defineBoundingBox:
                    scan.state = .scanning
                case .scanning:
                    scan.state = .adjustingOrigin
                case .adjustingOrigin:
                    state = .testing
                }
            }
        case .testing:
            // Testing is the last state, show the share sheet at the end.
            createAndShareReferenceObject()
        }
    }
    
    @objc
    func ghostBoundingBoxWasCreated(_ notification: Notification) {
        if let scan = scan, scan.state == .ready {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = true
                self.displayInstruction(Message("Tap 'Next' to create an approximate bounding box around the product or object you want to scan. Try to conform the bounding box as closely as possible to the object."))
            }
        }
    }
    
    @objc
    func ghostBoundingBoxWasRemoved(_ notification: Notification) {
        if let scan = scan, scan.state == .ready {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = false
                self.displayInstruction(Message("Point camera at your product or object to scan."))
            }
        }
    }
    
    @objc
    func boundingBoxWasCreated(_ notification: Notification) {
        if let scan = scan, scan.state == .defineBoundingBox {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = true
            }
        }
    }
}
