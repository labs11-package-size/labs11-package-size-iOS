//
//  PulleyViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/27/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import Pulley

class PulleyViewController {
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScannARMainSegue" {
            guard let embeddedVC = segue.destination as? ScannARMainViewController else {fatalError()}
            embeddedVC.scannARNetworkingController = self.scannARNetworkingController
        }
        
    }
    
    @IBOutlet weak var primaryContentContainerView: UIContentContainer!
    @IBOutlet weak var drawerContentContainerView: UIContentContainer!
    var scannARNetworkingController: ScannARNetworkController?
}
