//
//  SecondAddProductTableViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/3/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class SecondAddProductTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lengthTextField.tag = 0
        widthTextField.tag = 1
        heightTextField.tag = 2
        lengthTextField.delegate = self
        widthTextField.delegate = self
        heightTextField.delegate = self
        lengthPickerView.delegate = self
        lengthPickerView.dataSource = self
        widthPickerView.delegate = self
        widthPickerView.dataSource = self
        heightPickerView.delegate = self
        heightPickerView.dataSource = self
        updateViews()
    }

    // MARK: Private Methods
    private func updateViews(){
        scanWithARButton.clipsToBounds = true
        scanWithARButton.layer.cornerRadius = 8
        enterManuallyButton.clipsToBounds = true
        enterManuallyButton.layer.cornerRadius = 4
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    // MARK: UIPickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return inches.count
        case 1: return decimal.count
        default: return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(String(format: "%.0f", inches[row]))"
        case 1:
            let str = String(format: "%.2f", decimal[row])
            let lowerBound = str.index(str.startIndex, offsetBy: 1)
            let upperBound = str.index(str.startIndex, offsetBy: 4)
            let mySubstring: Substring = str[lowerBound..<upperBound]
            return "\(mySubstring)"
        default: return "inches"
        
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag  {
        case 0:
            switch component {
            case 0:
                lengthTextField.text = "\(inches[row] + decimal[lengthPickerView.selectedRow(inComponent: 1)])"
            case 1:
                lengthTextField.text = "\(inches[lengthPickerView.selectedRow(inComponent: 0)] + decimal[row])"
            default:
                print("")
            }
        case 1:
            switch component {
            case 0:
                widthTextField.text = "\(inches[row] + decimal[widthPickerView.selectedRow(inComponent: 1)])"
            case 1:
                widthTextField.text = "\(inches[widthPickerView.selectedRow(inComponent: 0)] + decimal[row])"
            default:
                print("")
            }
        
        default:
            switch component {
            case 0:
                heightTextField.text = "\(inches[row] + decimal[heightPickerView.selectedRow(inComponent: 1)])"
            case 1:
                heightTextField.text = "\(inches[heightPickerView.selectedRow(inComponent: 0)] + decimal[row])"
            default:
                print("")
            }
        }
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
    
    
    // MARK: Outlets
    
    @IBOutlet weak var lengthPickerView: UIPickerView! {
        didSet {
            delegate?.length = Double("\(self.lengthTextField.text!)") ?? 0.0
        }
    }
    @IBOutlet weak var widthPickerView: UIPickerView! {
        didSet {
            delegate?.width = Double("\(self.widthTextField.text!)") ?? 0.0
        }
    }
    @IBOutlet weak var heightPickerView: UIPickerView! {
        didSet {
            delegate?.height = Double("\(self.heightTextField.text!)") ?? 0.0
        }
    }
    @IBOutlet weak var enterManuallyButton: UIButton!
    @IBOutlet weak var scanWithARButton: UIButton!
    @IBOutlet weak var manualEntryStackView: UIStackView!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    // MARK: Properties
    weak var delegate: AddProductProtocolDelegate?
    var inches: [Double] = stride(from: 0.0, to: 60.0, by: 1.0).map{$0}
    var decimal: [Double] = stride(from: 0.00, to: 1.00, by: 0.01).map{$0}
}
