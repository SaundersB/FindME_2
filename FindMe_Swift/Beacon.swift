//
//  Beacon.swift
//  FindMe_Swift
//
//  Created by Brandon_Saunders on 9/3/16.
//  Copyright © 2016 Brandon_Saunders. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// Inherit the ViewController class.
extension ViewController: CLLocationManagerDelegate {
    func setupBeacon() {
        print("Setting up the iBeacon reading")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        view.backgroundColor = UIColor.grayColor()
        
        // Enter Your iBeacon UUID
        let uuid = NSUUID(UUIDString: "e2c56db5-dffb-48d2-b060-d0f5a71096e0")!
        
        // Use identifier like your company name or website
        let identifier = "saunders-brandon.FindMe-Swift"
        
        let Major:CLBeaconMajorValue = 0
        let Minor:CLBeaconMinorValue = 0
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: Major, minor: Minor, identifier: identifier)
        
        // called delegate when Enter iBeacon Range
        beaconRegion.notifyOnEntry = true
        
        // called delegate when Exit iBeacon Range
        beaconRegion.notifyOnExit = true
        
        // Requests permission to use location services
        locationManager.requestAlwaysAuthorization()
        
        // Starts monitoring the specified iBeacon Region
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
            
        case .AuthorizedAlways:
            print("Always authorized")
            // Starts the generation of updates that report the user’s current location.
            locationManager.startUpdatingLocation()
            
        case .Restricted:
            print("Restricted")
            // Your app is not authorized to use location services.
            
            simpleAlert("Permission Error", message: "Need Location Service Permission To Access Beacon")
            
            
        case .Denied:
            print("Denied")
            // The user explicitly denied the use of location services for this app or location services are currently disabled in Settings.
            
            simpleAlert("Permission Error", message: "Need Location Service Permission To Access Beacon")
            
        default:
            print("Undecided")

            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            break
        }
    }
    
    func simpleAlert (title:String,message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion)
    {
        print("didRangeBeacons")

        
        // Tells the delegate that one or more beacons are in range.
        let foundBeacons = beacons
        
        if foundBeacons.count > 0 {
            
            if let closestBeacon = foundBeacons[0] as? CLBeacon {
                
                var proximityMessage: String!
                if lastStage != closestBeacon.proximity {
                    
                    lastStage = closestBeacon.proximity
                    
                    switch  lastStage {
                        
                    case .Immediate:
                        proximityMessage = "Very close"
                        self.view.backgroundColor = UIColor.greenColor()
                        
                    case .Near:
                        proximityMessage = "Near"
                        self.view.backgroundColor = UIColor.grayColor()
                        
                    case .Far:
                        proximityMessage = "Far"
                        self.view.backgroundColor = UIColor.blackColor()
                        
                        
                    default:
                        proximityMessage = "Where's the beacon?"
                        self.view.backgroundColor = UIColor.redColor()
                        
                    }
                    var makeString = "Beacon Details:n"
                    makeString += "UUID = (closestBeacon.proximityUUID.UUIDString)n"
                    makeString += "Identifier = (region.identifier)n"
                    makeString += "Major Value = (closestBeacon.major.intValue)n"
                    makeString += "Minor Value = (closestBeacon.minor.intValue)n"
                    makeString += "Distance From iBeacon = (proximityMessage)"
                    
                    self.beaconStatus.text = proximityMessage
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        
        // Tells the delegate that a iBeacon Area is being monitored
        
        locationManager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        // Tells the delegate that the user entered in iBeacon range or area.
        
        simpleAlert("Welcome", message: "Welcome to our store")
        
        // This method called because
        // beaconRegion.notifyOnEntry = true
        // in setupBeacon() function
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        // Tells the delegate that the user exit the iBeacon range or area.
        
        simpleAlert("Good Bye", message: "Have a nice day")
        
        // This method called because
        // beaconRegion.notifyOnExit = true
        // in setupBeacon() function
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        switch  state {
            
        case .Inside:
            //The user is inside the iBeacon range.
            
            locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            
            break
            
        case .Outside:
            //The user is outside the iBeacon range.
            
            locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
            
            break
            
        default :
            // it is unknown whether the user is inside or outside of the iBeacon range.
            break
            
        }
    }
    
    
    
}