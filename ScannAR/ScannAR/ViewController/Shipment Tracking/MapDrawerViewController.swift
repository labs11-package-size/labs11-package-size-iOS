//
//  MapDrawerViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/18/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

enum MapDrawerLevel{
    case top, bottom, middle
}

protocol MapDrawerDelegate {
    func updateMapDrawer(frame: CGRect)
}

class MapDrawerViewController: UIViewController{
    
    @IBOutlet var panView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var lastY: CGFloat = 0
    var pan: UIPanGestureRecognizer!
    
    var scannARNetworkingController: ScannARNetworkController?
    var shipment: Shipment?
    var mapDrawerDelegate: MapDrawerDelegate?
    var parentView: UIView!
    
    var initalFrame: CGRect!
    var topY: CGFloat = 80 //change this in viewWillAppear for top position
    var middleY: CGFloat = 400 //change this in viewWillAppear to decide if animate to top or bottom
    var bottomY: CGFloat = 600 //no need to change this
    let bottomOffset: CGFloat = 108 //drawer height on bottom position
    var lastLevel: MapDrawerLevel = .bottom //choose inital position of the drawer
    
    var disableTableScroll = false
    
    //hack panOffset To prevent jump when goes from top to down
    var panOffset: CGFloat = 0
    var applyPanOffset = false
    
    //tableview variables
    var listItems: [Any] = []
    var headerItems: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        self.panView.addGestureRecognizer(pan)
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
        
        //        self.hidesBottomBarWhenPushed = true
        self.tableView.reloadData()
        self.reloadInputViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initalFrame = UIScreen.main.bounds
        self.topY = round(initalFrame.height * 0.05) + 42
        self.middleY = (initalFrame.height * 0.6) - 42
        self.bottomY = (initalFrame.height - bottomOffset) + 4
        self.lastY = self.bottomY
        
        mapDrawerDelegate?.updateMapDrawer(frame: self.initalFrame.offsetBy(dx: 0, dy: self.bottomY))
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {return}
        
        if (self.parentView.frame.minY > topY){
            self.tableView.contentOffset.y = 0
        }
    }
    
    
    //this stops unintended tableview scrolling while animating to top
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == tableView else {return}
        
        if disableTableScroll{
            targetContentOffset.pointee = scrollView.contentOffset
            disableTableScroll = false
        }
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer){
//        let p = recognizer.location(in: self.tableView)
//        let index = tableView.indexPathForRow(at: p)
        //WARNING: calling selectRow doesn't trigger tableView didselect delegate. So handle selected row here.
        //You can remove this line if you dont want to force select the cell
        //tableView.selectRow(at: index, animated: false, scrollPosition: .none)
    }
    
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        
        let dy = recognizer.translation(in: self.parentView).y
        switch recognizer.state {
        case .began:
            applyPanOffset = (self.tableView.contentOffset.y > 0)
        case .changed:
            if self.tableView.contentOffset.y > 0{
                panOffset = dy
                return
            }
            
            if self.tableView.contentOffset.y <= 0{
                if !applyPanOffset{panOffset = 0}
                let maxY = max(topY, lastY + dy - panOffset)
                let y = min(bottomY, maxY)
                //                self.panView.frame = self.initalFrame.offsetBy(dx: 0, dy: y)
                mapDrawerDelegate?.updateMapDrawer(frame: self.initalFrame.offsetBy(dx: 0, dy: y))
                
            }
            
            if self.parentView.frame.minY > topY{
                self.tableView.contentOffset.y = 0
            }
        case .failed, .ended, .cancelled:
            panOffset = 0
            
            if (self.tableView.contentOffset.y > 0){
                return
            }
            
            self.panView.isUserInteractionEnabled = false
            
            self.disableTableScroll = self.lastLevel != .top
            
            self.lastY = self.parentView.frame.minY
            self.lastLevel = self.nextLevel(recognizer: recognizer)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: {
                
                switch self.lastLevel{
                case .top:
                    //                    self.panView.frame = self.initalFrame.offsetBy(dx: 0, dy: self.topY)
                    self.mapDrawerDelegate?.updateMapDrawer(frame: self.initalFrame.offsetBy(dx: 0, dy: self.topY))
                    self.tableView.contentInset.bottom = 50
                case .middle:
                    //                    self.panView.frame = self.initalFrame.offsetBy(dx: 0, dy: self.middleY)
                    self.mapDrawerDelegate?.updateMapDrawer(frame: self.initalFrame.offsetBy(dx: 0, dy: self.middleY))
                case .bottom:
                    //                    self.panView.frame = self.initalFrame.offsetBy(dx: 0, dy: self.bottomY)
                    self.mapDrawerDelegate?.updateMapDrawer(frame: self.initalFrame.offsetBy(dx: 0, dy: self.bottomY))
                }
                
            }) { (_) in
                self.panView.isUserInteractionEnabled = true
                self.lastY = self.parentView.frame.minY
            }
        default:
            break
        }
    }
    
    func nextLevel(recognizer: UIPanGestureRecognizer) -> MapDrawerLevel{
        let y = self.lastY
        let velY = recognizer.velocity(in: self.view).y
        if velY < -200{
            return y > middleY ? .middle : .top
        }else if velY > 200{
            return y < (middleY + 1) ? .middle : .bottom
        }else{
            if y > middleY {
                return (y - middleY) < (bottomY - y) ? .middle : .bottom
            }else{
                return (y - topY) < (middleY - y) ? .top : .middle
            }
        }
    }
}

