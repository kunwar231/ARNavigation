//
//  AppDelegate.swift
//  ARKitNavigationDemo
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var locationManager:CLLocationManager!
    
    var currentLocation:CLLocation!

    var window: UIWindow?
    var appCoordinator: MainCoordinator!
    // MARK: - App Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        
        if locationManager.location != nil
        {
            self.currentLocation = locationManager.location!
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            appCoordinator = MainCoordinator(window: window)
        }
        return true
    }
}


extension AppDelegate: CLLocationManagerDelegate
{
    //MARK: LocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last

    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
}


