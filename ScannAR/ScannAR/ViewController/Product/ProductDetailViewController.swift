//
//  ProductDetailViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, BottomButtonDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupDelegates()
        setupTapGestures()
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
        if let thumbnail = product.thumbnail {
            var data: Data
            do {
                data = try Data(contentsOf: thumbnail)
                imageView.image = UIImage(data: data)
            } catch {
                print("could not get image")
                imageView.image = UIImage(named: "ET")
            }
        } else {
            imageView.image = UIImage(named: "ET")
        }
        
        nameTextField.text = product.name
        manufacturerIdTextField.text = product.manufacturerId
        valueTextField.text =  String(format: "%.2f", (product.value)) // NumberFormatter.localizedString(from: NSNumber(value: product.value), number: .currency)
        weightTextField.text = String(format: "%.2f", (product.weight))
        lengthTextField.text = String(format: "%.2f", (product.length))
        widthTextField.text = String(format: "%.2f", (product.width))
        heightTextField.text = String(format: "%.2f", (product.height))
        fragileSwitch.isOn =  product.fragile == 1 ? true : false
        
        arrowImageView.setImageColor(color: .gray)

    }
    
    private func setupTapGestures(){
        
        let tapGestureForDescription = UITapGestureRecognizer(target: self, action: #selector(self.handleDescriptionTap(_:)))
       
        self.descriptionStackView.isUserInteractionEnabled = true
        self.descriptionStackView.addGestureRecognizer(tapGestureForDescription)
        
    }
    
    private func fetchAssets(){
        guard let product = product else {fatalError("No product available to show")}
        guard let uuid = product.uuid else {fatalError("No uuid available to show")}
        scannARNetworkController.getAssetsForProduct(uuid: uuid, completion: { (results, error) in
            
            guard let firstAsset = results?.first else { return }
            guard let url = URL(string: firstAsset.urlString) else {
                return
            }
            var data: Data
            do {
                data = try Data(contentsOf:  url)
            } catch {
                print("Could not get picture from URL")
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
            
        })
    }
    
    private func fetchPreview(completionHandler: @escaping ([PackageConfiguration]?, Error?) -> Void) {
        guard let product = product else {fatalError("No product available to show")}
        guard let productUUID = product.uuid else {fatalError("No product uuid available")}
        let packagePreview = PackagePreviewRequest(products: [productUUID.uuidString], boxType: boxType) // could add boxType specifier here as well.
        scannARNetworkController.postPackagingPreview(packagingDict: packagePreview) { (results, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let results = results else {
                print("No Results")
                return
            }
            self.fetchResults = results
            completionHandler(results,nil)
            
        }
    }
    
    private func updateProductValues(){
    
        guard let product = product else { fatalError("No Product present")}
        product.name = nameTextField.text
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
        manufacturerIdTextField.delegate = self
        valueTextField.delegate = self
        weightTextField.delegate = self
        lengthTextField.delegate = self
        widthTextField.delegate = self
        heightTextField.delegate = self
    }
    
    private func changeEditingTo(_ bool: Bool) {
        nameTextField.isUserInteractionEnabled = bool
        manufacturerIdTextField.isUserInteractionEnabled = bool
        valueTextField.isUserInteractionEnabled = bool
        weightTextField.isUserInteractionEnabled = bool
        fragileSwitch.isUserInteractionEnabled = bool
        
    }
    
    private func updateProductOnServer(){
        
        updateProductValues()
        guard let product = product else { fatalError("No Product present")}
        
        guard let uuid = product.uuid else { fatalError("No UUID present")}
        let dict = NetworkingHelpers.dictionaryFromProductForUpdate(product: product)
        scannARNetworkController.putEditProduct(dict: dict, uuid: uuid) { (_) in
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PackMultipleSegue"{
            guard let product = product else { fatalError("No Product present")}
            guard let destVC = segue.destination as? PickProductToPackViewController else { fatalError("Did not transition to PickProductToPackViewController")}
            destVC.startingProduct = product
        } else if segue.identifier == "ProductDescriptionSegue"{
            guard let description = product?.productDescription else { fatalError("No Product description available")}
            guard let destVC = segue.destination as? ProductDescriptionViewController else { fatalError("Did not transition to ProductDescriptionViewController")}
            destVC.productDescription = description
            destVC.product = product
        } else if segue.identifier == "PackItNowSegue" {
            guard let destVC = segue.destination as? RecommendedBoxViewController else { fatalError("Did not transition to RecommendedBoxViewController")}
            bottomButtonDelegate?.updateDelegate(destVC)
            guard let package = package else { fatalError("No package to send")}
            destVC.package = package
            destVC.bottomButtonDelegate = bottomButtonDelegate
        }
    }
   
    // MARK: - BottomButtonDelegateMethods
    func packThisProduct() {
        self.packItNowButtonTapped(self)
    }
    
    func packMultipleProducts() {
        print("pack multiple items segue")
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        changeEditingTo(true)
        notification.notificationOccurred(.warning)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    @objc func saveTapped(sender: UIButton) {
        changeEditingTo(false)
        notification.notificationOccurred(.success)
        updateProductOnServer()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    }
    
    @objc func handleDescriptionTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ProductDescriptionSegue", sender: self)
    }
    
    private func packItNowButtonTapped(_ sender: Any) {
        notification.notificationOccurred(.success)
        self.fetchPreview(completionHandler: { results, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let results = results else { return }
            
            self.scannARNetworkController.postAddPackages(packagingConfigurations: results, completion: { (results, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                if let results = results, results.last != nil {
                    let packageRep = results.last
                    let moc = CoreDataStack.shared.mainContext
                    
                    let package = Package(packageRepresentation: packageRep!, context: moc)
                    self.package = package
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "PackItNowSegue", sender: self)
                    }
                }
                
            })
            
        })
    }

    
    // MARK: - Properties
    var boxType: BoxType?
    var bottomButtonDelegate: DelegatePasserDelegate?
    var fetchResults: [PackageConfiguration] = []
    let scannARNetworkController = ScannARNetworkController.shared
    var product: Product?
    var package: Package?
    let notification = UINotificationFeedbackGenerator()
    var collectionViewToReload: UICollectionView?
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var manufacturerIdTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var fragileSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionStackView: UIStackView!
    
}

extension ProductDetailViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
}
