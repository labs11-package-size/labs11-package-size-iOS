//
//  CardsViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

class CardsViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cardsView: CardsView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cardsUpIconImageView: UIImageView!
    
    // MARK: Properties
    var boxType: BoxType?
    let storage = MockStorage.shared
    var displayData = [CardCellDisplayable]()
    lazy var cardImageViewHeight: CGFloat = cardsView.frame.height * 0.45 //  45% is cell.imageView height constraint's multiplier
    
//    let shipperBox = "shipperBox"
//    let mailerBox = "standardMailerBox"
    var products: [Product] = []
    let scannARNetworkController = ScannARNetworkController.shared
//    lazy var data: [CardCellDisplayable] = [
//        CardCellDisplayable(boxTypeImageViewFileName: shipperBox, title: "ShipperBox1", subtitle: "12x12x8", details: "Is this my espresso machine?", itemImageName: "toy1")
//        ,
//        CardCellDisplayable(boxTypeImageViewFileName: mailerBox, title: "MailerBox1", subtitle: "10x8x4", details: "Hey, you know how I'm, like, always trying to save the planet?", itemImageName: "toy2"),
//        CardCellDisplayable(boxTypeImageViewFileName: shipperBox, title: "ShipperBox2", subtitle: "8x6x4", details: "Yes, Yes, without the oops! ", itemImageName: "toyboots")
//    ]
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardsUpIconImageView.setImageColor(color: UIColor(named: "appARKADarkBlue")!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setCardsViewLayout()
        fetchPreview()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleViewControllerPresentation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        handleViewControllerDismiss()
    }
    
    // MARK: Methods
    
    func setCardsViewLayout() {
        view.layoutIfNeeded()
        cardsView.setLayout()
    }
    
    private func fetchPreview() {
//        guard products.count > 0 else { return }
//        let productUUIDs = products.map { $0.uuid!.uuidString }
//        let packagePreview = PackagePreviewRequest(products: productUUIDs, boxType: nil) // could add boxType specifier here as well.
//        scannARNetworkController.postPackagingPreview(packagingDict: packagePreview) { (results, error) in
//
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            guard let results = results else {
//                print("No Results")
//                return
//            }
            
//            for result in results {
//                self.storage.data.append(CardCellDisplayable(boxTypeImageViewFileName: "shipperBox", title: result.size, subtitle: "\(result.weightLimit)", details: "Is this my espresso machine?", itemImageName: "toy2"))
//            }
            
                if let firstItem = self.storage.data.first {
                    self.displayData.append(firstItem)
                }
            self.cardsView.reloadData()
                ///self.reloadInputViews()
            
            
      //  }
    }
    
    
    
    func handleViewControllerPresentation() {
        if displayData.count == storage.data.count { return }
        cardsView.scrollToItem(at: 0)
        var indexPaths = [IndexPath]()
        for (index, _) in storage.data.enumerated() {
            if index != 0 {
                indexPaths.append(IndexPath(row: index, section: 0))
                displayData.append(storage.data[index])
            }
        }
        cardsView.insertItems(at: indexPaths)
    }
    
    func handleViewControllerDismiss() {
        let amountOfCells = cardsView.numberOfItems(inSection: 0)
        if amountOfCells == 0 { return }
        var indexPathsToDelete = [IndexPath]()
        for index in (1 ..< amountOfCells).reversed() {
            indexPathsToDelete.append(IndexPath(row: index, section: 0))
            displayData.remove(at: index)
        }
        cardsView.deleteItems(at: indexPathsToDelete)
    }
}

// MARK: StoryboardInitialisable Protocol

extension CardsViewController {
    static func instantiateViewController() -> CardsViewController {
        return Storyboard.main.viewController(CardsViewController.self)
    }
}

// MARK: CollectionView DataSource

extension CardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as! CardCollectionViewCell
        
        cell.setContent(data: displayData[indexPath.row])
        for view in cell.scrollView.subviews {
            view.removeFromSuperview()
        }
        cell.setScrollView()
        cell.delegate = self
        cell.actionsHandler = self
        
        return cell
    }
}

extension CardsViewController: SwipingCollectionViewCellDelegate {
    func cellSwipe(_ cell: SwipingCollectionViewCell, with progress: CGFloat) {
        bottomView.alpha = 1 - progress
        bottomView.transform.ty = progress * 50
    }
    
    func cellSwipedUp(_ cell: SwipingCollectionViewCell) {
        if let interactiveTransitionableViewController = presentingViewController as? InteractiveTransitionableViewController,
            let interactiveDismissTransition = interactiveTransitionableViewController.interactiveDismissTransition {
            interactiveDismissTransition.isEnabled = false
        }
    }
    
    func cellReturnedToInitialState(_ cell: SwipingCollectionViewCell) {
        if let interactiveTransitionableViewController = presentingViewController as? InteractiveTransitionableViewController,
            let interactiveDismissTransition = interactiveTransitionableViewController.interactiveDismissTransition {
            interactiveDismissTransition.isEnabled = true
        }
    }
}

extension CardsViewController: CardCollectionViewCellActionsHandler {
    func savePackageConfigForLaterButtonTapped(cell: CardCollectionViewCell) {
        if let index = cardsView.indexPath(for: cell)?.row {
            // Save package config for later without adding to shipment
        }
    }
    
    func addPackageConfigButtonTapped(cell: CardCollectionViewCell) {
        if let index = cardsView.indexPath(for: cell)?.row {
            // Add configuration to a shipment
        }
    }
    
    func preview3DButtonTapped(cell: CardCollectionViewCell) {
        if let index = cardsView.indexPath(for: cell)?.row {
            performSegue(withIdentifier: "Preview3DSegue", sender: self)
        }
    }
    func deleteButtonTapped(cell: CardCollectionViewCell) {
        if let index = cardsView.indexPath(for: cell)?.row {
            storage.data.remove(at: index)
            displayData.remove(at: index)
            cardsView.removeItem(at: index)
        }
        if displayData.isEmpty {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CardsViewController: SmallToLargeAnimatable {
    var animatableBackgroundView: UIView {
        return backgroundView
    }
    
    var animatableMainView: UIView {
        return contentView
    }
    
    func prepareBeingDismissed() {
        cardsView.hideAllCellsExceptSelected(animated: true)
    }
}
