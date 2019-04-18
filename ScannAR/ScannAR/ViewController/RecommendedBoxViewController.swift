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
        updateViews()
    }
    
    // MARK: - Private Methods
    private func updateViews(){
        
        
        guard let package = package else {fatalError("No package sent to VC")}
        guard let dimensions = package.dimensions else {fatalError("No package dimensions")}
        boxSizeLabel.text = dimensions
        if let boxType = Box.boxVarieties[dimensions] {
            imageView.image = boxType == .shipper ? UIImage(named:"Shipper") : UIImage(named:"standardMailerBox")
            
        } else {
            imageView.image = UIImage(named:"Shipper")
        }
        
        useRecommendedBoxButton.layer.cornerRadius = 16
        useRecommendedBoxButton.clipsToBounds = true
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
    @IBOutlet weak var useRecommendedBoxButton: UIButton!
    @IBOutlet weak var useOtherBoxButton: UIButton!
    @IBOutlet weak var boxSizeLabel: UILabel!
    var package: Package?
}
