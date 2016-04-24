//
//  MenuViewController.swift
//  vision
//
//  Created by Jason Du on 2016-04-24.
//  Copyright © 2016 IBM Bluemix Developer Advocate Team. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var gradient : CAGradientLayer?
    var toColors : AnyObject?
    var fromColors : AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backblur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: backblur)
        blurView.frame = self.view.bounds
        view.insertSubview(blurView, atIndex: 0)
        
        self.gradient = CAGradientLayer()
        self.gradient?.frame = self.view.bounds
        self.gradient?.colors = [UIColor.lightGrayColor().CGColor, UIColor.whiteColor().CGColor]
        self.view.layer.insertSublayer(self.gradient!, atIndex: 0)
        
        self.toColors = [UIColor.whiteColor().CGColor, UIColor.lightGrayColor().CGColor]
        animateLayer()

    }
    
    func animateLayer(){
        
        self.fromColors = self.gradient?.colors
        self.gradient!.colors = self.toColors! as? [AnyObject] // You missed this line
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.delegate = self
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 20.00
        animation.removedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        
        self.gradient?.addAnimation(animation, forKey:"animateGradient")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        self.toColors = self.fromColors;
        self.fromColors = self.gradient?.colors
        
        animateLayer()
    }
}
