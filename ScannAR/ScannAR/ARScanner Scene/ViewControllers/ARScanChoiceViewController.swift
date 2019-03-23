//
//  ARScanChoiceViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ARScanChoiceViewController: UIViewController, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func loadSavedObject(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScannedObjectList") as! ARScanChoiceViewController
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func scanObjectButtonTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ARScanVC") as! ARScanViewController
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func createSession(){
        session = AVCaptureSession()
        device = AVCaptureDevice.default(for: .video)
        
        do {
            input = try AVCaptureDeviceInput(device: device!)
            
            session?.addInput(input!)
        }catch let error as NSError {
            
            print(error.localizedDescription)
            print(error.domain)
            print(error.localizedFailureReason as Any)
            print(error.localizedRecoveryOptions as Any)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        previewLayer?.frame = (delegate?.window?.frame)!
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(previewLayer!)
        session?.startRunning()
    }
}
