//
//  MKRouteStep+Extension.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 9/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit
import Polyline

// Get a CLLocation from a route step

extension routeStep {
    func getLocation() -> [CLLocation] {
        
        let coordinates: [CLLocationCoordinate2D] = decodePolyline(polylinsStr)!
        var locations: [CLLocation] = []
        
        for coord in coordinates
        {
            locations.append(CLLocation(latitude: coord.latitude, longitude: coord.longitude))
        }
        
        return locations
    }
}
