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
    var actionHandlerOptional: (()->())?
    var isTouchUpInside = true
    
    struct Constante
    {
        static let touchBeginOffSetX = CGFloat(-1)
        static let touchBeginOffSetY = CGFloat(-2)
        
        static let touchBeginAnimationKey = "touchBeginAnimationKey"
        static let touchEndAnimationKey = "touchEndAnimationKey"
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        didInt()
    }
    
    init(frame: CGRect, actionHandler handler: ()->())
    {
        super.init(frame: frame)
        actionHandlerOptional = handler
        didInt()
    }
    
    func didInt()
    {
        backgroundColor = UIColor.purpleColor()
        
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
            userInteractionEnabled = false
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
            animation.removedOnCompletion = false
            shapeLayer.addAnimation(animation, forKey: Constante.touchBeginAnimationKey)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        resetButton()
        if let touch = touches.allObjects.first as? UITouch
        {
            if self.pointInside(touch.locationInView(self), withEvent: nil)
            {
                isTouchUpInside = true
            }
            else
            {
                isTouchUpInside = false
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
    {

    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)
    {
        resetButton()
    }
    
    func resetButton()
    {
        let touchEndHandler: ()->() = {[unowned self] in
            self.shapeLayer.fillColor = UIColor.clearColor().CGColor
            
            let animation = CABasicAnimation()
            animation.delegate = self
            animation.fromValue = self.shapeLayer.presentationLayer().valueForKeyPath("fillColor") as CGColor
            animation.toValue = UIColor.clearColor().CGColor
            animation.keyPath = "fillColor"
            animation.duration = 0.3
            animation.removedOnCompletion = false
            self.shapeLayer.addAnimation(animation, forKey: Constante.touchEndAnimationKey)
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
}

extension waveButton
{
    override func animationDidStart(anim: CAAnimation!)
    {
        if shapeLayer.animationForKey(Constante.touchBeginAnimationKey) == anim
        {
            isTouchBeginAnimationHasStop = false
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool)
    {
        if shapeLayer.animationForKey(Constante.touchBeginAnimationKey) == anim
        {
            isTouchBeginAnimationHasStop = true
            
            if let touchAnimationHandler = touchAnimatonHandlerOptional
            {
                touchAnimationHandler()
            }
        }
        else if shapeLayer.animationForKey(Constante.touchEndAnimationKey) == anim
        {
            shapeLayer.removeAllAnimations()
            userInteractionEnabled = true
            
            if isTouchUpInside
            {
                if let action = actionHandlerOptional
                {
                    action()
                }
            }
        }
    }
}