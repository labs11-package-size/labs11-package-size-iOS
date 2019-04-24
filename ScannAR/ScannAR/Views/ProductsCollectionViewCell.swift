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
        imageContainerView.clipsToBounds = true
        imageContainerView.cornerRadius = 8
    }

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    var product: Product?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var lwhLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var infoStackView: UIStackView!
    
}
