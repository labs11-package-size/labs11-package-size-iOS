//
//  CreatingBoxViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class CreatingBoxViewController: UIViewController, BottomButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0, execute: {
            self.performSegue(withIdentifier:"SegueToPackageDetails",sender: self)
        })
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destVC = segue.destination as? PackageDetailViewController else { fatalError("Did not transition to PackageDetailViewController")}
        guard let package = package else { fatalError("No package to send")}
        
        bottomButtonDelegate?.updateDelegate(destVC)
        destVC.bottomButtonDelegate = bottomButtonDelegate
        destVC.package = package
        
    }

    var bottomButtonDelegate: DelegatePasserDelegate?
    var package: Package?
}
