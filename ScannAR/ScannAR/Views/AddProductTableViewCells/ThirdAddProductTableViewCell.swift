//
//  ThirdAddProductTableViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/3/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ThirdAddProductTableViewCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateViews()
        manufacturerIdTextField.tag = 0
        weightTextField.tag = 1
        valueTextField.tag = 2
        fragileSwitch.tag = 3
        manufacturerIdTextField.delegate = shiftableVCdelegate
        weightTextField.delegate = shiftableVCdelegate
        valueTextField.delegate = shiftableVCdelegate
        
    }
    
    // MARK: Private Methods
    private func updateViews(){
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        manufacturerIdTextField.clipsToBounds = true
        manufacturerIdTextField.layer.cornerRadius = 8
        valueTextField.clipsToBounds = true
        valueTextField.layer.cornerRadius = 8
        weightTextField.clipsToBounds = true
        weightTextField.layer.cornerRadius = 8
        
        manufacturerIdTextField.placeholder = "XYZ123"
    }
    // MARK: TextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        
        case 0:
            delegate?.manufacturerId = self.manufacturerIdTextField.text!
        case 1:
            delegate?.weight = Double("\(self.weightTextField.text!)") ?? 0.0
        default:
            delegate?.value = Double("\(self.valueTextField.text!)") ?? 0.0
            
        }

    }
    
    // MARK: Properties
    weak var delegate: AddProductProtocolDelegate?
    weak var shiftableVCdelegate: ShiftableViewController?
    @IBOutlet weak var manufacturerIdTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var fragileSwitch: UISwitch! {
        didSet {
            delegate?.fragile = self.fragileSwitch.isOn ? 1 : 0
        }
    }
}
