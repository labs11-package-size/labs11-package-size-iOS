//
//  SmallToLargeTransitionController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

class SmallToLargeTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: Properties
    
    var toViewController: CardsViewController?
    lazy var toViewControllerInitialYPosition: CGFloat = {
        let bottomTriggerViewHeight: CGFloat = fromViewControllerGestureView?.frame.height ?? 0
        let cardsViewYPosition = self.toViewController?.cardsView.frame.minY ?? 0
        let y = bottomTriggerViewHeight + cardsViewYPosition
        return y
    }()
    lazy var bottomTriggerImageViewHeight: CGFloat = toViewController?.cardImageViewHeight ?? 0
    var interactivePresentTransition: SmallToLargeViewInteractiveAnimator?
    var interactiveDismissTransition: SmallToLargeViewInteractiveAnimator?
    var fromViewControllerGestureView: UIView?
    
    // MARK: Methods
    
    func prepareViewForCustomTransition(fromViewController: AddProductViewController) {
        if self.toViewController != nil { return }
        let toViewController = CardsViewController.instantiateViewController()
        toViewController.transitioningDelegate = self
        toViewController.modalPresentationStyle = .custom
        class MockStorage {
            static let shared = MockStorage()
            let imageFileName = "james_bond"
            lazy var data = [
                CardCellDisplayable(imageViewFileName: imageFileName, title: "iOS Developer", subtitle: "Apple", details: "Animations/Transitions", itemImageName: "qrcode"),
                CardCellDisplayable(imageViewFileName: imageFileName, title: "Android Developer", subtitle: "Google", details: "Location/Maps", itemImageName: "qrcode"),
                CardCellDisplayable(imageViewFileName: imageFileName, title: "C++ Architect", subtitle: "Amazon", details: "Core", itemImageName: "qrcode")
            ]
            
            private init() {}
        }
        interactiveDismissTransition = SmallToLargeViewInteractiveAnimator(fromViewController: toViewController, toViewController: nil, gestureView: toViewController.view)
        self.toViewController = toViewController
        //self.fromViewControllerGestureView = fromViewController.bottomTriggerView
    }
    
    func removeCustomTransitionBehaviour() {
        interactivePresentTransition = nil
        interactiveDismissTransition = nil
        toViewController = nil
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SmallToLargePresentingViewAnimator(initialY: toViewControllerInitialYPosition)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SmallToLargeDismissingViewAnimator(initialY: toViewControllerInitialYPosition)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let presentInteractor = interactivePresentTransition else {
            return nil
        }
        guard presentInteractor.isTransitionInProgress else {
            return nil
        }
        return presentInteractor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let dismissInteractor = interactiveDismissTransition else {
            return nil
        }
        guard dismissInteractor.isTransitionInProgress else {
            return nil
        }
        return dismissInteractor
    }
}

