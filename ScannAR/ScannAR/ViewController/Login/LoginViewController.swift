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
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SegueToScannARMain" {
            guard let destVC = segue.destination as? UINavigationController, let secondVC = destVC.viewControllers.first as? ScannARMainViewController else { return }
            secondVC.scannARNetworkingController = self.scannARNetworkingController
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        loginButton.resignFirstResponder()
        
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
                    self.performSegue(withIdentifier: "SegueToScannARMain", sender: nil)
                }
                
            }
            
        
        }
        
        
    }
    
    // MARK: - Properties
    
    var scannARNetworkingController: ScannARNetworkController = ScannARNetworkController()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
