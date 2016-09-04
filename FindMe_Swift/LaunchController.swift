//
//  LaunchController.swift
//  FindMe_Swift
//
//  Created by Brandon_Saunders on 9/4/16.
//  Copyright © 2016 Brandon_Saunders. All rights reserved.
//

import Foundation



import UIKit
import CoreLocation
import CoreBluetooth

class LaunchController: UIViewController {
    
    
    var launchImage = UIImageView?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        var image: UIImage = UIImage(named: "beacon")!
        launchImage = UIImageView(image: image)
        launchImage!.frame = CGRectMake(0,0,100,200)
        self.view.addSubview(launchImage!)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}