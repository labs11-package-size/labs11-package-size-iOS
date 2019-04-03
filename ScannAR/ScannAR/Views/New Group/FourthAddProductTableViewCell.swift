//
//  FourthAddProductTableViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/3/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class FourthAddProductTableViewCell: UITableViewCell {

    
    @IBAction func packItButtonPushed(_ sender: Any) {
        delegate?.packItButtonTapped(self)
    }
    @IBAction func saveForLaterButtonPushed(_ sender: Any) {
        delegate?.saveForLaterTapped(self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.cancelButtonPressed(self)
    }
    
    // MARK: Properties
    weak var delegate: AddProductProtocolDelegate?
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveForLaterButton: UIButton!
    @IBOutlet weak var packItButton: UIButton!
}
