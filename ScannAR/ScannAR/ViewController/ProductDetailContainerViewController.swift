//
//  ProductDetailContainerViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/19/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ProductDetailContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let product = product else { fatalError("No product sent to Container VC")}
        
        if segue.identifier == "EmbedSegue" {
            guard let destVC = segue.destination as? ProductDetailViewController else { fatalError("Embed Segue not going to ProductDetailViewController")}
            destVC.product = product
        }
    }
    
    // MARK: - Properties
    
    var product: Product?

}
