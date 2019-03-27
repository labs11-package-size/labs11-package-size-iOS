//
//  ScannARMainViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import CoreData

class ScannARMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for:.valueChanged)
//        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchNetworkRequests()
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
        
        guard let scannARNetworkingController = scannARNetworkingController else { fatalError("Uh oh. There is not networking controller present")}
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
        
        default:
            
            scannARNetworkingController.getProducts(completion: { (results, error) in
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegateMethods
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ShipmentsCollectionViewCell else { fatalError("Could not dequeue cell as FavoritesCollectionViewCell") }
            
            let shipment = shipmentsFetchedResultsController.object(at: indexPath)
            
            // Configure the cell
            cell.titleLabel.text = shipment.carrierName
            cell.detailLabel.text = "\(shipment.status)"
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProductsCollectionViewCell else { fatalError("Could not dequeue cell as FavoritesCollectionViewCell") }
            
            let product = productsFetchedResultsController.object(at: indexPath)
            
            // Configure the cell
            cell.titleLabel.text = product.name
            cell.detailLabel.text = "\(product.identifier)"
            
            return cell
        }
        
        
    }
    
    // MARK: - Properties
    let reuseIdentifier = "DetailCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    var scannARNetworkingController: ScannARNetworkController?
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    lazy var productsFetchedResultsController: NSFetchedResultsController<Product> = {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "identifier", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "value", cacheName: nil)
        
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
