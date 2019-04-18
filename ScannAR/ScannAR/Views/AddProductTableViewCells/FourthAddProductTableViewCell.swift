//
//  FourthAddProductTableViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/3/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class FourthAddProductTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        packItButton.layer.cornerRadius = 20
        packItButton.clipsToBounds = true
        saveForLaterButton.layer.cornerRadius = 20
        saveForLaterButton.clipsToBounds = true
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
    }
    
    @IBAction func packItButtonPushed(_ sender: Any) {
        delegate?.packItButtonTapped(self)
    }
    @IBAction func saveForLaterButtonPushed(_ sender: Any) {
        delegate?.saveForLaterTapped(self)
    }
    
    // MARK: Properties
    weak var delegate: AddProductProtocolDelegate?
    @IBOutlet weak var saveForLaterButton: UIButton!
    @IBOutlet weak var packItButton: UIButton!
}
