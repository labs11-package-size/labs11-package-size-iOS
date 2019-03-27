//
//  AuthViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/27/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@objc(AuthViewController)
class AuthViewController: UITableViewController, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //
    }
    
    
}
