//
//  ShipmentsDetailViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/21/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit
import CoreData

class ShipmentsDetailViewController: UIViewController, BottomButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
        
        fetchShippingDetail()
        
    }
    
    // MARK: - Private Methods
    private func updateViews(){
        
        guard let shipment = shipment else {fatalError("No package available to show")}
        
        guard let dimensions = shipment.dimensions else {fatalError("No package dimensions associated with that shipment.")}
        
        dimensionsLabel.text = dimensions
        
        if let uuidStrings = shipment.productUuids {
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
        
        totalWeightLabel.text = shipment.shippedTo
        trackingNumberLabel.text = shipment.trackingNumber
        
        // Slide and PageControl
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.layer.cornerRadius = 8
        pageControl.clipsToBounds = true
        scrollContainerView.bringSubviewToFront(pageControl)
        
        
        
    }
    
    
    private func fetchShippingDetail(){
        guard let uuid = shipment?.uuid else { return }
        scannARNetworkingController.getShipmentDetail(uuid: uuid) { (results, error) in
            
            guard let results = results else {
                return
            }
            
            let moc = CoreDataStack.shared.container.newBackgroundContext()
            
            let newShipment = Shipment(shipmentRepresentation: results, context: moc)
            
            self.shipment?.shipmentTrackingDetail = newShipment.shipmentTrackingDetail
        }
        
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
    
    private func trackItButtonTapped() {
        performSegue(withIdentifier: "SegueToShipmentTracking", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destVC = segue.destination as? ShipmentTrackingMainViewController else { fatalError("Should be send Segue to ShipmentDetailVC but is not")}
        destVC.shipment = self.shipment
//        let transition: CATransition = CATransition()
//        transition.duration = 0.2
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        DispatchQueue.main.async {
//            self.view.layer.add(transition, forKey: nil)
//        }
    }
    
    // MARK: - BottomButtonDelegateMethods
    func trackItTapped() {
        self.trackItButtonTapped()
    }
    
    
    // MARK: - Properties
    var bottomButtonDelegate: DelegatePasserDelegate?
    var slides: [Slide] = []
    var productUUIDStrings: [String] = []
    var scannARNetworkingController = ScannARNetworkController.shared
    var shipment: Shipment?
    var package: Package?
    
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

    // MARK: - Outlets
    @IBOutlet weak var trackingNumberLabel: UILabel!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var boxTypeLabel: UILabel!
    
}

extension ShipmentsDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension ShipmentsDetailViewController {
    
    func createSlides() -> [Slide] {
        
        guard let shipment = shipment else {fatalError("No package available to show")}
        
        var slides: [Slide] = []
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        
        if let dimensions = shipment.dimensions {
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
            
            var data: Data
            do {
                data = try Data(contentsOf: product.thumbnail!)
                slide.imageView.image = UIImage(data: data)
            } catch {
                print("error")
            }
            
            slides.append(slide)
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

extension ShipmentsDetailViewController: UIScrollViewDelegate {
    
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

