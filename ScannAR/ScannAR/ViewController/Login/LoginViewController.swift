//
//  LoginViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

@objcMembers
class LoginViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.sendSubviewToBack(backgroundImage)
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let googleSigninButton = GIDSignInButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        googleSigninButton.style = .wide
        googleSigninButton.colorScheme = .dark
        googleSigninButton.center = view.center
        
        self.view.addSubview(googleSigninButton)
        
    }
    
    // GoogleSignIn target action
    func googleSigninButtonTapped(sender: UIButton!) {
        print("googleSigninButton tapped")
        sender.isHidden = true
        DispatchQueue.main.async {
            self.reloadInputViews()
        }
        GIDSignIn.sharedInstance().signIn()
        
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
    
    
    // MARK: - Properties
    
    var scannARNetworkingController: ScannARNetworkController = ScannARNetworkController.shared
    var user: User?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
