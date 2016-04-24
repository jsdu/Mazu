//
//  SyncViewController.swift
//  vision
//
//  Created by Jason Du on 2016-04-23.
//  Copyright © 2016 IBM Bluemix Developer Advocate Team. All rights reserved.
//

import UIKit
import Firebase
class SyncViewController: UIViewController {

    
    var gradient : CAGradientLayer?
    var toColors : AnyObject?
    var fromColors : AnyObject?

    override func viewDidLoad() {
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

    
    
    @IBAction func syncButton(sender: AnyObject) {
        // Create a reference to a Firebase location
        let myRootRef = Firebase(url:"https://mazu.firebaseio.com/fishData")
        var data: NSData = NSData()
        for i in 0 ..< sData.sharedInstance.party.count {
            data = UIImageJPEGRepresentation(sData.sharedInstance.party[i].fishImage!,0.1)!
        
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let user: NSDictionary = ["fishImage":base64String,
                                  "forkLength":sData.sharedInstance.party[i].forkLength,
                                  "totalLength":sData.sharedInstance.party[i].totalLength,
                                  "sex":sData.sharedInstance.party[i].sex,
                                  "weight":sData.sharedInstance.party[i].weight,
                                  
                                  "user":sData.sharedInstance.party[i].user,
                                  "company":sData.sharedInstance.party[i].company,
                                  "gear":sData.sharedInstance.party[i].gear,
                                  "licenseNum":sData.sharedInstance.party[i].licenseNum,
                                  "quota":sData.sharedInstance.party[i].quota,
                                  "targetSpecies":sData.sharedInstance.party[i].targetSpecies,
                                  "vesselType":sData.sharedInstance.party[i].vesselType,
                                  
                                  "date":sData.sharedInstance.party2[i].date,
                                  "latitude":sData.sharedInstance.party2[i].latitude,
                                  "longitutde":sData.sharedInstance.party2[i].longitude,
                                  "time":sData.sharedInstance.party2[i].time,

                                  ]
        
        //add firebase child node
        print (sData.sharedInstance.party[i].species)
        var fishId = sData.sharedInstance.party[i].species
        fishId += "_"
        fishId += "\(Int(arc4random_uniform(1000)))"
        let profile = myRootRef.ref.childByAppendingPath(fishId)
        
        // Write data to Firebase
        profile.setValue(user)
        print("SAVED TO FIREBASE")
        }
        SweetAlert().showAlert("Synced!", subTitle: "You have saved your data to the database.", style: AlertStyle.Success)

    }
}
