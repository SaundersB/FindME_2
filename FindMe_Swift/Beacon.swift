//
//  Beacon.swift
//  FindMe_Swift
//
//  Created by Brandon_Saunders on 9/3/16.
//  Copyright © 2016 Brandon_Saunders. All rights reserved.
//
/*
Description:
iBeacon is a protocol developed by Apple. Beacons are hardware transmitters that are a class of Bluetooth low energy (LE) devices who broadcast their identifier to nearby portable electronic devices. The technology enables smartphones, tablets and other devices to perform actions when in close proximity to an iBeacon.

Region Monitoring:
iBeacons can be set to notify when a user has entered or exited a iBeacon region.

Monitoring: actions triggered on entering/exiting region’s range; works no matter whether the app is running, suspended, or killed (if the app's not running when an enter/exit even comes, iOS will launch it into the background for a few seconds to handle the event)
Ranging: actions triggered based on proximity to a beacon; works only when the app is running (e.g., it's displayed on screen, or running in the background in response to a monitoring event, etc.)

Ranging:
iBeacons can be set to notify within four different distance ranges.

Beacon Ranging Distance Options:
Immediate	Within a few centimeters
Near	Within a couple of meters
Far	Greater than 10 meters away

Beacon Payload:
Apple has provided a beacon API for iOS applications that handles the beacon payload.

Beacon type (2 bytes, 0x02-15)
Apple has assigned a value for proximity beacons, which is used by all iBeacons. Some sources state that this is a two-byte field,with the first byte indicating a protocol identifier of 2 for iBea‐ con and the second byte indicating a length of 21 further bytes (15 in hex is 21 decimal).
Proximity UUID (16 bytes)
This field contains the UUID for the iBeacon. Typically, this will be set to the organization that owns the beacon. Not all beacon products allow this field to be set.
Major (2 bytes) and Minor (2 byte) numbers
These fields, each two bytes in length, contain the major or minor number that will be contained within the iBeacon’s broadcast.
Measured power (1 byte)
Implicit within the iBeacon protocol is the idea of ranging (identifying the distance a device is from a beacon, as discussed in “Ranging” on page 48). There may be slight variations in transmitter power, so an iBeacon is calibrated with a reference client. Measured power is set by holding a receiver one meter from the beacon and finding an average received signal strength. This field holds the measured power as a two’s comple‐ ment.3 For example, a value of C5 indicates a measured power at one meter of –59 dBm.
*/

import Foundation
import UIKit
import CoreLocation

// Inherit the ViewController class.
extension ViewController: CLLocationManagerDelegate {
    func setupBeacon() {
        print("Setting up for iBeacon reading")
        
        // Enabling location services.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // iBeacon UUID
        let uuid = NSUUID(UUIDString: "e2c56db5-dffb-48d2-b060-d0f5a71096e0")!
        
        // Company identifier. I like to use the bundler identifier.
        let identifier = "saunders-brandon.FindMe-Swift"
        
        // Setting the major and minor codes that are specific to the iBeacon.
        let Major:CLBeaconMajorValue = 0
        let Minor:CLBeaconMinorValue = 0
        
        // Setting the reacon region according to the beacon specific stats.
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: Major, minor: Minor, identifier: identifier)
        
        // Called delegate when Enter iBeacon Range
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        
        // Requests permission to use location services
        locationManager.requestAlwaysAuthorization()
        
        // Starts monitoring the specified iBeacon Region
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startMonitoringVisits()
        locationManager.pausesLocationUpdatesAutomatically = false
        
        regsiterForNotifications()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("User has made a decision about location services.")
        
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
        // Tells the delegate that one or more beacons are in range.
        let foundBeacons = beacons
        
        if foundBeacons.count > 0 {
            if let closestBeacon = foundBeacons[0] as? CLBeacon {
                var proximityMessage: String!

                switch  closestBeacon.proximity {
                    case .Far:
                        print("Far")
                        proximityMessage = "Far"
                        self.view.backgroundColor = UIColor.redColor()
                    
                    case .Near:
                        print("Near")
                        proximityMessage = "Near"
                        self.view.backgroundColor = UIColor.grayColor()
                    
                    case .Immediate:
                        print("Immediate")
                        proximityMessage = "Immediate"
                        self.view.backgroundColor = UIColor.greenColor()
                        sendLocalNotificationWithMessage("You're in our store")
                        
                    case .Unknown:
                        print("Out of range")
                        proximityMessage = "Out of range"
                        self.view.backgroundColor = UIColor.whiteColor()
                }
                self.beaconStatus.text = proximityMessage
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        // Tells the delegate that a iBeacon Area is being monitored
        locationManager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        locationManager.startUpdatingLocation()
        
        // Tells the delegate that the user entered in iBeacon range or area.
        simpleAlert("Welcome", message: "Welcome to our store!")
        sendLocalNotificationWithMessage("Welcome to our store!")
        // This method called because
        // beaconRegion.notifyOnEntry = true
        // in setupBeacon() function
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        locationManager.stopUpdatingLocation()
        
        // Tells the delegate that the user exit the iBeacon range or area.
        simpleAlert("Good Bye", message: "Thank you for visiting.")
        sendLocalNotificationWithMessage("Thank you for visiting.")
        // This method called because
        // beaconRegion.notifyOnExit = true
        // in setupBeacon() function
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        print("Determined location state")
        
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
                print("Unknown user location")
                break
        }
    }
    
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        print("Sending local notification")
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func regsiterForNotifications(){
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
}