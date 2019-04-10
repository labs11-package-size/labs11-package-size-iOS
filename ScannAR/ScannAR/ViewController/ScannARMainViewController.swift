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
    
//    @IBAction func unwindToScannARMainViewController(segue: UIStoryboardSegue) {
//        //nothing goes here
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UINib(nibName: "ShipmentsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: shipmentReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: productReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "PackagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: packageReuseIdentifier)
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for:.valueChanged)
        setupLongPress()
//        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        scannARNetworkingController = ScannARNetworkController.shared
        fetchNetworkRequests()
        
    }
    
    // Private Methods
    
    private func loadImage(forCell cell: ProductsCollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoReference = photoReferences[indexPath.item]
        // Check for image in cache
        if let cachedImage = cache.value(for: photoReference.uuid) {
            cell.productImageView.image = cachedImage
            return
        }
        
        // Start an operation to fetch image data
        let fetchOp = FetchPhotoOperation(photoReference: photoReference)
        let cacheOp = BlockOperation {
            if let image = fetchOp.image {
                self.cache.cache(value: image, for: photoReference.uuid)
            }
        }
        let completionOp = BlockOperation {
            defer { self.operations.removeValue(forKey: photoReference.uuid) }
            
            if let currentIndexPath = self.collectionView?.indexPath(for: cell),
                currentIndexPath != indexPath {
                return // Cell has been reused
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
        
        operations[photoReference.uuid] = fetchOp
    }
    
    private func setupLongPress(){
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ScannARMainViewController.handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = false
        self.collectionView?.addGestureRecognizer(lpgr)
    }

    // MARK: - Private Methods
    
    private func flashSaveOnServerNoticeToUser(_ name: String, type: String) {
        DispatchQueue.main.async {
            let popup = UIView(frame: CGRect(x: self.view.center.x - 100, y: self.view.center.y - 100, width: 200, height: 200))
            popup.alpha = 1
            popup.backgroundColor = .gray
            
            let label = UILabel()
            
            label.text = "\(name) \(name)"
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
    
//    private func setupSearchBar() {
//        let swipeDown = UISwipeGestureRecognizer(target: collectionView, action: #selector(down))
//        swipeDown.direction = .down
//        let swipeUp = UISwipeGestureRecognizer(target: collectionView, action: #selector(up))
//        swipeUp.direction = .up
//
//        self.view.addGestureRecognizer(swipeDown)
//        self.view.addGestureRecognizer(swipeUp)
//
//        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 40.0))
//        searchBar.isUserInteractionEnabled = false
//        self.searchBar!.alpha = 0.0
//        if let searchBar = searchBar
//        {
//            searchBar.backgroundColor = UIColor.red
//            self.view.addSubview(searchBar)
//        }
//    }
//
//    @objc private func down(sender: UIGestureRecognizer) {
//        print("down")
//        //show bar
//        searchBar.isUserInteractionEnabled = true
//        UIView.animate(withDuration: 0.2, animations: { () -> Void in
//            self.searchBar!.alpha = 1.0
//            self.searchBar!.frame = CGRect(x: 0.0, y: 129.0, width: self.view.frame.width, height: 40.0)
//        }, completion: { (Bool) -> Void in
//        })
//    }
//
//    @objc private func up(sender: UIGestureRecognizer) {
//        print("up")
//        searchBar.isUserInteractionEnabled = false
//        UIView.animate(withDuration: 0.2, animations: { () -> Void in
//            self.searchBar!.alpha = 0.0
//            self.searchBar!.frame = CGRect(x: 0.0, y: 129.0, width: self.view.frame.width, height: 40.0)
//        }, completion: { (Bool) -> Void in
//        })
//    }
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        fetchNetworkRequests()
        
    }
    
    
    private func fetchNetworkRequests(){
        
        guard let scannARNetworkingController = scannARNetworkingController else { fatalError("Uh oh. There is no networking controller present")}
        
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
                    self.photoReferences = results
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
                
            }
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegateMethods
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AccountViewSegue" {
            guard let destVC = segue.destination as? AccountViewController else { fatalError("Segue should cast view controller as AccountViewController but failed to do so.")}
            destVC.scannARNetworkingController = self.scannARNetworkingController
        } else if segue.identifier == "ProductDetailSegue" {
            
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {fatalError("No selected indexPath")}
            let product = productsFetchedResultsController.object(at: indexPath)
            guard let destVC = segue.destination as? ProductDetailViewController else { fatalError("Segue should cast view controller as ProductDetailViewController but failed to do so.")}
            destVC.scannARNetworkingController = self.scannARNetworkingController
            destVC.product = product
            
        } else if segue.identifier == "ShipmentDetailSegue" {
            
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {fatalError("No selected indexPath")}
            let shipment = shipmentsFetchedResultsController.object(at: indexPath)
            guard let destVC = segue.destination as? ShipmentsDetailViewController else { fatalError("Segue should cast view controller as ProductDetailViewController but failed to do so.")}
            destVC.scannARNetworkingController = self.scannARNetworkingController
            destVC.shipment = shipment
            
        } else if segue.identifier == "ShowAddProductSegue" {
        
        } else if segue.identifier == "ARScanMainMenuShow" {
            guard segue.destination is ARScanMenuScreenViewController else { fatalError("Segue should cast view controller as ARScanMenuScreenViewController but failed to do so.")}
            let transition: CATransition = CATransition()
            transition.duration = 0.7
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            self.navigationController!.view.layer.add(transition, forKey: nil)
        } else if segue.identifier == "PackageDetailSegue" {
            guard let destVC = segue.destination as? PackageDetailViewController else { fatalError("Segue should cast view controller as PackageDetailViewController but failed to do so.")}
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {fatalError("No selected indexPath")}
            let package = packagesFetchedResultsController.object(at: indexPath)
            destVC.scannARNetworkingController = self.scannARNetworkingController
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
            return productsFetchedResultsController.sections?.count ?? 0
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
            if productsFetchedResultsController.sections?.count ?? 0 > 0 {
                return productsFetchedResultsController.sections?[section].numberOfObjects ?? 0
            } else {
                return 0
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
            cell.productNamesLabel.text = "Products in Package: \(productNames.joined(separator: ", "))"
            
            
            
            return cell
        
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shipmentReuseIdentifier, for: indexPath) as? ShipmentsCollectionViewCell else { fatalError("Could not dequeue cell as ShipmentsCollectionViewCell") }
            
            let shipment = shipmentsFetchedResultsController.object(at: indexPath)
            
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
            
            cell.statusLabel.text = "Status: \(shipment.status)"
            cell.totalWeightLabel.text = "Weight: \(shipment.totalWeight)"
            cell.trackingNumberLabel.text = "Tracking #: \(shipment.trackingNumber ?? "N/A")"
            
            guard
                let shippedTo = shipment.shippedTo else { return cell }
            cell.shippedToLabel.text = "To: \(shippedTo)"
            
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productReuseIdentifier, for: indexPath) as? ProductsCollectionViewCell else { fatalError("Could not dequeue cell as ProductsCollectionViewCell") }
            
            let product = productsFetchedResultsController.object(at: indexPath)
            
            
            
            // Configure the cell
            if photoReferences.count > 0 {
                loadImage(forCell: cell, forItemAt: indexPath)
            }
            
            cell.product = product
            cell.titleLabel.text = product.name
            cell.detailLabel.text = "$\(product.value)"
            cell.lwhLabel.text = "L: \(product.length) | W: \(product.width) | H: \(product.height)"
            cell.weightLabel.text = "\(product.weight) lbs"
            
//            if let urlString = product.thumbnail {
//
//                if let url = URL(string: urlString){
//                    var data: Data
//                    do {
//                        data = try Data(contentsOf: url)
//                    } catch {
//                        print("Could not get image from Thumbnail image URL.")
//                        return cell
//                    }
//
//                    DispatchQueue.main.async {
//                        cell.productImageView.image = UIImage(data: data)
//                    }
//                }
//            }
            
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
        return CGSize(width: collectionView.bounds.size.width / 2 - 8, height: CGFloat(kWhateverHeightYouWant))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            performSegue(withIdentifier: "PackageDetailSegue", sender: nil)
        case 2:
            performSegue(withIdentifier: "ShipmentDetailSegue", sender: nil)
        default:
            performSegue(withIdentifier: "ProductDetailSegue", sender: nil)
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

    // MARK: - Tap gesture Recognizer
    @objc (handleLongPressWithGestureRecognizer:)
    func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizer.State.ended){
            return
        }
        
        let p = gestureRecognizer.location(in: self.collectionView)
        
        if let indexPath : IndexPath = (self.collectionView?.indexPathForItem(at: p)){
            //do whatever you need to do
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            displayAlertViewController(for: indexPath)
            
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
                    self.scannARNetworkingController?.deletePackage(uuid: itemUUID, completion: { (error) in

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
                    self.scannARNetworkingController?.deleteShipment(uuid: itemUUID, completion: { (results, error) in
                        
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
                    self.scannARNetworkingController?.deleteProduct(uuid: itemUUID, completion: { (error) in
                        
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
    
    // MARK: - Navigation
    
    
    
    // MARK: - Properties
    let productReuseIdentifier = "ProductCell"
    let packageReuseIdentifier = "PackageCell"
    let shipmentReuseIdentifier = "ShipmentCell"
    @IBOutlet weak var newProductShipmentBarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    var scannARNetworkingController: ScannARNetworkController?
    var coreDataImporter: CoreDataImporter = CoreDataImporter(context: CoreDataStack.shared.mainContext)
    private var blockOperation = BlockOperation()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private let cache = Cache<UUID, UIImage>()
    private let photoFetchQueue = OperationQueue()
    private var operations = [UUID : Operation]()
    private var photoReferences = [ProductRepresentation]() {
        didSet {
//            cache.clear()
            DispatchQueue.main.async { self.collectionView?.reloadData() }
        }
    }
    
    lazy var productsFetchedResultsController: NSFetchedResultsController<Product> = {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "lastUpdated", ascending: false)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "lastUpdated", cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        
        return frc
        
    }()
    
    lazy var packagesFetchedResultsController: NSFetchedResultsController<Package> = {
        
        let fetchRequest: NSFetchRequest<Package> = Package.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "identifier", ascending: false)
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
            NSSortDescriptor(key: "status", ascending: false)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "status", cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        
        return frc
        
    }()
    
}
