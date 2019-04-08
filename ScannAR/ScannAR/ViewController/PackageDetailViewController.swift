//
//  PackageDetailViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/7/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class PackageDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        updateViews()
        trackingNumberTextField.delegate = self
    }
    // MARK: - Private Methods
    
    private func updateViews() {
        
        
        guard let package = package else {fatalError("No package available to show")}
        dimensionsTextField.text = package.dimensions
        totalWeightTextField.text = String(format: "%.2f",package.totalWeight)
        trackingNumberEnterStackView.isHidden = true
        createShipmentButton.isHidden = true
        
    }
    
    private func changeEditingTo(_ bool: Bool) {
        dimensionsTextField.isUserInteractionEnabled = bool
        totalWeightTextField.isUserInteractionEnabled = bool
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    // MARK: - IBActions
    @IBAction func showTrackingNumberButtonTapped(_ sender: Any) {
        trackingNumberEnterStackView.isHidden = !trackingNumberEnterStackView.isHidden
        createShipmentButton.isHidden = !createShipmentButton.isHidden
    }
    
    @IBAction func createShipmentTapped(_ sender: Any) {
        
        guard trackingNumberTextField.text != "" else { return }
        
        guard let uuid = package?.uuid else { return }
        let productNames = "Test" // package?.productNames else { return }
        
        let newShipment = Shipment(identifier: nil, carrierName: nil, productNames: productNames, shippedDate: nil, dateArrived: nil, lastUpdated: nil, shippingType: nil, status: 1, trackingNumber: trackingNumberTextField.text!, shippedTo: nil, uuid: uuid, context: CoreDataStack.shared.container.newBackgroundContext())
        let dict = NetworkingHelpers.dictionaryFromShipment(shipment: newShipment)
        
        scannARNetworkingController?.postNewShipment(dict: dict, uuid: uuid, completion: { (results, error) in
            
            if let error = error {
                print("Error: \(error)")
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    // MARK: - Properties
    var scannARNetworkingController: ScannARNetworkController?
    var package: Package?
    var collectionViewToReload: UICollectionView?

    @IBOutlet weak var showTrackingNumber: UIButton!
    @IBOutlet weak var createShipmentButton: UIButton!
    @IBOutlet weak var dimensionsTextField: UITextField!
    @IBOutlet weak var totalWeightTextField: UITextField!
    @IBOutlet weak var trackingNumberTextField: UITextField!
    @IBOutlet weak var trackingNumberEnterStackView: UIStackView!
    
}

extension PackageDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
