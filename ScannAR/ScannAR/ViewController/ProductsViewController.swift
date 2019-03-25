//
//  ProductsViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        guard let scannARNetworkingController = scannARNetworkingController else { fatalError("No networking controller present")}
//
//        scannARNetworkingController.getProducts(completion: { (string, error) in
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 
    // MARK: - CollectionViewDelegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProductsCollectionViewCell else { fatalError("Could not dequeue cell as FavoritesCollectionViewCell") }
        
        return cell
    }
    
    // MARK: - Properties
    let reuseIdentifier = "ProductCell"
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var shippingButton: UIButton!
    var scannARNetworkingController: ScannARNetworkController?
}
