//
//  ARScanMenuScreenViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ARScanMenuScreenViewController: UIViewController, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createSession()
        // Do any additional setup after loading the view.
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScannedObjectList")  as! SavedARScansListViewController
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func scanObjectButtonTapped(_ sender: UIButton) {
        print("scan object button tapped")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ARScanVC")
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
       
    }
   
    func createSession() {
        session = AVCaptureSession()
        device = AVCaptureDevice.default(for: .video)
        
        var error: NSError?
        do {
            input = try AVCaptureDeviceInput(device: device!)
        } catch  {
            print(error)
        }
        
        if error == nil {
            session?.addInput(input!)
        } else {
            print("camera input error: \(String(describing: error))")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        previewLayer?.frame = (delegate?.window?.frame)!
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(previewLayer!)
        session?.startRunning()
    }}
