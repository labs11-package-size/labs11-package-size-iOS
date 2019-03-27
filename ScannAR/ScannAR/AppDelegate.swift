//
//  AppDelegate.swift
//  ScannAR
//
//  Created by ScannAR Team on 3/20/19.
//

import ARKit
import UIKit
import Firebase
import GoogleSignIn


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // FirebaseApp.configure()
        // GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
       
        return true
    }
    

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {

            return self.application(application,
                                    open: url,
                                   
                sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: [:])
    }
    // old_delegate
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation) {
            return true
        }
       return true
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

        guard let controller = GIDSignIn.sharedInstance().uiDelegate as? AuthViewController else { return }

        if let error = error {
//            controller.showMessagePrompt(error.localizedDescription)

            return
        }
        

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
       
//        controller.firebaseLogin(credential)

}

}
