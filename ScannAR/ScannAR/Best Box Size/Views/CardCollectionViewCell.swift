//
//  CardCollectionViewCell.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/5/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

protocol CardCollectionViewCellActionsHandler: class {
    func deleteButtonTapped(cell: CardCollectionViewCell)
    func savePackageConfigForLaterButtonTapped(cell: CardCollectionViewCell)
    func addPackageConfigButtonTapped(cell: CardCollectionViewCell)
    func preview3DButtonTapped(cell: CardCollectionViewCell)
}

class CardCollectionViewCell: SwipingCollectionViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var boxTypeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var preview3DButton: UIButton!
    @IBOutlet weak var addPackageConfigButton: UIButton!
    @IBOutlet weak var saveConfigForLaterButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: Properties
    
    weak var actionsHandler: CardCollectionViewCellActionsHandler?
    override var swipeDistanceOnY: CGFloat {
        return actionsView.bounds.height
    }
    
    // MARK: Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        frontContentView.layer.cornerRadius = 10.0
    }
    
    func setContent(data: CardCellDisplayable) {
        boxTypeImageView.image = UIImage(named: data.boxTypeImageViewFileName)
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        detailsLabel.text = data.details
        itemImageView.image = UIImage(named: data.itemImageName)
    }
    
    override func frontViewPositionChanged(on percent: CGFloat) {
        super.frontViewPositionChanged(on: percent)
        saveConfigForLaterButton.alpha = percent
        addPackageConfigButton.alpha = percent
        preview3DButton.alpha = percent
        
        deleteButton.alpha = percent
        
        let transformPercent = min(percent / 4 + 0.75, 1)
        saveConfigForLaterButton.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
        addPackageConfigButton.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
        preview3DButton.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
        
        deleteButton.transform = CGAffineTransform(scaleX: transformPercent, y: transformPercent)
    }
    
    private func handleButtonTap(completion: @escaping () -> Void) {
        moveCellToInitialState {
            completion()
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Preview3DSegue"{
            guard segue.destination is BoxConfig3DPreviewViewController else { fatalError("Segue should cast view controller as BoxConfig3DPreviewViewController but failed to do so.")}
        }
    }
    // MARK: IBActions
    var toVC: UIViewController?
    @IBAction private func preview3DButtonTapped(_ sender: Any) {
        handleButtonTap { [weak self] in
            guard let self = self else { return }
            self.actionsHandler?.preview3DButtonTapped(cell: self)
     }
    }
    
    @IBAction func addPackageConfigButtonTapped(_ sender: Any) {
        handleButtonTap {  [weak self] in
            guard let self = self else { return }
            self.actionsHandler?.addPackageConfigButtonTapped(cell: self)
        }
    }
    
    @IBAction func savePackageConfigForLaterButtonTapped(_ sender: Any) {
        handleButtonTap {  [weak self] in
            guard let self = self else { return }
            self.actionsHandler?.savePackageConfigForLaterButtonTapped(cell: self)
            
        }
    }
    
    
    @IBAction private func deleteButtonTapped(_ sender: Any) {
        handleButtonTap { [weak self] in
            guard let self = self else { return }
            self.actionsHandler?.deleteButtonTapped(cell: self)
        }
    }
}
