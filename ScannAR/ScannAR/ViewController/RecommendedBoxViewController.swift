//
//  RecommendedBoxViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/16/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class RecommendedBoxViewController: UIViewController, BottomButtonDelegate {
    
    

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
        
    }
    
    func useRecommendedBoxTapped() {
        performSegue(withIdentifier: "SegueToWaiting", sender: self)
    }
    
    func useAnotherBoxTapped() {
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destVC = segue.destination as? CreatingBoxViewController else { fatalError("Did not transition to CreatingBoxViewController")}
        bottomButtonDelegate?.updateDelegate(destVC)
        destVC.bottomButtonDelegate = bottomButtonDelegate
        destVC.package = package
    }
    
    var bottomButtonDelegate: DelegatePasserDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var boxSizeLabel: UILabel!
    var package: Package?
}
