//
//  ShipmentsDetailViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import MapKit

class ShipmentsDetailViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
        addAnnotation()
        shipmentMapView.delegate = self
        
    }
    
    // MARK: - Private Methods
    private func updateViews(){
        guard let shipment = shipment else { fatalError("No shipment passed to this VC") }
        trackingNumberLabel.text = shipment.trackingNumber
        carrierNameLabel.text = shipment.carrierName
        statusLabel.text = ShipmentStatus.dict[Int(shipment.status)]
        shippedToLabel.text = shipment.shippedTo
        totalValueLabel.text = "\(shipment.totalValue)"
        totalWeightLabel.text = "\(shipment.totalWeight)"
        shippingTypeLabel.text = shipment.shippingType
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateArrived = shipment.dateArrived {
            dateArrivedLabel.text = dateFormatter.string(from: dateArrived)
        } else {
            dateArrivedLabel.text = "N/A"
        }
        
        if let shippedDate = shipment.shippedDate {
            shippedDateLabel.text = dateFormatter.string(from: shippedDate)
        } else {
            shippedDateLabel.text = "N/A"
        }
        
        if let lastUpdated = shipment.lastUpdated {
            lastUpdatedLabel.text = dateFormatter.string(from: lastUpdated)
        } else {
            lastUpdatedLabel.text = "N/A"
        }
        
    }
    
    private func addAnnotation() {
        
        guard let address = shipment?.shippedTo else { return }
        let geocoder = CLGeocoder()
        let destination = MKPointAnnotation()
        destination.title = address
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                destination.coordinate = placemark.location!.coordinate
                self.shipmentMapView.setCenter(placemark.location!.coordinate,
                                          animated: true)
            }
        })
        
        
        shipmentMapView.addAnnotation(destination)
        
    }
    
    private func alertOnDeleteButtonPressed() {
        
        guard let shipmentToDelete = shipment else { fatalError("No shipment passed to this VC") }
        
        let shipmentName = shipmentToDelete.shippedTo ?? ""
        guard let uuid = shipmentToDelete.uuid else {
            print("Error: no UUID associated with the shipment")
            return
        }
        
        let alert = UIAlertController(title: "Are you sure you want to delete shipment going to \(shipmentName)?", message: "Press okay to remove it from the Library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            if action.style == .destructive {
                
                self.scannARNetworkingController?.deleteShipment(uuid: uuid, completion: { (results, error) in
                    
                    if let error = error {
                        print("Error deleting object: \(error)")
                    }
                    
                    let moc = CoreDataStack.shared.mainContext
                    moc.perform {
                        moc.delete(shipmentToDelete)
                        
                        do {
                            try moc.save()
                        } catch let saveError {
                            print("Error saving context: \(saveError)")
                        }
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                })
                
                
            }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - MapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - IBActions
    @IBAction func deleteButtonPressed(_ sender: Any) {
        alertOnDeleteButtonPressed()
    }
    
    
    // MARK: - Properties
    var scannARNetworkingController: ScannARNetworkController?
    var shipment: Shipment?
    @IBOutlet weak var shipmentMapView: MKMapView!
    @IBOutlet weak var shipmentImageView: UIImageView!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var carrierNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shippedToLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var shippedDateLabel: UILabel!
    @IBOutlet weak var shippingTypeLabel: UILabel!
    @IBOutlet weak var dateArrivedLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
}
