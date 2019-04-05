//
//  InteractiveTransitionableViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

protocol InteractiveTransitionableViewController {
    var interactivePresentTransition: SmallToLargeViewInteractiveAnimator? { get }
    var interactiveDismissTransition: SmallToLargeViewInteractiveAnimator? { get }
}
