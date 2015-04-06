//
//  waveButton.swift
//  waveButton
//
//  Created by Aaron on 4/6/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

import UIKit

class waveButton: UIView
{
    let shapeLayer = CAShapeLayer()
    lazy var touchBeginRadius: CGFloat = {
        //calculate everytime when access this var?
        return self.bounds.width/20
    }()
    
    lazy var touchEndRadius: CGFloat = {
       return self.bounds.width
    }()
    
    var touchAnimatonHandlerOptional: (()->())?
    var pathFrom = UIBezierPath()
    var isTouchBeginAnimationHasStop = true
    
    struct Constante
    {
        static let touchBeginOffSetX = CGFloat(-1)
        static let touchBeginOffSetY = CGFloat(-2)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        layer.cornerRadius = bounds.width/2
        layer.masksToBounds = true
        multipleTouchEnabled = false
        
        shapeLayer.fillColor = UIColor.blueColor().CGColor
        layer.addSublayer(shapeLayer)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        if let touch = touches.allObjects.first as? UITouch
        {
            self.shapeLayer.fillColor = UIColor.blueColor().CGColor
            touchAnimatonHandlerOptional = nil
            
            var pointFrom = touch.locationInView(self)
            pointFrom.x += Constante.touchBeginOffSetX
            pointFrom.y += Constante.touchBeginOffSetY
            
            pathFrom = UIBezierPath(arcCenter: pointFrom, radius: touchBeginRadius, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: false)
            let pathTo = UIBezierPath(arcCenter: pointFrom, radius: touchEndRadius, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: false)
            
            shapeLayer.path = pathTo.CGPath
            
            let animation = CABasicAnimation()
            animation.delegate = self
            animation.fromValue = pathFrom.CGPath
            animation.toValue = pathTo.CGPath
            animation.keyPath = "path"
            animation.duration = 0.5
            shapeLayer.addAnimation(animation, forKey: nil)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        let touchEndHandler: ()->() = {[unowned self] in
            self.shapeLayer.fillColor = UIColor.clearColor().CGColor
            
            let animation = CABasicAnimation()
            animation.fromValue = self.shapeLayer.presentationLayer().valueForKeyPath("fillColor") as CGColor
            animation.toValue = UIColor.clearColor().CGColor
            animation.keyPath = "fillColor"
            animation.duration = 0.3
            self.shapeLayer.addAnimation(animation, forKey: nil)
        }
        
        if isTouchBeginAnimationHasStop
        {
            touchEndHandler()
        }
        else
        {
            touchAnimatonHandlerOptional = touchEndHandler
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {

    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)
    {
    }
}

extension waveButton
{
    override func animationDidStart(anim: CAAnimation!)
    {
        isTouchBeginAnimationHasStop = false
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool)
    {
        isTouchBeginAnimationHasStop = true
        
        if let touchAnimationHandler = touchAnimatonHandlerOptional
        {
            touchAnimationHandler()
        }
    }
}