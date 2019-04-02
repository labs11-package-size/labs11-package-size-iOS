//
//  ARDetectViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARDetectViewController: UIViewController, ARSCNViewDelegate, ARSKViewDelegate {
    
    
    var viewObj = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 89))
    var objectURL:URL?
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // FIXME: - Let's blur this for consistency
        self.navigationController?.presentTransparentNavigationBar()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonItemTapped(_:))), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSceneView()
        viewObj.backgroundColor = UIColor.clear
        let blankImage = UIImage()
        let imageView = UIImageView(image: blankImage)
        viewObj = imageView
        viewObj.contentMode = .scaleAspectFit
    }
    
    func setUpSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = false
        do {
            let configuration = ARWorldTrackingConfiguration()
            if objectURL != nil {
                configuration.detectionObjects = Set([try ARReferenceObject(archiveURL: objectURL!)])
            }
            sceneView.session.run(configuration)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBOutlet weak var flashlightButton: RoundedButton!
    
    @IBAction func flashlightButtonToggled(_ sender: Any) {
        print("flashlight BUtton Tapped")
        // Toggle flashlight
        flashlightButton.isSelected = !flashlightButton.isSelected
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        if flashlightButton.isSelected {
            print("I am selected.")
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.torchMode = .on
                captureDevice.unlockForConfiguration()
            } catch {
                print("Error while attempting to access flashlight.")
            }
        } else {
            print("I am not selected.")
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.torchMode = .off
                captureDevice.unlockForConfiguration()
            } catch {
                print("Error while attempting to access flashlight.")
            }
        }
        
    }
    
    
    @IBAction func cancelBarButtonItemTapped(_ sender: Any){
        
        let transition: CATransition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: false)
        }
        
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let alertController = UIAlertController(title: "Found Object", message: "This is your object.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        let shipScene = SCNScene(named: "art.scnassets/ArrowB.scn")!
        let planeNode = shipScene.rootNode.childNodes.first!
        planeNode.position =  SCNVector3.positionFromTransform(anchor.transform)
        planeNode.position.y = 0.25
        print(planeNode.position)
        planeNode.eulerAngles.y = .pi / 2
        sceneView.scene.rootNode.addChildNode(planeNode)
        
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}
