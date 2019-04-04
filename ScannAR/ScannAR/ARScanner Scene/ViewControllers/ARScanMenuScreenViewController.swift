//
//  ARScanMenuScreenViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import AVFoundation

class ARScanMenuScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var tutorialButtonImage = UIImage(named: "ET")
    @IBOutlet weak var scannARTutorialButton: DesignableButton!
    @IBOutlet weak var detectObjectButton: DesignableButton!
    @IBOutlet weak var scanObjectButton: DesignableButton!
    
    
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
        self.navigationController?.isNavigationBarHidden = true
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scannARTutorialButton.leftImage(image: (tutorialButtonImage?.imageRotatedByDegrees(degrees: 0, flip: true))!)
        detectObjectButton.leftImage(image: UIImage(named: "DNO")!)
        scanObjectButton.leftImage(image: UIImage(named: "SCN")!)
    }
    
    @IBAction func loadSavedObject(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScannedObjectList")  as! SavedARScansListViewController
        let transition: CATransition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let transition: CATransition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: nil)
  
    }
    
    @IBAction func scanObjectButtonTapped(_ sender: UIButton) {
        //print("scan object button tapped")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ARScanVC") as! ARScanViewController
        let transition: CATransition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        DispatchQueue.main.async {
            self.navigationController!.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(vc, animated: false)
        }
       
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
    }
}
