//
//  SettingsViewController.swift
//  vision
//
//  Created by Jason Du on 2016-04-24.
//  Copyright © 2016 IBM Bluemix Developer Advocate Team. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    
    @IBOutlet var licenseNum: UITextField!
    
    
    @IBOutlet var company: UITextField!
    
    
    @IBOutlet var vesselType: UITextField!
    
    
    @IBOutlet var gear: UITextField!
    
    
    @IBOutlet var targetedSpecies: UITextField!
    
    
    @IBOutlet var quota: UITextField!
    
    @IBOutlet var user: UITextField!
    
    @IBAction func save(sender: AnyObject) {
        sData.sharedInstance.company = company.text!
        sData.sharedInstance.gear = gear.text!
        sData.sharedInstance.licenseNum = licenseNum.text!
        sData.sharedInstance.quota = Int(quota.text!)!
        sData.sharedInstance.targetSpecies = targetedSpecies.text!
        sData.sharedInstance.user = user.text!
        sData.sharedInstance.vesselType = vesselType.text!
        SweetAlert().showAlert("Success!", subTitle: "You have saved your credentials.", style: AlertStyle.Success)

    }
    
    override func viewWillAppear(animated: Bool) {
        company.text = sData.sharedInstance.company
        gear.text = sData.sharedInstance.gear
        licenseNum.text = sData.sharedInstance.licenseNum
        quota.text = "\(sData.sharedInstance.quota)"
        targetedSpecies.text = sData.sharedInstance.targetSpecies
        user.text = sData.sharedInstance.user
        vesselType.text = sData.sharedInstance.vesselType
    }
    
    
    @IBAction func mainMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
