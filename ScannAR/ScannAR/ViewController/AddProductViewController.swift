//
//  AddProductViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/27/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        manufacturerIdTextField.delegate = self
        valueTextField.delegate = self
        weightTextField.delegate = self
        lengthTextField.delegate = self
        widthTextField.delegate = self
        heightTextField.delegate = self
        
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - IBActions
    @IBAction func submitButtonTapped(_ sender: Any) {
        
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
           let newProduct = Product(fragile: 0, height: Double(height)!, length: Double(length)!, manufacturerId: manufacturerId, name: name, productDescription: productDescription, value: Double(value)!, weight: Double(weight)!, width: Double(width)!)
            let dict = NetworkingHelpers.dictionaryFromProduct(product: newProduct)
            scannARNetworkController.postNewProduct(dict: dict) { error in
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    @IBOutlet weak var scrollView: UIScrollView!
    
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
