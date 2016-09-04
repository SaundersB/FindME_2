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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconStatus.numberOfLines = 0;
        beaconStatus.textAlignment = NSTextAlignment.Center;
        beaconStatus.font = UIFont (name: "HelveticaNeue-Bold", size: 50)
        
        // Initialize beacon listening.
        self.setupBeacon()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        if peripheral.state == CBPeripheralManagerState.PoweredOff {
            print("Please turn on bluetooth")
            simpleAlert("Beacon", message: "Turn On Your Device Bluetooth")
        }
    }

}