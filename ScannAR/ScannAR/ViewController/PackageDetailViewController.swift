//
//  PackageDetailViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/7/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import SafariServices

class PackageDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        updateViews()
        trackingNumberTextField.delegate = self
        updatePicture()
    }
    // MARK: - Private Methods
    
    private func updateViews() {
        
        
        guard let package = package else {fatalError("No package available to show")}
        dimensionsLabel.text = package.dimensions
        totalWeightLabel.text = String(format: "%.2f",package.totalWeight)
        trackingNumberEnterStackView.isHidden = true
        createShipmentButton.isHidden = true
        
        showTrackingNumber.layer.cornerRadius = 8
        showTrackingNumber.clipsToBounds = true
        createShipmentButton.layer.cornerRadius = 8
        createShipmentButton.clipsToBounds = true
        threeDPackagePreviewButton.layer.cornerRadius = 8
        threeDPackagePreviewButton.clipsToBounds = true
    }
    
    private func updatePicture() {
        guard let package = package else { fatalError("No package present in this VC")}
        if let dimensions = package.dimensions {
            if let boxType = Box.boxVarieties[dimensions] {
                
                switch boxType {
                case .shipper:
                    self.boxImageView.image = UIImage(named: "standardMailerBox")
                    self.boxTypeLabel.text = "Mailer"
                default:
                    self.boxImageView.image = UIImage(named: "Shipper")
                    self.boxTypeLabel.text = "Shipper"
                }
            } else {
                self.boxImageView.image = UIImage(named: "Shipper")
                self.boxTypeLabel.text = "Shipper"
            }
            
        } else {
            self.boxImageView.image = UIImage(named: "Shipper")
            self.boxTypeLabel.text = "N/A"
        }
        boxImageView.clipsToBounds = true
        boxImageView.layer.cornerRadius = 12
    }
    
    private func linkToURL(with url: URL) {
            
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
            
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateShipmentSegue" {
            guard let destVC = segue.destination as? ScannARMainViewController else { fatalError("Supposed to segue to ScannARMainViewController but did not.")}

        }
        
    }
    
    // MARK: - IBActions
    @IBAction func showTrackingNumberButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.8) {
            self.trackingNumberEnterStackView.isHidden = !self.trackingNumberEnterStackView.isHidden
            self.createShipmentButton.isHidden = !self.createShipmentButton.isHidden
        }
        
    }
    @IBAction func threeDPackagePreviewButton(_ sender: Any) {
        guard let urlString = package?.modelURL, urlString != "http://www.google.com" else { return }
        guard let url = URL(string: urlString) else { return }
        linkToURL(with: url)
    }
    
    @IBAction func createShipmentTapped(_ sender: Any) {
        
        guard trackingNumberTextField.text != "" else { return }
        
        guard let uuid = package?.uuid else { return }
        let productNames = ["Test"] // package?.productNames else { return }
        
        let newShipment = Shipment(carrierName: nil, productNames: productNames, shippedDate: nil, dateArrived: nil, lastUpdated: nil, shippingType: nil, status: 1, trackingNumber: trackingNumberTextField.text!, shippedTo: nil, uuid: uuid, context: CoreDataStack.shared.container.newBackgroundContext())
        let dict = NetworkingHelpers.dictionaryFromShipment(shipment: newShipment)
        
        scannARNetworkingController?.postNewShipment(dict: dict, uuid: uuid, completion: { (results, error) in
            
            if let error = error {
                print("Error: \(error)")
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "CreateShipmentSegue", sender: nil)
            }
            
        })
    }
    
    // MARK: - Properties
    var scannARNetworkingController: ScannARNetworkController?
    var package: Package?
    var collectionViewToReload: UICollectionView?
    @IBOutlet weak var boxImageView: UIImageView!
    
    
    @IBOutlet weak var threeDPackagePreviewButton: UIButton!
    @IBOutlet weak var showTrackingNumber: UIButton!
    @IBOutlet weak var createShipmentButton: UIButton!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var boxTypeLabel: UILabel!
    
    @IBOutlet weak var trackingNumberTextField: UITextField!
    @IBOutlet weak var trackingNumberEnterStackView: UIStackView!
    
}

extension PackageDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
