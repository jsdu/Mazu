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
//import TagListView
import JGProgressHUD
import AlamofireImage
import Alamofire
import Foundation
import SwiftyJSON

/// Triggers the processing of the selected image and displays the results
class ResultController: UIViewController {
    
    @IBOutlet var forkLengthField: UITextField!
    
    @IBOutlet var totalLengthField: UITextField!
    
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var sexSegControl: UISegmentedControl!
    
    @IBOutlet var sexSegmentControl: UISegmentedControl!
    
    @IBOutlet var recognizedFishTextField: UITextField!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var progressHUD:JGProgressHUD = JGProgressHUD(style: .Dark)
    //  @IBOutlet weak var imageTags: TagListView!
    
    var imageToProcess: UIImage!
    var originalFacesContainerHeight: CGFloat!
    
    
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        sexSegmentControl.layer.cornerRadius = 5;
        sexSegmentControl.clipsToBounds = true;
    }
    
    func setImage(imageToProcess: UIImage) {
        self.imageToProcess = imageToProcess
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        imageView.image = imageToProcess
        backgroundImageView.image = BlurFilter().filter(imageToProcess)
        //    enableGhostContent();
    }
    
    override func viewDidAppear(animated: Bool) {
        processImage()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //    if (segue.identifier == "Faces") {
        //      facesController = segue.destinationViewController as! FacesController
        //    }
    }
    
    /// Processes the image
    private func processImage() {
        progressHUD.indicatorView = JGProgressHUDPieIndicatorView(HUDStyle: .Dark)
        progressHUD.showInView(view, animated: true)
        progressHUD.textLabel.text = "Analyzing..."
        
        
        uploadWithAlamofire()
    }
    
    
    /// Updates the user interface with the analysis results
    private func updateWithResult(result: Result) {
        print("Refreshing UI with results...", result);
        
        // add tags for every keyword and tag, highlighting the one with higher score
        for keyword in result.keywords() {
            if (keyword["text"].string! == "NO_TAGS") {
                continue
            }
            self.recognizedFishTextField.text = keyword["text"].string!
        }
        
    }
    
    
    func uploadWithAlamofire() {
        
        // define parameters
        //\"clownfish_927405258\"
        let parameters = [
            "version": "2015-12-02",
            "classifier_ids":"{\"classifier_ids\":[\"smallMouthBass_1156558140\",\"LargeMouthBass_1666979638\",\"goby_1212804789\",\"ToyClownfish_735783254\"]}"
        ]
        
        let user = "f26af77d-3f5c-421f-8267-99099efd4df3"
        let password = "DXnKey5DGMG4"
        
        let credentialData = "\(user):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
       // let newJson = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
        print ("Begin Upload")
        // Begin upload
        Alamofire.upload(.POST, "https://gateway.watsonplatform.net/visual-recognition-beta/api/v2/classify?version=2015-12-02",
                         // define your headers here
            headers: headers,
            multipartFormData: { multipartFormData in
                // import image to request
                if let imageData = UIImageJPEGRepresentation(self.imageToProcess, 1) {
                    multipartFormData.appendBodyPart(data: imageData, name: "images_file", fileName: "myImage.png", mimeType: "image/png")
                }
                
                
                // import parameters
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
                
            }, // you can customise Threshold if you wish. This is the alamofire's default value
            encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        let result = JSON(data: response.data!)
                        print (result)
                        if let name = result["images"][0]["scores"][0]["name"].string {
                            print (result["images"][0]["scores"][0]["score"])
                            if result["images"][0]["scores"][0]["score"] > 0.75 {
                                self.recognizedFishTextField.text = name
                                if (self.recognizedFishTextField.text == "goby") {
                                    SweetAlert().showAlert("Invasive Species!", subTitle: "Do NOT release this species.", style: AlertStyle.CustomImag(imageFile: "invasiveSpecies"))
                                    self.recognizedFishTextField.text = "Goby"
                                } else if (self.recognizedFishTextField.text == "LargeMouthBass") {
                                    self.recognizedFishTextField.text = "Largemouth Bass"
                                } else if (self.recognizedFishTextField.text == "smallMouthBass") {
                                    self.recognizedFishTextField.text = "Smallmouth Bass"
                                } else if (self.recognizedFishTextField.text == "clownfish") {
                                    self.recognizedFishTextField.text = "Clownfish"
                                }
                            }
                            self.progressHUD.dismiss()
                            
                        } else {
                            self.progressHUD.dismiss()
                        }
                        
//                        if let name = result[1].string {
//                            print (name)
//                        }
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    self.progressHUD.dismiss()
                }
        })
        
    }
    
    
    @IBAction func continueButton(sender: AnyObject) {
        
        let newFish = fishData()
        newFish.company = sData.sharedInstance.company
        newFish.licenseNum = sData.sharedInstance.licenseNum
        newFish.gear = sData.sharedInstance.gear
        newFish.quota = sData.sharedInstance.quota
        newFish.targetSpecies = sData.sharedInstance.targetSpecies
        newFish.vesselType = sData.sharedInstance.vesselType
        newFish.user = sData.sharedInstance.user
        
        
        if let forkLength = Int(forkLengthField.text!) {
            newFish.forkLength = forkLength
        } else {
            newFish.forkLength = 0
        }
        
        if let totalLength = Int(totalLengthField.text!) {
            newFish.totalLength = totalLength
        } else {
            newFish.totalLength = 0
        }
        
        if (sexSegControl.selectedSegmentIndex == 0){
            newFish.sex = "Male"
        } else if (sexSegControl.selectedSegmentIndex == 1) {
            newFish.sex = "Female"
        } else {
            newFish.sex = "Unknown"
        }
        newFish.species = recognizedFishTextField.text!
        newFish.fishImage = imageToProcess
        if let fishWeight = Int(weightTextField.text!) {
            newFish.weight = fishWeight
        } else {
            newFish.weight = 0
        }
        sData.sharedInstance.party.append(newFish)
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
