//
//  LoginViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.sendSubviewToBack(backgroundImage)
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
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard usernameTextField.text != "", passwordTextField.text != "" else {
            return
        }
        
        var dict: [String: String] = [:]
        dict["username"] = usernameTextField.text
        dict["password"] = passwordTextField.text
        scannARNetworkingController.getAuthenticationToken(dict: dict) { (string, error) in
            
            if let error = error {
                print("There was an error with your username and password: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "SegueToProducts", sender: nil)
                }
                
            }
            
        
        }
        
        
    }
    
    var scannARNetworkingController: ScannARNetworkController = ScannARNetworkController()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    
}
