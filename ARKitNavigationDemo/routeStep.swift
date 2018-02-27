//
//  routeStep.swift
//  ARKitNavigationDemo
//
//  Created by Etelligens on 27/02/18.
//  Copyright © 2018 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct routeStep {
    var instruction: String = ""
    var polyline: MKPolyline = MKPolyline()
    var distance: CLLocationDistance = 0.0
    var polylinsStr: String = ""
    
    init(instr: String, polylin: MKPolyline, dist: CLLocationDistance, strPol: String) {
        self.instruction = instr
        self.polyline = polylin
        self.distance = dist
        self.polylinsStr = strPol
    }
}
