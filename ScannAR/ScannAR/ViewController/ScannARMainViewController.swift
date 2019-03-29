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
        
        self.collectionView!.register(UINib(nibName: "ShipmentsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: shipmentReuseIdentifier)
        self.collectionView!.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: productReuseIdentifier)
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for:.valueChanged)
        setupLongPress()
//        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchNetworkRequests()
    }
    
    // Private Methods
    private func setupLongPress(){
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ScannARMainViewController.handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = false
        self.collectionView?.addGestureRecognizer(lpgr)
    }

    // MARK: - Private Methods
    
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shipmentReuseIdentifier, for: indexPath) as? ShipmentsCollectionViewCell else {fatalError("Unable to dequeue cell as shipment collection view cell")}
            guard let destVC = segue.destination as? ShipmentsDetailViewController else { fatalError("Segue should cast view controller as ProductDetailViewController but failed to do so.")}
            destVC.scannARNetworkingController = self.scannARNetworkingController
            destVC.shipment = cell.shipment
            
        }

    }
 
    // MARK: - CollectionViewDelegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            return shipmentsFetchedResultsController.sections?.count ?? 0
        default:
            return productsFetchedResultsController.sections?.count ?? 0
        }
    
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shipmentReuseIdentifier, for: indexPath) as? ShipmentsCollectionViewCell else { fatalError("Could not dequeue cell as ShipmentsCollectionViewCell") }
            
            let shipment = shipmentsFetchedResultsController.object(at: indexPath)
            
            // Configure the cell
            
            cell.titleLabel.text = "\(shipment.productId)"
            cell.detailLabel.text = "\(shipment.status)"
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productReuseIdentifier, for: indexPath) as? ProductsCollectionViewCell else { fatalError("Could not dequeue cell as ProductsCollectionViewCell") }
            
            let product = productsFetchedResultsController.object(at: indexPath)
            
            // Configure the cell
            cell.product = product
            cell.titleLabel.text = product.name
            cell.detailLabel.text = "$\(product.value)"
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kWhateverHeightYouWant = 100
        return CGSize(width: collectionView.bounds.size.width / 2 - 8, height: CGFloat(kWhateverHeightYouWant))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
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
            print("Add Shipment")
            
        default:
            print("Add Product")
            guard let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewControllerSB") as? AddProductViewController else {fatalError("could not cast presented view controller as AddProductViewController")}
            
            presentedViewController.scannARNetworkController = self.scannARNetworkingController
            presentedViewController.collectionViewToReload = self.collectionView
            presentedViewController.providesPresentationContextTransitionStyle = true
            presentedViewController.definesPresentationContext = true
            presentedViewController.modalPresentationStyle = .overFullScreen
            presentedViewController.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.3)
            self.present(presentedViewController, animated: true, completion: nil)
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
        
        let productToDelete = self.productsFetchedResultsController.object(at: indexPath)
        
        let productName = productToDelete.name ?? ""
        guard let uuid = productToDelete.uuid else {
            print("Error: no UUID associated with the product")
            return
        }
        
        let alert = UIAlertController(title: "Are you sure you want to delete product \(productName)?", message: "Press okay to remove it from the Library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            if action.style == .destructive {
                let productToDelete = self.productsFetchedResultsController.object(at: indexPath)
                self.scannARNetworkingController?.deleteProduct(uuid: uuid, completion: { (error) in
                    
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
                        }
                        
                    }
                })
                
                
            }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    
    
    // MARK: - Properties
    let productReuseIdentifier = "ProductCell"
    let shipmentReuseIdentifier = "ShipmentCell"
    @IBOutlet weak var newProductShipmentBarButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    var scannARNetworkingController: ScannARNetworkController?
    var coreDataImporter: CoreDataImporter = CoreDataImporter(context: CoreDataStack.shared.mainContext)
    private var blockOperation = BlockOperation()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    lazy var productsFetchedResultsController: NSFetchedResultsController<Product> = {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "identifier", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        
        return frc
        
    }()
    
    lazy var shipmentsFetchedResultsController: NSFetchedResultsController<Shipment> = {
        
        let fetchRequest: NSFetchRequest<Shipment> = Shipment.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "identifier", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "status", cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        
        return frc
        
    }()
    
}
