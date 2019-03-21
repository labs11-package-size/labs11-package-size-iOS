//
//  ARScanViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARScanViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UIDocumentPickerDelegate {
    
    @IBOutlet weak var blurView:UIVisualEffectView!
    func backFromBackground() {}
    func readFile(_ url: URL){}
}
