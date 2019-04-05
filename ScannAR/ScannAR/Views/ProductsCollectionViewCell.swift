//
//  ProductsCollectionViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
    }

    @IBOutlet weak var productImageView: UIImageView!
    var product: Product?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var lwhLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
}
