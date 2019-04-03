//
//  ShipmentsCollectionViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/26/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ShipmentsCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var dateShippedLabel: UILabel!
    @IBOutlet weak var carrierNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var shipment: Shipment?
    
}
