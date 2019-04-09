//
//  PackagesCollectionViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/4/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class PackagesCollectionViewCell: UICollectionViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    @IBOutlet weak var productNamesLabel: UILabel!
    var package: Package?
}
