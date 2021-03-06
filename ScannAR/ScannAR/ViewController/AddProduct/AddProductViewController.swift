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
        
        self.addProductTableView.register(UINib(nibName: "FirstAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: firstReuseIdentifier)
        self.addProductTableView.register(UINib(nibName: "SecondAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: secondReuseIdentifier)
        self.addProductTableView.register(UINib(nibName: "ThirdAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: thirdReuseIdentifier)
        self.addProductTableView.register(UINib(nibName: "FourthAddProductTableViewCell", bundle: nil), forCellReuseIdentifier: fourthReuseIdentifier)
        
        addProductTableView.delegate = self
        addProductTableView.dataSource = self
        addProductTableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        // fill
        displayImage = previewImage
        
        print(bestBoxSize)
        if bestBoxSize.height == nil || bestBoxSize.length == nil || bestBoxSize.width == nil {
            length = Double(0.0)
            width = Double(0.0)
            height = Double(0.0)
        }else {
            length = Double(bestBoxSize.length! * 39.3701)
            width = Double(bestBoxSize.width! * 39.3701)
            height = Double(bestBoxSize.height! * 39.3701)
            DispatchQueue.main.async {
                self.manualEntryHidden = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.addProductTableView.reloadData()
        }
    }
    // MARK: - Private Methods
    
    func endEditing(){ 
        self.view.endEditing(true)
    }
    
    func showAlertForMissedInformation() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Missing Product Information", message: "Sorry but you need to input the length, width, height, and value, weight, and name properties of the product before saving the product. These values cannot be zero.", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func showInputScreenToInputPhotoURL() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Picture URL", message: "Please give the URL to the picture below", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let imageURLString = alertController.textFields?[0].text
            
            self.thumbnail = imageURLString!
            self.imageURLString = imageURLString
            
            DispatchQueue.main.async {
                 self.addProductTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
           
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        //adding textfields to our dialog box
        
        DispatchQueue.main.async {
            alertController.addTextField { (textField) in
                textField.placeholder = "Enter Picture URL"
                //finally presenting the dialog box
                self.present(alertController, animated: true, completion: nil)
            }
    
        }
    
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
        case 1: return manualEntryHidden ? 124 : 300
            
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
            if let shiftVC = shiftableVCDelegate {
              cell.shiftableVCdelegate = shiftVC
                
            }
            cell.delegate = self
            cell.lengthTextField.text = String(format: "%.2f", (length))
            cell.widthTextField.text = String(format: "%.2f", (width))
            cell.heightTextField.text = String(format: "%.2f", (height))
            
    
            cell.lengthTextField.keyboardType = UIKeyboardType.decimalPad
            cell.widthTextField.keyboardType = UIKeyboardType.decimalPad
            cell.heightTextField.keyboardType = UIKeyboardType.decimalPad
            
            cell.manualEntryStackView.isHidden = manualEntryHidden
        
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: thirdReuseIdentifier, for: indexPath) as? ThirdAddProductTableViewCell else { fatalError("Could not dequeue as ThirdAddProductTableViewCell")}
            
            if let shiftVC = shiftableVCDelegate {
                cell.shiftableVCdelegate = shiftVC
                cell.manufacturerIdTextField.delegate = shiftVC
                cell.valueTextField.delegate = shiftVC
                cell.weightTextField.delegate = shiftVC
            }
            cell.delegate = self
            cell.valueTextField.text = String(format: "%.2f", (value)) // NumberFormatter.localizedString(from: NSNumber(value: value), number: .currency)
            cell.weightTextField.text = String(format: "%.2f", (weight))
            
            cell.valueTextField.keyboardType = UIKeyboardType.decimalPad
            cell.weightTextField.keyboardType = UIKeyboardType.decimalPad
            
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: fourthReuseIdentifier, for: indexPath) as? FourthAddProductTableViewCell else { fatalError("Could not dequeue as FourthAddProductTableViewCell")}
            cell.delegate = self
            
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: firstReuseIdentifier, for: indexPath) as? FirstAddProductTableViewCell else { fatalError("Could not dequeue as FirstAddProductTableViewCell")}
            if let shiftVC = shiftableVCDelegate {
                cell.shiftableVCdelegate = shiftVC
            }
            cell.delegate = self
            cell.productImageView.image = self.displayImage
            cell.nameTextField.text = self.name
            cell.descriptionTextView.text = self.productDescription
            cell.setNeedsDisplay()
            return cell
        }
       
    }
    
    // MARK: - IBActions
    func saveForLaterTapped(_ sender: Any) {
        let scannARNetworkController = ScannARNetworkController.shared
        
        guard height != 0.0,
            length != 0.0,
            width != 0.0,
            name != "",
            value != 0.0,
            weight != 0.0 else {
                showAlertForMissedInformation()
                return
                
        }
        
        let thumbnailURL = URL(string:thumbnail)
        
        let newProduct = Product(fragile: fragile, height: Double(height), length: Double(length), manufacturerId: manufacturerId, name: name, productDescription: productDescription, value: value, weight: weight, width: Double(width), thumbnail: thumbnailURL, context: CoreDataStack.shared.container.newBackgroundContext())
        let dict = NetworkingHelpers.dictionaryFromProduct(product: newProduct)
        let newProductAsset = ProductAsset(urlString:imageURLString ?? "", name: "Picture1")
        let assetDict = NetworkingHelpers.dictionaryFromProductAsset(productAsset: newProductAsset)
        scannARNetworkController.postNewProduct(dict: dict) { results,error in
            
            if let uuid = results?.last?.uuid {
                
                if newProductAsset.urlString != "" {
                    scannARNetworkController.postNewAssetsForProduct(dict: assetDict, uuid: uuid, completion: { (error) in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: {})
                            return
                        }
                    })
                }
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {})
            }
            
        }
    }

    
    func packItButtonTapped(_ sender: Any){
        let scannARNetworkController = ScannARNetworkController.shared
        
        guard height != 0.0,
            length != 0.0,
            width != 0.0,
            name != "",
            value != 0.0,
            weight != 0.0 else {
                showAlertForMissedInformation()
                return
        }
        
        let thumbnailURL = URL(string:thumbnail)
        
        let newProduct = Product(fragile: fragile, height: Double(height), length: Double(length), manufacturerId: manufacturerId, name: name, productDescription: productDescription, value: value, weight: weight, width: Double(width), thumbnail: thumbnailURL, context: CoreDataStack.shared.container.newBackgroundContext())
        self.product = newProduct
        let dict = NetworkingHelpers.dictionaryFromProduct(product: newProduct)
        let newProductAsset = ProductAsset(urlString:imageURLString ?? "", name: "Picture1")
        let assetDict = NetworkingHelpers.dictionaryFromProductAsset(productAsset: newProductAsset)
        scannARNetworkController.postNewProduct(dict: dict) { results, error in
            
            guard let results = results else {
                self.dismiss(animated: true, completion: {})
                return
            }
            
            guard let result = results.first else {
                self.dismiss(animated: true, completion: {})
                return
            }
            
            let moc = CoreDataStack.shared.mainContext
            let product = Product(productRepresentation: result, context: moc)
            self.product = product
            
            do {
                try moc.save()
            } catch let saveError {
                print("Error saving context: \(saveError)")
            }
            
            if let uuid = product.uuid {
                
                if newProductAsset.urlString != "" {
                    scannARNetworkController.postNewAssetsForProduct(dict: assetDict, uuid: uuid, completion: { (error) in
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "SegueToProductDetail", sender: self)
                            return
                            
                        }
                    })
                }
            }
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "SegueToProductDetail", sender: self)
//
//            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ScanARSegue"{
        guard segue.destination is ARScanMenuScreenViewController else { fatalError("Segue should cast view controller as ARScanMenuScreenViewController but failed to do so.")}
        let transition: CATransition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
            DispatchQueue.main.async {
                self.navigationController!.view.layer.add(transition, forKey: nil)
            }
        } else if segue.identifier == "SegueToProductDetail" {
            
            guard let destVC = segue.destination.children[0] as? ProductDetailContainerViewController else { fatalError("Segue should cast view controller as ProductDetailViewController but failed to do so.")}
            destVC.product = product

        }
    }
    //FIXME: - cancelButtonPressed 
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        ScannARMainViewController.segmentPrimer = 0
        DispatchQueue.main.async {
        
            //self.popToRootViewController
            self.dismiss(animated: true, completion: {})
        }
    }
    
    func scanWithARButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ScanARSegue", sender: sender)
        }
    }
    
    
    func addImageButtonTapped(_ sender: Any) {
        
        showInputScreenToInputPhotoURL()
    }
    
    // MARK: - Properties
    var previewImage: UIImage?
    var shiftableVCDelegate: ShiftableViewController?
    var product: Product?
    var bestBoxSize: (length: Float?, width: Float?, height: Float?)
    @IBOutlet weak var addProductTableView: UITableView!
    var scannARNetworkController: ScannARNetworkController = ScannARNetworkController.shared
    var collectionViewToReload: UICollectionView?
    var isKeyboardAppear = false
    var displayImage: UIImage?
    var manualEntryHidden: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.addProductTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
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
    var thumbnail: String = ""
    var imageURLString: String? {
        didSet {
            guard let url = URL(string: imageURLString!) else {
                displayImage = previewImage
                return
            }
            var imageData: Data
            do {
                imageData = try Data.init(contentsOf: url, options: .alwaysMapped)
            } catch {
                print("Could not get data for image at URL.")
                return
            }
            let image = UIImage(data: imageData) ?? previewImage
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

