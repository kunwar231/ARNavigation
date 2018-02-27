//
//  webserviceClass.swift
//  transportTracker
//
//  Created by Etelligens on 26/08/17.
//  Copyright © 2017 Etelligens. All rights reserved.
//

import UIKit
import Alamofire

class webserviceClass: NSObject {
    
    static let sharedInstance = webserviceClass()
    let netorkReachability: NetworkReachabilityManager = NetworkReachabilityManager()!
    
    //MARK: GET Request
    func getRequest(headers: [String: String], parameters: [String: AnyObject], urlString: String, completion: @escaping (Bool, [String: AnyObject]) -> ())
    {
        
        Alamofire.request(urlString, method:.get, parameters:parameters,encoding: URLEncoding.default, headers:headers).responseJSON { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                completion(true, json as! [String: AnyObject])
            }
                
            else if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                
                completion(false, ["data": utf8Text as AnyObject])
            }
        }
    }
    
    //MARK: Get Google Directions
    func getGoogleDirections(methodType: Int, urlString: String, parameters: [String: AnyObject], completion: @escaping (Bool, [String: AnyObject]) -> ())
    {
        if !isConnectedToInternet()
        {
            completion(true, ["status": false as AnyObject, "msg": "No internet connection" as AnyObject])
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        self.getRequest(headers: headers, parameters: parameters, urlString: urlString, completion: { (success, response) in
                
                completion(success, response)
        
        })
    }
    
    //MARK: - Check Internet Connection
    func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
