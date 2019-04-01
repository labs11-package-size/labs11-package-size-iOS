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
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func scanObjectButtonTapped(_ sender: UIButton) {
        print("scan object button tapped")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ARScanVC") as! ARScanViewController
        let transition: CATransition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
        self.navigationController?.pushViewController(vc, animated: false)
        
        //        showActionSheetForScanObjectAndImage()
    }
    //    func showActionSheetForScanObjectAndImage() {
    ////        let actionSheetController = UIAlertController(title: "Please select option ", message: "", preferredStyle: .alert)
    ////
    ////        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
    ////            print("Cancel")
    ////        }
    ////        actionSheetController.addAction(cancelActionButton)
    ////
    ////        let saveActionButton = UIAlertAction(title: "Scan Photos", style: .default) { _ in
    ////            print("Scan Photos")
    ////            self.openCamera()
    ////        }
    ////        actionSheetController.addAction(saveActionButton)
    ////
    ////        let deleteActionButton = UIAlertAction(title: "Scan Objects", style: .default) { _ in
    ////            print("Scan Objects")
    ////            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ARScanVC")
    ////            DispatchQueue.main.async {
    ////                self.navigationController?.pushViewController(vc!, animated: true)
    ////            }
    ////
    ////        }
    ////        actionSheetController.addAction(deleteActionButton)
    ////
    ////        self.present(actionSheetController, animated: true, completion: nil)
    //    }
    //    func openCamera()  {
    ////        imagePicker =  UIImagePickerController()
    ////        imagePicker.delegate = self
    ////        imagePicker.sourceType = .camera
    ////        present(imagePicker, animated: true, completion: nil)
    //    }
    //    //MARK: - Add image to Library
    //    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    ////        if let error = error {
    ////            // we got back an error!
    ////            let alertController = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
    ////            alertController.addAction(UIAlertAction(title: "OK", style: .default))
    ////            present(alertController, animated: true)
    ////        } else {
    ////            let alertController = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
    ////            alertController.addAction(UIAlertAction(title: "OK", style: .default))
    ////            present(alertController, animated: true)
    ////        }
    //    }
    //
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    ////        imagePicker.dismiss(animated: true, completion: nil)
    ////        let alert = UIAlertController(title: "Do you want to save image", message: "", preferredStyle: UIAlertController.Style.alert)
    ////        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
    ////            let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    ////            self.SaveImageToLocal(image:img)
    ////        }))
    ////        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
    ////
    ////        }))
    ////        if let popoverController = alert.popoverPresentationController {
    ////            popoverController.sourceView = self.view
    ////            popoverController.sourceRect = self.view.bounds
    ////        }
    ////        self.present(alert, animated: true, completion: nil)
    //    }
    //    func SaveImageToLocal(image:UIImage){
    ////        do {
    ////            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
    ////
    ////            let alert = UIAlertController(title: "Enter Photo Name", message: "", preferredStyle: .alert)
    ////            alert.addTextField { (textField) in
    ////                textField.placeholder = "Please Enter Photo Name"
    ////            }
    ////            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
    ////                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
    ////                print("Text field: \((textField?.text)!)")
    ////                let documentURL = documentDirectory.appendingPathComponent((textField?.text)! + ".\(SavedARScansListViewController.kPng)")
    ////                DispatchQueue.global().async {
    ////                    if !FileManager.default.fileExists(atPath: documentURL.path) {
    ////                        do {
    ////                            try image.pngData()!.write(to: documentURL)
    ////                            self.OkAlertwithMessage(message: "Image Added Successfully")
    ////                        } catch {
    ////                            print(error)
    ////                        }
    ////                    } else {
    ////                        print("Image Not Added")
    ////                    }
    ////
    ////                }
    ////            }))
    ////            DispatchQueue.main.async {
    ////                self.present(alert, animated: true, completion: nil)
    ////            }
    ////
    ////        } catch {
    ////            print(error)
    ////        }
    //    }
    //    func OkAlertwithMessage(message:String) {
    ////        let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
    ////        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
    ////
    ////        })
    ////        alertView.addAction(action)
    ////        self.present(alertView, animated: true, completion: nil)
    //    }
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
