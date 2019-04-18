//
//  AddProductCollectionViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/15/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class AddProductCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        packageImageView.setImageColor(color: UIColor(named: "appARKADarkBlue")!)
        plusButtonImageView.setImageColor(color: UIColor(named: "appARKADarkBlue")!)
    }
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var plusButtonImageView: UIImageView!
    
}
