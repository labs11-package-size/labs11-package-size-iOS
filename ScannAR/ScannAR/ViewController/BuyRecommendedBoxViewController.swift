//
//  BuyRecommendedBoxViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/17/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import SafariServices

class BuyRecommendedBoxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
        setupTapGestures()
    }

    // MARK: - Private Methods
    private func linkToURL(with url: URL) {
        
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
        
    }
    
    private func updateViews(){
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let text = NSAttributedString(string: textView.text!,
                                      attributes: [NSAttributedString.Key.paragraphStyle:style])
        textView.attributedText = text
        textView.textColor = .white
        textView.font = .preferredFont(forTextStyle: .body)
        textView.centerVertically()
        
    }
    
    private func setupTapGestures(){
        
        let tapGestureForDescription = UITapGestureRecognizer(target: self, action: #selector(self.handleTextViewTap(_:)))
        self.textView.addGestureRecognizer(tapGestureForDescription)
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PackageDetailSegue" {
            
            guard let destVC = segue.destination as? PackageDetailViewController else { fatalError("Destinatation should be PackageDetailViewController")}
            destVC.package = self.package
            destVC.barButtonFlag = true
            
        }
    }
    
    // MARK: - IBactions and Gestures
    
    @objc func handleTextViewTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "PackageDetailSegue", sender: self)
    }
    
    @IBAction func buyRecommendedPackage(_ sender: Any) {
        linkToURL(with: URL(string: "https://www.arka.com")!)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Properties
    var package: Package?

}
