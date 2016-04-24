//
//  File.swift
//  vision
//
//  Created by Jason Du on 2016-04-23.
//  Copyright © 2016 IBM Bluemix Developer Advocate Team. All rights reserved.
//

import UIKit

//
//  pdata.swift
//  policeCount
//
//  Created by Jason Du on 2016-02-16.
//  Copyright © 2016 Jason Du. All rights reserved.
//

import UIKit

private let sharedInstance = sData()

class sData {
    static let sharedInstance = sData()
    var party:[fishData] = []
    var party2:[fishData2] = []
    var user = ""
    var licenseNum = ""
    var company = ""
    var vesselType = ""
    var gear = ""
    var targetSpecies = ""
    var quota = 0

    class var sharedDispatchInstance: sData {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: sData? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = sData()
        }
        return Static.instance!
    }
    
    class var sharedStructInstance: sData {
        struct Static {
            static let instance = sData()
        }
        return Static.instance
    }
}