extension MapDrawerViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapDrawerTableViewCell", for: indexPath) as! MapDrawerTableViewCell
        
        guard let shipment = shipment else { fatalError("No shipment passed to this VC") }
        
        let dateLabelArray = ["April 13, 2019", "April 13, 2019", "April 13, 2019", "April 13, 2019", "April 13, 2019", "April 13, 2019", "April 13, 2019", "April 12, 2019", "April 11, 2019", "April 11, 2019", "April 11, 2019", "April 11, 2019"]
        let timeLabelArray = ["10:32 am", "8:55 am", "8:45 am", "7:10 am", "6:05 am", "5:09 am", "12:00 am", " ", "9:57 pm", "8:42 pm", "1:23 pm", "7:05 am"]
        let statusLabelArray = ["Delivered, In/At Mailbox", "Out for Delivery", "Sorting Complete", "Arrived at Post Office ", "Arrived at USPS Facility", "Departed USPS Regional Facility", "Arrived at USPS Regional Destination Facility", "In Transit to Next Facility", "Arrived at USPS Regional Origin Facility", "Accepted at USPS Origin Facility", "USPS in possession of item", "Shipping Label Created, USPS Awaiting Item "]
        let currentLocationLabelArray = ["NORTH DIGHTON, MA 02764", "NORTH DIGHTON, MA 02764", "NORTH DIGHTON, MA 02764", "NORTH DIGHTON, MA 02764", "NORTH DIGHTON, MA 02764", "PROVIDENCE RI DISTRIBUTION CENTER", "PROVIDENCE RI DISTRIBUTION CENTER", " ", "CHAMPAIGN IL DISTRIBUTION CENTER", "CHARLESTON, IL 61920", "CHARLESTON, IL 61920", "CHARLESTON, IL 61920"]
        
        cell.configure(model: shipment)
        cell.trackingCellStatusLabel.text = statusLabelArray[indexPath.row]
        cell.trackingCellDateLabel.text = dateLabelArray[indexPath.row]
        cell.trackingCellTimeLabel.text = timeLabelArray[indexPath.row]
        cell.trackingCellCurrentLocation.text = currentLocationLabelArray[indexPath.row]
        return cell
    }
}

extension MapDrawerViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

