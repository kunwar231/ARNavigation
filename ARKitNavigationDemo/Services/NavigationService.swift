//
//  NavigationService.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit
import CoreLocation
import Polyline

let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"

struct NavigationService {
    
    func getDirections(destinationLocation: CLLocationCoordinate2D, request: MKDirectionsRequest, completion: @escaping ([routeStep]) -> Void) {
//        var steps: [MKRouteStep] = []
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if appdelegate.currentLocation == nil
        {
            return
        }
        
        let placeMark = MKPlacemark(coordinate: destinationLocation)
        
        request.destination = MKMapItem(placemark: placeMark)
//        request.source = MKMapItem.forCurrentLocation()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: appdelegate.currentLocation.coordinate))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let origin = "\(appdelegate.currentLocation.coordinate.latitude),\(appdelegate.currentLocation.coordinate.longitude)"
        let destin = "\(destinationLocation.latitude),\(destinationLocation.longitude)"
        getDirections(origin: origin, destination: destin, travelMode: "driving" as AnyObject) { (steps, success) in
            
            completion(steps!)
        }
//        let directions = MKDirections(request: request)
//
//        directions.calculate { response, error in
//            if error == nil {
//                print("Error getting directions")
//            } else {
//                guard let response = response else { return }
//                for route in response.routes {
//                    steps.append(contentsOf: route.steps)
//                }
//                completion(steps)
//            }
//        }
    }
    
    //MARK: Get Directions
    func getDirections(origin: String!, destination: String!, travelMode: AnyObject!, completionHandler: @escaping ((_ steps: [routeStep]?, _ success: Bool) -> Void)) {
        
        webserviceClass.sharedInstance.getGoogleDirections(methodType: 1, urlString: baseURLDirections, parameters: ["origin": origin as AnyObject, "destination": destination as AnyObject, "mode": travelMode as AnyObject, "key":"AIzaSyDfa6IvMbKniGo-6MdEvrgZ6o5Tg-w7QDE" as AnyObject], completion: { (success, response) in
            
            if success == true
            {
                if (response["routes"] as! [[String: AnyObject]]).count == 0
                {
                    return
                }
                
                let selectedRoute = (response["routes"] as! [[String: AnyObject]])[0] as [String: AnyObject]
                let legs = (selectedRoute["legs"] as! [[String: AnyObject]])[0]["steps"] as! [[String: AnyObject]]
                var steps: [routeStep] = []

                for leg in legs
                {
                    var instruct: String = ""
                    var poliLyne = MKPolyline()
                    var distance: CLLocationDistance = CLLocationDistance(0.0)
                    let maneuver = leg["maneuver"] as? String
                    var strPol: String = ""
                    
                    if maneuver != nil
                    {
                        instruct = maneuver!
                    }
                    
                    if let poliObj = leg["polyline"]
                    {
                        let poliLineStr = poliObj as! [String: String]
                        strPol = poliLineStr["points"]!
                        let coordinates: [CLLocationCoordinate2D]? = decodePolyline(strPol)
                        poliLyne = MKPolyline(coordinates: coordinates!, count: coordinates!.count)
                    }
                    if let poliObj = leg["distance"]
                    {
                        let poliLineStr = poliObj as! [String: AnyObject]
                        let strVal = poliLineStr["value"] as! Double
                        distance = CLLocationDistance.init(strVal)
                    }
                    
                    let step = routeStep(instr: instruct, polylin: poliLyne, dist: distance, strPol: strPol)
                    steps.append(step)
                }
                
                
                completionHandler(steps, true)
            }
            else
            {
                completionHandler(nil, false)
            }
            
        })
    }
}
