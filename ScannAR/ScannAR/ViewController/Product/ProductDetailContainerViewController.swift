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
            
            self.delgateForButtomContainer = destVC
            destVC.product = product
            destVC.containerVC = self
        } else if segue.identifier == "EmbedBottomSegue" {
            guard let destVC = segue.destination as? BottomButtonContainerViewController else { fatalError("Embed Segue not going to ProductDetailViewController")}
            destVC.delegate = delgateForButtomContainer
            destVC.progressBarDelegate = progressBarDelgateForButtomContainer
            self.delgateForButtomContainer?.bottomButtonDelegate = destVC
            
        } else if segue.identifier == "EmbedTopSegue" {
            guard let destVC = segue.destination as? ProgressViewController else { fatalError("Embed Segue not going to ProductDetailViewController")}
            self.progressBarDelgateForButtomContainer = destVC
        }
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var productDetailContainerView: UIView!
    var delgateForButtomContainer: ProductDetailViewController?
    var progressBarDelgateForButtomContainer: ProgressViewController?
    var product: Product?

}
