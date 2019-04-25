//
//  AppDelegate.swift
//  ScannAR
//
//  Created by ScannAR Team on 3/20/19.
//

import ARKit
import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        Appearance.setupNavAppearance()
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let loginFlag = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if loginFlag {
            signInalreadySignedInUser()

        }
       
        
        return true
    }
    

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }

    // old_delegate
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }


    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error)
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                
                guard let authResult = authResult else {
                    print("result is empty")
                    return
                }
                self.user = authResult.user
                // User is signed in
                print("Signed In as: \(user.profile!)")
                
                guard let user = self.user else { fatalError("Do not have user object sent from google")}
                var dict: [String: String] = [:]
                dict["uid"] = user.uid
                dict["displayName"] = user.displayName
                dict["email"] = user.email
                dict["photoURL"] = user.photoURL?.absoluteString
                print("\(user.email)")
                
                let scannARNetworkingController = ScannARNetworkController.shared
                scannARNetworkingController.postForAuthenticationToken(dict: dict) { (string, error) in
                    
                    if let error = error {
                        print("There was an error with your username and password: \(error)")
                    }
                    
                    DispatchQueue.main.async {
                        self.window?.rootViewController = ScannARMainNavigationController.instantiate()
                    }
                    
                }
                
               
                
            }
        }
        
        
    }
    
    private func signInalreadySignedInUser() {
        
        guard let user = Auth.auth().currentUser else { fatalError("Do not have user object sent from google")}
        var dict: [String: String] = [:]
        dict["uid"] = user.uid
        dict["displayName"] = user.displayName
        dict["email"] = user.email
        dict["photoURL"] = user.photoURL?.absoluteString
        print("\(user.email)")
        
        let scannARNetworkingController = ScannARNetworkController.shared
        scannARNetworkingController.postForAuthenticationToken(dict: dict) { (string, error) in
            
            if let error = error {
                print("There was an error with your username and password: \(error)")
            }
            
            DispatchQueue.main.async {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                
                let storyboard = UIStoryboard(name: "ScannARMainViewController", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "ScannARMainNavigationControllerSB")
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
            
        }
        
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    // MARK: - ARScan Required
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ARScanViewController {
            DispatchQueue.main.async {
                viewController.backFromBackground()
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ARScanViewController {
            DispatchQueue.main.async {
                viewController.blurView?.isHidden = false
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ARScanViewController {
            DispatchQueue.main.async {
                viewController.blurView?.isHidden = true
            }
        }
    }

    // MARK: - Properties
    var user: User?


}
