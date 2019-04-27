//
//  AccountViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAccount()
        changeEditingTo(false)
    }
    
    // MARK: - Private Methods
    private func getAccount(){

        scannARNetworkingController.getUserAccountInfo { (result, error) in

            if let error = error {
                print("There was an error getting your account information: \(error)")
                return
            }

            guard let result = result else {fatalError("There was no Account information returned for the user.")}

            self.account = result

        }

    }
    
    private func updateAccountInfoOnServer(){

        guard let account = account else { fatalError(" Error: No account exists")}
        
        let dict = NetworkingHelpers.dictionaryFromAccount(account: account)
        
        scannARNetworkingController.putEditUserAccountInfo(dict: dict) { (result, error) in

        if let error = error {
                print("There was an error getting your account information: \(error)")
                return
            }

        guard let result = result else {fatalError("There was no Account information returned for the user.")}

        self.account = result
        }
    }
    
        private func updateAccountInfoFromText(){
            guard var account = self.account else {fatalError("There was no Account information returned for the user.")}
            if let email = emailTextField.text, let name = userNameTextField.text, email != "", name != "" {
                self.account?.email = emailTextField.text!
                self.account?.displayName = userNameTextField.text!
            }
            
        }
        
        
    
    private func updateViews() {
        
        guard let account = account else { return }
        
        DispatchQueue.main.async {
            
            self.userNameTextField.layer.cornerRadius = 8
            self.userNameTextField.clipsToBounds = true
            self.emailTextField.layer.cornerRadius = 8
            self.emailTextField.clipsToBounds = true
            
            self.emailTextField.text = account.email
            self.userNameTextField.text = account.displayName
            
            guard let photoURL = account.photoURL else { return }
            guard let profileURL = URL(string: photoURL) else { return }
            var data: Data
            do {
                data = try Data.init(contentsOf: profileURL)
            } catch {
                print("Could not get profile image.")
                return
            }
            let image = UIImage(data: data)
            self.profileImageView.image = image
        }
    }
    
    
    
    private func changeEditingTo(_ bool: Bool) {
    self.emailTextField.isUserInteractionEnabled = bool
    self.userNameTextField.isUserInteractionEnabled = bool
    self.profileImageView.isUserInteractionEnabled = bool
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - IBActions
    @IBAction func editButtonTapped(_ sender: Any) {
        changeEditingTo(true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    @objc func doneTapped(sender: UIButton) {
        changeEditingTo(false)
        updateAccountInfoFromText()
        updateAccountInfoOnServer()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        
    }
    @IBAction func logoutTapped(_ sender: Any) {
        
        ScannARNetworkController.shared.resetWebToken()
        CoreDataStack.shared.resetCoreData()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "SegueToWalkthrough", sender: self)
    }
    
    
    
    // MARK: - Properties
    var scannARNetworkingController = ScannARNetworkController.shared
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    var account: Account? {
        didSet {
            updateViews()
        }
    }

}
