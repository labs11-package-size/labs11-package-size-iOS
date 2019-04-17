//
//  RecommendedBoxViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/16/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class RecommendedBoxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let package = package else {fatalError("No package sent to VC")}
        print(package)
        print(package.dimensions)
        print(package.modelURL)
        boxSizeLabel.text = "\(package.identifier) - \(package.dimensions)"
        imageView.image = UIImage(named:"Shipper")
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let destVC = segue.destination as? BuyRecommendedBoxViewController else { fatalError("Destinatation should be BuyRecommendedBoxViewController")}
        destVC.package = self.package
    }
    
    @IBAction func useRecommendedBoxTapped(_ sender: Any) {
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var boxSizeLabel: UILabel!
    var package: Package?
}
