//
//  CircleView.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class CircleView: UIView {
    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width)/2, startAngle: CGFloat(.pi * 1.0), endAngle: CGFloat(.pi * 3.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor(named: "appARKADarkBlue")!.cgColor
        circleLayer.lineWidth = 4.0;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        // Get the Graphics Context
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Set the circle outerline-width
        context.setLineWidth(5.0);
        
        // Set the circle outerline-colour
        UIColor.red.set()
        
        // Create Circle
        context.addArc(center: CGPoint(x: CGFloat(frame.maxX/2), y: CGFloat(frame.maxY/2)), radius: 16, startAngle: .pi, endAngle: .pi * 3, clockwise: true)
        // Draw
        context.strokePath();
    }
}
