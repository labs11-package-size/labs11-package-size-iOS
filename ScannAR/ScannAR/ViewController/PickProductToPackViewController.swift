//
//  PickProductToPackViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/6/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import CoreData

class PickProductToPackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, ProductPickerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
        tableView.dataSource = self
        tableView.delegate = self
        guard let fetchedObjects = productsFetchedResultsController.fetchedObjects else { return }
        self.allProducts = fetchedObjects
        
        self.tableView.register(UINib(nibName: "PickProductTableViewCell", bundle: nil), forCellReuseIdentifier: pickProductReuseIdentifier)
        
    }

    // MARK: - Private Methods
    private func updateViews(){
        
        styleViews()
        guard let startingProduct = startingProduct else { return }
        pickedProducts.append(startingProduct)
    }
    
    private func styleViews(){
        
        buttonContainerView.layer.cornerRadius = 10
        buttonContainerView.clipsToBounds = true
    }
    
    
    // MARK: - UITableViewDelegate & UITableViewDataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return pickedProducts.count
        default:
            return productsToPick.count
        }
        
    }
    
    // MARK: ProductPickerDelegates
    func updateProduct(_ product: Product) {
        if pickedProducts.contains(product){
            self.pickedProducts.remove(object: product)
            
        } else {
            self.pickedProducts.append(product)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80))
            view.backgroundColor = UIColor(named: "appARKADarkBlue")
            view.clipsToBounds = true
            view.layer.cornerRadius = 6
            
            let label = UILabel(frame: CGRect(x: 8, y: 0, width: Int(view.bounds.width), height: 30))
            label.text = "Products Added - (\(pickedProducts.count))"
            label.textColor = .white
            label.font = .preferredFont(forTextStyle: .title3)
            view.addSubview(label)
            return view
        default:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80))
            view.backgroundColor = UIColor(named: "appARKADarkBlue")
            view.clipsToBounds = true
            view.layer.cornerRadius = 6
            
            let label = UILabel(frame: CGRect(x: 8, y: 0, width: Int(view.bounds.width), height: 30))
            label.text = "Available Products - (\(productsToPick.count))"
            label.textColor = .white
            label.font = .preferredFont(forTextStyle: .title3)
            view.addSubview(label)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80))
        view.backgroundColor = UIColor(named: "appARKATeal")
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: pickProductReuseIdentifier, for: indexPath) as? PickProductTableViewCell else { fatalError("Unable to Dequeue cell as PickProductTableViewCell")}
            
            let product = pickedProducts[indexPath.row]
            
            cell.layer.cornerRadius = 6
            cell.addRemoveButton.setTitle("Remove", for: .normal)
            cell.product = product
            cell.productNameLabel.text = product.name
            cell.delegate = self
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: pickProductReuseIdentifier, for: indexPath) as? PickProductTableViewCell else { fatalError("Unable to Dequeue cell as PickProductTableViewCell")}
            
            let product = productsToPick[indexPath.row]
            
            cell.layer.cornerRadius = 6
            cell.clipsToBounds = true
            cell.addRemoveButton.setTitle("Add", for: .normal)
            cell.product = product
            cell.productNameLabel.text = product.name
            cell.delegate = self
            
            return cell
        }
        
    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PreviewPackagingSegue" {
            guard let destVC = segue.destination as? CardsViewController else { return }
            destVC.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "appARKADarkBlue")
            destVC.navigationController?.navigationBar.isTranslucent = true
            destVC.navigationController?.navigationBar.backgroundColor = UIColor.clear
            destVC.navigationController?.navigationBar.alpha = 0.1
            destVC.navigationController?.setNavigationBarHidden(false, animated: false)
            destVC.products = self.pickedProducts
            switch boxSegmentedControl.selectedSegmentIndex {
            case 0:
                print("No Box.")
            case 1:
                destVC.boxType = .shipper
            default:
                destVC.boxType = .mailer
            }
        }
    }

    // MARK: - IBActions
    @IBAction func previewPackages(_ sender: Any) {
        
        guard pickedProducts.count > 0 else { return }
        
    }

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var previewPackagesButton: UIButton!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var boxSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    var pickedProducts: [Product] = [] {
        didSet {
            self.productsToPick = allProducts.filter { !pickedProducts.contains($0)}
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.previewPackagesButton.setTitle("Preview Products (\(self.pickedProducts.count))", for: .normal)
            }
        }
    }
    var startingProduct: Product?
    var productsToPick: [Product] = []
    var allProducts: [Product] = [] {
        didSet {
            self.productsToPick = allProducts.filter { !pickedProducts.contains($0)}
        }
    }
    
    let pickProductReuseIdentifier = "PickProductCell"
    lazy var productsFetchedResultsController: NSFetchedResultsController<Product> = {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "lastUpdated", ascending: false)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "name", cacheName: nil)
        
        frc.delegate = self
        try? frc.performFetch()
        
        return frc
        
    }()
    
}
