//
//  ScannARMainViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import CoreData

class ScannARMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register Collection View Cells
        self.collectionView!.register(UINib(nibName: "ShipmentsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: shipmentReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: productReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "PackagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: packageReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "AddProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: addProductReuseIdentifier)
        
        // set up collection view delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupSegmentedControl()
        setupLongPress()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        segmentedControl.selectedSegmentIndex = ScannARMainViewController.segmentPrimer
        getAccount()
        fetchNetworkRequests()
        
    }
    
    // Private Methods
    
    private func getAccount(){
        
        scannARNetworkingController.getUserAccountInfo { (result, error) in
            
            if let error = error {
                print("There was an error getting your account information: \(error)")
                return
            }
            
            guard let result = result else {fatalError("There was no Account information returned for the user.")}
            
            self.account = result
            
        }
        
    }
    
    private func setupSegmentedControl(){
        segmentedControl.selectedSegmentIndex = ScannARMainViewController.segmentPrimer
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for:.valueChanged)
    }
    
    private func loadImage(forCell cell: ProductsCollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoReference = productsFetchedResultsController.object(at: indexPath)
        guard let thumbnail = photoReference.thumbnail else {
            cell.productImageView.image = UIImage(named: "ET")
            return
            
        }
        
        guard let uuid = photoReference.uuid else { return }
        // Check for image in cache
        
        if let cachedImage = cache.value(for: uuid) {
            cell.productImageView.image = cachedImage
            return
            
        }
        // Start an operation to fetch image data
        let fetchOp = FetchPhotoOperation(photoReference: photoReference)
        let cacheOp = BlockOperation {
            if let image = fetchOp.image {
                self.cache.cache(value: image, for: uuid)
            }
        }
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: uuid) }
            
            if let currentIndexPath = self.collectionView?.indexPath(for: cell){
                
                var newCurrentIndexPath: IndexPath
                if currentIndexPath.section == 0 {
                    newCurrentIndexPath = IndexPath(item: currentIndexPath.item - 1, section: 0)
                } else {
                    newCurrentIndexPath = currentIndexPath
                }
                
                if newCurrentIndexPath != indexPath {
                    return // Cell has been reused
                }
                
            }
            
            if let image = fetchOp.image {
                cell.productImageView.image = image
                
            }
        }
        
        cacheOp.addDependency(fetchOp)
        completionOp.addDependency(fetchOp)
        
        photoFetchQueue.addOperation(fetchOp)
        photoFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(completionOp)
        
        operations[uuid] = fetchOp
    }
    
    private func setupLongPress(){
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ScannARMainViewController.handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = false
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    private func flashSaveOnServerNoticeToUser(_ name: String, type: String) {
        DispatchQueue.main.async {
            let popup = UIView(frame: CGRect(x: self.view.center.x - 100, y: self.view.center.y - 200, width: 200, height: 200))
            popup.alpha = 1
            
            popup.layer.cornerRadius = 20
            popup.backgroundColor = .white
            popup.layer.shadowColor = UIColor.gray.cgColor
            popup.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            popup.layer.shadowRadius = 2.0
            popup.layer.shadowOpacity = 1.0
            popup.layer.masksToBounds = false
            popup.layer.shadowPath = UIBezierPath(roundedRect:popup.bounds, cornerRadius:popup.layer.cornerRadius).cgPath
            
            let label = UILabel()
            
            label.text = "\(name)\n\(type)"
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 4
            label.font = UIFont.systemFont(ofSize: 14)
            
            popup.addSubview(label)
            self.view.addSubview(popup)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: popup.centerYAnchor).isActive = true
            let widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160)
            label.addConstraint(widthConstraint)
            
            UIView.animate(withDuration: 3, animations: {
                popup.alpha = 0
            }, completion: { _ in
                popup.removeFromSuperview()
            })
            
        }
        
    }
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        fetchNetworkRequests()
        
    }
    
    
    private func fetchNetworkRequests(){
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            
            scannARNetworkingController.getPackages(completion: { (results, error) in
                
                guard let results = results else {
                    return
                }
               
                self.coreDataImporter.syncPackages(packageRepresentations: results, completion: { (error) in
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            })
        
        case 2:
            
            scannARNetworkingController.getShipments { (results, error) in
                
                guard let results = results else {
                    return
                }
                
                self.coreDataImporter.syncShipments(shipmentRepresentations: results, completion: { (error) in
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
                
            }
            
        
        default:
            
            scannARNetworkingController.getProducts { (results, error) in
                
                guard let results = results else {
                    return
                }
                
                self.coreDataImporter.syncProducts(productRepresentations: results, completion: { (error) in
                    
                    DispatchQueue.main.async {
                        self.photoReferences = self.productsFetchedResultsController.fetchedObjects ?? []
                        self.collectionView.reloadData()
                    }
                })
                
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AccountViewSegue" {
            ScannARMainViewController.segmentPrimer = segmentedControl.selectedSegmentIndex
            
        } else if segue.identifier == "ProductDetailSegue" {
            
            ScannARMainViewController.segmentPrimer = 0
            
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {fatalError("No selected indexPath")}
            var newIndexPath: IndexPath
            if indexPath.section == 0 {
                newIndexPath = IndexPath(item: indexPath.item - 1, section: 0)
            } else {
                newIndexPath = indexPath
            }
            let product = productsFetchedResultsController.object(at: newIndexPath)
            guard let destVC = segue.destination.children[0] as? ProductDetailContainerViewController else { fatalError("Segue should cast view controller as ProductDetailViewController but failed to do so.")}
            destVC.product = product
            
        } else if segue.identifier == "ShipmentDetailSegue" {
            
            ScannARMainViewController.segmentPrimer = 2
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {fatalError("No selected indexPath")}
            let shipment = shipmentsFetchedResultsController.object(at: indexPath)
            guard let destVC = segue.destination.children[0] as? ShipmentsDetailContainerViewController else { fatalError("Segue should cast view controller as ShipmentTrackingMainViewController but failed to do so.")}
            destVC.shipment = shipment
            
        } else if segue.identifier == "ARScanMainMenuShow" {
            guard segue.destination is ARScanMenuScreenViewController else { fatalError("Segue should cast view controller as ARScanMenuScreenViewController but failed to do so.")}
            let transition: CATransition = CATransition()
            transition.duration = 0.7
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            self.navigationController!.view.layer.add(transition, forKey: nil)
        } else if segue.identifier == "PackageDetailSegue" {
             ScannARMainViewController.segmentPrimer = 1
            guard let destVC = segue.destination.children[0] as? PackageDetailContainerViewController else { fatalError("Segue should cast view controller as PackageDetailViewController but failed to do so.")}
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {fatalError("No selected indexPath")}
            let package = packagesFetchedResultsController.object(at: indexPath)
            destVC.package = package
        }
        
        

    }
 
    // MARK: - CollectionViewDelegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            return packagesFetchedResultsController.sections?.count ?? 0
        case 2:
            return shipmentsFetchedResultsController.sections?.count ?? 0
        default:
            return productsFetchedResultsController.sections?.count ?? 0 + 1
        }
    
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            if packagesFetchedResultsController.sections?.count ?? 0 > 0 {
                return packagesFetchedResultsController.sections?[section].numberOfObjects ?? 0
            } else {
                return 0
            }
        case 2:
            if shipmentsFetchedResultsController.sections?.count ?? 0 > 0 {
                return shipmentsFetchedResultsController.sections?[section].numberOfObjects ?? 0
            } else {
                return 0
            }
        default:
            if section == 0 {
                if productsFetchedResultsController.sections?.count ?? 0 > 0 {
                    return productsFetchedResultsController.sections?[section].numberOfObjects ?? 0 + 1
                } else {
                    return 1
                }
            } else {
                if productsFetchedResultsController.sections?.count ?? 0 > 0 {
                    return productsFetchedResultsController.sections?[section].numberOfObjects ?? 0
                } else {
                    return 0
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: packageReuseIdentifier, for: indexPath) as? PackagesCollectionViewCell else { fatalError("Could not dequeue cell as PackageCollectionViewCell") }
            
            let package = packagesFetchedResultsController.object(at: indexPath)
            
            // Configure the cell
            cell.package = package
            
            if let dimensions = package.dimensions {
                if let boxType = Box.boxVarieties[dimensions] {
                    
                    switch boxType {
                    case .shipper:
                        cell.boxImageView.image = UIImage(named: "Shipper")
                    default:
                        cell.boxImageView.image = UIImage(named: "standardMailerBox")
                    }
                } else {
                    cell.boxImageView.image = UIImage(named: "Shipper")
                }
                
            } else {
                cell.boxImageView.image = UIImage(named: "Shipper")
            }
            
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            
            guard let dimensions = package.dimensions,
                let productNames = package.productNames else { return cell }
            
            cell.dimensionsLabel.text = "\(dimensions)"
            cell.numberOfProductsLabel.text = "\(productNames.count)"
            cell.productNamesLabel.text = "Products:\n\(productNames.joined(separator: ", "))"
            
            return cell
        
        case 2:
            
            let shipment = shipmentsFetchedResultsController.object(at: indexPath)
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shipmentReuseIdentifier, for: indexPath) as? ShipmentsCollectionViewCell else { fatalError("Could not dequeue cell as ShipmentsCollectionViewCell") }
            
            cell.shipment = shipment
            
            guard let dimensions = shipment.dimensions else {fatalError("No dimensions associated with that shipment.")}
            
            if let boxType = Box.boxVarieties[dimensions] {
                
                switch boxType {
                case .shipper:
                    cell.imageView.image = UIImage(named: "Shipper")
                default:
                    cell.imageView.image = UIImage(named: "standardMailerBox")
                }
            } else {
                cell.imageView.image = UIImage(named: "Shipper")
            }
            
            
            
            // Configure the cell
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            
            cell.statusLabel.text = "Status: \(ShipmentStatus.dict[Int(shipment.status)]!)"
            
            cell.trackingNumberLabel.text = "Tracking #: \(shipment.trackingNumber ?? "N/A")"
            guard let shippedTo = shipment.shippedTo else { return cell }
            cell.shippedToLabel.text = "To: \(shippedTo)"
            
            // make emoji identifiers
            var emojiString = ""
            
            switch shipment.status {
            case 0:
                emojiString = "❓"
            case 1:
                emojiString = "📬"
            case 2:
                emojiString = "✈️"
            case 3:
                emojiString = "🚛"
            case 4:
                emojiString = "🏠"
            default:
                emojiString = "⏱"
            }
            
            switch shipment.totalValue {
            case (Double.greatestFiniteMagnitude * -1)..<10.00:
                emojiString = "\(emojiString) 💲"
            case 10.00..<100.00:
                emojiString = "\(emojiString) 💲💲"
            default:
                emojiString = "\(emojiString) 💲💲💲"
            }
            
            switch shipment.totalWeight {
            case (Double.greatestFiniteMagnitude * -1)..<100.00:
                emojiString = "\(emojiString)"
            default:
                emojiString = "\(emojiString) 🐘"
            }
            cell.emojiTextLabel.text = emojiString
            
            return cell
            
        default:
            
            if indexPath.section == 0 && indexPath.item == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addProductReuseIdentifier, for: indexPath) as? AddProductCollectionViewCell else { fatalError("Could not dequeue cell as AddProductCollectionViewCell") }
                
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.layer.borderWidth = 1.0
                
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.masksToBounds = true
                
                cell.layer.shadowColor = UIColor.gray.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cell.layer.shadowRadius = 2.0
                cell.layer.shadowOpacity = 1.0
                cell.layer.cornerRadius = 8
                cell.layer.masksToBounds = false
                cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
                
                return cell
            }
            
            var newIndexPath: IndexPath
            if indexPath.section == 0 {
                newIndexPath = IndexPath(item: indexPath.item - 1, section: 0)
            } else {
                newIndexPath = indexPath
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productReuseIdentifier, for: newIndexPath) as? ProductsCollectionViewCell else { fatalError("Could not dequeue cell as ProductsCollectionViewCell") }
            
            let product = productsFetchedResultsController.object(at: newIndexPath)
            
            // Configure the cell
            if photoReferences.count > 0 {
                loadImage(forCell: cell, forItemAt: newIndexPath)
            }
            
            cell.product = product
            cell.titleLabel.text = product.name
            cell.detailLabel.text = "$\(product.value)"
            cell.lwhLabel.text = "L: \(product.length) | W: \(product.width) | H: \(product.height)"
            cell.weightLabel.text = "\(product.weight) lbs"

            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kWhateverHeightYouWant = 180
        
        let cgSizeToReturn = segmentedControl.selectedSegmentIndex == 2 ? CGSize(width: collectionView.bounds.size.width - 8, height: CGFloat(kWhateverHeightYouWant)) : CGSize(width: collectionView.bounds.size.width / 2 - 8, height: CGFloat(kWhateverHeightYouWant))
        
        return cgSizeToReturn
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            performSegue(withIdentifier: "PackageDetailSegue", sender: nil)
        case 2:
            performSegue(withIdentifier: "ShipmentDetailSegue", sender: nil)
        default:
            if indexPath.section == 0 && indexPath.item == 0 {
                performSegue(withIdentifier: "ShowAddProductSegue", sender: nil)
            } else {
                performSegue(withIdentifier: "ProductDetailSegue", sender: nil)
            }
            
        }
        
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperation = BlockOperation()
    }
    
    // MARK: - IBActions
    @IBAction func addButtonClicked(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            print("Add Package")
        case 2:
            print("Add Shipment")
            
        default:
            
            performSegue(withIdentifier: "ShowAddProductSegue", sender: nil)
        
        }
    }
    
    @IBAction func unwindToScannARMainViewController(segue: UIStoryboardSegue) {
        let transition: CATransition = CATransition()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.moveIn
        self.navigationController!.view.layer.add(transition, forKey: nil)
    }

    // MARK: - Tap gesture Recognizer
    @objc (handleLongPressWithGestureRecognizer:)
    func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        let p = gestureRecognizer.location(in: self.collectionView)
        
        if let indexPath : IndexPath = (self.collectionView?.indexPathForItem(at: p)){
            
            if indexPath.section == 0 && indexPath.item == 0 && self.segmentedControl.selectedSegmentIndex == 0 {
                return
            }
            if (gestureRecognizer.state != UIGestureRecognizer.State.ended){
                return
            }
            
            //do whatever you need to do
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            var newIndexPath: IndexPath
            if indexPath.section == 0 && self.segmentedControl.selectedSegmentIndex == 0 {
                newIndexPath = IndexPath(item: indexPath.item - 1, section: 0)
            } else {
                newIndexPath = indexPath
            }
            
            displayAlertViewController(for: newIndexPath)
            
        }
        
    }
    
    
    // MARK: - Display Alert View Controller
    func displayAlertViewController(for indexPath: IndexPath){
        
        let itemName: String
        let itemUUID: UUID
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            let itemToDelete = self.packagesFetchedResultsController.object(at: indexPath)
            itemName = itemToDelete.uuid?.uuidString ?? ""
            itemUUID = itemToDelete.uuid!
        case 2:
            let itemToDelete = self.shipmentsFetchedResultsController.object(at: indexPath)
            itemName = itemToDelete.shippedTo ?? ""
            itemUUID = itemToDelete.uuid!
            
        default:
            
            let itemToDelete = self.productsFetchedResultsController.object(at: indexPath)
            itemName = itemToDelete.name ?? ""
            itemUUID = itemToDelete.uuid!
        }
        
        
        let alert = UIAlertController(title: "Are you sure you want to delete \(itemName)?", message: "Press okay to remove it from the Library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            if action.style == .destructive {
                
                switch self.segmentedControl.selectedSegmentIndex {
                case 1:
                    
                    let packageToDelete = self.packagesFetchedResultsController.object(at: indexPath)
                    // delete Package networking below once route is created.
                    self.scannARNetworkingController.deletePackage(uuid: itemUUID, completion: { (error) in

                        if let error = error {
                            print("Error deleting object: \(error)")
                        }

                        let moc = CoreDataStack.shared.mainContext
                        moc.perform {
                            moc.delete(packageToDelete)

                            do {
                                try moc.save()
                            } catch let saveError {
                                print("Error saving context: \(saveError)")
                            }
                            DispatchQueue.main.async {
                                
                                self.collectionView.reloadData()
                                
                                    self.flashSaveOnServerNoticeToUser(itemName, type: "Deleted")
                            }

                        }
                    })
                    
                case 2:
                    let shipmentToDelete = self.shipmentsFetchedResultsController.object(at: indexPath)
                    self.scannARNetworkingController.deleteShipment(uuid: itemUUID, completion: { (results, error) in
                        
                        if let error = error {
                            print("Error deleting object: \(error)")
                        }
                        
                        let moc = CoreDataStack.shared.mainContext
                        moc.perform {
                            moc.delete(shipmentToDelete)
                            
                            do {
                                try moc.save()
                            } catch let saveError {
                                print("Error saving context: \(saveError)")
                            }
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.flashSaveOnServerNoticeToUser(itemName, type: "Deleted")
                            }
                            
                        }
                    })
                    
                default:
                    let productToDelete = self.productsFetchedResultsController.object(at: indexPath)
                    self.scannARNetworkingController.deleteProduct(uuid: itemUUID, completion: { (error) in
                        
                        if let error = error {
                            print("Error deleting object: \(error)")
                        }
                        
                        let moc = CoreDataStack.shared.mainContext
                        moc.perform {
                            moc.delete(productToDelete)
                            
                            do {
                                try moc.save()
                            } catch let saveError {
                                print("Error saving context: \(saveError)")
                            }
                            DispatchQueue.main.async {
                                self.photoReferences = self.productsFetchedResultsController.fetchedObjects ?? []
                                self.collectionView.reloadData()
                                self.flashSaveOnServerNoticeToUser(itemName, type: "Deleted")
                            }
                            
                        }
                    })
                }
                
                
                
            }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    let addProductReuseIdentifier = "AddProductCell"
    let productReuseIdentifier = "ProductCell"
    let packageReuseIdentifier = "PackageCell"
    let shipmentReuseIdentifier = "ShipmentCell"
    static var segmentPrimer: Int = 0
    var account: Account?
    @IBOutlet weak var newProductShipmentBarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    var scannARNetworkingController = ScannARNetworkController.shared
    lazy var coreDataImporter: CoreDataImporter = { CoreDataImporter(context: CoreDataStack.shared.mainContext)
        }()
    private var blockOperation = BlockOperation()
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        willSet {
            ScannARMainViewController.segmentPrimer = newValue.selectedSegmentIndex
        }
    }
    private let cache = Cache<UUID, UIImage>()
    private let photoFetchQueue = OperationQueue()
    private var operations = [UUID : Operation]()
    private var photoReferences = [Product]() {
        didSet {
            cache.clear()
        }
    }
    
    lazy var productsFetchedResultsController: NSFetchedResultsController<Product> = {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "lastUpdated", ascending: false)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "fragile", cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        
        return frc
        
    }()
    
    lazy var packagesFetchedResultsController: NSFetchedResultsController<Package> = {
        
        let fetchRequest: NSFetchRequest<Package> = Package.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "lastUpdated", ascending: false)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "dimensions", cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        
        return frc
        
    }()
    
    lazy var shipmentsFetchedResultsController: NSFetchedResultsController<Shipment> = {
        
        let fetchRequest: NSFetchRequest<Shipment> = Shipment.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "status", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "status", cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        
        return frc
        
    }()
    
}
