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
        
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        lengthPickerContainerView.clipsToBounds = true
        lengthPickerContainerView.layer.cornerRadius = 8
        widthPickerContainerView.clipsToBounds = true
        widthPickerContainerView.layer.cornerRadius = 8
        heightPickerContainerView.clipsToBounds = true
        heightPickerContainerView.layer.cornerRadius = 8
        lengthTextField.clipsToBounds = true
        lengthTextField.layer.cornerRadius = 8
        widthTextField.clipsToBounds = true
        widthTextField.layer.cornerRadius = 8
        heightTextField.clipsToBounds = true
        heightTextField.layer.cornerRadius = 8
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag  {
        case 0:
            switch component {
            case 0:
                lengthTextField.text = "\(inches[row] + decimal[lengthPickerView.selectedRow(inComponent: 1)])"
                delegate?.length = Double("\(self.lengthTextField.text!)") ?? 0.0

            case 1:
                lengthTextField.text = "\(inches[lengthPickerView.selectedRow(inComponent: 0)] + decimal[row])"
                delegate?.length = Double("\(self.lengthTextField.text!)") ?? 0.0

            default:
                print("")
            }
        case 1:
            switch component {
            case 0:
                widthTextField.text = "\(inches[row] + decimal[widthPickerView.selectedRow(inComponent: 1)])"
                delegate?.width = Double("\(self.widthTextField.text!)") ?? 0.0
            case 1:
                widthTextField.text = "\(inches[widthPickerView.selectedRow(inComponent: 0)] + decimal[row])"
                delegate?.width = Double("\(self.widthTextField.text!)") ?? 0.0
            default:
                print("")
            }
        
        default:
            switch component {
            case 0:
                heightTextField.text = "\(inches[row] + decimal[heightPickerView.selectedRow(inComponent: 1)])"
                delegate?.height = Double("\(self.heightTextField.text!)") ?? 0.0
            case 1:
                heightTextField.text = "\(inches[heightPickerView.selectedRow(inComponent: 0)] + decimal[row])"
                delegate?.height = Double("\(self.heightTextField.text!)") ?? 0.0
            default:
                print("")
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel { label = view }
        else { label = UILabel() }
        
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        
        switch component {
        case 0:
            label.text = "\(String(format: "%.0f", inches[row]))"
            label.minimumScaleFactor = 0.75
        case 1:
            let str = String(format: "%.2f", decimal[row])
            let lowerBound = str.index(str.startIndex, offsetBy: 1)
            let upperBound = str.index(str.startIndex, offsetBy: 4)
            let mySubstring: Substring = str[lowerBound..<upperBound]
            label.minimumScaleFactor = 0.75
            label.text = "\(mySubstring)"
        default:
            label.text = "inches"
            label.font = UIFont.preferredFont(forTextStyle: .callout)
            label.minimumScaleFactor = 0.5
            
        }
        
        return label
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
    
    
    
    
    // MARK: Outlets
    
    @IBOutlet weak var lengthPickerView: UIPickerView!
    @IBOutlet weak var widthPickerView: UIPickerView!
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var scanWithARButton: UIButton!
    @IBOutlet weak var manualEntryStackView: UIStackView!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var heightPickerContainerView: UIView!
    @IBOutlet weak var widthPickerContainerView: UIView!
    @IBOutlet weak var lengthPickerContainerView: UIView!
    
    // MARK: Properties
    weak var delegate: AddProductProtocolDelegate?
    weak var shiftableVCdelegate: ShiftableViewController?
    var inches: [Double] = stride(from: 0.0, to: 60.0, by: 1.0).map{$0}
    var decimal: [Double] = stride(from: 0.00, to: 1.00, by: 0.01).map{$0}
}
