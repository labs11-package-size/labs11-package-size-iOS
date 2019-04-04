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
        fetchAssets()
        changeEditingTo(false)
        lengthTextField.isUserInteractionEnabled = false
        widthTextField.isUserInteractionEnabled = false
        heightTextField.isUserInteractionEnabled = false
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
        fragileSwitch.isOn =  product.fragile == 1 ? true : false
        
    }
    
    private func fetchAssets(){
        guard let product = product else {fatalError("No product available to show")}
        guard let uuid = product.uuid else {fatalError("No uuid available to show")}
        scannARNetworkingController?.getAssetsForProduct(uuid: uuid, completion: { (results, error) in
            
            guard let firstAsset = results?.first else { return }
            let url = URL(string: firstAsset.urlString)
            var data: Data
            do {
                data = try Data(contentsOf: url!)
            } catch {
                print("Could not get picture from URL")
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
            
        })
    }
    
    private func updateProductValues(){
    
        guard let product = product else { fatalError("No Product present")}
        product.name = nameTextField.text
        product.productDescription = descriptionTextField.text
        product.manufacturerId = manufacturerIdTextField.text
        
        if let value = Double("\(valueTextField.text)") {
            product.value = value
        }
        if let height = Double("\(heightTextField.text)") {
            product.height = height
        }
        product.fragile = fragileSwitch.isOn ? 1 : 0
        
    
    }
    
    private func setupDelegates() {
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        manufacturerIdTextField.delegate = self
        valueTextField.delegate = self
        weightTextField.delegate = self
        lengthTextField.delegate = self
        widthTextField.delegate = self
        heightTextField.delegate = self
    }
    
    private func changeEditingTo(_ bool: Bool) {
        nameTextField.isUserInteractionEnabled = bool
        descriptionTextField.isUserInteractionEnabled = bool
        manufacturerIdTextField.isUserInteractionEnabled = bool
        valueTextField.isUserInteractionEnabled = bool
        weightTextField.isUserInteractionEnabled = bool
        fragileSwitch.isUserInteractionEnabled = bool
        
        
    }
    
    private func updateProductOnServer(){
        
        updateProductValues()
        guard let scannARNetworkingController = scannARNetworkingController else { fatalError("No ScannARNetworkingController present")}
        guard let product = product else { fatalError("No Product present")}
        
        guard let uuid = product.uuid else { fatalError("No UUID present")}
        let dict = NetworkingHelpers.dictionaryFromProductForUpdate(product: product)
        scannARNetworkingController.putEditProduct(dict: dict, uuid: uuid) { (_) in
            self.flashSaveOnServerNoticeToUser()
        }
    }
    
    private func flashSaveOnServerNoticeToUser() {
        guard let product = product else { return }
        DispatchQueue.main.async {
            let popup = UIView(frame: CGRect(x: self.view.center.x - 100, y: self.view.center.y - 100, width: 200, height: 200))
            popup.alpha = 1
            popup.backgroundColor = .gray
            
            let label = UILabel()
            
            label.text = "\(String(product.name!)) saved"
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 4
            label.font = UIFont.systemFont(ofSize: 20)
            
            popup.addSubview(label)
            self.view.addSubview(popup)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: popup.centerYAnchor).isActive = true
            let widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160)
            label.addConstraint(widthConstraint)
            
            UIView.animate(withDuration: 2, animations: {
                popup.alpha = 0
            }, completion: { _ in
                popup.removeFromSuperview()
            })
            
        }
        
    }
    
   
    // MARK: - IBActions
    @IBAction func editButtonTapped(_ sender: Any) {
        changeEditingTo(true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    @objc func saveTapped(sender: UIButton) {
        changeEditingTo(false)
        updateProductOnServer()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    }
    
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
    @IBOutlet weak var imageView: UIImageView!
    
}

extension ProductDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
