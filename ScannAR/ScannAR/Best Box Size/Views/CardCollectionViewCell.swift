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
    
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var boxTypeImageView: UIImageView!
    @IBOutlet weak var boxTypeNameLabel: UILabel!
    @IBOutlet weak var boxSizeLabel: UILabel!
    @IBOutlet weak var preview3DButton: UIButton!
    @IBOutlet weak var addPackageConfigButton: UIButton!
    @IBOutlet weak var saveConfigForLaterButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: Properties
    var boxTypeImageViewFileName: String = ""
    var previousContentOffset: CGPoint = .zero
    var imgNamesArray: [String] = ["0", "1", "2"]
    var imgArray: [UIImage] = []
    var pageIndex: Int = 0
    var labelText = """
                Item #: 12345
                Name: Ducky
                Weight: 420oz
                Size: 3x4x9
"""
    
    weak var actionsHandler: CardCollectionViewCellActionsHandler?
    override var swipeDistanceOnY: CGFloat {
        return actionsView.bounds.height
    }
    
    // MARK: Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        frontContentView.layer.cornerRadius = 10.0
        scrollView.delegate = self
        scrollView.frame = smallView.frame
        pageControl.numberOfPages = imgNamesArray.count
        pageControl.currentPage = 0
        scrollView.isPagingEnabled = true
        smallView.bringSubviewToFront(pageControl)
    }
    
    func setScrollView(){
        
        for name in imgNamesArray {
            guard let img = UIImage(named: name) else { return }
            if !imgArray.contains(img) {
                imgArray.append(img)
            }else{
                print("Image already exists.")
            }
        }
        
        print(imgArray.count)
        
        for i in 0..<imgArray.count {
            
            
            let imageView = UIImageView()
            let imageLabel = UILabel()
            //imageLabel.removeFromSuperview()
            //            imageLabel.text = ""
            imageView.image = imgArray[i].resizedImage(newSize: CGSize(width: smallView.frame.height, height: smallView.frame.height))
            imageView.contentMode = .left
            let xPosition = self.smallView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition + 0.0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            imageLabel.frame = CGRect(x: imageView.frame.origin.x + 104.0, y: imageView.frame.origin.y, width: imageView.frame.size.width, height: imageView.frame.size.height)
            imageLabel.textColor = UIColor.black
            //            imageLabel.frame.origin.x = imageView.frame.origin.x + 42.0
            
            imageLabel.backgroundColor = UIColor.clear
            imageLabel.textColor = UIColor.black
            imageLabel.lineBreakMode = .byWordWrapping
            imageLabel.numberOfLines = 0
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.contentSize.height = scrollView.frame.height
            
            
            scrollView.addSubview(imageView)
            scrollView.addSubview(imageLabel)
            imageLabel.text = labelText
            
            
            
        }
        
    }
    func setContent(data: PackageConfiguration) {
        boxTypeImageView.image = UIImage(named: PackageConfigViewStorage.shared.boxType.rawValue)
        boxTypeNameLabel.text = data.id + ", " + data.size + ", \(PackageConfigViewStorage.shared.boxType.rawValue)"
        boxSizeLabel.text = String(data.weightLimit) + ", " + String(data.currWeight) + ", " + String(data.itemCount)
        //        detailsLabel.text = data.details
        //        itemImageView.image = UIImage(named: data.itemImageName)
        
        //        setScrollView()
        
        
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

extension CardCollectionViewCell: UIScrollViewDelegate {
    
    // MARK: - UIScrollView Delegate methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        print(pageControl.currentPage)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let _: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let _: CGFloat = currentVerticalOffset / maximumVerticalOffset
    }
    
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControl.currentPage == 0) {
            
            let pageUnselectedColor: UIColor = .blue
            pageControl.pageIndicatorTintColor = pageUnselectedColor
            
            let pageSelectedColor: UIColor = .green
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let kMaxIndex: CGFloat = CGFloat(imgNamesArray.count) - 1
        let pageSize: CGFloat = smallView.frame.width
        let pageSpacing: CGFloat = 0
        
        let targetX = scrollView.contentOffset.x + velocity.x * 60
        var targetIndex: CGFloat = 0.0
        
        if velocity.x >= 0 {
            targetIndex = ceil(targetX / (pageSize + pageSpacing))
        }
        else {
            targetIndex = floor(targetX / (pageSize + pageSpacing))
        }
        if targetIndex < 0 {
            targetIndex = 0
        }
        if targetIndex > kMaxIndex {
            targetIndex = kMaxIndex;
        }
        
        targetContentOffset.pointee.x = targetIndex * (pageSize + pageSpacing)
        let previousIndex = (previousContentOffset.x / (pageSize + pageSpacing))
        var k: CGFloat = 0.0
        k = (scrollView.contentOffset.x / (pageSize + pageSpacing))
        if k > previousIndex {
            k = k.rounded(.up)
        } else {
            k = k.rounded(.down)
        }
        k = min(max(0, k), kMaxIndex)
        DispatchQueue.main.async {
            scrollView.setContentOffset(CGPoint(x: k * (pageSize + pageSpacing), y: scrollView.contentOffset.y), animated: true)
            //            self.scrollView.reloadInputViews()
        }
        //        scrollView.reloadInputViews()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        previousContentOffset = scrollView.contentOffset
    }
}
