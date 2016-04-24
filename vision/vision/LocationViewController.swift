//
//  LocationViewController.swift
//  vision
//
//  Created by Jason Du on 2016-04-22.
//  Copyright © 2016 IBM Bluemix Developer Advocate Team. All rights reserved.
//

import UIKit
import MapKit
class LocationViewController: UIViewController,MKMapViewDelegate {

    let locationManager = CLLocationManager()

    @IBOutlet var latitudeLabel: UILabel!
    
    @IBOutlet var longitudeLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if (locationManager.location != nil) {
            let newMarker = CustomPointAnnotation()
            newMarker.imageName = "Fish"
            newMarker.coordinate = (locationManager.location?.coordinate)!
            self.mapView.addAnnotation(newMarker)
            latitudeLabel.text = ("\((locationManager.location?.coordinate.latitude)!)")
            longitudeLabel.text = ("\((locationManager.location?.coordinate.longitude)!)")
            locationManager.startUpdatingLocation()
        }
        

        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        
        dateLabel.text = convertedDate
        
        dateFormatter.dateFormat = "HH:mm:ss"
        convertedDate = dateFormatter.stringFromDate(currentDate)
        
        timeLabel.text = convertedDate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = false
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        return anView
    }

    @IBAction func Finish(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let newFish = fishData2()
        newFish.date = dateLabel.text!
        newFish.latitude = Double(latitudeLabel.text!)!
        newFish.longitude = Double(longitudeLabel.text!)!
        newFish.time = timeLabel.text!
        sData.sharedInstance.party2.append(newFish)
    }

}
extension LocationViewController: CLLocationManagerDelegate {
    // 2
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        
        self.mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
}
