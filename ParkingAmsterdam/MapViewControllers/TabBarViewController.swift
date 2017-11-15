//
//  TabBarViewController.swift
//  ParkingAmsterdam
//
//  Created by Trym Lintzen on 14-11-17.
//  Copyright © 2017 Kyrill van Seventer. All rights reserved.
//

import UIKit
import MapKit
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    var sourceCoordinate = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let destinationVC = viewController as? ParkingList {
            destinationVC.sourceCoordinate = sourceCoordinate
        }
        print(viewController)
    }

 

}
