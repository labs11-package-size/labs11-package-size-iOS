//
//  PackageDetailViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/7/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import SafariServices

class PackageDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        updateViews()
        trackingNumberTextField.delegate = self
        updatePicture()
        
        
        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.layer.cornerRadius = 8
        pageControl.clipsToBounds = true
        scrollContainerView.bringSubviewToFront(pageControl)
    }
    // MARK: - Private Methods
    
    private func updateViews() {
        
        
        guard let package = package else {fatalError("No package available to show")}
        dimensionsLabel.text = package.dimensions
        totalWeightLabel.text = String(format: "%.2f",package.totalWeight)
        trackingNumberEnterStackView.isHidden = true
        createShipmentButton.isHidden = true
        
        showTrackingNumber.layer.cornerRadius = 8
        showTrackingNumber.clipsToBounds = true
        createShipmentButton.layer.cornerRadius = 8
        createShipmentButton.clipsToBounds = true
        threeDPackagePreviewButton.layer.cornerRadius = 8
        threeDPackagePreviewButton.clipsToBounds = true
    }
    
    private func updatePicture() {
//        guard let package = package else { fatalError("No package present in this VC")}
//        if let dimensions = package.dimensions {
//            if let boxType = Box.boxVarieties[dimensions] {
//
//                switch boxType {
//                case .shipper:
//                    self.boxImageView.image = UIImage(named: "standardMailerBox")
//                    self.boxTypeLabel.text = "Mailer"
//                default:
//                    self.boxImageView.image = UIImage(named: "Shipper")
//                    self.boxTypeLabel.text = "Shipper"
//                }
//            } else {
//                self.boxImageView.image = UIImage(named: "Shipper")
//                self.boxTypeLabel.text = "Shipper"
//            }
//
//        } else {
//            self.boxImageView.image = UIImage(named: "Shipper")
//            self.boxTypeLabel.text = "N/A"
//        }
//        boxImageView.clipsToBounds = true
//        boxImageView.layer.cornerRadius = 12
    }
    
    private func linkToURL(with url: URL) {
            
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
            
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateShipmentSegue" {
            guard let destVC = segue.destination as? ScannARMainViewController else { fatalError("Supposed to segue to ScannARMainViewController but did not.")}

        }
        
    }
    
    // MARK: - IBActions
    @IBAction func showTrackingNumberButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.8) {
            self.trackingNumberEnterStackView.isHidden = !self.trackingNumberEnterStackView.isHidden
            self.createShipmentButton.isHidden = !self.createShipmentButton.isHidden
        }
        
    }
    @IBAction func threeDPackagePreviewButton(_ sender: Any) {
        guard let urlString = package?.modelURL, urlString != "http://www.google.com" else { return }
        guard let url = URL(string: urlString) else { return }
        linkToURL(with: url)
    }
    
    @IBAction func createShipmentTapped(_ sender: Any) {
        
        guard trackingNumberTextField.text != "" else { return }
        
        guard let uuid = package?.uuid else { return }
        let productNames = ["Test"] // package?.productNames else { return }
        
        let newShipment = Shipment(carrierName: nil, productNames: productNames, shippedDate: nil, dateArrived: nil, lastUpdated: nil, shippingType: nil, status: 1, trackingNumber: trackingNumberTextField.text!, shippedTo: nil, uuid: uuid, context: CoreDataStack.shared.container.newBackgroundContext())
        let dict = NetworkingHelpers.dictionaryFromShipment(shipment: newShipment)
        
        scannARNetworkingController?.postNewShipment(dict: dict, uuid: uuid, completion: { (results, error) in
            
            if let error = error {
                print("Error: \(error)")
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "CreateShipmentSegue", sender: nil)
            }
            
        })
    }
    
    // MARK: - Properties
    var scannARNetworkingController: ScannARNetworkController?
    var package: Package?
    var slides: [Slide] = []
    var collectionViewToReload: UICollectionView?
//    @IBOutlet weak var boxImageView: UIImageView!
    
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var threeDPackagePreviewButton: UIButton!
    @IBOutlet weak var showTrackingNumber: UIButton!
    @IBOutlet weak var createShipmentButton: UIButton!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var boxTypeLabel: UILabel!
    
    @IBOutlet weak var trackingNumberTextField: UITextField!
    @IBOutlet weak var trackingNumberEnterStackView: UIStackView!
    
}

extension PackageDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension PackageDetailViewController {
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "logistics-package")
//        slide1.titleLabel.text = "A real-life bear"
//        slide1.descriptionLabel.text = "Did you know that Winnie the chubby little cubby was based on a real, young bear in London"
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "package-delivery")
//        slide2.titleLabel.text = "A real-life bear"
//        slide2.descriptionLabel.text = "Did you know that Winnie the chubby little cubby was based on a real, young bear in London"
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "package-for-delivery")
//        slide3.titleLabel.text = "A real-life bear"
//        slide3.descriptionLabel.text = "Did you know that Winnie the chubby little cubby was based on a real, young bear in London"
        
        let slide4:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide4.imageView.image = UIImage(named: "package-delivery-in-hand")
//        slide4.titleLabel.text = "A real-life bear"
//        slide4.descriptionLabel.text = "Did you know that Winnie the chubby little cubby was based on a real, young bear in London"
        
        
        let slide5:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide5.imageView.image = UIImage(named: "package-cube-box-for-delivery")
//        slide5.titleLabel.text = "A real-life bear"
//        slide5.descriptionLabel.text = "Did you know that Winnie the chubby little cubby was based on a real, young bear in London"
        
        return [slide1, slide2, slide3, slide4, slide5]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollContainerView.frame.width, height: scrollContainerView.frame.height)
        scrollView.contentSize = CGSize(width: scrollContainerView.frame.width * CGFloat(slides.count), height: scrollContainerView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: scrollContainerView.frame.width * CGFloat(i), y: 0, width: scrollContainerView.frame.width, height: scrollContainerView.frame.height - 46)
            scrollView.addSubview(slides[i])
        }
    }
}

extension PackageDetailViewController: UIScrollViewDelegate {
    
    // MARK: - UIScrollViewDelegate Methods
    
    
    /*
     * default function called when view is scolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollContainerView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = 0//scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
}
