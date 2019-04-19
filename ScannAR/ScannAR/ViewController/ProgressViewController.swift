//
//  ProgressViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/19/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateViews()
    }
    
    // MARK: - Navigation
    private func updateViews(){
        productImageView.setImageColor(color: .white)
        productImageView.backgroundColor = UIColor(named: "appARKADarkBlue")
        packageImageView.setImageColor(color: .gray)
        shippingImageView.setImageColor(color: .gray)
        
        productContainerView.layer.cornerRadius = 20
        productContainerView.clipsToBounds = true
        productContainerView.backgroundColor = UIColor(named: "appARKADarkBlue")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var shippingImageView: UIImageView!
    
    @IBOutlet weak var productContainerView: UIView!
    @IBOutlet weak var packageContainerView: UIView!
    @IBOutlet weak var shippingContainerView: UIView!
    
}
