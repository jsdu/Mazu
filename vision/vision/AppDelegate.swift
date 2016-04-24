/**
 * Copyright 2016 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the “License”);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an “AS IS” BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    print("Loading default settings...")
    let defaultSettings = NSBundle.mainBundle().URLForResource("Default Settings", withExtension: "plist")
    NSUserDefaults.standardUserDefaults().registerDefaults(NSDictionary(contentsOfURL: defaultSettings!) as! [String : AnyObject])
    NSUserDefaults.standardUserDefaults().synchronize()
    IQKeyboardManager.sharedManager().enable = true

    UITabBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().barTintColor = UIColor(red:0.09, green:0.66, blue:0.55, alpha:1.0)
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    UITabBar.appearance().barTintColor = UIColor(red:0.09, green:0.66, blue:0.55, alpha:1.0)


    return true
  }

  func applicationWillResignActive(application: UIApplication) {
  }

  func applicationDidEnterBackground(application: UIApplication) {
  }

  func applicationWillEnterForeground(application: UIApplication) {
  }

  func applicationDidBecomeActive(application: UIApplication) {
  }

  func applicationWillTerminate(application: UIApplication) {
  }

}

