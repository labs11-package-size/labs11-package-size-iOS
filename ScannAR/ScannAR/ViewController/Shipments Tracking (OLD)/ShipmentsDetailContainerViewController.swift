//
//  ShipmentsDetailContainerViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ShipmentsDetailContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let shipment = shipment else { fatalError("No shipment sent to Container VC")}
        
        if segue.identifier == "EmbedSegue" {
            guard let destVC = segue.destination as? ShipmentsDetailViewController else { fatalError("Embed Segue not going to ShipmentsDetailViewController")}
            
            self.delgateForButtomContainer = destVC
            destVC.shipment = shipment
        } else if segue.identifier == "EmbedBottomSegue" {
            guard let destVC = segue.destination as? BottomButtonContainerViewController else { fatalError("Embed Segue not going to ShipmentsDetailViewController")}
            destVC.delegate = delgateForButtomContainer
            destVC.progressBarDelegate = progressBarDelgateForButtomContainer
            self.delgateForButtomContainer?.bottomButtonDelegate = destVC
            destVC.buttonState = .trackingNumberEntered
            
        } else if segue.identifier == "EmbedTopSegue" {
            guard let destVC = segue.destination as? ProgressViewController else { fatalError("Embed Segue not going to ShipmentsDetailViewController")}
            self.progressBarDelgateForButtomContainer = destVC
            destVC.buttonState = .trackingNumberEntered
        }
        
    }
    
    // MARK: - Properties

    @IBOutlet weak var shipmentDetailContainerView: UIView!
    var delgateForButtomContainer: ShipmentsDetailViewController?
    var progressBarDelgateForButtomContainer: ProgressViewController?
    var bottomButtonDelegate: DelegatePasserDelegate?
    var shipment: Shipment?
}
