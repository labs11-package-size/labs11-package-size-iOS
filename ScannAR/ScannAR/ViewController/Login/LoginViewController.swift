//
//  LoginViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@objcMembers
class LoginViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.sendSubviewToBack(backgroundImage)
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        let googleSigninButton = GIDSignInButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        googleSigninButton.style = .wide
        googleSigninButton.colorScheme = .dark
        googleSigninButton.addTarget(self, action: #selector(googleSigninButtonTapped), for: .touchUpInside)
        googleSigninButton.center = view.center
        
        self.view.addSubview(googleSigninButton)
    }
    
    // GoogleSignIn target action
    func googleSigninButtonTapped(sender: UIButton!) {
        print("googleSigninButton tapped")
        
        if appDelegate.user == nil {
            appDelegate.user = Auth.auth().currentUser
        }
        guard let user = appDelegate.user else { fatalError("Do not have user object sent from google")}
        var dict: [String: String] = [:]
        dict["uid"] = user.uid
        dict["displayName"] = user.displayName
        dict["email"] = user.email
        dict["photoURL"] = user.photoURL?.absoluteString
        scannARNetworkingController.postForAuthenticationToken(dict: dict) { (string, error) in
            
            if let error = error {
                print("There was an error with your username and password: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "SegueToScannARMain", sender: nil)
                }
                
            }
            
            
        }
        
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
