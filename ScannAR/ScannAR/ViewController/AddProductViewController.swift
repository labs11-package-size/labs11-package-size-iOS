//
//  AddProductViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/27/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import Foundation

class AddProductViewController: UIViewController {

    
    var previewImage: UIImage?
    var bestBoxSize: (length: Float?, width: Float?, height: Float?)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        // fill
        guard bestBoxSize == (0,0,0) else {
            lengthTextField.text = String(format: "%.2f", (bestBoxSize.length! * 39.3701))
            widthTextField.text = String(format: "%.2f", (bestBoxSize.width! * 39.3701))
            heightTextField.text = String(format: "%.2f", (bestBoxSize.height! * 39.3701))
            return
        }
    }
    // MARK: - Private Methods
    
    private func updateViews() {
        valueTextField.keyboardType = UIKeyboardType.decimalPad
        lengthTextField.keyboardType = UIKeyboardType.decimalPad
        weightTextField.keyboardType = UIKeyboardType.decimalPad
        heightTextField.keyboardType = UIKeyboardType.decimalPad
        widthTextField.keyboardType = UIKeyboardType.decimalPad
        
        manualEntryStackView.isHidden = false
    }
    
    private func setupDelegates() {
        nameTextField.delegate = self
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        manufacturerIdTextField.delegate = self
        valueTextField.delegate = self
        weightTextField.delegate = self
        lengthTextField.delegate = self
        widthTextField.delegate = self
        heightTextField.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func submitTapped(_ sender: Any) {
        guard let scannARNetworkController = scannARNetworkController else { fatalError("No networking controller present")}
        
        guard let height = heightTextField.text,
            let length = lengthTextField.text,
            let manufacturerId = manufacturerIdTextField.text,
            let name = nameTextField.text,
            let productDescription = descriptionTextField.text,
            let value = valueTextField.text,
            let weight = weightTextField.text,
            let width = widthTextField.text else { return }
        
        if nilPropertiesRemaining { return }
        else {
            let newProduct = Product(fragile: fragileSwitch.isOn ? 1 : 0, height: Double(height)!, length: Double(length)!, manufacturerId: manufacturerId, name: name, productDescription: productDescription, value: Double(value)!, weight: Double(weight)!, width: Double(width)!, context: CoreDataStack.shared.container.newBackgroundContext())
            let dict = NetworkingHelpers.dictionaryFromProduct(product: newProduct)
            scannARNetworkController.postNewProduct(dict: dict) { error in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func manualEntryTapped(_ sender: Any) {
    
        manualEntryStackView.isHidden = false
    }
    
    @IBAction func scanWithARButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ScanARSegue", sender: nil)
    }
    
    // MARK: - Properties
    var scannARNetworkController: ScannARNetworkController?
    var collectionViewToReload: UICollectionView?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var manufacturerIdTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var fragileSwitch: UISwitch!
    
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var manualEntryStackView: UIStackView!
    
}


extension AddProductViewController{
    
    private var nilPropertiesRemaining : Bool {
        if nameTextField.text == "" ||
            descriptionTextField.text == "" ||
            manufacturerIdTextField.text == "" ||
            valueTextField.text == "" ||
            weightTextField.text == "" ||
            lengthTextField.text == "" ||
            widthTextField.text == "" ||
            heightTextField.text == "" {
            return true
        } else {
            return false
        }
        
    }
    
}

extension AddProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
