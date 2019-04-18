//
//  MapDrawerTableViewCell.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/18/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

//enum ShipmentStatus: String {
//    case inTransit = "In Transit"
//    case preShipment = "Pre-shipment"
//    case delivered = "Delivered"
//}

struct MockShipmentModel {
    let carrierLogoImage: UIImage?
    let carrierName: String?
    let dateArrived: Date?
    let lastUpdated: Date?
    let productNames: [String]?
    let shippedDate: Date?
    let shippedTo: String?
    let shippingType: String?
    let status: Int16
    let totalValue: Double
    let totalWeight: Double
    let trackingNumber: String?
    let uuid: UUID?
}

class MapDrawerTableViewCell: UITableViewCell {
    
    
    var model: MockShipmentModel!
    @IBOutlet weak var trackingCellStatusLabel: UILabel!
    @IBOutlet weak var trackingCellDateLabel: UILabel!
    @IBOutlet weak var trackingCellTimeLabel: UILabel!
    @IBOutlet weak var trackingCellCurrentLocation: UILabel!
    @IBOutlet weak var carrierLogoImageView: UIImageView!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var carrierNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var shippedToLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var shippedDateLabel: UILabel!
    @IBOutlet weak var shippingTypeLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    //    @IBOutlet weak var dateArrivedLabel: UILabel!
    //    @IBOutlet weak var collectionView: UICollectionView! //header view
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let model = MockShipmentModel(carrierLogoImage: UIImage(named: "1970-standing-eagle-logo")!, carrierName: "USPS", dateArrived: Date(), lastUpdated: Date(), productNames: ["yaya", "nana", "ohoh", "noodles", "too"], shippedDate: Date(), shippedTo: "1 Infinite Loop, Cupertino, CA", shippingType: "Snail Mail", status: 2, totalValue: 42.0, totalWeight: 42.0, trackingNumber: "92748999985493513036555961", uuid: UUID())
    }
    
    func configure(model: MockShipmentModel){
        
        trackingNumberLabel.text = model.trackingNumber
        carrierLogoImageView.image = UIImage(named: "1970-standing-eagle-logo")
        carrierNameLabel.text = model.carrierName
        statusLabel.text = ShipmentStatus.dict[Int(model.status)]
        shippedToLabel.text = model.shippedTo
        totalValueLabel.text = "\(model.totalValue)"
        totalWeightLabel.text = "\(model.totalWeight)"
        shippingTypeLabel.text = model.shippingType
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateArrived = model.dateArrived {
            lastUpdatedLabel.text = "Updated on " + dateFormatter.string(from: dateArrived)
        } else {
            lastUpdatedLabel.text = "No Status Information Available."
        }
        
        if let shippedDate = model.shippedDate {
            lastUpdatedLabel.text = "Updated on " + dateFormatter.string(from: shippedDate)
            shippedDateLabel.text = dateFormatter.string(from: shippedDate)
        } else {
            shippedDateLabel.text = "No Status Information Available."
        }
        
        if let lastUpdated = model.lastUpdated {
            lastUpdatedLabel.text = "Updated on " + dateFormatter.string(from: lastUpdated)
        }
    }
    
    
    
    
    
    open func updateViews(){
        guard let model = model else { fatalError("No model passed to this VC") }
        trackingNumberLabel.text = model.trackingNumber
        carrierNameLabel.text = model.carrierName
        statusLabel.text = "\(model.status)" //ShipmentStatus.dict[Int(model.status)]
        shippedToLabel.text = "\(model.shippedTo)"
        totalValueLabel.text = "\(model.totalValue)"
        totalWeightLabel.text = "\(model.totalWeight)"
        shippingTypeLabel.text = model.shippingType
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let dateArrived = model.dateArrived {
            lastUpdatedLabel.text = dateFormatter.string(from: dateArrived)
        } else {
            lastUpdatedLabel.text = "No Status Information Available."
        }
        
        if let shippedDate = model.shippedDate {
            shippedDateLabel.text = dateFormatter.string(from: shippedDate)
        } else {
            shippedDateLabel.text = "No Status Information Available."
        }
        
        if let lastUpdated = model.lastUpdated {
            lastUpdatedLabel.text = dateFormatter.string(from: lastUpdated)
        }
        
    }
}

