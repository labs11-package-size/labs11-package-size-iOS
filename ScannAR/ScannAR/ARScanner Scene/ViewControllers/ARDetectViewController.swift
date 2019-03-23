//
//  ARDetectViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class ARDetectViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var objectURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScene()
    }
    
    func setUpScene() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        do {
            let configuration = ARWorldTrackingConfiguration()
            if objectURL != nil {
                configuration.detectionObjects = Set([try ARReferenceObject(archiveURL: objectURL!)])
            }
            sceneView.session.run(configuration, options: [])
        }catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - ARSCNViewDelegate Methods
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let alertController = UIAlertController(title: "Object Detected", message: "Your object was scanned correctly and is detectable in 3D space.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        let arrowScene = SCNScene(named: "art.scnassets/ArrowB.scn")!
        let arrowNode = arrowScene.rootNode.childNodes.first!
        // FIXME: - Add extension to SCNVector3
//        arrowNode.position = SCNVector3.positionFromTransform(anchor.transform)
        arrowNode.position.y = 0.25
        sceneView.scene.rootNode.addChildNode(arrowNode)
        
        return arrowNode
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
