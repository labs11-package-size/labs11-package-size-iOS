//
//  ProgressViewController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/19/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, ProgressBarDelegate, BottomButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        updateViews()
        layoutViewDirectFromProduct()
        
        switch buttonState {
        case .packageStart:
            layoutViewDirectFromPackages()
        case .trackingNumberEntered:
            layoutViewDirectFromShipments()
        default:
            print("Nothing to update")
        }
        
        
    }
    
    // MARK: - Private Methods
    private func updateViews(){
        
        
        productContainerView.layer.cornerRadius = 20
        productContainerView.clipsToBounds = true
        
        
        packageContainerView.layer.cornerRadius = 20
        packageContainerView.clipsToBounds = true
        
        
        shippingContainerView.layer.cornerRadius = 20
        shippingContainerView.clipsToBounds = true
        
        
        // product shadow
        
        productContainerView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        productContainerView.layer.shadowRadius = 2.0
        productContainerView.layer.shadowOpacity = 1.0
        productContainerView.layer.masksToBounds = false
        
        productContainerView.layer.shadowColor = UIColor.gray.cgColor
        productContainerView.layer.shadowPath = UIBezierPath(roundedRect:productContainerView.bounds, cornerRadius:productContainerView.layer.cornerRadius).cgPath
        
        // package shadow
        packageContainerView.layer.shadowColor = UIColor.gray.cgColor
        packageContainerView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        packageContainerView.layer.shadowRadius = 2.0
        packageContainerView.layer.shadowOpacity = 1.0
        packageContainerView.layer.masksToBounds = false
        packageContainerView.layer.shadowPath = UIBezierPath(roundedRect:packageContainerView.bounds, cornerRadius:packageContainerView.layer.cornerRadius).cgPath
        
        // package shadow
        shippingContainerView.layer.shadowColor = UIColor.gray.cgColor
        shippingContainerView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        shippingContainerView.layer.shadowRadius = 2.0
        shippingContainerView.layer.shadowOpacity = 1.0
        shippingContainerView.layer.masksToBounds = false
        shippingContainerView.layer.shadowPath = UIBezierPath(roundedRect:shippingContainerView.bounds, cornerRadius:shippingContainerView.layer.cornerRadius).cgPath
        
        drawDottedLine(view0)
        drawDottedLine(view1)
    }
    
    private func layoutViewDirectFromProduct(){
        
        productImageView.setImageColor(color: .white)
        productImageView.backgroundColor = UIColor(named: "appARKADarkBlue")
        packageImageView.setImageColor(color: .gray)
        shippingImageView.setImageColor(color: .gray)
        
        productContainerView.backgroundColor = UIColor(named: "appARKADarkBlue")
        
        packageContainerView.borderColor = .gray
        packageContainerView.borderWidth = 1
        
        shippingContainerView.borderColor = .gray
        shippingContainerView.borderWidth = 1
        
        
    }
    
    private func layoutViewDirectFromPackages(){
        
        self.packageViewSetup()
        
        self.drawLine(self.view0, 1.0, duration: 0.01, uiColor: .gray, completion: {})
        
    }
    
    private func layoutViewDirectFromShipments(){
        layoutViewDirectFromPackages()
        
        self.drawLine(self.view1, 1, duration: 0.01, uiColor: UIColor(named: "appARKADarkBlue")!, completion:  {
            self.addCircleView(self.shippingContainerView, duration: 0.01) {
                self.drawLine(self.view1, 1, duration: 0.01, uiColor: .gray, completion: {
                    self.removePreviousShapeLayers()
                })
                UIView.animate(withDuration: 0.01, animations: {
                    self.shipmentViewSetup()
                })
                
            }
        })
        
    }
    
    private func packageViewSetup(){
        productContainerView.backgroundColor = .gray
        productImageView.backgroundColor = .gray
        
        packageImageView.setImageColor(color: .white)
        packageContainerView.backgroundColor = UIColor(named: "appARKADarkBlue")
        packageContainerView.borderColor = UIColor(named: "appARKADarkBlue")

    }
    
    private func shipmentViewSetup(){
        packageContainerView.backgroundColor = .gray
        packageImageView.backgroundColor = .gray
        packageContainerView.borderColor = .gray
        
        shippingImageView.setImageColor(color: .white)
        shippingContainerView.backgroundColor = UIColor(named: "appARKADarkBlue")
        shippingContainerView.borderColor = UIColor(named: "appARKADarkBlue")
        
        
    }
    
    private func drawDottedLine(_ view: UIView) {
        
        let start = CGPoint(x: view.bounds.minX, y: view.bounds.maxY/2)
        let end = CGPoint(x: view.bounds.maxX, y: view.bounds.maxY/2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
        
        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    private func drawLine(_ view: UIView, _ percentageFill: Double, duration: Double, uiColor: UIColor, completion: @escaping () -> Void) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let start = CGPoint(x: view.bounds.minX, y: view.bounds.maxY/2)
        let end = CGPoint(x: view.bounds.maxX * CGFloat(percentageFill) , y: view.bounds.maxY/2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = uiColor.cgColor
        shapeLayer.lineWidth = 4
        
        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = duration
        shapeLayer.add(animation, forKey: "MyAnimation")
        
        view.layer.addSublayer(shapeLayer)
        CATransaction.commit()
    }
    private func drawDot(_ view: UIView, duration: Double, uiColor: UIColor, completion: @escaping () -> Void)-> Void{
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let middleX = view.bounds.maxX/2
        let middleY = view.bounds.maxY/2
        let radius = CGFloat(8)
        
        let dotPath = UIBezierPath(ovalIn: CGRect(x: middleX - radius/2, y: middleY - radius/2, width: radius, height: radius))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.strokeColor = uiColor.cgColor
        
        let animation = CABasicAnimation(keyPath: "drawDot")
        animation.duration = duration
        shapeLayer.add(animation, forKey: "DotAnimation")
        self.dotShapeLayer = shapeLayer
        view.layer.addSublayer(shapeLayer)
        CATransaction.commit()
    }
    
    private func removePreviousShapeLayers() {
        dotShapeLayer?.removeFromSuperlayer()
        circleView?.removeFromSuperview()
    }
    
    func addCircleView(_ view: UIView, duration: Double, completion: @escaping () -> Void) -> Void {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let circleWidth = view.bounds.width
        let circleHeight = view.bounds.height
        
        // Create a new CircleView
        let circleView = CircleView(frame: CGRect(x: 0, y: 0, width: circleWidth, height: circleHeight))
        self.circleView = circleView
        view.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(duration: duration)
        CATransaction.commit()
    }
    
    func packThisBoxTapped() {
        
        self.drawLine(self.view0, 0.5, duration: 0.8, uiColor: UIColor(named: "appARKADarkBlue")!, completion: { self.drawDot(self.view0, duration: 0.8, uiColor: UIColor(named: "appARKADarkBlue")!) {} })
    
    }
    
    func useRecommendedBoxTapped() {
        self.drawLine(self.view0, 1, duration: 0.5, uiColor: UIColor(named: "appARKADarkBlue")!, completion:  {
            self.addCircleView(self.packageContainerView, duration: 0.8) {
                self.drawLine(self.view0, 1, duration: 0.05, uiColor: .gray, completion: {
                    self.removePreviousShapeLayers()
                })
                UIView.animate(withDuration: 0.5, animations: {
                    self.packageViewSetup()
                }, completion: { (true) in
                    UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeCubic, animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                            self.packageContainerView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
                        }
                        
                        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                            self.packageContainerView.transform = .identity
                        }
                    })
                    
                })
            
            }
        })
    }
    
    func shipItTapped() {
        self.drawLine(self.view1, 0.5, duration: 0.8, uiColor: UIColor(named: "appARKADarkBlue")!, completion: { self.drawDot(self.view1, duration: 0.8, uiColor: UIColor(named: "appARKADarkBlue")!) {} })
    }
    
    func trackingNumberEntered() {
        self.drawLine(self.view1, 1, duration: 0.5, uiColor: UIColor(named: "appARKADarkBlue")!, completion:  {
            self.addCircleView(self.shippingContainerView, duration: 0.8) {
                self.drawLine(self.view1, 1, duration: 0.05, uiColor: .gray, completion: {
                    self.removePreviousShapeLayers()
                })
                UIView.animate(withDuration: 0.5, animations: {
                    self.shipmentViewSetup()
                }, completion: { (true) in
                    UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeCubic, animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                            self.shippingContainerView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
                        }
                        
                        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                            self.shippingContainerView.transform = .identity
                        }
                    })
                    
                })
                
            }
        })
    }
    
    
    @IBOutlet weak var view0: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var shippingImageView: UIImageView!
    var dotShapeLayer: CAShapeLayer?
    var circleView: CircleView?
    var buttonState: ButtonState = .productStart
    
    @IBOutlet weak var productContainerView: UIView!
    @IBOutlet weak var packageContainerView: UIView!
    @IBOutlet weak var shippingContainerView: UIView!
    
}
