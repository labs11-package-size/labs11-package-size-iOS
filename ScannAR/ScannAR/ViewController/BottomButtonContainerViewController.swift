//
//  BottomButtonContainerViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/19/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class BottomButtonContainerViewController: UIViewController, DelegatePasserDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateViews()
    }
    
    // MARK: - Private Methods
    
    private func updateViews(){
        
//        mainCallToActionButton.layer.shadowColor = UIColor.gray.cgColor
//        mainCallToActionButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        mainCallToActionButton.layer.shadowRadius = 2.0
//        mainCallToActionButton.layer.shadowOpacity = 1.0
        //mainCallToActionButton.layer.cornerRadius = 8
        //mainCallToActionButton.layer.masksToBounds = false
        //mainCallToActionButton.layer.shadowPath = UIBezierPath(roundedRect:mainCallToActionButton.bounds, cornerRadius:mainCallToActionButton.layer.cornerRadius).cgPath
        
        switch buttonState {
        case .packageStart:
            mainCallToActionButton.setTitle("Ship it!", for: .normal)
            otherActionButton.setTitle("See 3D Package Preview", for: .normal)
        case .trackingNumberEntered:
            mainCallToActionButton.setTitle("Track It", for: .normal)
            otherActionButton.setTitle("", for: .normal)
        default:
            print("Nothing to update")
        }
    }
    
    // MARK: - Delegate Passer Delegate Method
    func updateDelegate(_ vc: BottomButtonDelegate) {
        self.delegate = vc
    }
    
    func cancelTapped() {
        // Noting to do
        progressBarDelegate?.cancelTapped()
    }
    
    @IBAction func mainCallToActionButtonTapped(_ sender: Any) {
        
        switch buttonState {
        case .productStart:
            guard let packThisProduct = delegate?.packThisProduct else { fatalError("Pack this product should be implemented and is not")}
            packThisProduct()
            mainCallToActionButton.setTitle("Use Recommended Box", for: .normal)
            otherActionButton.setTitle("Use a different box", for: .normal)
            progressBarDelegate?.packThisBoxTapped()
            buttonState = .packTapped
        case .packTapped:
            
            progressBarDelegate?.useRecommendedBoxTapped()
            guard let useRecommendedBoxTapped = delegate?.useRecommendedBoxTapped else { fatalError("Use Recommended Box should be implemented and is not")}
            useRecommendedBoxTapped()
            
            mainCallToActionButton.setTitle("Ship it!", for: .normal)
            otherActionButton.setTitle("See 3D Package Preview", for: .normal)
            buttonState = .packageStart
            
        case .packageStart:
            
            progressBarDelegate?.shipItTapped()
            guard let shipItTapped = delegate?.shipItTapped else { fatalError("Use Ship It should be implemented and is not")}
            shipItTapped()
            
            buttonState = .shipItTapped
        
        case .shipItTapped:
            
            progressBarDelegate?.trackingNumberEntered()
            mainCallToActionButton.setTitle("Track It", for: .normal)
            otherActionButton.setTitle("", for: .normal)
            buttonState = .trackingNumberEntered
            
        default:
            guard let trackItTapped = delegate?.trackItTapped else { fatalError("Use Tracking Number Entered should be implemented and is not")}
            trackItTapped()
        }
        
    }
    
    @IBAction func otherCallToActionButtonTapped(_ sender: Any) {
        switch buttonState {
        case .productStart:
            print("to be developed")
        case .packTapped:
            
            print("to be developed")
            
        case .packageStart:
            
            guard let view3DPreviewButtonTapped = delegate?.view3DPreviewButtonTapped else { fatalError("Use Recommended Box should be implemented and is not")}
            view3DPreviewButtonTapped()
            
        case .shipItTapped:
            
            print("to be developed")
            
        default:
            print("to be developed")
        }
        
    }
    
    
    
    @IBOutlet weak var mainCallToActionButton: UIButton!
    @IBOutlet weak var otherActionButton: UIButton!
    
    var buttonState: ButtonState = .productStart
    var delegate: BottomButtonDelegate?
    var progressBarDelegate: ProgressBarDelegate?
}

enum ButtonState: String{
    case productStart
    case packTapped
    case packageStart
    case shipItTapped
    case trackingNumberEntered
}
