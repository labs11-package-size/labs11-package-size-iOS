//
//  ProductDescriptionViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/11/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ProductDescriptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let productDescription = productDescription else { return }
        productDescriptionTextView.text = productDescription
    }
    
    // MARK: - Private Methods
    
    private func changeEditingTo(_ bool: Bool) {
        productDescriptionTextView.isUserInteractionEnabled = bool
        
    }
    
    private func updateProductValues(){
        
        guard let product = product else { fatalError("No Product present")}
        product.productDescription = productDescriptionTextView.text
        
    }
    
    private func updateProductOnServer(){
        
        updateProductValues()

        guard let product = product else { fatalError("No Product present")}
        
        guard let uuid = product.uuid else { fatalError("No UUID present")}
        let dict = NetworkingHelpers.dictionaryFromProductForUpdate(product: product)
        scannARNetworkingController.putEditProduct(dict: dict, uuid: uuid) { (_) in
            self.flashSaveOnServerNoticeToUser()
        }
    }
    
    private func flashSaveOnServerNoticeToUser() {
        guard let product = product else { return }
        DispatchQueue.main.async {
            let popup = UIView(frame: CGRect(x: self.view.center.x - 100, y: self.view.center.y - 100, width: 200, height: 200))
            popup.alpha = 1
            popup.backgroundColor = .gray
            
            let label = UILabel()
            
            label.text = "\(String(product.name!)) saved"
            label.textColor = .black
            label.textAlignment = .center
            label.numberOfLines = 4
            label.font = UIFont.systemFont(ofSize: 20)
            
            popup.addSubview(label)
            self.view.addSubview(popup)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: popup.centerYAnchor).isActive = true
            let widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160)
            label.addConstraint(widthConstraint)
            
            UIView.animate(withDuration: 2, animations: {
                popup.alpha = 0
            }, completion: { _ in
                popup.removeFromSuperview()
            })
            
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func editButtonTapped(_ sender: Any) {
        changeEditingTo(true)
        notification.notificationOccurred(.warning)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    @objc func saveTapped(sender: UIButton) {
        changeEditingTo(false)
        notification.notificationOccurred(.success)
        updateProductOnServer()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBOutlet weak var productDescriptionTextView: UITextView!
    var productDescription: String?
    let notification = UINotificationFeedbackGenerator()
    var product: Product?
    var scannARNetworkingController = ScannARNetworkController.shared

}
