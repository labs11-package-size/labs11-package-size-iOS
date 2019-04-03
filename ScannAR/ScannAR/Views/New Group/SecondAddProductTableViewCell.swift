//
//  SecondAddProductTableViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/3/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class SecondAddProductTableViewCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lengthTextField.tag = 0
        widthTextField.tag = 1
        heightTextField.tag = 2
        lengthTextField.delegate = self
        widthTextField.delegate = self
        heightTextField.delegate = self
    }


    
    // MARK: TextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
            
        case 0:
            delegate?.length = Double("\(self.lengthTextField.text!)") ?? 0.0
        case 1:
            delegate?.width = Double("\(self.widthTextField.text!)") ?? 0.0
        default:
            delegate?.height = Double("\(self.heightTextField.text!)") ?? 0.0
        }
        
    }
    
    // MARK: IBActions
    
    @IBAction func scanWithARButtonTapped(_ sender: Any) {
        delegate?.scanWithARButtonTapped(self)
    }
    
    @IBAction func manualEntryTapped(_ sender: Any) {
        
        if manualEntryStackView.isHidden {
            delegate?.manualEntryHidden = false
        } else {
            delegate?.manualEntryHidden = true
        }
    }
    
    // MARK: Properties
    weak var delegate: AddProductProtocolDelegate?
    
    @IBOutlet weak var manualEntryStackView: UIStackView!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
}
