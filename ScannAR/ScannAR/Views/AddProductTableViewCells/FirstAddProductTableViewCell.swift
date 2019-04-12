//
//  FirstAddProductTableViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/3/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class FirstAddProductTableViewCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameTextField.tag = 0
        descriptionTextView.tag = 1
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        productImageView.layer.cornerRadius = 16
        productImageView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 8
        nameTextField.layer.cornerRadius = 8
    }
    
    // MARK: TextFieldDelegate & TextViewDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.name = self.nameTextField.text!
        delegate?.endEditing()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.productDescription = self.descriptionTextView.text!
        delegate?.endEditing()
    }
    
    // MARK: IBActions
    @IBAction func addImageButtonTapped(_ sender: Any) {
        delegate?.showInputScreenToInputPhotoURL()
    }
    
    // MARK: Properties
    weak var delegate: AddProductProtocolDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
}
