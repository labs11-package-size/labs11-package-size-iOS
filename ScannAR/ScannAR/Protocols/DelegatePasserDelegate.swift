//
//  DelegatePasserDelegate.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

protocol DelegatePasserDelegate: class {
    func updateDelegate(_ vc: BottomButtonDelegate)
    func mainCallToActionButtonTapped(_ sender: Any)
    
}
