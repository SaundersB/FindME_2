//
//  ViewController.swift
//  FindMe_Swift
//
//  Created by Brandon_Saunders on 9/3/16.
//  Copyright © 2016 Brandon_Saunders. All rights reserved.
//


import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController,CBPeripheralManagerDelegate {
    
    @IBOutlet weak var beaconStatus: UILabel!
    
    var locationManager = CLLocationManager()
    let myBTManager = CBPeripheralManager()
    var lastStage = CLProximity.Unknown
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Define in iBeacon.swift
        beaconStatus.numberOfLines = 0;
        beaconStatus.textAlignment = NSTextAlignment.Center;
        beaconStatus.font = UIFont (name: "Helvetica Neue", size: 30)
        
        self.setupBeacon()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        if peripheral.state == CBPeripheralManagerState.PoweredOff {
            print("Need to turn on bluetooth")
            simpleAlert("Beacon", message: "Turn On Your Device Bluetooth")
        }
    }

}