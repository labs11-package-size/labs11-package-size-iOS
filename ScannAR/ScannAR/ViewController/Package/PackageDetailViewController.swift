//
//  PackageDetailViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/7/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import SafariServices
import CoreData

class PackageDetailViewController: UIViewController, BottomButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView.delegate = self
        updateViews()
        
        
    }
    // MARK: - Private Methods
    
    private func updateViews() {
        
        guard let package = package else {fatalError("No package available to show")}
        
        guard let dimensions = package.dimensions else {fatalError("No dimensions associated with that package.")}
        
        dimensionsLabel.text = package.dimensions
        
        if let uuidStrings = package.productUuids {
            productUUIDStrings = uuidStrings
        }
        
        
        if let boxType = Box.boxVarieties[dimensions] {
            
            switch boxType {
            case .shipper:
                boxTypeLabel.text = "Shipper"
            default:
                boxTypeLabel.text = "Mailer"
            }
        } else {
            boxTypeLabel.text = "N/A"
        }
        
        totalWeightLabel.text = String(format: "%.2f",package.totalWeight)
        
//        threeDPackagePreviewButton.layer.cornerRadius = 8
//        threeDPackagePreviewButton.clipsToBounds = true
        
        
        // Slide and PageControl
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.layer.cornerRadius = 8
        pageControl.clipsToBounds = true
        scrollContainerView.bringSubviewToFront(pageControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func createShipmentTapped(with trackingNumber: String, _ sender: Any) {
        
        guard trackingNumber != "" else { return }
        
        guard let uuid = package?.uuid else { return }
        let productNames = package?.productNames
        let productUuids = package?.productUuids
        let dimensions = package?.dimensions
        
        let newShipment = Shipment(carrierName: nil, dimensions: dimensions, productNames: nil, productUuids: nil, shipmentTrackingDetail: nil, shippedDate: nil, dateArrived: nil, lastUpdated: nil, shippingType: nil, status: 1, trackingNumber: trackingNumber, shippedTo: nil, uuid: uuid, context: CoreDataStack.shared.container.newBackgroundContext())
        let dict = NetworkingHelpers.dictionaryFromShipment(shipment: newShipment)
        
        scannARNetworkingController.postNewShipment(dict: dict, uuid: uuid, completion: { (results, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            if let results = results, results.last != nil {
                let shipmentRep = results.last
                let moc = CoreDataStack.shared.mainContext
                
                let shipment = Shipment(shipmentRepresentation: shipmentRep!, context: moc)
                self.shipment = shipment
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ShowShipment", sender: self)
                }
            }
            
        })
        
    }
    
    private func linkToURL(with url: URL) {
            
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
            
    }
    
    private func getCompoundPredicate()->NSCompoundPredicate{
        var predicateArray: [NSPredicate] = []
        for uuidString in productUUIDStrings {
            let uuid = UUID(uuidString: uuidString)
            let predicate = NSPredicate(format: "uuid = %@", argumentArray: [uuid])
            predicateArray.append(predicate)
            print(predicate)
        }
        
        return NSCompoundPredicate.init(type: .or, subpredicates: predicateArray)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MainSegue" {
            ScannARMainViewController.segmentPrimer = 1
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        } else if segue.identifier == "ShowShipment" {
            guard let destVC = segue.destination as? ShipmentsDetailViewController else { fatalError("Should be send Segue to ShipmentDetailVC but is not")}
            destVC.shipment = self.shipment
            destVC.package = self.package
            destVC.productUUIDStrings = self.productUUIDStrings
            bottomButtonDelegate?.updateDelegate(destVC)
            destVC.bottomButtonDelegate = bottomButtonDelegate
            
        }
    }
    
    // MARK: - IBActions
    func showTrackingNumberButtonTapped(_ sender: Any) {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Add a USPS Tracking Number", message: "Please paste a valid USPS tracking number for the item below. If you do not have a tracking number at this time, press cancel.", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            guard let trackingNumberString = alertController.textFields?[0].text, trackingNumberString != "" else {
            
                self.view.shake()
                self.notification.notificationOccurred(.error)
                self.bottomButtonDelegate?.buttonState = .packageStart
                self.bottomButtonDelegate?.cancelTapped()
                return
                
            }
            
            self.trackingNumber = trackingNumberString
            self.trackingNumberEntered()
            self.bottomButtonDelegate?.mainCallToActionButtonTapped(self)
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
            self.bottomButtonDelegate?.buttonState = .packageStart
            self.bottomButtonDelegate?.cancelTapped()
            
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        //adding textfields to our dialog box
        
        DispatchQueue.main.async {
            alertController.addTextField { (textField) in
                textField.placeholder = "Ex: 9405510200866698489237"
                //finally presenting the dialog box
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func threeDPackagePreviewButton(_ sender: Any) {
        guard let urlString = package?.modelURL, urlString != "http://www.google.com" else { return }
        guard let url = URL(string: urlString) else { return }
        linkToURL(with: url)
    }
    
    @IBAction func backToPackagesTapped(_ sender: Any) {
        ScannARMainViewController.segmentPrimer = 1
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToScannARMainViewController22", sender: self)
        }
        
    }
    
    // MARK: - BottomButtonDelegateMethods
    func shipItTapped() {
        self.showTrackingNumberButtonTapped(self)
    }
    
    func trackingNumberEntered() {
        guard let trackingNumber = trackingNumber else { return }
        self.createShipmentTapped(with: trackingNumber, self)
    }
    
    func view3DPreviewButtonTapped() {
        guard let modelURL = package?.modelURL else { return }
        if let url = URL(string: modelURL) {
            linkToURL(with: url)
        } else {
            return
        }
    }

    
    // MARK: - Properties
    var bottomButtonDelegate: DelegatePasserDelegate?
    
    var scannARNetworkingController = ScannARNetworkController.shared
    var package: Package?
    var shipment: Shipment?
    var trackingNumber: String?
    var slides: [Slide] = []
    var collectionViewToReload: UICollectionView?
    var productUUIDStrings: [String] = []
    let notification = UINotificationFeedbackGenerator()
    lazy var filteredProducts: [Product] = {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let compoundPredicate = getCompoundPredicate()
        fetchRequest.predicate = compoundPredicate
        
        var fetchedProducts: [Product] = []
        do {
            fetchedProducts = try moc.fetch(fetchRequest)
        } catch {
            fatalError("Failed to fetch product: \(error)")
        }
        
        return fetchedProducts
        
    }()
    
    // MARK: - @IBOutlets
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var threeDPackagePreviewButton: UIButton!
//    @IBOutlet weak var showTrackingNumber: UIButton!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var boxTypeLabel: UILabel!
    @IBOutlet var backToPackagesBarButtonItem: UIBarButtonItem!
    
}

extension PackageDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension PackageDetailViewController {
    
    func createSlides() -> [Slide] {
        
        guard let package = package else {fatalError("No package available to show")}
        
        var slides: [Slide] = []
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        
        if let dimensions = package.dimensions {
            if let boxType = Box.boxVarieties[dimensions] {
                
                switch boxType {
                case .shipper:
                    slide1.imageView.image = UIImage(named: "Shipper")
                default:
                    slide1.imageView.image = UIImage(named: "standardMailerBox")
                }
            } else {
                slide1.imageView.image = UIImage(named: "Shipper")
            }
            
        } else {
            slide1.imageView.image = UIImage(named: "Shipper")
        }
        
        slides.append(slide1)
        
        for product in filteredProducts {
            let slide: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            
            if let thumbnail = product.thumbnail {
                var data: Data
                do {
                    data = try Data(contentsOf: thumbnail)
                    slide.imageView.image = UIImage(data: data)
                } catch {
                    print("error")
                }
                slides.append(slide)
            }
            
            
            
        }
        
        return slides
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
            if slides.count > 2 {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            }
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            
            if slides.count > 3 {
            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            }
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            if slides.count > 4 {
            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
            }
        }
    }
}
