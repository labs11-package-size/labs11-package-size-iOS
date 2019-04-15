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
    @IBOutlet weak var boxConfigLabel: UILabel!
    @IBOutlet weak var boxSizeLabel: UILabel!
    @IBOutlet weak var preview3DButton: UIButton!
    @IBOutlet weak var addPackageConfigButton: UIButton!
    @IBOutlet weak var saveConfigForLaterButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet var itemDetailLabel: UILabel!
    // MARK: Properties
    let storage = PackageConfigViewStorage.shared
    var boxTypeImageViewFileName: String = ""
    var previousContentOffset: CGPoint = .zero
    var imgNamesArray = [String]()
    
    var imgArray: [UIImage] = []
    var pageIndex: Int = 0
//    var labelText = """
//                Item #: 12345
//                Name: Ducky
//                Weight: 420oz
//                Size: 3x4x9
//"""
    
    weak var actionsHandler: CardCollectionViewCellActionsHandler?
    override var swipeDistanceOnY: CGFloat {
        return actionsView.bounds.height
    }
    
    // MARK: Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgNamesArray = (0..<storage.data.count).map{ String($0) }
        print(imgNamesArray)
        frontContentView.layer.cornerRadius = 10.0
        scrollView.delegate = self
        scrollView.frame.size = smallView.frame.size
        pageControl.currentPage = 0
        scrollView.isPagingEnabled = true
        smallView.bringSubviewToFront(pageControl)
        
    }
    
//    private func fetchAssets(){
//        //guard let product = product else {fatalError("No product available to show")}
//        //guard let uuid = product.uuid else {fatalError("No uuid available to show")}
//        ScannARNetworkController?.getAssetsForProduct(uuid: uuid, completion: { (results, error) in
//
//            guard let firstAsset = results?.first else { return }
//            guard let url = URL(string: firstAsset.urlString) else {
//                return
//            }
//            var data: Data
//            do {
//                data = try Data(contentsOf:  url)
//            } catch {
//                print("Could not get picture from URL")
//                return
//            }
//            DispatchQueue.main.async {
//                self.imageView.image = UIImage(data: data)
//            }
//
//        })
//    }
    
    func setScrollView(){
        // dynamically builds package detail paging scrollViews from fetched results
        for name in imgNamesArray {
            guard let img = UIImage(named: name) else { return }
            if !imgArray.contains(img) {
                imgArray.append(img)
            }else{
                print("Image already exists.")
            }
        }
        
        for packageConfig in storage.data {
            var i = 0
            
            for item in packageConfig.items {
                //print("packageConfig \(i), itemCount: \(packageConfig.itemCount)")
                let imageView = UIImageView()
                itemDetailLabel = UILabel()
                
                
                imageView.image = imgArray[i].resizedImage(newSize: CGSize(width: smallView.frame.height, height: smallView.frame.height))
                imageView.contentMode = .left
                let xPosition = self.scrollView.frame.width * CGFloat(i)
                imageView.frame = CGRect(x: xPosition + 0.0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
                
                itemDetailLabel.frame = CGRect(x: imageView.frame.origin.x + 104.0, y: imageView.frame.origin.y, width: imageView.frame.size.width, height: imageView.frame.size.height)
                itemDetailLabel.contentMode = .right
                itemDetailLabel.textColor = UIColor.black
                
                itemDetailLabel.backgroundColor = UIColor.clear
                itemDetailLabel.textColor = UIColor.black
                itemDetailLabel.lineBreakMode = .byWordWrapping
                itemDetailLabel.numberOfLines = 0
                
                scrollView.contentSize.width = smallView.frame.width * CGFloat(i + 1)
                scrollView.contentSize.height = smallView.frame.height
                
                
                scrollView.addSubview(imageView)
                scrollView.addSubview(itemDetailLabel)
                itemDetailLabel.text = """
                            Item #: \(item.id)
                            Name: \(item.uuid?.prefix(7) ?? "1234567")
                            Weight: \(item.weight)oz
                            Size: \(item.origSize)
              """
                i += 1
                
                
                
            }
            
        }
        
    }
    
  
    func setContent(data: PackageConfiguration) {
        let boxConfigLabelText = """
                ID #:   \(data.id)
                Name:   \(storage.boxType.rawValue)
                Size:   \(data.size)
                Item Count:   \(data.itemCount)
                Max Weight:   \(data.weightLimit)oz
                Packed Weight:   \(data.currWeight)oz
"""
        boxTypeImageView.image = UIImage(named: "\(storage.boxType.rawValue)")
        boxConfigLabel.text = boxConfigLabelText

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
       // print(pageControl.currentPage)
        
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
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        previousContentOffset = scrollView.contentOffset
    }
}
