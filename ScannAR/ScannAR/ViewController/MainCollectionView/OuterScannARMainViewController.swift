//
//  OuterScannARMainViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/24/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class OuterScannARMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func scannItBarButtonTapped(_ sender: UIBarButtonItem){
        let vc = UIStoryboard(name: "ARScan", bundle: nil).instantiateViewController(withIdentifier: "ARScanMainMenu")  as! ARScanMenuScreenViewController
        let transition: CATransition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
