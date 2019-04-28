//
//  WalkthroughViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes & Joshua Kaunert on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class WalkthroughViewController: UIViewController, AlertOnboardingDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayOfAlerts = [alert1, alert2, alert3, alert4]
        alertView = AlertOnboarding(arrayOfAlerts: arrayOfAlerts)
        alertView.delegate = self
        setupOnboarding()
        setupBottomControls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        alertView.show()
    }
    
    //MARK:- Onboarding Properties
    
    var alertView: AlertOnboarding!
    var arrayOfAlerts = [Alert]()
    
    let alert1 = Alert(image: UIImage(named: "scannarlogo_rev1")!, title: "ScannAR", text: "ScannAR is an app that uses augmented reality to track and right-size your shipping, helping you get more shipping done for less.")
    let alert2 = Alert(image: UIImage(named: "SCANIT")!, title: "Scan It", text: "Using your iPhone, scan any item with the ScannAR app. The ScannAR app will tell you the object's exact dimensions.")
    let alert3 = Alert(image: UIImage(named: "PACKIT")!, title:  "Pack It", text: "Now that you have your product's dimensions, ScannAR can tell you the perfect box size for the item.")
    let alert4 = Alert(image: UIImage(named: "SHIPIT")!, title:  "Ship It", text: "Once you have selected your packaging, you are ready to ship. ScannAR will track you shipment for you.")
    
    
    // MARK: - Onboarding Private Methods
    
    private func setupOnboarding() {
        
        self.alertView.colorButtonText = .black
        self.alertView.colorButtonBottomBackground = UIColor(named: "appARKATeal")!
        self.alertView.colorTitleLabel = .black
        self.alertView.colorDescriptionLabel = .black
        self.alertView.colorPageIndicator = UIColor(red: 173/255, green: 206/255, blue: 183/255, alpha: 1.0)
        self.alertView.colorCurrentPageIndicator = UIColor(named: "appARKATeal")!
        
    }
    
    private func setupBottomControls(){
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [/*previousButton, pageControl,*/ nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - IBActions
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueToLogin", sender: self)
    }
    
    // MARK: - Properties
//    private let previousButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("PREV", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font  = UIFont.boldSystemFont(ofSize: 15)
//        button.setTitleColor(.white, for: .normal)
//        return button
//    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SIGNIN", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font  = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(nextButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        return pc
    }()
 
    // MARK: Onboarding Delegeate Methods
    
    
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        print("Onboarding skipped the \(currentStep) step and the max step he saw was the number \(maxStep)")
    }
    
    func alertOnboardingCompleted() {
        print("Onboarding completed!")
    }
    
    func alertOnboardingNext(_ nextStep: Int) {
        print("Next step triggered! \(nextStep)")
    }

}

extension WalkthroughViewController {
    
    // Change the name of the storyboard if this is not "Main"
    // identifier is the Storyboard ID that you put juste before
    class func instantiate() -> WalkthroughViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewControllerSB") as! WalkthroughViewController
        
        return viewController
    }
    
}

