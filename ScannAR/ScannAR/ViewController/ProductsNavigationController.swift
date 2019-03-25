//
//  ProductsNavigationController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ProductsNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destVC = segue.destination as? ProductsViewController else { return }
        destVC.scannARNetworkingController = self.scannARNetworkingController
    }

    var scannARNetworkingController: ScannARNetworkController?
}