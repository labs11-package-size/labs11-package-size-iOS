//
//  ARScanViewController+NavBar.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

extension ARScanViewController {
    
    func setupNavigationBar() {
        backButton = UIBarButtonItem(title: "Back", style: .plain, target: self,
                                     action: #selector(previousButtonTapped(_:)))
        
        exitButton = UIBarButtonItem(title: "Exit", style: .plain, target: self,
                                     action: #selector(exitButtonTapped(_:)))
        
        let startOverButton = UIBarButtonItem(title: "Restart", style: .plain, target: self,
                                              action: #selector(restartButtonTapped(_:)))
        
        let navigationItem = UINavigationItem(title: "Start")
        navigationItem.leftBarButtonItems = [exitButton, backButton]
        navigationItem.rightBarButtonItems = [startOverButton, exitButton]
        navigationBar!.items = [navigationItem]
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    func showBackButton(_ show: Bool) {
        guard let navBar = navigationBar, let navItem = navBar.items?.first else { return }
        if show {
            navItem.leftBarButtonItems = [backButton]
        } else {
            navItem.leftBarButtonItem = nil
        }
    }
    
    func setNavigationBarTitle(_ title: String) {
        guard let navBar = navigationBar, let navItem = navBar.items?.first else { return }
        navItem.title = title
    }
}
