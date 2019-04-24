//
//  ShipmentsCollectionViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/26/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import Foundation

class ShipmentsCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    @IBOutlet weak var shippedToLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var emojiTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var shipment: Shipment?
    
}
