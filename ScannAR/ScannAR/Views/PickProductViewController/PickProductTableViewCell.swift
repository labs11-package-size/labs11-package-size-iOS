//
//  PickProductTableViewCell.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/6/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class PickProductTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addRemoveButton.clipsToBounds = true
        addRemoveButton.layer.cornerRadius = 6
    }
    
    // MARK: - IBActions
    @IBAction func addRemoveButtonTapped(_ sender: Any) {
        guard let product = product else { fatalError("No product!") }
        delegate?.updateProduct(product)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var addRemoveButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    
    // MARK: - Properties
    var product: Product?
    var delegate: ProductPickerDelegate?
}
