//
//  ProductDetailViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupDelegates()
        updateViews()
    }
    // MARK: - Private Methods
    
    private func updateViews() {
        
        valueTextField.keyboardType = UIKeyboardType.decimalPad
        lengthTextField.keyboardType = UIKeyboardType.decimalPad
        weightTextField.keyboardType = UIKeyboardType.decimalPad
        lengthTextField.keyboardType = UIKeyboardType.decimalPad
        widthTextField.keyboardType = UIKeyboardType.decimalPad
        
        
        guard let product = product else {fatalError("No product available to show")}
        nameTextField.text = product.name
        descriptionTextField.text = product.productDescription
        manufacturerIdTextField.text = product.manufacturerId
        valueTextField.text = "\(product.value)"
        weightTextField.text = "\(product.weight)"
        lengthTextField.text = "\(product.length)"
        widthTextField.text = "\(product.width)"
        heightTextField.text = "\(product.height)"
        
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
        
    
    
    // MARK: - Properties
    var scannARNetworkingController: ScannARNetworkController?
    var product: Product?
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
    @IBOutlet weak var scrollView: UIScrollView!

}

extension ProductDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
