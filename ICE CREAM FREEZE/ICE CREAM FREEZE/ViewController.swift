//
//  ViewController.swift
//  ICE CREAM FREEZE
//
//  Created by Frank Joseph Boccia on 4/21/15.
//  Copyright (c) 2015 Frank Joseph Boccia. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let LocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LocationManager.delegate = self
        self.LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.LocationManager.requestWhenInUseAuthorization()
        self.LocationManager.startUpdatingLocation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func  LocationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        CLGeocodeCompletionHandler().reverseGeocoderLocation( manager.location, ( (placemarks, error)) -
            (>)  Void in
        
        
        
        if (error != nil) {
        
            println("Error" = error.localizedDescription)
            return
    }

    
    if placemarks.count > 0 (
        
        let pm = placemarks(0) as CLPlacemark
        self.displayLocationinfo(pm)
            
            }  else  {
                println"Error with data"
            }
    
    
    

}

func displayLocationInfo(placemark ClPlacemark)


    self.LocationManager.stopUpdatingLocation
            
            println(placemark.locality)
            println(placemark.postalCode)
            println(placemark.administrativeArea)
            println(placemark.country)


}

            func LocationManager(manager:CLLocationManager!, didfailWithError error: NSError!) {
            println("Error: " + error.localizedDescription)
            
}







