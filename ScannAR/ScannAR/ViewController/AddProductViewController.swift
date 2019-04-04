//
//  AddProductViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/27/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import Foundation

class AddProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddProductProtocolDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        addProductTableView.delegate = self
        addProductTableView.dataSource = self
        addProductTableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        
        self.addProductTableView.register(UINib(nibName: "FirstAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: firstReuseIdentifier)
        self.addProductTableView.register(UINib(nibName: "SecondAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: secondReuseIdentifier)
        self.addProductTableView.register(UINib(nibName: "ThirdAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: thirdReuseIdentifier)
        self.addProductTableView.register(UINib(nibName: "FourthAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: fourthReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        // fill
        guard bestBoxSize == (0,0,0) else {
            length = Double(bestBoxSize.length ?? 0.0 * 39.3701)
            width = Double(bestBoxSize.width ?? 0.0 * 39.3701)
            height = Double(bestBoxSize.height ?? 0.0 * 39.3701)
            return
        }
    }
    // MARK: - Private Methods
    
    func endEditing(){ 
        self.view.endEditing(true)
    }
    
    func showInputScreenToInputPhotoURL() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Picture URL", message: "Please give the URL to the picture below", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let imageURLString = alertController.textFields?[0].text
            
            self.imageURLString = imageURLString
            self.addProductTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Picture URL"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate and UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row {
        case 1: return manualEntryHidden ? 115 : 180
            
        case 2: return 200
            
        case 3: return 220
            
        default:
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        switch indexPath.row {
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: secondReuseIdentifier, for: indexPath) as? SecondAddProductTableViewCell else { fatalError("Could not dequeue as SecondAddProductTableViewCell")}
            cell.delegate = self
            cell.lengthTextField.text = "\(length)"
            cell.widthTextField.text = "\(width)"
            cell.heightTextField.text = "\(height)"
            
            cell.lengthTextField.keyboardType = UIKeyboardType.decimalPad
            cell.widthTextField.keyboardType = UIKeyboardType.decimalPad
            cell.heightTextField.keyboardType = UIKeyboardType.decimalPad
            
            cell.manualEntryStackView.isHidden = manualEntryHidden
        
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: thirdReuseIdentifier, for: indexPath) as? ThirdAddProductTableViewCell else { fatalError("Could not dequeue as ThirdAddProductTableViewCell")}
            cell.delegate = self
            cell.valueTextField.text = "\(value)"
            cell.weightTextField.text = "\(weight)"
            
            cell.valueTextField.keyboardType = UIKeyboardType.decimalPad
            cell.weightTextField.keyboardType = UIKeyboardType.decimalPad
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: fourthReuseIdentifier, for: indexPath) as? FourthAddProductTableViewCell else { fatalError("Could not dequeue as FourthAddProductTableViewCell")}
            cell.delegate = self
            
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: firstReuseIdentifier, for: indexPath) as? FirstAddProductTableViewCell else { fatalError("Could not dequeue as FirstAddProductTableViewCell")}
            cell.delegate = self
            cell.productImageView.image = displayImage
            cell.nameTextField.text = name
            cell.descriptionTextView.text = productDescription
            
            return cell
        }
       
    }
    
    // MARK: - IBActions
    func saveForLaterTapped(_ sender: Any) {
        guard let scannARNetworkController = scannARNetworkController else { fatalError("No networking controller present")}
        
        guard height != 0.0,
            length != 0.0,
            width != 0.0,
            name != "",
            value != 0.0,
            weight != 0.0 else { return }
        
        let newProduct = Product(fragile: fragile, height: Double(height), length: Double(length), manufacturerId: manufacturerId, name: name, productDescription: productDescription, value: value, weight: weight, width: Double(width), context: CoreDataStack.shared.container.newBackgroundContext())
        let dict = NetworkingHelpers.dictionaryFromProduct(product: newProduct)
        scannARNetworkController.postNewProduct(dict: dict) { error in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func packItButtonTapped(_ sender: Any){
        print("Send to Packaging")
    }
    
    func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scanWithARButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ScanARSegue", sender: nil)
    }
    
    
    func addImageButtonTapped(_ sender: Any) {
        
        showInputScreenToInputPhotoURL()
    }
    
    // MARK: - Properties
    var previewImage: UIImage?
    var bestBoxSize: (length: Float?, width: Float?, height: Float?)
    @IBOutlet weak var addProductTableView: UITableView!
    var scannARNetworkController: ScannARNetworkController?
    var collectionViewToReload: UICollectionView?
    
    var displayImage: UIImage?
    var manualEntryHidden: Bool = true {
        didSet {
            addProductTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
    }
    var height: Double = 0.0
    var length: Double = 0.0
    var width: Double = 0.0
    var manufacturerId: String = ""
    var name: String = ""
    var productDescription: String = ""
    var value: Double = 0.0
    var weight: Double = 0.0
    var fragile: Int = 0
    var imageURLString: String? {
        didSet {
            guard let url = URL(string: imageURLString!) else { return }
            var imageData: Data
            do {
                imageData = try Data.init(contentsOf: url, options: .alwaysMapped)
            } catch {
                print("Could not get data for image at URL.")
                return
            }
            let image = UIImage(data: imageData)
            displayImage = image
            
        }
    }
    
    // reuseIDs
    let firstReuseIdentifier = "FirstCell"
    let secondReuseIdentifier = "SecondCell"
    let thirdReuseIdentifier = "ThirdCell"
    let fourthReuseIdentifier = "FourthCell"
    
}


extension AddProductViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
